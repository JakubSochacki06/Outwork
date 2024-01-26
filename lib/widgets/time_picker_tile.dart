import 'package:flutter/material.dart';
import 'package:outwork/providers/morning_routine_provider.dart';
import 'package:outwork/utilities/utilities.dart';

class TimePickerTile extends StatelessWidget {
  final dynamic subject;
  const TimePickerTile({required this.subject});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Text(subject.scheduledTime == null?'Schedule notification ->':'Scheduled at ${subject.scheduledTime.hour}:${subject.scheduledTime.minute}', style: Theme.of(context).primaryTextTheme.labelLarge,),
          Spacer(),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              subject.setScheduledTime(null);
            },
          ),
          IconButton(
            icon: Icon(subject.scheduledTime == null?Icons.notification_add:Icons.notifications_active),
            onPressed: () async{
              TimeOfDay? scheduledTime = await pickSchedule(context);
              subject.setScheduledTime(scheduledTime);
            },
          ),
        ],
      ),
    );
  }
}
