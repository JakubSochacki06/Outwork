import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:outwork/models/project.dart';
import 'package:outwork/providers/projects_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/widgets/calendar_picker_tile.dart';
import 'package:provider/provider.dart';


class PomodoroSettingsPopup extends StatefulWidget {
  final Map<dynamic, dynamic> pomodoroSettings;
  PomodoroSettingsPopup({required this.pomodoroSettings});

  @override
  State<PomodoroSettingsPopup> createState() => _PomodoroSettingsPopupState();
}

class _PomodoroSettingsPopupState extends State<PomodoroSettingsPopup> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

    return Container(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FractionallySizedBox(
              widthFactor: 0.15,
              alignment: Alignment.center,
              child: Container(
                height: height * 0.005,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Text(
              'Edit pomodoro settings',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(
              height: height*0.01,
            ),
            Row(
              children: [
                Container(
                  width: width*0.28,
                  child: Column(
                    children: [
                      Text('Pomodoro minutes', style: Theme.of(context).primaryTextTheme.labelLarge, textAlign: TextAlign.center,),
                      NumberPicker(
                        minValue: 5,
                        maxValue: 50,
                        itemCount: 3,
                        infiniteLoop: true,
                        // haptics: true,
                        value: widget.pomodoroSettings['Pomodoro']!,
                        onChanged: (number){
                          setState(() {
                            widget.pomodoroSettings['Pomodoro'] = number;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  width: width*0.28,
                  child: Column(
                    children: [
                      Text('Short break minutes', style: Theme.of(context).primaryTextTheme.labelLarge, textAlign: TextAlign.center,),
                      NumberPicker(
                        minValue: 1,
                        maxValue: 15,
                        itemCount: 3,
                        infiniteLoop: true,
                        // haptics: true,
                        value: widget.pomodoroSettings['ShortBreak']!,
                        onChanged: (number){
                          setState(() {
                            widget.pomodoroSettings['ShortBreak'] = number;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  width: width*0.28,
                  child: Column(
                    children: [
                      Text('Long break minutes', style: Theme.of(context).primaryTextTheme.labelLarge, textAlign: TextAlign.center,),
                      NumberPicker(
                        minValue: 5,
                        maxValue: 50,
                        itemCount: 3,
                        infiniteLoop: true,
                        // haptics: true,
                        value: widget.pomodoroSettings['LongBreak']!,
                        onChanged: (number){
                          setState(() {
                            widget.pomodoroSettings['LongBreak'] = number;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async{
                await userProvider.updatePomodoroSettings(widget.pomodoroSettings);
                Navigator.pop(context);
                // Navigator.pop(context);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => PomodoroPage(userProvider: userProvider)),
                // );
              },
              child: Text(
                'Submit',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer),
              ),
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                minimumSize: Size(width * 0.8, height * 0.05),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

