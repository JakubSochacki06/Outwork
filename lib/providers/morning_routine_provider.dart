import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:outwork/models/firebase_user.dart';


class MorningRoutineProvider extends ChangeNotifier {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  List<dynamic> _morningRoutines = [];

  List<dynamic> get morningRoutines => _morningRoutines;

  Future<void> setMorningRoutines(FirebaseUser user) async{
    _morningRoutines = user.morningRoutines!;
  }

  Future<void> addMorningRoutineToDatabase(String morningRoutine, String email) async{
    _morningRoutines.add({'name':morningRoutine, 'completed':false});
    await _db
        .collection('users_data')
        .doc(email)
        .set({'morningRoutines': _morningRoutines}, SetOptions(merge: true));
    notifyListeners();
  }

  Future<void> removeMorningRoutineFromDatabase(String morningRoutine, String email) async{
    _morningRoutines.removeWhere((map) => map['name'] == morningRoutine);
    await _db
        .collection('users_data')
        .doc(email)
        .set({'morningRoutines': _morningRoutines}, SetOptions(merge: true));
    notifyListeners();
  }

  Future<void> updateRoutineCompletionStatus(int index, bool completed, String email) async {
    _morningRoutines[index]['completed'] = completed;
    await _db.collection('users_data').doc(email).update({
      'morningRoutines':_morningRoutines,
    });
    notifyListeners();
  }

  Future<void> updateMorningRoutineOrder(List<Map<String, dynamic>> morningRoutines, String email) async {
    await _db.collection('users_data').doc(email).update({
      'morningRoutines': morningRoutines,
    });
    _morningRoutines = morningRoutines;
    notifyListeners();
    print('notified');
  }

  int countProgress(){
    int sum = 0;
    for(final morningRoutine in _morningRoutines){
      if(morningRoutine['completed'] == true){
        sum += 1;
      }
    }
    return sum;
  }

  bool morningRoutineFinished(){
    return _morningRoutines.length!=0?countProgress() == _morningRoutines.length:false;
  }
}