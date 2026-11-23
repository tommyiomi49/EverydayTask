import 'schoolwork_model.dart';
import 'subject_model.dart';

class SchoolworkWithSubject {
  final SchoolworkModel schoolwork;
  final SubjectModel subject;

  SchoolworkWithSubject({
    required this.schoolwork,
    required this.subject,
  });

  int? get workId => schoolwork.workId;
  int get subjectId => schoolwork.subjectId;
  String get title => schoolwork.title;
  String get description => schoolwork.description;
  String get dueDate => schoolwork.dueDate;
  String get dueTime => schoolwork.dueTime;
  String get priority => schoolwork.priority;
  String get status => schoolwork.status;

  String get subjectCode => subject.subjectCode;
  String get subjectName => subject.subjectName;
  String get instructorName => subject.instructorName;

  bool get isCompleted => schoolwork.isCompleted;
  bool get isInProgress => schoolwork.isInProgress;
  bool get isPending => schoolwork.isPending;
  bool get isOverdue => schoolwork.isOverdue;
  bool get isDueToday => schoolwork.isDueToday;
  bool get isDueTomorrow => schoolwork.isDueTomorrow;
  String get dueRelativeText => schoolwork.dueRelativeText;
  DateTime? get dueDateTime => schoolwork.dueDateTime;
}

