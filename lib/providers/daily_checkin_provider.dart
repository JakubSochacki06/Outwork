import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:outwork/models/firebase_user.dart';
import 'package:outwork/string_extension.dart';
import 'package:provider/provider.dart';
import 'package:outwork/models/daily_checkin.dart';
import 'package:outwork/string_extension.dart';
import 'package:uuid/uuid.dart';

class DailyCheckinProvider extends ChangeNotifier {
  List<DailyCheckin> _dailyCheckins = [];
  FirebaseFirestore _db = FirebaseFirestore.instance;

  List<DailyCheckin> get dailyCheckins => _dailyCheckins;

  void setDailyCheckins(FirebaseUser user) {
    _dailyCheckins = user.dailyCheckins!;
  }

  Future<void> removeDailyCheckinProgressToFirebase(
      int step, String name, String userEmail) async {
    int indexToUpdate =
        _dailyCheckins.indexWhere((dailyCheckin) => dailyCheckin.name == name);
    if(_dailyCheckins[indexToUpdate].value != 0){

      if(_dailyCheckins[indexToUpdate].value! - step <= 0){
        // IF ADDING WOULD CAUSE GOING OVER GOAL, FOR EXAMPLE STEP = 2, VALUE = 1. THIS SETS VALUE AS 0 SO IT DOESNT BUG AT -1/x
        _dailyCheckins[indexToUpdate].value = 0;
      } else {
        _dailyCheckins[indexToUpdate].value = _dailyCheckins[indexToUpdate].value! - step;
      }

    } else {
      return;
    }
    List<Map<String, dynamic>> checkinsAsMap =
        _dailyCheckins.map((checkin) => checkin.toMap()).toList();
    await _db.collection('users_data').doc(userEmail).update({
      'dailyCheckins': checkinsAsMap,
    });
    notifyListeners();
  }

  Future<void> addDailyCheckinProgressToFirebase(
      int step, String name, String userEmail) async {
    int indexToUpdate =
        _dailyCheckins.indexWhere((dailyCheckin) => dailyCheckin.name == name);
    if(_dailyCheckins[indexToUpdate].goal! > _dailyCheckins[indexToUpdate].value!){

      if(_dailyCheckins[indexToUpdate].value! + step > _dailyCheckins[indexToUpdate].goal!){
        // IF ADDING WOULD CAUSE GOING OVER GOAL, FOR EXAMPLE STEP = 3, VALUE = 6, GOAL = 8. THIS SETS VALUE AS GOAL SO IT DOESNT BUG AT 9/8
        _dailyCheckins[indexToUpdate].value = _dailyCheckins[indexToUpdate].goal;
      } else {
        _dailyCheckins[indexToUpdate].value = _dailyCheckins[indexToUpdate].value! + step;
      }

    } else {
      return;
    }
    List<dynamic> rawDailyCheckins = [];
    _dailyCheckins.forEach((dailyCheckin) {
      rawDailyCheckins.add(dailyCheckin.toMap());
    });
    await _db.collection('users_data').doc(userEmail).update({
      'dailyCheckins': rawDailyCheckins,
    });
    notifyListeners();
  }

  Future<void> addDailyCheckinToFirebase(String name, String unit, int goal,
      int step, String hexColor, String userEmail, String emojiName) async {
    var uuid = const Uuid();
    DailyCheckin newCheckin = DailyCheckin(
        name: name,
        unit: unit,
        goal: goal,
        step: step,
        emojiName: emojiName,
        id: uuid.v4().substring(0, 6),
        value: 0,
        color: HexColor(hexColor)
    );
    _dailyCheckins.add(newCheckin);
    await _db.collection('users_data').doc(userEmail).update({
      'dailyCheckins': FieldValue.arrayUnion([newCheckin.toMap()]),
    });
    notifyListeners();
  }

  Future<void> deleteDailyCheckinFromFirebase(String id, String userEmail) async{
    DailyCheckin checkinToRemove = _dailyCheckins.firstWhere((dailyCheckin) => dailyCheckin.id == id);
    _dailyCheckins.remove(checkinToRemove);
    await _db.collection('users_data').doc(userEmail).update({
      'dailyCheckins': FieldValue.arrayRemove([checkinToRemove.toMap()]),
    });
    notifyListeners();
  }

  Future<void> editDailyCheckin(String name, String unit, int goal, int step, String userEmail, String emojiName, String id) async {
    int indexToUpdate = _dailyCheckins.indexWhere((dailyCheckin) => dailyCheckin.id == id);
    _dailyCheckins[indexToUpdate] = DailyCheckin(
        name: name,
        unit: unit,
        goal: goal,
        step: step,
        emojiName: emojiName,
        id: id,
        value: _dailyCheckins[indexToUpdate].value,
        color: _dailyCheckins[indexToUpdate].color
    );
    List<dynamic> rawDailyCheckins = [];
    _dailyCheckins.forEach((dailyCheckin) {
      rawDailyCheckins.add(dailyCheckin.toMap());
    });
    await _db.collection('users_data').doc(userEmail).update({
      'dailyCheckins': rawDailyCheckins,
    });
    notifyListeners();
  }

  int countDoneCheckins(
      bool morningRoutineFinished, bool nightRoutineFinished) {
    int amountDone = 0;
    _dailyCheckins.forEach((dailyCheckin) {
      if (dailyCheckin.goal == dailyCheckin.value) amountDone++;
    });
    morningRoutineFinished == true ? amountDone++ : null;
    nightRoutineFinished == true ? amountDone++ : null;
    return amountDone;
  }
}
