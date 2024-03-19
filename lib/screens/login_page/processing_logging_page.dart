import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:outwork/providers/daily_checkin_provider.dart';
import 'package:outwork/providers/journal_entry_provider.dart';
import 'package:outwork/providers/morning_routine_provider.dart';
import 'package:outwork/providers/night_routine_provider.dart';
import 'package:outwork/providers/projects_provider.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:outwork/providers/xp_level_provider.dart';
import 'package:outwork/screens/login_page/login_page.dart';
import 'package:outwork/services/database_service.dart';
import 'package:outwork/page_navigator.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/user_provider.dart';

import '../../providers/progress_provider.dart';

class ProcessingLoggingPage extends StatefulWidget {
  @override
  State<ProcessingLoggingPage> createState() => _LoggingPageState();
}

class _LoggingPageState extends State<ProcessingLoggingPage> {

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    ProjectsProvider projectsProvider = Provider.of<ProjectsProvider>(context, listen: false);
    MorningRoutineProvider morningRoutineProvider = Provider.of<MorningRoutineProvider>(context, listen: false);
    NightRoutineProvider nightRoutineProvider = Provider.of<NightRoutineProvider>(context, listen: false);
    XPLevelProvider xpLevelProvider = Provider.of<XPLevelProvider>(context, listen: false);
    ProgressProvider progressProvider = Provider.of<ProgressProvider>(context, listen: false);
    JournalEntryProvider journalEntryProvider = Provider.of<JournalEntryProvider>(
        context, listen: false);


    Future<void> setUpData() async{
      DatabaseService _dbS = DatabaseService();
      await _dbS.setUserDataFromGoogle(FirebaseAuth.instance.currentUser!);
      await userProvider.fetchUserData(FirebaseAuth.instance.currentUser!.email!);
      DateTime now = DateTime.now();
      if(userProvider.user!.lastUpdated!.day != now.day){
        await userProvider.restartDailyData();
      }
      await projectsProvider.setProjectsList(userProvider.user!);
      morningRoutineProvider.setMorningRoutines(userProvider.user!);
      journalEntryProvider.setJournalEntries(userProvider.user!);
      nightRoutineProvider.setNightRoutines(userProvider.user!);
      progressProvider.setProgressFields(userProvider.user!);
      xpLevelProvider.setXPAmount(userProvider.user!);
    }

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/loader.json', height: 150, width: 150),
                AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText('Loading...', speed: Duration(milliseconds: 100), textStyle: Theme.of(context).textTheme.bodyLarge)
                  ],
                )
              ],
            ),);
          } else if (snapshot.hasData) {
            return FutureBuilder
              (
              future: setUpData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/loader.json', height: 150, width: 150),
                      AnimatedTextKit(
                        repeatForever: true,
                        animatedTexts: [
                          TyperAnimatedText('Loading...', speed: Duration(milliseconds: 100), textStyle: Theme.of(context).textTheme.bodyLarge)
                        ],
                      )
                    ],
                  ));
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (userProvider.user == null) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(child: Lottie.asset('assets/loader.json')),
                        Text('Loading user', style: Theme.of(context).textTheme.headlineMedium,)
                      ],
                    );
                  }
                  return PageNavigator();
                } else {
                  return const Center(child: Text('Something went Wrong!'));
                }
              },
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went Wrong!'));
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}