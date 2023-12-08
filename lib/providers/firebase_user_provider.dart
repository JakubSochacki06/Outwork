import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:outwork/models/firebase_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUserProvider extends ChangeNotifier {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseUser _user = FirebaseUser();
  FirebaseUser get user => _user;

  Future<void> getUser(String email) async {
    await for (var snapshot in _db.collection('users_data').snapshots()) {
      for (var message in snapshot.docs) {
        if (message.data()['email'] == email) {
          print('got user!');
          _user =  FirebaseUser.fromMap(message.data());
          return;
        }
      }
    }
    print('woops got to the end');
  }
}