import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class DatabaseService {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> setUserDataFromGoogle(User user) async {
    // var uuid = const Uuid();
    // String familyID = uuid.v4().substring(0, 6);
    var doc = await _db.collection('users_data').doc(user.email).get();
    if (doc.exists) return;
    await _db.collection('users_data').doc(user.email).set({
      'displayName': user.displayName,
      'email': user.email,
      'photoURL': user.photoURL
    });
    // await _db.collection('families').doc(familyID).set({
    //   'familyID': familyID,
    //   'membersEmails': [user.email],
    // });
  }
}