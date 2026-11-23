import 'package:personaltasklogger/model/ScheduledTask.dart';

class FutureScheduledTask extends ScheduledTask {
  FutureScheduledTask({
    required super.id,
    required super.taskGroupId,
    required super.templateId,
    required super.title,
    required super.description,
    required super.createdAt,
    required super.schedule,
    required super.active,
    required super.pausedAt,
    required super.important,
    required super.oneTimeCompletedOn,
  });
}
