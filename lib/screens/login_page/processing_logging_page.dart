import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:outwork/providers/chat_provider.dart';
import 'package:outwork/providers/journal_entry_provider.dart';
import 'package:outwork/providers/morning_routine_provider.dart';
import 'package:outwork/providers/night_routine_provider.dart';
import 'package:outwork/providers/projects_provider.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:outwork/providers/xp_level_provider.dart';
import 'package:outwork/screens/login_page/account_creation_slides.dart';
import 'package:outwork/screens/login_page/login_page.dart';
import 'package:outwork/services/database_service.dart';
import 'package:outwork/page_navigator.dart';
import 'package:outwork/services/notifications_service.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../constants/constants.dart';
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
    JournalEntryProvider journalEntryProvider = Provider.of<JournalEntryProvider>(context, listen: false);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    Future<void> setUpData() async{
      DatabaseService _dbS = DatabaseService();
      if(await _dbS.userExists(FirebaseAuth.instance.currentUser!)){
        await userProvider.fetchUserData(FirebaseAuth.instance.currentUser!.email!);
        DateTime now = DateTime.now();
        if(userProvider.user!.lastUpdated!.day != now.day){
          await userProvider.restartDailyData();
        }
        await Purchases.logIn(userProvider.user!.email!);
        print("BEFORE SETTINGS PROJECT LIST");
        await projectsProvider.setProjectsList(userProvider.user!);
        await FirebaseMessaging.instance.requestPermission(provisional: true);
        if(userProvider.user!.toughModeSelected!){
          await FirebaseMessaging.instance.subscribeToTopic("tough${themeProvider.selectedLocale!.languageCode}");
        } else {
          await FirebaseMessaging.instance.subscribeToTopic("basic${themeProvider.selectedLocale!.languageCode}");
        }
        final apnsToken = await FirebaseMessaging.instance.getToken();
        print("APNS");
        print(apnsToken);
        print("AFTER SETTING PROJECT LIST");
        xpLevelProvider.setXPAmount(userProvider.user!);
        morningRoutineProvider.setMorningRoutines(userProvider.user!);
        journalEntryProvider.setJournalEntries(userProvider.user!);
        nightRoutineProvider.setNightRoutines(userProvider.user!);
        progressProvider.setProgressFields(userProvider.user!);
        print("EVERYTHING SET");
        try {
          CustomerInfo customerInfo = await Purchases.getCustomerInfo();
          if (customerInfo.entitlements.all['premium']!.isActive) {
            userProvider.user!.isPremiumUser = true;
          } else {
            userProvider.user!.isPremiumUser = false;
          }
        } catch (e) {
          userProvider.user!.isPremiumUser = false;
        }
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AccountCreationSlides()),
        );
      }
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
                    TyperAnimatedText(AppLocalizations.of(context)!.loading, speed: const Duration(milliseconds: 100), textStyle: Theme.of(context).textTheme.bodyLarge)
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
                          TyperAnimatedText(AppLocalizations.of(context)!.loading, speed: const Duration(milliseconds: 100), textStyle: Theme.of(context).textTheme.bodyLarge)
                        ],
                      )
                    ],
                  ));
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (userProvider.user == null) {
                    return Center(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/loader.json', height: 150, width: 150),
                        AnimatedTextKit(
                          repeatForever: true,
                          animatedTexts: [
                            TyperAnimatedText(AppLocalizations.of(context)!.creatingUser, speed: const Duration(milliseconds: 100), textStyle: Theme.of(context).textTheme.bodyLarge)
                          ],
                        )
                      ],
                    ));
                  }
                  return PageNavigator();
                } else {
                  return Center(child: Text(AppLocalizations.of(context)!.somethingWentWrong));
                }
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(AppLocalizations.of(context)!.somethingWentWrong));
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}