import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:android_intent_plus/android_intent.dart';

class NotifyHelper {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> initNotification() async {
    if (isInitialized) return;
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    print("🕒 Detected Timezone: $currentTimeZone");
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    if (Platform.isAndroid) {
      var status = await Permission.notification.request();
      if (await Permission.scheduleExactAlarm.isDenied) {
        await Permission.scheduleExactAlarm.request();
        return;
      }
      if (status.isDenied) {
        print("❌ Notification permission denied.");
        return;
      } else if (status.isPermanentlyDenied) {
        print(
          "⚠️ Notification permission permanently denied. Please enable it in settings.",
        );
        return;
      }
    }

    const initSettingAndroid = AndroidInitializationSettings(
      '@drawable/appicon',
    );
    const initSettingIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: initSettingAndroid,
      iOS: initSettingIOS,
    );

    await notificationsPlugin.initialize(initSettings);
    print("✅ Notifications successfully initialized.");
  }

  //như tên hàm
  void openExactAlarmSettings() async {
    final intent = AndroidIntent(
      action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
    );
    await intent.launch();
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "dailyflow_prototype_2",
        "channelName",
        channelDescription: "Description",
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    final details = notificationDetails();
    await notificationsPlugin.show(
      id,
      title ?? "Default Title",
      body ?? "Default Body",
      details,
    );
  }

  Future<void> scheduledNotification({
    required id,
    required String title,
    required String body,
    required int year,
    required int month,
    required int day,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    var scheduledDate = tz.TZDateTime(tz.local, year, month, day, hour, minute);

    // var scheduledDate = now.add(const Duration(seconds: 6));
    print("🕒 Now: $now");
    print("📆 Scheduled Notification Time: $scheduledDate");

    if (scheduledDate.isBefore(now)) {
      print("⚠️ Scheduled time is in the past! Adjusting to tomorrow...");
      scheduledDate = scheduledDate.add(Duration(days: 1));
    }

    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          channelDescription: 'your channel description',
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
    print("✅ Notification scheduled for: $scheduledDate");
  }

  Future<void> cancelAllNotifications() async {
    await notificationsPlugin.cancelAll();
  }

  Future<void> cancelNotifications(int id) async {
    await notificationsPlugin.cancel(id);
    print("Notification id $id canceled");
  }
}
