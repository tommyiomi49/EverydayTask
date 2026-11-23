import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/schoolwork_model.dart';
import '../models/schoolwork_with_subject.dart';
import '../models/subject_model.dart';
import 'auth_service.dart';

class DashboardStats {
  final int totalSubjects;
  final int totalSchoolworks;
  final int pendingCount;
  final int inProgressCount;
  final int completedCount;
  final int overdueCount;
  final int dueTodayCount;
  final int dueTomorrowCount;
  final List<SchoolworkWithSubject> urgentWorks;

  DashboardStats({
    required this.totalSubjects,
    required this.totalSchoolworks,
    required this.pendingCount,
    required this.inProgressCount,
    required this.completedCount,
    required this.overdueCount,
    required this.dueTodayCount,
    required this.dueTomorrowCount,
    required this.urgentWorks,
  });

  double get overallProgress => totalSchoolworks == 0
      ? 0.0
      : (completedCount / totalSchoolworks).clamp(0.0, 1.0);

  int get overallProgressPercent => (overallProgress * 100).round();
}

class SchoolworkService {
  static final SchoolworkService instance = SchoolworkService._init();
  SchoolworkService._init();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Retrieves all schoolworks for a given user, joining with their subjects from Cloud Firestore
  Future<List<SchoolworkWithSubject>> getSchoolworksForUser(
    int userId, {
    int? subjectId,
    String? statusFilter, // 'All', 'Pending', 'In Progress', 'Completed', 'Overdue'
    String? priorityFilter, // 'All', 'High', 'Medium', 'Low'
    String? searchQuery,
    String sortBy = 'due_date_asc', // 'due_date_asc', 'priority_desc', 'title_asc'
  }) async {
    // 1. Fetch user's subjects map: subjectId -> SubjectModel
    final subjectsSnapshot = await _firestore
        .collection('subjects')
        .where('user_id', isEqualTo: userId)
        .get();

    final subjectMap = <int, SubjectModel>{};
    for (final doc in subjectsSnapshot.docs) {
      final data = doc.data();
      final sId = data['subject_id'] as int? ?? int.tryParse(doc.id) ?? 0;
      subjectMap[sId] = SubjectModel.fromMap(data);
    }

    // 2. Fetch user's schoolworks from Firestore
    final worksSnapshot = await _firestore
        .collection('schoolworks')
        .where('user_id', isEqualTo: userId)
        .get();

    final list = <SchoolworkWithSubject>[];

    for (final doc in worksSnapshot.docs) {
      final data = doc.data();
      final work = SchoolworkModel.fromMap(data);
      final sId = work.subjectId;

      final subject = subjectMap[sId] ??
          SubjectModel(
            subjectId: sId,
            userId: userId,
            subjectCode: data['subject_code'] as String? ?? 'TASK',
            subjectName: data['subject_name'] as String? ?? 'Academic Task',
            instructorName: data['instructor_name'] as String? ?? '',
          );

      // Apply subject filter
      if (subjectId != null && work.subjectId != subjectId) {
        continue;
      }

      // Apply status filter
      if (statusFilter != null && statusFilter != 'All') {
        if (statusFilter == 'Overdue') {
          if (!work.isOverdue) continue;
        } else if (work.status.toLowerCase() != statusFilter.toLowerCase()) {
          continue;
        }
      }

      // Apply priority filter
      if (priorityFilter != null && priorityFilter != 'All') {
        if (work.priority.toLowerCase() != priorityFilter.toLowerCase()) {
          continue;
        }
      }

      // Apply search query
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.trim().toLowerCase();
        final match = work.title.toLowerCase().contains(q) ||
            work.description.toLowerCase().contains(q) ||
            subject.subjectCode.toLowerCase().contains(q) ||
            subject.subjectName.toLowerCase().contains(q);
        if (!match) continue;
      }

      list.add(SchoolworkWithSubject(schoolwork: work, subject: subject));
    }

    // Sort in memory
    switch (sortBy) {
      case 'priority_desc':
        list.sort((a, b) {
          final pA = _priorityRank(a.priority);
          final pB = _priorityRank(b.priority);
          if (pA != pB) return pA.compareTo(pB);
          final d = a.dueDate.compareTo(b.dueDate);
          if (d != 0) return d;
          return a.dueTime.compareTo(b.dueTime);
        });
        break;
      case 'title_asc':
        list.sort((a, b) =>
            a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case 'due_date_asc':
      default:
        list.sort((a, b) {
          final d = a.dueDate.compareTo(b.dueDate);
          if (d != 0) return d;
          return a.dueTime.compareTo(b.dueTime);
        });
        break;
    }

    return list;
  }

