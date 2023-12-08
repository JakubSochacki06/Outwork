// import 'package:familyfridge/providers/firebase_user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:outwork/services/database_service.dart';
import 'package:outwork/page_navigator.dart';
import 'package:outwork/screens/login_page.dart';
import 'package:provider/provider.dart';
// import 'package:familyfridge/services/database_service.dart';

class ProcessingLoggingPage extends StatefulWidget {
  @override
  State<ProcessingLoggingPage> createState() => _LoggingPageState();
}

class _LoggingPageState extends State<ProcessingLoggingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            DatabaseService dbs = DatabaseService();
            print(FirebaseAuth.instance.currentUser!.providerData[0].providerId);
            if(FirebaseAuth.instance.currentUser!.providerData[0].providerId == "google.com"){
              dbs.setUserDataFromGoogle(FirebaseAuth.instance.currentUser!);
            }

            return PageNavigator();
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