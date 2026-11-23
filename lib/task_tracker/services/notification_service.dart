import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/schoolwork_model.dart';
import '../models/subject_model.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._init();
  NotificationService._init();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    // Local notifications plugin does not support web; safely bypass
    if (kIsWeb) {
      _initialized = true;
      return;
    }

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    try {
      await _notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (response) {
          debugPrint('Notification clicked: ${response.payload}');
        },
      );
      _initialized = true;
    } catch (e) {
      debugPrint('Failed to initialize local notifications: $e');
    }
  }

  /// Shows an instant reminder or confirmation notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (kIsWeb) return;
    if (!_initialized) await init();

    const androidDetails = AndroidNotificationDetails(
      'task_tracker_reminders',
      'Schoolwork Reminders',
      channelDescription:
          'Reminders and alerts for upcoming schoolworks and deadlines',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notificationsPlugin.show(id, title, body, details, payload: payload);
    } catch (e) {
      debugPrint('Could not display notification: $e');
    }
  }

  /// Cancels scheduled reminder for a specific schoolwork
  Future<void> cancelNotification(int id) async {
    if (kIsWeb) return;
    try {
      await _notificationsPlugin.cancel(id);
    } catch (e) {
      debugPrint('Could not cancel notification: $e');
    }
  }

  /// Schedules or posts a reminder alert for a schoolwork
  Future<void> scheduleSchoolworkReminder(
    SchoolworkModel work,
    SubjectModel subject,
  ) async {
    if (kIsWeb) return;
    final workId = work.workId ?? 0;
    // Notify immediate feedback that reminder is active
    await showNotification(
      id: workId,
      title: 'Reminder Set: [${subject.subjectCode}] ${work.title}',
      body:
          'Due on ${work.dueDate} at ${work.dueTime}. Priority: ${work.priority}',
      payload: 'work_$workId',
    );
  }
}