  int _priorityRank(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return 1;
      case 'medium':
        return 2;
      case 'low':
        return 3;
      default:
        return 4;
    }
  }

  /// Retrieves schoolworks belonging to a specific subject
  Future<List<SchoolworkWithSubject>> getSchoolworksForSubject(
      int subjectId) async {
    final subjDoc = await _firestore
        .collection('subjects')
        .doc(subjectId.toString())
        .get();
    SubjectModel subject;
    if (subjDoc.exists && subjDoc.data() != null) {
      subject = SubjectModel.fromMap(subjDoc.data()!);
    } else {
      subject = SubjectModel(
        subjectId: subjectId,
        userId: 0,
        subjectCode: 'TASK',
        subjectName: 'Academic Task',
        instructorName: '',
      );
    }

    final worksSnapshot = await _firestore
        .collection('schoolworks')
        .where('subject_id', isEqualTo: subjectId)
        .get();

    final list = worksSnapshot.docs.map((doc) {
      final work = SchoolworkModel.fromMap(doc.data());
      return SchoolworkWithSubject(schoolwork: work, subject: subject);
    }).toList();

    list.sort((a, b) {
      final d = a.dueDate.compareTo(b.dueDate);
      if (d != 0) return d;
      return a.dueTime.compareTo(b.dueTime);
    });

    return list;
  }

  /// Inserts a new schoolwork item into Cloud Firestore
  Future<SchoolworkModel> addSchoolwork(SchoolworkModel work) async {
    final int generatedId =
        work.workId ?? DateTime.now().millisecondsSinceEpoch;
    final modelWithId = work.copyWith(workId: generatedId);

    // Determine user_id to store on the schoolwork document for fast user queries
    int userId = 0;
    try {
      final subjDoc = await _firestore
          .collection('subjects')
          .doc(work.subjectId.toString())
          .get();
      if (subjDoc.exists && subjDoc.data() != null) {
        userId = subjDoc.data()?['user_id'] as int? ?? 0;
      }
    } catch (_) {}

    if (userId == 0 && AuthService.instance.currentUser?.userId != null) {
      userId = AuthService.instance.currentUser!.userId!;
    }

    final data = modelWithId.toMap();
    data['user_id'] = userId;

    await _firestore
        .collection('schoolworks')
        .doc(generatedId.toString())
        .set(data);

    return modelWithId;
  }

  /// Updates an existing schoolwork item in Cloud Firestore
  Future<void> updateSchoolwork(SchoolworkModel work) async {
    if (work.workId == null) return;
    await _firestore
        .collection('schoolworks')
        .doc(work.workId.toString())
        .update(work.toMap());
  }

  /// Deletes a schoolwork item from Cloud Firestore
  Future<void> deleteSchoolwork(int workId) async {
    await _firestore.collection('schoolworks').doc(workId.toString()).delete();
  }

  /// Updates status ('Pending', 'In Progress', 'Completed')
  Future<void> updateStatus(int workId, String newStatus) async {
    await _firestore
        .collection('schoolworks')
        .doc(workId.toString())
        .update({'status': newStatus});
  }

  /// Toggles between Completed and Pending
  Future<void> toggleCompleted(int workId, bool isCompleted) async {
    await updateStatus(workId, isCompleted ? 'Completed' : 'Pending');
  }

  /// Computes comprehensive dashboard statistics for the logged-in student
  Future<DashboardStats> getDashboardStats(int userId) async {
    final allWorks = await getSchoolworksForUser(userId);

    final subjSnapshot = await _firestore
        .collection('subjects')
        .where('user_id', isEqualTo: userId)
        .get();
    final totalSubjects = subjSnapshot.docs.length;

    int pending = 0;
    int inProgress = 0;
    int completed = 0;
    int overdue = 0;
    int dueToday = 0;
    int dueTomorrow = 0;

    final urgent = <SchoolworkWithSubject>[];

    for (final item in allWorks) {
      if (item.isCompleted) {
        completed++;
      } else {
        if (item.isInProgress) {
          inProgress++;
        } else {
          pending++;
        }

        if (item.isOverdue) {
          overdue++;
          urgent.add(item);
        } else if (item.isDueToday) {
          dueToday++;
          urgent.add(item);
        } else if (item.isDueTomorrow) {
          dueTomorrow++;
          urgent.add(item);
        } else if (item.priority.toLowerCase() == 'high') {
          urgent.add(item);
        }
      }
    }

    return DashboardStats(
      totalSubjects: totalSubjects,
      totalSchoolworks: allWorks.length,
      pendingCount: pending,
      inProgressCount: inProgress,
      completedCount: completed,
      overdueCount: overdue,
      dueTodayCount: dueToday,
      dueTomorrowCount: dueTomorrow,
      urgentWorks: urgent,
    );
  }

  /// Reseeds demo subjects and schoolworks for a student in Cloud Firestore
  Future<void> reseedDemoData(int userId) async {
    final existingSubjects = await _firestore
        .collection('subjects')
        .where('user_id', isEqualTo: userId)
        .get();
    final existingWorks = await _firestore
        .collection('schoolworks')
        .where('user_id', isEqualTo: userId)
        .get();

    final batch = _firestore.batch();
    for (final doc in existingSubjects.docs) {
      batch.delete(doc.reference);
    }
    for (final doc in existingWorks.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();

    await seedInitialDataIfEmpty(userId, force: true);
  }

  /// Seeds demo data if user has no subjects in Cloud Firestore
  Future<void> seedInitialDataIfEmpty(int userId, {bool force = false}) async {
    if (!force) {
      final existing = await _firestore
          .collection('subjects')
          .where('user_id', isEqualTo: userId)
          .limit(1)
          .get();
      if (existing.docs.isNotEmpty) return;
    }

    final subj1Id = DateTime.now().millisecondsSinceEpoch;
    final subj2Id = subj1Id + 1;
    final subj3Id = subj1Id + 2;
    final subj4Id = subj1Id + 3;

    final subjects = [
      {
        'subject_id': subj1Id,
        'user_id': userId,
        'subject_code': 'CS301',
        'subject_name': 'Data Structures and Algorithms',
        'instructor_name': 'Prof. Emily Chen',
      },
      {
        'subject_id': subj2Id,
        'user_id': userId,
        'subject_code': 'MATH202',
        'subject_name': 'Discrete Mathematics',
        'instructor_name': 'Dr. Robert Santos',
      },
      {
        'subject_id': subj3Id,
        'user_id': userId,
        'subject_code': 'IT215',
        'subject_name': 'Database Management Systems',
        'instructor_name': 'Engr. Sarah Jenkins',
      },
      {
        'subject_id': subj4Id,
        'user_id': userId,
        'subject_code': 'ENG102',
        'subject_name': 'Technical Report Writing',
        'instructor_name': 'Ms. Laura Davis',
      },
    ];

    final now = DateTime.now();
    String formatDate(DateTime dt) {
      final y = dt.year.toString().padLeft(4, '0');
      final m = dt.month.toString().padLeft(2, '0');
      final d = dt.day.toString().padLeft(2, '0');
      return '$y-$m-$d';
    }

    final todayStr = formatDate(now);
    final tomorrowStr = formatDate(now.add(const Duration(days: 1)));
    final inThreeDaysStr = formatDate(now.add(const Duration(days: 3)));
    final nextWeekStr = formatDate(now.add(const Duration(days: 7)));
    final yesterdayStr = formatDate(now.subtract(const Duration(days: 1)));

    final works = [
      {
        'work_id': subj1Id + 10,
        'subject_id': subj1Id,
        'user_id': userId,
        'title': 'Binary Search Tree Implementation',
        'description':
            'Implement insertion, deletion, and in-order traversal in C++ or Java with full test cases.',
        'due_date': todayStr,
        'due_time': '23:59',
        'priority': 'High',
        'status': 'Pending',
      },
      {
        'work_id': subj1Id + 11,
        'subject_id': subj3Id,
        'user_id': userId,
        'title': 'ERD Diagram and Normalization Case Study',
        'description':
            'Design ERD for University Enrollment System and normalize tables up to 3NF.',
        'due_date': tomorrowStr,
        'due_time': '17:00',
        'priority': 'High',
        'status': 'In Progress',
      },
      {
        'work_id': subj1Id + 12,
        'subject_id': subj2Id,
        'user_id': userId,
        'title': 'Problem Set 4: Graph Theory & Trees',
        'description':
            'Answer exercises 1 to 15 on Euler circuits and Hamiltonian paths.',
        'due_date': inThreeDaysStr,
        'due_time': '12:00',
        'priority': 'Medium',
        'status': 'Pending',
      },
      {
        'work_id': subj1Id + 13,
        'subject_id': subj4Id,
        'user_id': userId,
        'title': 'Project Proposal Draft',
        'description':
            'Submit 3-page draft of academic project proposal with literature review citations.',
        'due_date': nextWeekStr,
        'due_time': '23:59',
        'priority': 'Medium',
        'status': 'Pending',
      },
      {
        'work_id': subj1Id + 14,
        'subject_id': subj1Id,
        'user_id': userId,
        'title': 'Quiz 2 Review Notes',
        'description':
            'Review sorting algorithms: QuickSort, MergeSort, and HeapSort time complexities.',
        'due_date': yesterdayStr,
        'due_time': '10:00',
        'priority': 'Low',
        'status': 'Completed',
      },
    ];

    final batch = _firestore.batch();
    for (final s in subjects) {
      final docRef =
          _firestore.collection('subjects').doc(s['subject_id'].toString());
      batch.set(docRef, s);
    }
    for (final w in works) {
      final docRef =
          _firestore.collection('schoolworks').doc(w['work_id'].toString());
      batch.set(docRef, w);
    }
    await batch.commit();
  }
}
