import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:outwork/utilities/utilities.dart';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> createRoutineReminderNotification(TimeOfDay timeOfDay, String name, bool toughModeActivated, context) async {
  String notificationBody;
  if(toughModeActivated){
    notificationBody = '${AppLocalizations.of(context)!.notificationBodyTough} ${Emojis.smile_clown_face}';
  } else {
    notificationBody = '${AppLocalizations.of(context)!.notificationBodyBasic} ${Platform.isIOS?Emojis.sun:Emojis.symbols_sparkle}';
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