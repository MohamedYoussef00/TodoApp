
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mytodo/cubit/cubit.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {

    // Android initialization
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');// should mention the app icon during initialization itself

  /*  // Ios initialization
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );*/

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: null,
        );
    // the initialization settings are initialized after they are setted
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }


  Future<void> showNotification(int id, String title, String body,context) async {

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
     // tz.initializeTimeZones();
     // tz.TZDateTime scheduledAt = tz.TZDateTime.from(dateTime, tz.local),
      //  tz.TZDateTime.from(dateTime, tz.local),
        TodoCubit.get(context).taskesTime[0],
    //  tz.TZDateTime.now(tz.local).add(Duration(seconds: 1)),
      const NotificationDetails(
        // Android details
        android: AndroidNotificationDetails(
            'main_channel', 'Main Channel',
            channelDescription: "ashwin",
            importance: Importance.max,
            priority: Priority.max),
        // iOS details
       /* iOS: IOSNotificationDetails(
          sound: 'default.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),*/
      ),
      // Type of time interpretation
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      //uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
      androidAllowWhileIdle: true,//To show notification even when the app is closed
    );
  }

}