import 'package:flutter/material.dart';

int createUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}


Future<TimeOfDay?> pickSchedule(BuildContext context,) async {
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
          Duration(minutes: 1),
        ),
      ),
  );
  if(timeOfDay!=null){
    return timeOfDay;
  }
  return null;
}

