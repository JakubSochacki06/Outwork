import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:outwork/models/firebase_user.dart';
import 'package:outwork/models/routine.dart';

class MorningRoutineProvider extends ChangeNotifier {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  List<Routine> _morningRoutines = [];
  TimeOfDay? _scheduledTime;

  List<Routine> get morningRoutines => _morningRoutines;

  TimeOfDay? get scheduledTime => _scheduledTime;

  Future<void> setMorningRoutines(FirebaseUser user) async {
    List<dynamic> routines = user.morningRoutines!;
    for (var routine in routines) {
      _morningRoutines.add(Routine.fromMap(routine));
    }
  }

  void setScheduledTime(TimeOfDay? scheduledTime) {
    _scheduledTime = scheduledTime;
    notifyListeners();
  }

  Future<void> addMorningRoutineToDatabase(String morningRoutine, String email) async {
    print('ADDED ID: ${morningRoutine.hashCode.abs()}');
    _morningRoutines.add(
        Routine(name: morningRoutine, completed: false, scheduledTime: _scheduledTime != null
            ? {'hour': _scheduledTime!.hour, 'minute': _scheduledTime!.minute}
            : null, id: morningRoutine.hashCode.abs())
    );
    await _db
        .collection('users_data')
        .doc(email)
        .update({'morningRoutines': _morningRoutines});
    _scheduledTime = null;
    notifyListeners();
  }

  Future<void> removeMorningRoutineFromDatabase(int id, String email) async {
    _morningRoutines.removeWhere((routine) => routine.id == id);
    await AwesomeNotifications().cancel(id);
    await _db
        .collection('users_data')
        .doc(email)
        .update({'morningRoutines': _morningRoutines});
    notifyListeners();
  }

  Future<void> updateRoutineCompletionStatus(
      int index, bool completed, String email) async {
    _morningRoutines[index].completed = completed;
    await _db.collection('users_data').doc(email).update({
      'morningRoutines': _morningRoutines,
    });
    notifyListeners();
  }

  Future<void> updateMorningRoutineOrder(
      List<Routine> morningRoutines, String email) async {
    await _db.collection('users_data').doc(email).update({
      'morningRoutines': morningRoutines,
    });
    _morningRoutines = morningRoutines;
    notifyListeners();
  }

  int countProgress() {
    int sum = 0;
    for (final morningRoutine in _morningRoutines) {
      if (morningRoutine.completed == true) {
        sum += 1;
      }
    }
    return sum;
  }

  bool morningRoutineFinished() {
    return _morningRoutines.length != 0
        ? countProgress() == _morningRoutines.length
        : false;
  }
}
