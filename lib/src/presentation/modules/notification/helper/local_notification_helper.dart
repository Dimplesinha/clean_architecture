import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:workapp/main.dart';

class NotificationHelper {
  static final NotificationHelper _singleton = NotificationHelper._internal();

  NotificationHelper._internal();

  static NotificationHelper get instance => _singleton;

  static void showNotification() async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'flutter_clean_Architecture_id_1',
      'flutter_clean_Architecture',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      1,
      'New Notification',
      'This is a local notification!',
      platformChannelSpecifics,
      payload: 'item 1',
    );
  }

  static void scheduleNotification() async {
    // Define notification details
    var androidDetails = const AndroidNotificationDetails(
      'flutter_clean_Architecture_id_1',
      'flutter_clean_Architecture',
      channelDescription: 'Scheduled Notification',
      priority: Priority.high,
      importance: Importance.max,
    );
    DarwinNotificationDetails iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
    );

    var platformChannelSpecifics = NotificationDetails(android: androidDetails, iOS: iosDetails);

    tz.initializeTimeZones();
    // Define the time for the notification to be displayed
    var scheduledTime = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5));

    // Schedule the notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Scheduled Notification',
      'This is a scheduled notification!',
      scheduledTime,
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
