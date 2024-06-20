import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  if(timeOfDay!.hour <= 14 && dayTime == AppLocalizations.of(context)!.morning || timeOfDay.hour > 14 && dayTime == AppLocalizations.of(context)!.night){
    return timeOfDay;
  } else {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.ohSnap, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.error)),
          content: Text(dayTime==AppLocalizations.of(context)!.morning?'${AppLocalizations.of(context)!.insertThatRoutineIntoX("Night routines")}\n${AppLocalizations.of(context)!.morningRoutinesEndsAt}':'${AppLocalizations.of(context)!.insertThatRoutineIntoX("Morning Routines")}\n${AppLocalizations.of(context)!.nightRoutineStartsAt}', style: Theme.of(context).primaryTextTheme.labelLarge,),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)!.close, style: Theme.of(context).textTheme.bodySmall,),
              ),
            ),
          ],
        );
      },
    );
  }
  return null;
}

