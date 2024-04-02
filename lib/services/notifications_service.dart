import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final onClickNotification = BehaviorSubject<String>();

// on tap on any notification
  static void onNotificationTap(NotificationResponse notificationResponse) {
    onClickNotification.add(notificationResponse.payload!);
  }

// initialize the local notifications
  static Future init() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('notification_icon');
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );
    final LinuxInitializationSettings initializationSettingsLinux =
    LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
        linux: initializationSettingsLinux);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }

  static Future showOngoingNotifications() async{
    print('NOTIFICATIONS');
    print(await _flutterLocalNotificationsPlugin.pendingNotificationRequests());
    List<PendingNotificationRequest> requestList = await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  static Future showDummy() async{
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, now.hour, 11);
    await _flutterLocalNotificationsPlugin.zonedSchedule(2115, 'test', 'pls work', scheduledDate, notificationDetails, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime, );
  }

  // to show periodic notification at regular interval
  Future createRoutineReminder({
    required String title,
    required String body,
    required int notificationHour,
    required int notificationMinute,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('ScheduledID', 'scheduledChannel',
        channelDescription: 'Scheduled Routines notifications',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        title.hashCode.abs(),
        title,
        body,
      _nextInstanceOfTenAM(notificationHour, notificationMinute),
        NotificationDetails(android: androidNotificationDetails),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,);
  }

  tz.TZDateTime _nextInstanceOfTenAM(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  // close a specific channel notification
  static Future cancel(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  // close all the notifications available
  static Future cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}