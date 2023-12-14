import 'dart:io';
import 'package:outwork/models/firebase_user.dart';
import 'package:flutter/material.dart';
import 'package:outwork/models/journal_entry.dart';
import 'package:outwork/services/database_service.dart';

class JournalEntryProvider extends ChangeNotifier {
  JournalEntry _journalEntry = JournalEntry(feeling: '', stressLevel: 1, emotions: [], storedImage: null, savedImage: null, hasNote: false);
  List<JournalEntry>? _journalEntries;

  JournalEntry get journalEntry=> _journalEntry;
  List<JournalEntry> get journalEntries => _journalEntries!;

  Future<void> setJournalEntries(FirebaseUser user) async{
    _journalEntries = user.journalEntries!;
  }

  void updateSelectedFeeling(String feeling) {
    _journalEntry.feeling = feeling;
    notifyListeners();
  }

  void addEmotion(String emotion){
    _journalEntry.emotions.contains(emotion)?_journalEntry.emotions.remove(emotion):_journalEntry.emotions.add(emotion);
    notifyListeners();
  }

  void setStoredImage(File storedImage){
    _journalEntry.storedImage = storedImage;
    notifyListeners();
  }

  void setSavedImage(File savedImage){
    _journalEntry.savedImage = savedImage;
    notifyListeners();
  }

  void setHasNote(bool value){
    _journalEntry.hasNote = value;
    notifyListeners();
  }

  void setStressLevel(int stressLevel){
    _journalEntry.stressLevel = stressLevel;
    notifyListeners();
  }

  // void clearProvider(){
  //   _selectedFeeling = '';
  //   _emotions = [];
  // }

  Future<void> addJournalEntryToDatabase(String email) async{
    _journalEntries!.add(_journalEntry);
    DatabaseService dbS = DatabaseService();
    dbS.updateDataToDatabase(email, 'journalEntries', _journalEntries);
    notifyListeners();
  }
}