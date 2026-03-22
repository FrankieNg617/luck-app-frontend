import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const int onlineReminderId = 1;

  static Future<void> init() async {
    tz.initializeTimeZones();

    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings = InitializationSettings(
      android: android,
    );

    await _plugin.initialize(settings);
  }

  /// Schedule daily online reminder (8PM)
  static Future<void> scheduleOnlineReminder() async {
    final prefs = await SharedPreferences.getInstance();
    final onlineEnabled = prefs.getBool('settings_online_remind') ?? true;

    if (!onlineEnabled) {
      await cancelOnlineReminder();
      return;
    }

    final now = tz.TZDateTime.now(tz.local);
    final tomorrowAt8 = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day + 1,
      20,
      0,
    );

    await cancelOnlineReminder();

    await _plugin.zonedSchedule(
      onlineReminderId,
      'Check your luck today ✨',
      'Your fortune is waiting for you',
      tomorrowAt8,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'online_remind',
          'Online Reminder',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    debugPrint('online reminder scheduled for: $tomorrowAt8');
    final pending = await NotificationService.pendingNotifications();
    debugPrint('pending count: ${pending.length}');
    for (final n in pending) {
      debugPrint('id=${n.id}, title=${n.title}, body=${n.body}');
    }
  }

  static Future<void> cancelOnlineReminder() async {
    await _plugin.cancel(onlineReminderId);
    final pending = await NotificationService.pendingNotifications();
    debugPrint('pending count: ${pending.length}');
    for (final n in pending) {
      debugPrint('id=${n.id}, title=${n.title}, body=${n.body}');
    }
  }

  static Future<List<PendingNotificationRequest>> pendingNotifications() async {
    return _plugin.pendingNotificationRequests();
  }

  /// debug helper
  static Future<void> testIn5Seconds() async {
    final scheduled = tz.TZDateTime.now(tz.local).add(Duration(seconds: 5));

    debugPrint('test scheduled for: $scheduled');

    await _plugin.zonedSchedule(
      999,
      "Check your luck today ✨",
      "Your fortune is waiting for you",
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Test Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }
}
