import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:outwork/models/firebase_user.dart';


class NightRoutineProvider extends ChangeNotifier {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  List<dynamic> _nightRoutines = [];

  List<dynamic> get nightRoutines => _nightRoutines;

  Future<void> setNightRoutines(FirebaseUser user) async{
    _nightRoutines = user.nightRoutines!;
  }

  Future<void> addNightRoutineToDatabase(String nightRoutine, String email) async{
    _nightRoutines.add({'name':nightRoutine, 'completed':false});
    await _db
        .collection('users_data')
        .doc(email)
        .set({'nightRoutines': _nightRoutines}, SetOptions(merge: true));
    notifyListeners();
  }

  Future<void> updateRoutineCompletionStatus(int index, bool completed, String email) async {
    _nightRoutines[index]['completed'] = completed;
    await _db.collection('users_data').doc(email).update({
      'nightRoutines':_nightRoutines,
    });
    notifyListeners();
  }

  Future<void> updateNightRoutineOrder(List<Map<String, dynamic>> nightRoutines, String email) async {
    await _db.collection('users_data').doc(email).update({
      'nightRoutines': nightRoutines,
    });
    _nightRoutines = nightRoutines;
    notifyListeners();
  }

  int countProgress(){
    int sum = 0;
    for(final nightRoutine in _nightRoutines){
      if(nightRoutine['completed'] == true){
        sum += 1;
      }
    }
    return sum;
  }
}