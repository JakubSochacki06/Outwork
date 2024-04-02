import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:outwork/models/firebase_user.dart';

class EndOfTheDayJournalProvider extends ChangeNotifier {
  // TODO: CLEAR DATA AT THE END OF THE DAY
  Map<dynamic, dynamic> _endOfTheDayJournal = {};
  FirebaseFirestore _db = FirebaseFirestore.instance;


  Map<dynamic, dynamic> get endOfTheDayJournal => _endOfTheDayJournal;

  Future<void> setEndOfTheDayJournal(FirebaseUser user) async{
    _endOfTheDayJournal = user.endOfTheDayJournal!;
  }

  void changeFieldValue(String field, dynamic value){
    _endOfTheDayJournal[field] = value;
    notifyListeners();
  }

  Future<void> submitEndOfTheDayJournal(String email) async{
    await _db
        .collection('users_data')
        .doc(email)
        .set({'endOfTheDayJournal': _endOfTheDayJournal}, SetOptions(merge: true));
    notifyListeners();
  }

}