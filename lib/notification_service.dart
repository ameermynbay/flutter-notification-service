import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static late tz.Location _local; // Initialize the _local variable

  static void initialize() {
    tz.initializeTimeZones();
    _local = tz.local;
    _flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
  }

  static Future showScheduledNotification({  // this method is called when the button for creating a reminder is clicked
    // following are arguments that are from the reminder screen inputs
    required DateTime scheduledDate,
    required String title,
    required String body,
    required String payload,
    bool isDailyTask = false,
    bool isWeeklyTask = false,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      '9030',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@mipmap/ic_launcher',  //icon of the notification
    );
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);

    // if statements depending if the notification is one time, weekly or daily
    if (isDailyTask) {
      await _flutterLocalNotificationsPlugin.periodicallyShow(
        0,
        title,
        body,
        RepeatInterval.daily, // RepeatInterval.everyMinute is used for testing
        notificationDetails,
        androidAllowWhileIdle: true,
      );
    } else if (isWeeklyTask){
      await _flutterLocalNotificationsPlugin.periodicallyShow(
        0,
        title,
        body,
        RepeatInterval.weekly,
        notificationDetails,
        androidAllowWhileIdle: true,
      );
    }
    else {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, _local),
        notificationDetails,
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }
}
