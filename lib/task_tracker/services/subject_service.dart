import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/subject_model.dart';
import 'schoolwork_service.dart';

class SubjectService {
  static final SubjectService instance = SubjectService._init();
  SubjectService._init();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Retrieves all subjects for the given user, including workload metrics from Cloud Firestore
  Future<List<SubjectModel>> getSubjectsForUser(int userId) async {
    final snapshot = await _firestore
        .collection('subjects')
        .where('user_id', isEqualTo: userId)
        .get();

    // If user has no subjects yet in Firestore, seed initial demo subjects and tasks
    if (snapshot.docs.isEmpty) {
      await SchoolworkService.instance.seedInitialDataIfEmpty(userId);
      final refetched = await _firestore
          .collection('subjects')
          .where('user_id', isEqualTo: userId)
          .get();
      return _buildSubjectModelsWithMetrics(refetched.docs, userId);
    }

    return _buildSubjectModelsWithMetrics(snapshot.docs, userId);
  }

  Future<List<SubjectModel>> _buildSubjectModelsWithMetrics(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> subjectDocs,
    int userId,
  ) async {
    // Fetch all schoolworks for this user to aggregate metrics per subject in memory
    final worksSnapshot = await _firestore
        .collection('schoolworks')
        .where('user_id', isEqualTo: userId)
        .get();

    // Metrics map: subjectId -> {total: int, completed: int, pending: int}
    final metricsMap = <int, Map<String, int>>{};

    for (final doc in worksSnapshot.docs) {
      final data = doc.data();
      final subjId = data['subject_id'] as int? ?? 0;
      final status = (data['status'] as String? ?? '').toLowerCase();

      final current = metricsMap.putIfAbsent(
        subjId,
        () => {'total': 0, 'completed': 0, 'pending': 0},
      );
      current['total'] = (current['total'] ?? 0) + 1;
      if (status == 'completed') {
        current['completed'] = (current['completed'] ?? 0) + 1;
      } else {
        current['pending'] = (current['pending'] ?? 0) + 1;
      }
    }

    final list = subjectDocs.map((doc) {
      final data = doc.data();
      final sId = data['subject_id'] as int? ?? int.tryParse(doc.id) ?? 0;
      final m = metricsMap[sId] ?? {'total': 0, 'completed': 0, 'pending': 0};

      return SubjectModel.fromMap(
        data,
        totalWorks: m['total'] ?? 0,
        completedWorks: m['completed'] ?? 0,
        pendingWorks: m['pending'] ?? 0,
      );
    }).toList();

    // Sort by subjectCode ascending
    list.sort((a, b) =>
        a.subjectCode.toLowerCase().compareTo(b.subjectCode.toLowerCase()));

    return list;
  }

  /// Retrieves a single subject by ID with its metrics
  Future<SubjectModel?> getSubjectById(int subjectId) async {
    final doc =
        await _firestore.collection('subjects').doc(subjectId.toString()).get();
    if (!doc.exists || doc.data() == null) {
      final q = await _firestore
          .collection('subjects')
          .where('subject_id', isEqualTo: subjectId)
          .limit(1)
          .get();
      if (q.docs.isEmpty) return null;
      return _buildSingleSubjectWithMetrics(q.docs.first.data(), subjectId);
    }
    return _buildSingleSubjectWithMetrics(doc.data()!, subjectId);
  }

  Future<SubjectModel> _buildSingleSubjectWithMetrics(
    Map<String, dynamic> data,
    int subjectId,
  ) async {
    final worksSnapshot = await _firestore
        .collection('schoolworks')
        .where('subject_id', isEqualTo: subjectId)
        .get();

    int total = 0;
    int completed = 0;
    int pending = 0;

    for (final doc in worksSnapshot.docs) {
      total++;
      final status = (doc.data()['status'] as String? ?? '').toLowerCase();
      if (status == 'completed') {
        completed++;
      } else {
        pending++;
      }
    }

    return SubjectModel.fromMap(
      data,
      totalWorks: total,
      completedWorks: completed,
      pendingWorks: pending,
    );
  }

  /// Inserts a new subject into Cloud Firestore
  Future<SubjectModel> addSubject(SubjectModel subject) async {
    final int generatedId =
        subject.subjectId ?? DateTime.now().millisecondsSinceEpoch;
    final modelWithId = subject.copyWith(subjectId: generatedId);

    await _firestore
        .collection('subjects')
        .doc(generatedId.toString())
        .set(modelWithId.toMap());

    return modelWithId;
  }

  /// Updates an existing subject in Cloud Firestore
  Future<void> updateSubject(SubjectModel subject) async {
    if (subject.subjectId == null) return;
    await _firestore
        .collection('subjects')
        .doc(subject.subjectId.toString())
        .update(subject.toMap());
  }

  /// Deletes a subject and cascades delete to its schoolworks in Cloud Firestore
  Future<void> deleteSubject(int subjectId) async {
    await _firestore.collection('subjects').doc(subjectId.toString()).delete();

    // Cascading delete: delete all schoolworks with this subject_id
    final worksQuery = await _firestore
        .collection('schoolworks')
        .where('subject_id', isEqualTo: subjectId)
        .get();

    final batch = _firestore.batch();
    for (final doc in worksQuery.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
