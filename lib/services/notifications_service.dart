import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:outwork/utilities/utilities.dart';
import 'dart:io';


Future<void> createRoutineReminderNotification(TimeOfDay timeOfDay, String name, bool toughModeActivated) async {
  String notificationBody;
  if(toughModeActivated){
    notificationBody = 'Stop procrastinating and do it now ${Emojis.smile_clown_face}';
  } else {
    notificationBody = Platform.isIOS?'Stay consistent and you will win! ${Emojis.sun}':'Stay consistent and you will win! ${Emojis.symbols_sparkle}';
  }
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: name.hashCode.abs(),
      channelKey: 'scheduled_channel',
      title: 'Do you remember about $name? ${Emojis.time_alarm_clock}',
      body: notificationBody,
      notificationLayout: NotificationLayout.Default,
      wakeUpScreen: true,
      category: NotificationCategory.Reminder,
    ),
    // actionButtons: [
    //   NotificationActionButton(
    //     key: 'MARK_DONE',
    //     label: 'Mark Done',
    //   ),
    // ],
    schedule: NotificationCalendar(
      preciseAlarm: true,
      allowWhileIdle: true,
      timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
      hour: timeOfDay.hour,
      minute: timeOfDay.minute,
      second: 0,
      millisecond: 0,
      repeats: true,
    ),
  );
}