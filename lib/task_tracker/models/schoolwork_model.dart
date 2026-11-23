class SchoolworkModel {
  final int? workId;
  final int subjectId;
  final String title;
  final String description;
  final String dueDate; // e.g. "2026-11-15"
  final String dueTime; // e.g. "23:59"
  final String priority; // "High", "Medium", "Low"
  final String status; // "Pending", "In Progress", "Completed"

  SchoolworkModel({
    this.workId,
    required this.subjectId,
    required this.title,
    this.description = '',
    required this.dueDate,
    required this.dueTime,
    this.priority = 'Medium',
    this.status = 'Pending',
  });

  bool get isCompleted => status.toLowerCase() == 'completed';
  bool get isInProgress => status.toLowerCase() == 'in progress';
  bool get isPending => status.toLowerCase() == 'pending';

  DateTime? get dueDateTime {
    try {
      final dateParts = dueDate.split('-').map(int.parse).toList();
      final timeParts = dueTime.split(':').map(int.parse).toList();
      return DateTime(
        dateParts[0],
        dateParts[1],
        dateParts[2],
        timeParts.isNotEmpty ? timeParts[0] : 23,
        timeParts.length > 1 ? timeParts[1] : 59,
      );
    } catch (_) {
      return null;
    }
  }

  bool get isOverdue {
    if (isCompleted) return false;
    final dt = dueDateTime;
    if (dt == null) return false;
    return DateTime.now().isAfter(dt);
  }

  bool get isDueToday {
    final dt = dueDateTime;
    if (dt == null) return false;
    final now = DateTime.now();
    return dt.year == now.year && dt.month == now.month && dt.day == now.day;
  }

  bool get isDueTomorrow {
    final dt = dueDateTime;
    if (dt == null) return false;
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return dt.year == tomorrow.year &&
        dt.month == tomorrow.month &&
        dt.day == tomorrow.day;
  }

  String get dueRelativeText {
    if (isCompleted) return 'Completed';
    final dt = dueDateTime;
    if (dt == null) return dueDate;

    final now = DateTime.now();
    final difference = dt.difference(now);

    if (isOverdue) {
      final days = now.difference(dt).inDays;
      if (days == 0) return 'Overdue today';
      return 'Overdue by $days ${days == 1 ? "day" : "days"}';
    }

    if (isDueToday) {
      return 'Due today at $dueTime';
    }
    if (isDueTomorrow) {
      return 'Due tomorrow at $dueTime';
    }

    final inDays = difference.inDays;
    if (inDays < 7) {
      return 'Due in $inDays ${inDays == 1 ? "day" : "days"}';
    }
    return 'Due on $dueDate at $dueTime';
  }

  Map<String, dynamic> toMap() {
    return {
      if (workId != null) 'work_id': workId,
      'subject_id': subjectId,
      'title': title,
      'description': description,
      'due_date': dueDate,
      'due_time': dueTime,
      'priority': priority,
      'status': status,
    };
  }

  factory SchoolworkModel.fromMap(Map<String, dynamic> map) {
    return SchoolworkModel(
      workId: map['work_id'] as int?,
      subjectId: map['subject_id'] as int? ?? 0,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      dueDate: map['due_date'] as String? ?? '',
      dueTime: map['due_time'] as String? ?? '23:59',
      priority: map['priority'] as String? ?? 'Medium',
      status: map['status'] as String? ?? 'Pending',
    );
  }

  SchoolworkModel copyWith({
    int? workId,
    int? subjectId,
    String? title,
    String? description,
    String? dueDate,
    String? dueTime,
    String? priority,
    String? status,
  }) {
    return SchoolworkModel(
      workId: workId ?? this.workId,
      subjectId: subjectId ?? this.subjectId,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
      priority: priority ?? this.priority,
      status: status ?? this.status,
    );
  }
}

