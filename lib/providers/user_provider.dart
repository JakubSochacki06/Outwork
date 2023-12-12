import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:outwork/models/firebase_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:outwork/services/database_service.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final DatabaseService _dbS = DatabaseService();
  FirebaseUser? _user;

  FirebaseUser? get user => _user;

  // Register user with email and password
  Future<void> registerWithEmailPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _dbS.setUserDataFromEmail(FirebaseAuth.instance.currentUser!);
      await fetchUserData(email);
      notifyListeners();
    } catch (e) {
      // Handle registration errors
      print(e.toString());
    }
  }

  // Login user with email and password
  Future<void> loginWithEmailPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await fetchUserData(email);
      notifyListeners();
    } catch (e) {
      // Handle login errors
      print(e.toString());
    }
  }

  Future<void> _signInWithCredential(AuthCredential credential) async {
    final UserCredential authResult = await _auth.signInWithCredential(
        credential);

    // Retrieve additional user data and update _user
    await fetchUserData(authResult.user!.email!);

    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser
          .authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _signInWithCredential(credential);
      await _dbS.setUserDataFromGoogle(FirebaseAuth.instance.currentUser!);
    } catch (e) {
      // Handle error
      print(e.toString());
    }
  }

  Future<void> fetchUserData(String email) async {
    try {
      final QuerySnapshot querySnapshot = await _db.collection('users_data').where('email', isEqualTo: email).get();
      if (querySnapshot.docs.isNotEmpty) {
        dynamic userData = querySnapshot.docs.first.data();
        _user = FirebaseUser.fromMap(userData);
      }
    } catch (e) {
      // Handle error
      print(e.toString());
    }
  }

  Future<void> addMorningRoutineToDatabase(String morningRoutine) async{
    List<String> morningRoutines = await _dbS.getDataFromDatabase('users_data', _user!.email!, 'morningRoutines');
    morningRoutines.add(morningRoutine);
    await _db
        .collection('users_data')
        .doc(_user!.email!)
        .set({'morningRoutines': morningRoutines}, SetOptions(merge: true));
  }
  // Sign out the current user
  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}