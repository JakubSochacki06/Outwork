// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBOETDKwBnuWxxasfbqQofIJgrqoGlkxwA',
    appId: '1:77982820125:web:3ac56560a5a45a940f23f4',
    messagingSenderId: '77982820125',
    projectId: 'outwork-368cd',
    authDomain: 'outwork-368cd.firebaseapp.com',
    storageBucket: 'outwork-368cd.appspot.com',
    measurementId: 'G-K7LXF6H0BF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDpRCkmE05KDtZbz9durtAbz5FcQ3h4Wh0',
    appId: '1:77982820125:android:0d5da89c5d7d23050f23f4',
    messagingSenderId: '77982820125',
    projectId: 'outwork-368cd',
    storageBucket: 'outwork-368cd.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBz2S2yGt8LZ9Tp8R0SWqjk4Nmizeo4HpY',
    appId: '1:77982820125:ios:6eeda8311e15fb520f23f4',
    messagingSenderId: '77982820125',
    projectId: 'outwork-368cd',
    storageBucket: 'outwork-368cd.appspot.com',
    iosBundleId: 'com.example.outwork',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBz2S2yGt8LZ9Tp8R0SWqjk4Nmizeo4HpY',
    appId: '1:77982820125:ios:4c65e9fc3d2252c80f23f4',
    messagingSenderId: '77982820125',
    projectId: 'outwork-368cd',
    storageBucket: 'outwork-368cd.appspot.com',
    iosBundleId: 'com.example.outwork.RunnerTests',
  );
}
