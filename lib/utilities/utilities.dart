import 'package:flutter/material.dart';

int createUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}


Future<TimeOfDay?> pickSchedule(BuildContext context, String dayTime) async {
  DateTime now = DateTime.now();
  TimeOfDay? timeOfDay = await showTimePicker(
    builder: (BuildContext context, Widget? child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      );
    },
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        now.add(
          const Duration(minutes: 1),
        ),
      ),
  );
  if(timeOfDay!.hour <= 14 && dayTime == 'Morning' || timeOfDay.hour > 14 && dayTime == 'Night'){
    return timeOfDay;
  } else {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Oh snap!', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.error)),
          content: Text(dayTime=='Morning'?'Insert that routine into night routines.\nMorning routines ends at 14:59':'Insert that routine into morning routines.\nNight routines starts at 15:00', style: Theme.of(context).primaryTextTheme.labelLarge,),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close', style: Theme.of(context).textTheme.bodySmall,),
              ),
            ),
          ],
        );
      },
    );
  }
  return null;
}

