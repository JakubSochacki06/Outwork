import 'package:audioplayers/audioplayers.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/providers/xp_level_provider.dart';
import 'package:outwork/screens/projects_page/pop_ups/pomodoro_settings_popup.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  // 1 = Not started, 2 = paused, 3 = running
  int pomodoroTimerStatus = 1;
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
    if(pomodoroTimerStatus != 1){
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
    XPLevelProvider xpLevelProvider = Provider.of<XPLevelProvider>(context);


    void getNextMode(){
      if(pomodoroStatus == 'Pomodoro' && interval % 6 == 0){
        pomodoroStatus = AppLocalizations.of(context)!.longBreak;
        pomodoroTimerStatus = 1;
        pomodoroTimer = widget.userProvider.user!.pomodoroSettings!['LongBreak'] * 60;
        pomodoroController.restart(duration: pomodoroTimer);
        pomodoroController.pause();
        return;
      } else if(pomodoroStatus == AppLocalizations.of(context)!.shortBreak){
        pomodoroStatus = 'Pomodoro';
        pomodoroTimerStatus = 1;
        pomodoroTimer =  widget.userProvider.user!.pomodoroSettings!['Pomodoro'] * 60;
        pomodoroController.restart(duration: pomodoroTimer);
        pomodoroController.pause();
        return;
      } else {
        pomodoroStatus = AppLocalizations.of(context)!.shortBreak;
        pomodoroTimerStatus = 1;
        pomodoroTimer = widget.userProvider.user!.pomodoroSettings!['ShortBreak'] * 60;
        pomodoroController.restart(duration: pomodoroTimer);
        pomodoroController.pause();
        return;
      }
    }


    TextButton? generateTextButton() {
      switch (pomodoroTimerStatus) {
        case 2:
          return TextButton(
            onPressed: () {
              setState(() {
                pomodoroTimerStatus = 3;
                pomodoroController.resume();

              });
            },
            child: Text(AppLocalizations.of(context)!.resumeTimer,
                style: Theme.of(context).textTheme.bodyLarge),
          );
        case 3:
          return TextButton(
            onPressed: () {
              setState(() {
                pomodoroTimerStatus = 2;
                pomodoroController.pause();
              });

            },
            child:
            Text(AppLocalizations.of(context)!.pauseTimer, style: Theme.of(context).textTheme.bodyLarge),
          );
        case 1:
          return TextButton(
            onPressed: () {
              setState(() {
                pomodoroTimerStatus = 3;
                pomodoroController.start();
              });
            },
            child:
            Text(AppLocalizations.of(context)!.startTimer, style: Theme.of(context).textTheme.bodyLarge),
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
                    icon: const Icon(Icons.navigate_before),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: width * 0.015,
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
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
                        pomodoroTimerStatus = 1;
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
                        pomodoroTimerStatus = 1;
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
                        pomodoroStatus = AppLocalizations.of(context)!.shortBreak;
                        pomodoroTimerStatus = 1;
                        pomodoroTimer = widget.userProvider.user!.pomodoroSettings!['ShortBreak'] * 60;
                        pomodoroController.restart(duration: pomodoroTimer);
                        pomodoroController.pause();
                        // print(pomodoroTimer);
                        // pomodoroController.restart(duration: pomodoroTimer);
                      });
                    },
                    child: Text(AppLocalizations.of(context)!.shortBreak,
                        style: Theme.of(context).textTheme.labelLarge),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        pomodoroStatus = AppLocalizations.of(context)!.longBreak;
                        pomodoroTimerStatus = 1;
                        pomodoroTimer = widget.userProvider.user!.pomodoroSettings!['LongBreak'] * 60;
                        pomodoroController.restart(duration: pomodoroTimer);
                        pomodoroController.pause();
                        // print(pomodoroTimer);
                        // pomodoroController.restart(duration: pomodoroTimer);
                      });
                    },
                    child: Text(AppLocalizations.of(context)!.longBreak,
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
                  pomodoroTimerStatus != 1?IconButton(
                    icon: const Icon(Icons.skip_next),
                    onPressed: () async{
                      int workedSeconds = calculateTimeDifference(pomodoroTimer, pomodoroController.getTime()!);
                      await userProvider.addWorkedSecondsToDatabase(workedSeconds);
                      xpLevelProvider.addXpAmount((workedSeconds*0.10).toInt(), userProvider.user!.email!, context);
                      setState(() {
                        interval++;
                        getNextMode();
                      });
                    },
                  ):Container()
                ],
              ),
              SizedBox(height: height*0.01,),
              Text('#$interval ${AppLocalizations.of(context)!.youAreDoingGreat}', style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),),
              Text(pomodoroStatus=='Pomodoro'?AppLocalizations.of(context)!.itsTimeTo:AppLocalizations.of(context)!.itsTimeForA, style: Theme.of(context).textTheme.displayMedium),
              Text(pomodoroStatus=='Pomodoro'?AppLocalizations.of(context)!.focus:AppLocalizations.of(context)!.breakTIMER, style: pomodoroStatus=='Pomodoro'?Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).colorScheme.error):Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).colorScheme.secondary),),
            ],
          ),
        ),
      ),
    );
  }
}
