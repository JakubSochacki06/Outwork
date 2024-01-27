import 'package:flutter/material.dart';
import 'package:outwork/providers/morning_routine_provider.dart';
import 'package:outwork/utilities/utilities.dart';

class TimePickerTile extends StatelessWidget {
  final dynamic subject;
  final bool hasError;
  const TimePickerTile({required this.subject, required this.hasError});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    String minutes = '';
    if(subject.scheduledTime != null){
      subject.scheduledTime.minute.toString().length == 1? minutes = '0${subject.scheduledTime.minute}': minutes = subject.scheduledTime.minute.toString();
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height*0.01),
      decoration: BoxDecoration(
          border:
              Border.all(
              color: hasError == true? Theme.of(context).colorScheme.error:Theme.of(context).colorScheme.primary,
              width: 2),
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Text(subject.scheduledTime == null?'Schedule notification ->':'Scheduled at ${subject.scheduledTime.hour}:$minutes', style: Theme.of(context).primaryTextTheme.labelLarge,),
          Spacer(),
          subject.scheduledTime != null?InkWell(
            child: Icon(Icons.delete),
            onTap: () {
              subject.setScheduledTime(null);
            },
          ):Container(),
          SizedBox(width: width*0.01,),
          InkWell(
            child: Icon(subject.scheduledTime == null?Icons.notification_add:Icons.notifications_active),
            onTap: () async{
              TimeOfDay? scheduledTime = await pickSchedule(context, subject.runtimeType == MorningRoutineProvider?'Morning':'Night');
              subject.setScheduledTime(scheduledTime);
            },
          ),
        ],
      ),
    );
  }
}
