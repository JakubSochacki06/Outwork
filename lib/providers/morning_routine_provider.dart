import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:outwork/models/firebase_user.dart';
import 'package:outwork/models/routine.dart';

import '../services/notifications_service.dart';

class MorningRoutineProvider extends ChangeNotifier {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  List<Routine> _morningRoutines = [];
  TimeOfDay? _scheduledTime;

  List<Routine> get morningRoutines => _morningRoutines;

  TimeOfDay? get scheduledTime => _scheduledTime;

  void setMorningRoutines(FirebaseUser user) {
    List<dynamic> routines = user.morningRoutines!;
    _morningRoutines = [];
    for (var routine in routines) {
      _morningRoutines.add(Routine.fromMap(routine));
    }
  }

  void setScheduledTime(TimeOfDay? scheduledTime) {
    _scheduledTime = scheduledTime;
    notifyListeners();
  }

  Future<void> addMorningRoutineToDatabase(String morningRoutine, String email) async {
    _morningRoutines.add(
      Routine(
        name: morningRoutine,
        completed: false,
        scheduledTime: _scheduledTime != null
            ? {'hour': _scheduledTime!.hour, 'minute': _scheduledTime!.minute}
            : null,
        id: morningRoutine.hashCode.abs(),
      ),
    );
    _morningRoutines.sort((a, b) {
      final aTime = DateTime(2022, 1, 1, a.scheduledTime!["hour"], a.scheduledTime!["minute"]);
      final bTime = DateTime(2022, 1, 1, b.scheduledTime!["hour"], b.scheduledTime!["minute"]);
      return aTime.compareTo(bTime);
    });
    List<Map<String, dynamic>> routinesAsMap =
        _morningRoutines.map((entry) => entry.toMap()).toList();
    await _db
        .collection('users_data')
        .doc(email)
        .update({'morningRoutines': routinesAsMap});
    _scheduledTime = null;
    notifyListeners();
  }

  Future<void> removeMorningRoutineFromDatabase(int id, String email) async {
    _morningRoutines.removeWhere((routine) => routine.id == id);
    // await AwesomeNotifications().cancel(id);
    List<Map<String, dynamic>> routinesAsMap =
        _morningRoutines.map((entry) => entry.toMap()).toList();
    await _db
        .collection('users_data')
        .doc(email)
        .update({'morningRoutines': routinesAsMap});
    notifyListeners();
  }

  Future<void> updateRoutineCompletionStatus(
      int index, bool completed, String email) async {
    _morningRoutines[index].completed = completed;
    List<Map<String, dynamic>> routinesAsMap =
        _morningRoutines.map((entry) => entry.toMap()).toList();
    await _db.collection('users_data').doc(email).update({
      'morningRoutines': routinesAsMap,
    });
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
