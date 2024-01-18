import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:outwork/providers/daily_checkin_provider.dart';
import 'package:outwork/providers/end_of_the_day_journal_provider.dart';
import 'package:outwork/providers/morning_routine_provider.dart';
import 'package:outwork/providers/navbar_controller_provider.dart';
import 'package:outwork/providers/night_routine_provider.dart';
import 'package:outwork/providers/projects_provider.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/screens/add_project_page.dart';
import 'package:outwork/screens/pomodoro_page.dart';
import 'package:outwork/screens/project_info_page.dart';
import 'package:outwork/screens/settings_page.dart';
import 'package:outwork/theme/dark_theme.dart';
import 'screens/welcome_page.dart';
import 'screens/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:outwork/screens/processing_logging_page.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/journal_entry_provider.dart';
import 'package:outwork/theme/light_theme.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => NavbarControllerProvider()),
        ChangeNotifierProvider(create: (context) => DailyCheckinProvider()),
        ChangeNotifierProvider(create: (context) => MorningRoutineProvider()),
        ChangeNotifierProvider(create: (context) => NightRoutineProvider()),
        ChangeNotifierProvider(create: (context) => JournalEntryProvider()),
        ChangeNotifierProvider(create: (context) => EndOfTheDayJournalProvider()),
        ChangeNotifierProvider(create: (context) => ProjectsProvider()),
      ],
      child: MaterialApp(
        title: 'Outwork',
        theme: Provider.of<ThemeProvider>(context, listen:false).themeData,
        // darkTheme: darkTheme,
        // themeMode: ThemeMode.dark,
        routes: {
          '/welcome':(context) => WelcomePage(),
          '/login':(context) => LoginPage(),
          '/processingLogging':(context) => ProcessingLoggingPage(),
          '/settings':(context) => SettingsPage(),
        },
        initialRoute: FirebaseAuth.instance.currentUser!=null?'/processingLogging':'/login',
      ),
    );
  }
}