import 'package:flutter/cupertino.dart';
import 'package:personaltasklogger/db/repository/ScheduledTaskRepository.dart';
import 'package:personaltasklogger/model/ScheduledTask.dart';
import 'package:personaltasklogger/service/PreferenceService.dart';

class DueScheduleCountService {
  static final DueScheduleCountService _service =
      DueScheduleCountService._internal();

  final _dueTaskScheduleCount = ValueNotifier(0);

  factory DueScheduleCountService() {
    return _service;
  }

  DueScheduleCountService._internal();

  get count => _dueTaskScheduleCount;

  gather() {
    ScheduledTaskRepository.countDue()
        .then((count) => _dueTaskScheduleCount.value = count ?? 0);
  }

  incIfDue(ScheduledTask scheduledTask) {
    if (scheduledTask.isDue()) {
      inc();
    }
  }

  inc() {
    _dueTaskScheduleCount.value++;
  }

  decIfDue(ScheduledTask scheduledTask) {
    if (scheduledTask.isDue()) {
      dec();
    }
  }

  dec() {
    if (_dueTaskScheduleCount.value > 0) {
      _dueTaskScheduleCount.value--;
    }
  }

  bool shouldShowIndicatorValue() {
    return _dueTaskScheduleCount.value > 0 &&
        PreferenceService().showBadgeForDueSchedules;
  }
}
