// notification_service.dart
// Wraps flutter_local_notifications to provide REAL device notifications
// (not a UI simulation). This is the file to link for the "notification
// configure" / notification implementation checklist items.
//
// Two capabilities are exposed:
//   1. showInstant()   -> fires a notification immediately (great for a
//                         quick "does it work" screenshot).
//   2. scheduleReminder() -> schedules a real notification N seconds/minutes
//                            in the future using the device's local timezone.

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  /// Call once, early in main(), before runApp().
  static Future<void> init() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();
    // Using UTC as a safe default. Swap in a device-timezone package
    // (e.g. flutter_timezone) if you need exact local-time scheduling.
    tz.setLocalLocation(tz.UTC);

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

    await _plugin.initialize(initSettings);
    _initialized = true;
  }

  /// Requests notification permission (required on Android 13+ and iOS).
  /// Call this from a button tap so the OS permission dialog has a clear
  /// user gesture behind it.
  static Future<void> requestPermission() async {
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.requestNotificationsPermission();

    final iosImpl = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    await iosImpl?.requestPermissions(alert: true, badge: true, sound: true);
  }

  static const AndroidNotificationDetails _androidDetails =
      AndroidNotificationDetails(
    'fitness_tracker_channel',
    'Fitness Tracker Reminders',
    channelDescription: 'Workout and habit reminders',
    importance: Importance.max,
    priority: Priority.high,
  );

  static const NotificationDetails _details = NotificationDetails(
    android: _androidDetails,
    iOS: DarwinNotificationDetails(),
  );

  /// Fires a notification immediately. Useful to verify notifications work
  /// at all on the current device/emulator.
  static Future<void> showInstant({
    required String title,
    required String body,
  }) async {
    await _plugin.show(0, title, body, _details);
  }

  /// Schedules a real notification `secondsFromNow` seconds in the future.
  static Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required int secondsFromNow,
  }) async {
    final scheduledDate =
        tz.TZDateTime.now(tz.local).add(Duration(seconds: secondsFromNow));

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
