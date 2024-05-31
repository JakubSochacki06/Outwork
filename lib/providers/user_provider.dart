import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:outwork/widgets/snackBars/error_login_snackbar.dart';
import 'package:outwork/models/firebase_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseUser? _user;

  FirebaseUser? get user => _user;

  // Register user with email and password
  Future<void> registerWithEmailPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await fetchUserData(email);
      notifyListeners();
    } catch (e) {
      // Handle registration errors
      print(e.toString());
    }
  }

  Future<void> restartDailyData() async {
    DateTime now = DateTime.now();
    int checkinsDone = 0;
    _user!.dailyCheckins!.forEach((element) {
      element.value == element.goal ? checkinsDone++ : null;
      element.value = 0;
    });
    int morningDone = 0;
    _user!.morningRoutines!.forEach((element) {
      element['completed'] == true ? morningDone++ : null;
      element['completed'] = false;
    });
    int nightDone = 0;
    _user!.nightRoutines!.forEach((element) {
      element['completed'] == true ? nightDone++ : null;
      element['completed'] = false;
    });
    List<dynamic> rawDailyCheckins = [];
    _user!.dailyCheckins!.forEach((dailyCheckin) {
      rawDailyCheckins.add(dailyCheckin.toMap());
    });
    await _db.collection('users_data').doc(_user!.email).update({
      'lastUpdate': DateTime.now(),
      'dailyCheckins': rawDailyCheckins,
      'morningRoutines': _user!.morningRoutines,
      'nightRoutines': _user!.nightRoutines,
      'freeMessages': 5,
      'streak': morningDone == _user!.morningRoutines!.length &&
              nightDone == _user!.nightRoutines!.length &&
              checkinsDone == _user!.dailyCheckins!.length &&
              now.subtract(Duration(days: 1)).day == _user!.lastUpdated!.day
          ? FieldValue.increment(1)
          : 0,
    });
  }

  // Login user with email and password
  Future<void> loginWithEmailPassword(
      String email, String password, context) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await fetchUserData(email);
      notifyListeners();
    } catch (e) {
      ErrorLoginSnackBar.show(context);
      print(e.toString());
    }
  }

  Future<void> _signInWithCredential(AuthCredential credential) async {
    final UserCredential authResult =
        await _auth.signInWithCredential(credential);

    // Retrieve additional user data and update _user
    await fetchUserData(authResult.user!.email!);

    notifyListeners();
  }

  // Future<User> signInWithApple({List<Scope> scopes = const [Scope.email, Scope.fullName]}) async {
  //   final result = await TheAppleSignIn.performRequests(
  //       [AppleIdRequest(requestedScopes: scopes)]);
  //   switch (result.status) {
  //     case AuthorizationStatus.authorized:
  //       final AppleIdCredential = result.credential!;
  //       final oAuthCredential = OAuthProvider('apple.com');
  //       final credential = oAuthCredential.credential(
  //           idToken: String.fromCharCodes(AppleIdCredential.identityToken!));
  //       final UserCredential = await _auth.signInWithCredential(credential);
  //       final firebaseUser = UserCredential.user!;
  //       if (scopes.contains(Scope.fullName)) {
  //         final fullName = AppleIdCredential.fullName;
  //         if (fullName != null &&
  //             fullName.givenName != null &&
  //             fullName.familyName != null) {
  //           print(fullName);
  //           final displayName = '${fullName.givenName}${fullName.familyName}';
  //           await firebaseUser.updateDisplayName(displayName);
  //         }
  //       }
  //       print(firebaseUser.email);
  //       return firebaseUser;
  //     case AuthorizationStatus.error:
  //       throw PlatformException(
  //           code: 'ERROR_AUTHORIZATION_DENIED',
  //           message: result.error.toString());
  //
  //     case AuthorizationStatus.cancelled:
  //       throw PlatformException(
  //           code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
  //     default:
  //       throw UnimplementedError();
  //   }
  // }

  Future<void> githubApple() async{
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
    );

// Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
    );
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(oauthCredential);

    if (userCredential.user?.displayName == null ||
        (userCredential.user?.displayName != null && userCredential.user!.displayName!.isEmpty)) {
      final fixDisplayNameFromApple = [
        appleCredential.givenName ?? '',
        appleCredential.familyName ?? '',
      ].join(' ').trim();
      await userCredential.user?.updateDisplayName(fixDisplayNameFromApple);
    }
    if (userCredential.user?.email == null ||
        (userCredential.user?.email != null && userCredential.user!.email!.isEmpty)) {
      await userCredential.user?.updateEmail(appleCredential.email ?? '');
    }
    print(userCredential.user!);
  }

  // Future<void> signUpWithApple() async{
  //   final appleProvider = AppleAuthProvider();
  //   appleProvider.addScope('email');
  //   var credential = await FirebaseAuth.instance.signInWithProvider(appleProvider);
  //   print(FirebaseAuth.instance.currentUser!.email);
  //   print(credential.user);
  // }

  // void appleSign() async {
  //   AuthorizationResult authorizationResult =
  //   await TheAppleSignIn.performRequests([
  //     const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
  //   ]);
  //
  //   switch (authorizationResult.status) {
  //     case AuthorizationStatus.authorized:
  //       print("authorized");
  //       try {
  //         AppleIdCredential? appleCredentials = authorizationResult.credential;
  //         OAuthProvider oAuthProvider = OAuthProvider("apple.com");
  //         OAuthCredential oAuthCredential = oAuthProvider.credential(
  //             idToken: String.fromCharCodes(appleCredentials!.identityToken!),
  //             accessToken:
  //             String.fromCharCodes(appleCredentials.authorizationCode!));
  //         print(appleCredentials.email);
  //         print(appleCredentials.fullName.givenName);
  //         UserCredential userCredential =
  //         await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
  //         print(userCredential.user!.email);
  //       } catch (e) {
  //         print("apple auth failed $e");
  //       }
  //
  //       break;
  //     case AuthorizationStatus.error:
  //       print("error" + authorizationResult.error.toString());
  //       break;
  //     case AuthorizationStatus.cancelled:
  //       print("cancelled");
  //       break;
  //     default:
  //       print("none of the above: default");
  //       break;
  //   }
  // }

  Future<void> signInWithGoogle(context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _signInWithCredential(credential);
    } catch (e) {
      print(e);
      showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            child: Text(e.toString()),
          );
        },
      );
    }
  }

  Future<void> fetchUserData(String email) async {
    try {
      final QuerySnapshot querySnapshot = await _db
          .collection('users_data')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        dynamic userData = querySnapshot.docs.first.data();
        FirebaseUser? newUser = FirebaseUser.fromMap(userData);
        _user = newUser;
        return;
      }
    } catch (e) {
      // Handle error
      print(e.toString());
    }
  }

  void upgradeAccount(context) {
    _user!.isPremiumUser = true;
    Navigator.pop(context);
    Navigator.pop(context);
    notifyListeners();
  }

  Future<void> reloadData() async {
    await fetchUserData(user!.email!);
  }

  // Sign out the current user
  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  Future<void> addWorkedSecondsToDatabase(int workedSeconds) async {
    await _db
        .collection('users_data')
        .doc(user!.email)
        .update({'workedSeconds': FieldValue.increment(workedSeconds)});
    notifyListeners();
  }

  Future<void> updatePomodoroSettings(Map<dynamic, dynamic> newSettings) async {
    _user!.pomodoroSettings = newSettings;
    await _db
        .collection('users_data')
        .doc(user!.email)
        .update({'pomodoroSettings': newSettings});
    notifyListeners();
  }

  Future<void> updateMode(bool newMode) async {
    _user!.toughModeSelected = newMode;
    await _db
        .collection('users_data')
        .doc(user!.email)
        .update({'toughMode': newMode});
    notifyListeners();
  }
}
