import 'package:flutter/material.dart';
import 'package:outwork/providers/morning_routine_provider.dart';
import 'package:outwork/providers/night_routine_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'screens/welcome_page.dart';
import 'screens/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:outwork/screens/processing_logging_page.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/journal_entry_provider.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => MorningRoutineProvider()),
        ChangeNotifierProvider(create: (context) => NightRoutineProvider()),
        ChangeNotifierProvider(create: (context) => JournalEntryProvider()),
      ],
      child: MaterialApp(
        title: 'Outwork',
        // theme: ThemeData(
        //   useMaterial3: true,
        // ),
        // darkTheme: ThemeData(brightness: Brightness.dark),
        // themeMode: ThemeMode.dark,
        routes: {
          '/welcome':(context) => WelcomePage(),
          '/login':(context) => LoginPage(),
          '/processingLogging':(context) => ProcessingLoggingPage(),
        },
        initialRoute: '/login',
      ),
    );
  }
}