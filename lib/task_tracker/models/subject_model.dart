class SubjectModel {
  final int? subjectId;
  final int userId;
  final String subjectCode;
  final String subjectName;
  final String instructorName;

  // Optional summary fields for UI display
  final int totalWorks;
  final int completedWorks;
  final int pendingWorks;

  SubjectModel({
    this.subjectId,
    required this.userId,
    required this.subjectCode,
    required this.subjectName,
    required this.instructorName,
    this.totalWorks = 0,
    this.completedWorks = 0,
    this.pendingWorks = 0,
  });

  double get progress =>
      totalWorks == 0 ? 0.0 : (completedWorks / totalWorks).clamp(0.0, 1.0);

  int get progressPercent => (progress * 100).round();

  Map<String, dynamic> toMap() {
    return {
      if (subjectId != null) 'subject_id': subjectId,
      'user_id': userId,
      'subject_code': subjectCode,
      'subject_name': subjectName,
      'instructor_name': instructorName,
    };
  }

  factory SubjectModel.fromMap(Map<String, dynamic> map, {
    int totalWorks = 0,
    int completedWorks = 0,
    int pendingWorks = 0,
  }) {
    return SubjectModel(
      subjectId: map['subject_id'] as int?,
      userId: map['user_id'] as int? ?? 0,
      subjectCode: map['subject_code'] as String? ?? '',
      subjectName: map['subject_name'] as String? ?? '',
      instructorName: map['instructor_name'] as String? ?? '',
      totalWorks: totalWorks,
      completedWorks: completedWorks,
      pendingWorks: pendingWorks,
    );
  }

  SubjectModel copyWith({
    int? subjectId,
    int? userId,
    String? subjectCode,
    String? subjectName,
    String? instructorName,
    int? totalWorks,
    int? completedWorks,
    int? pendingWorks,
  }) {
    return SubjectModel(
      subjectId: subjectId ?? this.subjectId,
      userId: userId ?? this.userId,
      subjectCode: subjectCode ?? this.subjectCode,
      subjectName: subjectName ?? this.subjectName,
      instructorName: instructorName ?? this.instructorName,
      totalWorks: totalWorks ?? this.totalWorks,
      completedWorks: completedWorks ?? this.completedWorks,
      pendingWorks: pendingWorks ?? this.pendingWorks,
    );
  }
}

