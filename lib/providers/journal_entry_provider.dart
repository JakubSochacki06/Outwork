import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:outwork/models/firebase_user.dart';
import 'package:flutter/material.dart';
import 'package:outwork/models/journal_entry.dart';
import 'package:outwork/services/database_service.dart';

class JournalEntryProvider extends ChangeNotifier {
  JournalEntry _journalEntry = JournalEntry(emotions: []);
  FirebaseFirestore _db = FirebaseFirestore.instance;
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
    _journalEntry.storedImage != null? await uploadPhoto(_journalEntry.storedImage!, user):null;
    _journalEntry.storedImage != null? _journalEntry.hasPhoto = true: _journalEntry.hasPhoto = false;
    List<Map<String, dynamic>> entriesAsMap = journalEntries.map((entry) => entry.toMap()).toList();
    DatabaseService dbS = DatabaseService();
    await dbS.updateDataToDatabase(user.email!, 'journalEntries', entriesAsMap);
    clearProvider(user);
    notifyListeners();
  }

  Future<void> removeJournalEntryFromDatabase(DateTime date, FirebaseUser user) async{
    _journalEntries!.removeWhere((entry) => entry.date == date);
    List<Map<String, dynamic>> entriesAsMap = journalEntries.map((entry) => entry.toMap()).toList();
    await _db
        .collection('users_data')
        .doc(user.email)
        .set({'journalEntries': entriesAsMap}, SetOptions(merge: true));
    notifyListeners();
  }


  Future<void> uploadPhoto(File file, FirebaseUser user) async{
    String firebasePath = 'images/${user.email}/${_journalEntry.date}.jpg';
    final ref = FirebaseStorage.instance.ref().child(firebasePath);
    await ref.putFile(file);
    notifyListeners();
  }

  Future<String> retrievePhoto(DateTime date, FirebaseUser user) async{
    String firebasePath = 'images/${user.email}/$date.jpg';
    final ref = FirebaseStorage.instance.ref().child(firebasePath);
    String url = await ref.getDownloadURL();
    return url;
  }

  Future<void> deletePhoto(DateTime date, FirebaseUser user) async{
    String firebasePath = 'images/${user.email}/$date.jpg';
    final ref = FirebaseStorage.instance.ref().child(firebasePath);
    await ref.delete();
  }

  Map<String, int> getFeelingsAmount() {
    Map<String, int> feelingsAmount = {};

    journalEntries.forEach((journalEntry) {
      if (journalEntry.feeling != null) {
        feelingsAmount[journalEntry.feeling!] =
            (feelingsAmount[journalEntry.feeling!] ?? 0) + 1;
      }
    });

    return feelingsAmount;
  }

  Map<DateTime, String> getDatesAndFeelings(){
    Map<DateTime, String> datesAndFeelings = {};

    journalEntries.forEach((journalEntry) {
      datesAndFeelings[journalEntry.date!] = journalEntry.feeling!;
    });
    return datesAndFeelings;
  }

  int getNumberAsFeeling(String feeling){
    switch(feeling){
      case 'sad':
        return 1;
      case 'unhappy':
        return 2;
      case 'neutral':
        return 3;
      case 'happy':
        return 4;
      case 'veryhappy':
        return 5;
      default:
        return 0;
    }
  }

  String getAverageMood() {
    String averageMood = '';
    int biggestMoodAmount = 0;
    getFeelingsAmount().forEach((key, value) {
      if (value > biggestMoodAmount) {
        biggestMoodAmount = value;
        averageMood = key;
      }
    });
    return averageMood;
  }

  Color getColorByFeeling(String feeling){
    switch(feeling){
      case 'sad':
        return Color(0xFFFF7280);
      case 'unhappy':
        return Color(0xFFffb234);
      case 'neutral':
        return Color(0xFFffd934);
      case 'happy':
        return Color(0xFFadd633);
      case 'veryhappy':
        return Color(0xFFa0c15a);
      default:
        return Colors.transparent;
    }
  }

  double getAverageStressScore(){
    int sum = 0;
    journalEntries.forEach((entry) {
      sum+=entry.stressLevel;
    });
    return double.parse((sum/journalEntries.length).toStringAsFixed(2));
  }
}