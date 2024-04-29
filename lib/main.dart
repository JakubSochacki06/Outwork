import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:outwork/constants/constants.dart';
import 'package:outwork/providers/chat_provider.dart';
import 'package:outwork/providers/daily_checkin_provider.dart';
import 'package:outwork/providers/end_of_the_day_journal_provider.dart';
import 'package:outwork/providers/morning_routine_provider.dart';
import 'package:outwork/providers/navbar_controller_provider.dart';
import 'package:outwork/providers/night_routine_provider.dart';
import 'package:outwork/providers/progress_provider.dart';
import 'package:outwork/providers/projects_provider.dart';
import 'package:outwork/providers/theme_provider.dart';
import 'package:outwork/providers/user_provider.dart';
import 'package:outwork/providers/xp_level_provider.dart';
import 'package:outwork/screens/login_page/processing_logging_page.dart';
import 'package:outwork/screens/profile_page/settings_page.dart';
import 'package:outwork/services/notifications_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'go_pro_page.dart';
import 'screens/login_page/welcome_page.dart';
import 'screens/login_page/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/journal_entry_provider.dart';
import 'package:timezone/data/latest.dart' as tz;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await LocalNotifications.init();
  tz.initializeTimeZones();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  PurchasesConfiguration configuration = PurchasesConfiguration(googleRCApiKey);
  await Purchases.configure(configuration);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: true);
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => XPLevelProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider(context)),
        ChangeNotifierProvider(create: (context) => NavbarControllerProvider()),
        ChangeNotifierProvider(create: (context) => DailyCheckinProvider()),
        ChangeNotifierProvider(create: (context) => MorningRoutineProvider()),
        ChangeNotifierProvider(create: (context) => NightRoutineProvider()),
        ChangeNotifierProvider(create: (context) => ProgressProvider()),
        ChangeNotifierProvider(create: (context) => JournalEntryProvider()),
        ChangeNotifierProvider(create: (context) => EndOfTheDayJournalProvider()),
        ChangeNotifierProvider(create: (context) => ProjectsProvider()),
      ],
      child: MaterialApp(
        title: 'Outwork',
        theme: Provider.of<ThemeProvider>(context, listen: false).themeData,
        // darkTheme: darkTheme,
        // themeMode: ThemeMode.dark,
        routes: {
          '/welcome': (context) => WelcomePage(),
          '/login': (context) => const LoginPage(),
          '/processingLogging': (context) => ProcessingLoggingPage(),
          '/settings': (context) => const SettingsPage(),
        },
        initialRoute: FirebaseAuth.instance.currentUser != null
            ? '/processingLogging'
            : '/login',
      ),
    );
  }
}
