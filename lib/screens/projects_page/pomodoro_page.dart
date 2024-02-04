import 'package:audioplayers/audioplayers.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/screens/projects_page/pop_ups/pomodoro_settings_popup.dart';
import 'package:provider/provider.dart';
import 'package:outwork/widgets/appBars/main_app_bar.dart';

class PomodoroPage extends StatefulWidget {
  // need to pass userProvider in order to access it in dispose method.
  final UserProvider userProvider;
   PomodoroPage({required this.userProvider});

  @override
  State<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  CountDownController pomodoroController = CountDownController();
  String pomodoroStatus = 'Pomodoro';
  String pomodoroTimerStatus = 'Not started';
  late int pomodoroTimer;
  int interval = 1;

  int calculateTimeDifference(int startTimeSeconds, String endTime) {
    List<int> endComponents = endTime.split(':').map(int.parse).toList();
    int endSeconds = endComponents[0] * 60 + endComponents[1];
    int timeDifference = startTimeSeconds - endSeconds;
    return timeDifference.abs();
  }

  @override
  void initState() {
    pomodoroTimer = widget.userProvider.user!.pomodoroSettings!['Pomodoro'] * 60;
    super.initState();
  }

  @override
  void dispose() {
    if(pomodoroTimerStatus != 'Not started'){
      int workedSeconds = calculateTimeDifference(
          pomodoroTimer, pomodoroController.getTime()!);
      Future.delayed(Duration.zero, () async {
        try {
          await widget.userProvider.addWorkedSecondsToDatabase(workedSeconds);
        } catch (e) {
          print('Error during disposal: $e');
        }
      });
    }
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    UserProvider userProvider = Provider.of<UserProvider>(context);


    void getNextMode(){
      if(pomodoroStatus == 'Pomodoro' && interval % 6 == 0){
        pomodoroStatus = 'Long break';
        pomodoroTimerStatus = 'Not started';
        pomodoroTimer = widget.userProvider.user!.pomodoroSettings!['LongBreak'] * 60;
        pomodoroController.restart(duration: pomodoroTimer);
        pomodoroController.pause();
        return;
      } else if(pomodoroStatus == 'Short break'){
        pomodoroStatus = 'Pomodoro';
        pomodoroTimerStatus = 'Not started';
        pomodoroTimer =  widget.userProvider.user!.pomodoroSettings!['Pomodoro'] * 60;
        pomodoroController.restart(duration: pomodoroTimer);
        pomodoroController.pause();
        return;
      } else {
        pomodoroStatus = 'Short break';
        pomodoroTimerStatus = 'Not started';
        pomodoroTimer = widget.userProvider.user!.pomodoroSettings!['ShortBreak'] * 60;
        pomodoroController.restart(duration: pomodoroTimer);
        pomodoroController.pause();
        return;
      }
    }


    TextButton? generateTextButton() {
      switch (pomodoroTimerStatus) {
        case 'Paused':
          return TextButton(
            onPressed: () {
              setState(() {
                pomodoroTimerStatus = 'Running';
                pomodoroController.resume();

              });
            },
            child: Text('Resume timer',
                style: Theme.of(context).textTheme.bodyLarge),
          );
        case 'Running':
          return TextButton(
            onPressed: () {
              setState(() {
                pomodoroTimerStatus = 'Paused';
                pomodoroController.pause();
              });

            },
            child:
            Text('Pause timer', style: Theme.of(context).textTheme.bodyLarge),
          );
        case 'Not started':
          return TextButton(
            onPressed: () {
              setState(() {
                pomodoroTimerStatus = 'Running';
                pomodoroController.start();
              });
            },
            child:
            Text('Start timer', style: Theme.of(context).textTheme.bodyLarge),
          );
      }
      return null;
    }
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: width*0.04, vertical: height*0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                    iconSize: width * 0.07,
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).colorScheme.primary)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.navigate_before),
                  ),
                  Spacer(),
                  SizedBox(
                    width: width * 0.015,
                  ),
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () async{
                      await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        useRootNavigator: true,
                        builder: (context) => SingleChildScrollView(
                          child: Container(
                            // height: height*0.1,
                            padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom),
                            child: PomodoroSettingsPopup(pomodoroSettings: userProvider.user!.pomodoroSettings!,)
                          ),
                        ),
                      );
                      setState(() {
                        pomodoroTimer = widget.userProvider.user!.pomodoroSettings!['Pomodoro'] * 60;
                        pomodoroStatus = 'Pomodoro';
                        pomodoroTimerStatus = 'Not started';
                        pomodoroController.reset();
                      });
                    },
                  )
                ],
              ),
              SizedBox(height: height*0.01,),
              Text(pomodoroStatus,
                  style: Theme.of(context).textTheme.displayMedium),
              SizedBox(
                height: height * 0.01,
              ),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        pomodoroStatus = 'Pomodoro';
                        pomodoroTimerStatus = 'Not started';
                        pomodoroTimer = widget.userProvider.user!.pomodoroSettings!['Pomodoro'] * 60;
                        pomodoroController.restart(duration: pomodoroTimer);
                        pomodoroController.pause();
                        // print(pomodoroTimer);
                        // pomodoroController.restart(duration: pomodoroTimer);
                      });
                    },
                    child: Text('Pomodoro',
                        style: Theme.of(context).textTheme.labelLarge),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        pomodoroStatus = 'Short break';
                        pomodoroTimerStatus = 'Not started';
                        pomodoroTimer = widget.userProvider.user!.pomodoroSettings!['ShortBreak'] * 60;
                        pomodoroController.restart(duration: pomodoroTimer);
                        pomodoroController.pause();
                        // print(pomodoroTimer);
                        // pomodoroController.restart(duration: pomodoroTimer);
                      });
                    },
                    child: Text('Short break',
                        style: Theme.of(context).textTheme.labelLarge),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        pomodoroStatus = 'Long break';
                        pomodoroTimerStatus = 'Not started';
                        pomodoroTimer = widget.userProvider.user!.pomodoroSettings!['LongBreak'] * 60;
                        pomodoroController.restart(duration: pomodoroTimer);
                        pomodoroController.pause();
                        // print(pomodoroTimer);
                        // pomodoroController.restart(duration: pomodoroTimer);
                      });
                    },
                    child: Text('Long break',
                        style: Theme.of(context).textTheme.labelLarge),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.01,
              ),
              CircularCountDownTimer(
                onComplete: () async{
                  final player = AudioPlayer();
                  await player.play(AssetSource('successSound.mp3'));
                  await userProvider.addWorkedSecondsToDatabase(pomodoroTimer);
                  setState(() {
                    interval++;
                    getNextMode();
                  });
                },
                  duration: pomodoroTimer,
                  controller: pomodoroController,
                  width: width * 0.8,
                  height: height * 0.4,
                  isReverse: true,
                  autoStart: false,
                  fillColor: pomodoroStatus=='Pomodoro'?Theme.of(context).colorScheme.error:Theme.of(context).colorScheme.secondary,
                  textStyle:
                      Theme.of(context).primaryTextTheme.displayLarge,
                  strokeWidth: 15,
                  ringColor: Theme.of(context).colorScheme.primary),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  generateTextButton()!,
                  pomodoroTimerStatus != 'Not started'?IconButton(
                    icon: Icon(Icons.skip_next),
                    onPressed: () async{
                      int workedSeconds = calculateTimeDifference(pomodoroTimer, pomodoroController.getTime()!);
                      await userProvider.addWorkedSecondsToDatabase(workedSeconds);
                      setState(() {
                        interval++;
                        getNextMode();
                      });
                    },
                  ):Container()
                ],
              ),
              SizedBox(height: height*0.01,),
              Text('#$interval You are doing great.', style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.primary),),
              Text(pomodoroStatus=='Pomodoro'?'It\'s time to ':'It\'s time for a ', style: Theme.of(context).textTheme.displayMedium),
              Text(pomodoroStatus=='Pomodoro'?'FOCUS':'BREAK', style: pomodoroStatus=='Pomodoro'?Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).colorScheme.error):Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).colorScheme.secondary),),
            ],
          ),
        ),
      ),
    );
  }
}
