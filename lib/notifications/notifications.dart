import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:outwork/utilities/utilities.dart';

Future<void> createRoutineReminderNotification(TimeOfDay timeOfDay, String name) async {
  print('DELETED ID: ${name.hashCode.abs()}');
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: name.hashCode.abs(),
      channelKey: 'scheduled_channel',
      title: '${Emojis.time_alarm_clock} Do you remember about $name?',
      body: 'Stay consistent and you will win!',
      notificationLayout: NotificationLayout.Default,
      wakeUpScreen: true,
      category: NotificationCategory.Reminder,
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'MARK_DONE',
        label: 'Mark Done',
      ),
    ],
    schedule: NotificationCalendar(
      preciseAlarm: true,
      timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
      hour: timeOfDay.hour,
      minute: timeOfDay.minute,
      second: 0,
      millisecond: 0,
      repeats: true,
    ),
  );
}