import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const int onlineReminderId = 1;

  static Future<void> init() async {
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: android);

    await _plugin.initialize(settings);
  }

  static Future<bool> shouldNotifyToday() async {
    final prefs = await SharedPreferences.getInstance();

    final lastOpen = prefs.getString('last_open_date');

    final today = DateTime.now().toIso8601String().substring(0, 10);

    return lastOpen != today;
  }

  /// Schedule daily online reminder (8PM)
  static Future<void> scheduleOnlineReminder() async {
    final shouldNotify = await shouldNotifyToday();

    if (!shouldNotify) {
      await cancelOnlineReminder();
      return;
    }

    final now = tz.TZDateTime.now(tz.local);

    // Target: today 8PM
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      20,
    );

    // If already past 8PM → schedule tomorrow
    if (scheduled.isBefore(now)) {
      scheduled = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day + 1,
        20,
      );
    }

    await _plugin.zonedSchedule(
      onlineReminderId,
      "Check your luck today ✨",
      "Your fortune is waiting for you",
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'online_remind',
          'Online Reminder',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelOnlineReminder() async {
    await _plugin.cancel(onlineReminderId);
  }

  /// debug helper
  static Future<void> testIn10Seconds() async {
    final scheduled =
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));

    await _plugin.zonedSchedule(
      999,
      "Test notification",
      "If you see this, it works",
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test',
          'Test',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
