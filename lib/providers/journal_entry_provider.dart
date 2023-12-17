import 'dart:io';
import 'package:outwork/models/firebase_user.dart';
import 'package:flutter/material.dart';
import 'package:outwork/models/journal_entry.dart';
import 'package:outwork/services/database_service.dart';

class JournalEntryProvider extends ChangeNotifier {
  JournalEntry _journalEntry = JournalEntry(emotions: []);
  bool _wantToAddNote = false;
  List<JournalEntry>? _journalEntries;

  JournalEntry get journalEntry=> _journalEntry;
  bool get wantToAddNote=> _wantToAddNote;
  List<JournalEntry> get journalEntries => _journalEntries!;

  Future<void> setJournalEntries(FirebaseUser user) async{
    _journalEntries = user.journalEntries!;
  }

  void updateSelectedFeeling(String feeling) {
    _journalEntry.feeling = feeling;
    notifyListeners();
  }

  void addEmotion(String emotion){
    _journalEntry.emotions!.contains(emotion)?_journalEntry.emotions!.remove(emotion):_journalEntry.emotions!.add(emotion);
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


  void changeWantToAddNote(bool value){
    _wantToAddNote = value;
    notifyListeners();
  }

  void clearProvider(FirebaseUser user){
    _journalEntry = JournalEntry(emotions:[]);
    _wantToAddNote = false;
    _journalEntries = user.journalEntries!;
    notifyListeners();
  }

  Future<void> addJournalEntryToDatabase(FirebaseUser user) async{
    _journalEntry.date = DateTime.now();
    _journalEntries!.add(_journalEntry);
    List<Map<String, dynamic>> entriesAsMap = journalEntries.map((entry) => entry.toMap()).toList();
    DatabaseService dbS = DatabaseService();
    dbS.updateDataToDatabase(user.email!, 'journalEntries', entriesAsMap);
    clearProvider(user);
    notifyListeners();
  }
}