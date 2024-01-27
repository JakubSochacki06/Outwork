import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:outwork/models/firebase_user.dart';
import 'package:outwork/models/routine.dart';

class NightRoutineProvider extends ChangeNotifier {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  List<Routine> _nightRoutines = [];
  TimeOfDay? _scheduledTime;

  List<Routine> get nightRoutines => _nightRoutines;

  TimeOfDay? get scheduledTime => _scheduledTime;

  Future<void> setNightRoutines(FirebaseUser user) async {
    List<dynamic> routines = user.nightRoutines!;
    _nightRoutines = [];
    for (var routine in routines) {
      _nightRoutines.add(Routine.fromMap(routine));
    }
  }

  void setScheduledTime(TimeOfDay? scheduledTime) {
    _scheduledTime = scheduledTime;
    notifyListeners();
  }

  Future<void> addNightRoutineToDatabase(
      String nightRoutine, String email) async {
    _nightRoutines.add(
      Routine(
        name: nightRoutine,
        completed: false,
        scheduledTime: _scheduledTime != null
            ? {'hour': _scheduledTime!.hour, 'minute': _scheduledTime!.minute}
            : null,
        id: nightRoutine.hashCode.abs(),
      ),
    );
    List<Map<String, dynamic>> routinesAsMap = _nightRoutines.map((entry) => entry.toMap()).toList();
    await _db
        .collection('users_data')
        .doc(email)
        .set({'nightRoutines': routinesAsMap}, SetOptions(merge: true));
    _scheduledTime = null;
    notifyListeners();
  }
  Future<void> updateRoutineCompletionStatus(
      int index, bool completed, String email) async {
    _nightRoutines[index].completed = completed;
    List<Map<String, dynamic>> routinesAsMap = _nightRoutines.map((entry) => entry.toMap()).toList();
    await _db.collection('users_data').doc(email).update({
      'nightRoutines': routinesAsMap,
    });
    notifyListeners();
  }

  Future<void> removeNightRoutineFromDatabase(int id, String email) async {
    _nightRoutines.removeWhere((routine) => routine.id == id);
    await AwesomeNotifications().cancel(id);
    List<Map<String, dynamic>> routinesAsMap = _nightRoutines.map((entry) => entry.toMap()).toList();
    await _db
        .collection('users_data')
        .doc(email)
        .update({'nightRoutines': routinesAsMap});
    notifyListeners();
  }

  int countProgress() {
    int sum = 0;
    for (final nightRoutine in _nightRoutines) {
      if (nightRoutine.completed == true) {
        sum += 1;
      }
    }
    return sum;
  }

  bool nightRoutineFinished() {
    return _nightRoutines.length != 0
        ? countProgress() == _nightRoutines.length
        : false;
  }
}
