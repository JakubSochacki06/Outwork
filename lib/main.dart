import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_update/in_app_update.dart';
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
import 'package:outwork/screens/chat_page.dart';
import 'package:outwork/screens/login_page/processing_logging_page.dart';
import 'package:outwork/screens/profile_page/settings_page.dart';
import 'package:outwork/services/notifications_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/l10n.dart';
import 'notification_controller.dart';
import 'screens/login_page/welcome_page.dart';
import 'screens/login_page/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/journal_entry_provider.dart';




Future main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(testDeviceIds: ['BF39F4EB121478D2876344D1BF1E3091']));
  await MobileAds.instance.initialize();
  await dotenv.load();
  await AwesomeNotifications()
      .initialize('resource://drawable/notification_icon',[
    NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notification',
        channelDescription: 'Basic notifications channel',
        channelGroupKey: 'basic_channel_group',
        importance: NotificationImportance.High,
        channelShowBadge: true),
    NotificationChannel(
        channelKey: 'scheduled_channel',
        channelName: 'Scheduled Notifications',
        channelDescription: 'Scheduled notifications channel',
        importance: NotificationImportance.High,
        channelShowBadge: true
    ),
  ], channelGroups: [
    NotificationChannelGroup(
        channelGroupKey: 'basic_channel_group', channelGroupName: 'Basic Group')
  ]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterBranchSdk.init();
  PurchasesConfiguration configuration = PurchasesConfiguration(Platform.isIOS?appleRCApiKey:googleRCApiKey);
  await Purchases.configure(configuration);
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  Future<Locale> loadSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String languageCode = prefs.getString('languageCode') ?? 'en';
    return Locale(languageCode);
  }

  Locale locale = await loadSelectedLanguage();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: MyApp(locale: locale,),
      ),
    );
    FlutterNativeSplash.remove();
  });
}

class MyApp extends StatefulWidget {
  final Locale locale;
  MyApp({required this.locale});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: NotificationController.onDismissActionReceivedMethod,
    );

    // FlutterBranchSdk.validateSDKIntegration();
    checkForUpdate();
    initBranch();
    super.initState();
  }

  void initBranch() async{
    StreamSubscription<Map> streamSubscription = FlutterBranchSdk.initSession().listen((data) async {
      if (data.containsKey("+clicked_branch_link") &&
          data["+clicked_branch_link"] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('referredBy', data["referring_user_email"]);
        print('Custom string: ${data["custom_string"]}');

      }
    }, onError: (error) {
      PlatformException platformException = error as PlatformException;
      print(
          'InitSession error: ${platformException.code} - ${platformException.message}');
    });
  }

  Future<void> checkForUpdate() async {
    print('checking for Update');
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          print('update available');
          update();
        }
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  void update() async {
    print('Updating');
    await InAppUpdate.startFlexibleUpdate();
    InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((e) {
      print(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: true);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    themeProvider.selectedLocale == null?themeProvider.setStartingLocale(widget.locale):null;
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
        theme: themeProvider.themeData,
        debugShowCheckedModeBanner: false,
        locale: themeProvider.selectedLocale,
        supportedLocales: L10n.all,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
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
