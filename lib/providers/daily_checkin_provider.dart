import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:outwork/models/firebase_user.dart';
import 'package:provider/provider.dart';

class DailyCheckinProvider extends ChangeNotifier {
  List<dynamic> _dailyCheckins = [];
  FirebaseFirestore _db = FirebaseFirestore.instance;

  List<dynamic> get dailyCheckins => _dailyCheckins;

  void setDailyCheckins(FirebaseUser user){
    _dailyCheckins = user.dailyCheckins!;
  }

  Future<void> removeDailyCheckinProgressToFirebase(int step, String name, String userEmail) async{
    int indexToUpdate = _dailyCheckins.indexWhere((map) => map['name'] == name);
    _dailyCheckins[indexToUpdate]['value'] != 0?_dailyCheckins[indexToUpdate]['value'] -= step:(){return;};
    await _db.collection('users_data').doc(userEmail).update({
      'dailyCheckins':_dailyCheckins,
    });
    notifyListeners();
  }

  Future<void> addDailyCheckinProgressToFirebase(int step, String name, String userEmail) async{
    int indexToUpdate = _dailyCheckins.indexWhere((map) => map['name'] == name);
    _dailyCheckins[indexToUpdate]['goal'] > _dailyCheckins[indexToUpdate]['value']?_dailyCheckins[indexToUpdate]['value'] += step:(){return;};
    await _db.collection('users_data').doc(userEmail).update({
      'dailyCheckins':_dailyCheckins,
    });
    notifyListeners();
  }

  // Future<void> addDailyCheckinToFirebase

  int countDoneCheckins(bool morningRoutineFinished, bool nightRoutineFinished){
    int amountDone = 0;
    _dailyCheckins.forEach((dailyCheckin) {
      if(dailyCheckin['goal'] == dailyCheckin['value']) amountDone++;
    });
    morningRoutineFinished == true?amountDone++:null;
    nightRoutineFinished == true?amountDone++:null;
    return amountDone;
  }
}