import 'package:flutter/material.dart';
import 'package:outwork/providers/firebase_user_provider.dart';
import 'screens/welcome_page.dart';
import 'screens/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:outwork/screens/processing_logging_page.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:outwork/providers/google_signin_provider.dart';

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
        ChangeNotifierProvider(create: (context) => GoogleSignInProvider()),
        ChangeNotifierProvider(create: (context) => FirebaseUserProvider()),
      ],
      child: MaterialApp(
        title: 'Outwork',
        // theme: ThemeData(
        //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        //   useMaterial3: true,
        // ),
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