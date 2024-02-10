import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> setUserDataFromGoogle(User user) async {
    var doc = await _db.collection('users_data').doc(user.email).get();
    if (doc.exists) return;
    await _db.collection('users_data').doc(user.email).set({
      'displayName': user.displayName,
      'email': user.email,
      'photoURL': user.photoURL,
      'morningRoutines':[
        // {'name': 'Prepare healthy breakfast', 'completed': false},
      ],
      'nightRoutines':[
        // {'name': 'End of the day journal', 'completed': false, 'deletable':false},
      ],
      'journalEntries':[
      ],
      'projectsIDList':[

      ],
      'books':[

      ],
      'pomodoroSettings':{
        'Pomodoro':25,
        'ShortBreak':5,
        'LongBreak':15,
      },
      'xpAmount':0,
      'workedSeconds':0,
      'endOfTheDayJournal':{},
      'dailyCheckins':[
        {'name':'Water', 'goal':8, 'unit':'glasses', 'value':0, 'color':'FF0083B0', 'step':1, 'emojiName':'water', 'id':'EXAMP1'},
        {'name':'Meditation', 'goal':15, 'unit':'minutes', 'value':0, 'color':'FFec2F4B', 'step':5, 'emojiName':'meditation', 'id':'EXAMP2'},
        {'name':'Exercises', 'goal':60, 'unit':'minutes', 'value':0, 'color':'FF89216B', 'step':15, 'emojiName':'exercises', 'id':'EXAMP3'},
      ],
      'lastUpdate': FieldValue.serverTimestamp(),
    });
  }

  Future<void> setUserDataFromEmail(User user) async{
    var doc = await _db.collection('users_data').doc(user.email).get();
    if (doc.exists) return;
    await _db.collection('users_data').doc(user.email).set({
      'displayName': user.email,
      'email': user.email,
      'photoURL': 'https://img.freepik.com/premium-vector/account-icon-user-icon-vector-graphics_292645-552.jpg',
      'morningRoutines':[
        'Prepare healthy breakfast',
      ]
    });
  }

  Future<dynamic> getDataFromDatabase(
      String collection, String documentID, String field) async {
    await for (var snapshot in _db.collection(collection).snapshots()) {
      for (var message in snapshot.docs) {
        if (message.id == documentID) {
          return message.data()[field];
        }
      }
    }
  }

  Future<void> updateDataToDatabase(String email, String field, dynamic value) async{
    await _db.collection('users_data').doc(email).update({
      field:value,
    });
  }

}