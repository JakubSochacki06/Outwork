import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:outwork/models/firebase_user.dart';
import 'package:flutter/material.dart';
import 'package:outwork/models/journal_entry.dart';
import 'package:outwork/services/database_service.dart';
import 'package:intl/intl.dart';

class JournalEntryProvider extends ChangeNotifier {
  JournalEntry _journalEntry = JournalEntry(emotions: []);
  JournalEntry _existingEntry = JournalEntry(emotions: []);
  FirebaseFirestore _db = FirebaseFirestore.instance;
  DatabaseService _dbS = DatabaseService();
  List<JournalEntry>? _journalEntries;
  String? feelingError;

  JournalEntry get journalEntry=> _journalEntry;
  JournalEntry get existingEntry => _existingEntry;
  List<JournalEntry> get journalEntries => _journalEntries!;

  void setJournalEntries(FirebaseUser user) {
    _journalEntries = user.journalEntries!;
  }

  void setFeelingError(String? error){
   feelingError = error;
   notifyListeners();
  }

  void updateSelectedFeeling(String feeling, final subject) {
    subject.feeling = feeling;
    notifyListeners();
  }
  void addEmotionToEntry(String emotion, JournalEntry subject) {
    if (subject.emotions == null) {
      subject.emotions = [];
    }
    if (subject.emotions!.contains(emotion)) {
      subject.emotions!.remove(emotion);
    } else {
      subject.emotions!.add(emotion);
    }
    notifyListeners();
  }

  void setStoredImage(File storedImage, final subject){
    subject.storedImage = storedImage;
    notifyListeners();
  }

  void setSavedImage(File savedImage, final subject){
    subject.savedImage = savedImage;
    notifyListeners();
  }

  void setHasNote(bool value, final subject){
    subject.hasNote = value;
    notifyListeners();
  }

  void setStressLevel(int stressLevel, final subject){
    subject.stressLevel = stressLevel;
    notifyListeners();
  }

  void clearProvider(FirebaseUser user){
    _journalEntry = JournalEntry(emotions:[]);
    _journalEntries = user.journalEntries!;
    notifyListeners();
  }

  void clearExistingNote(){
    _existingEntry = JournalEntry();
}

  Future<void> addJournalEntryToDatabase(FirebaseUser user) async{
    _journalEntry.date = DateTime.now();
    _journalEntries!.add(_journalEntry);
    _journalEntry.storedImage != null? await uploadPhoto(_journalEntry.storedImage!, user, _journalEntry):null;
    _journalEntry.storedImage != null? _journalEntry.hasPhoto = true: _journalEntry.hasPhoto = false;
    List<Map<String, dynamic>> entriesAsMap = journalEntries.map((entry) => entry.toMap()).toList();
    await _dbS.updateDataToDatabase(user.email!, 'journalEntries', entriesAsMap);
    clearProvider(user);
    notifyListeners();
  }

  Future<void> editJournalEntryAndSubmit(FirebaseUser user) async{
    int indexOfEditedEntry = _journalEntries!.indexWhere((entry) => entry.date == _existingEntry.date);
    _journalEntries![indexOfEditedEntry] = _existingEntry;
    print('xd');
    _existingEntry.storedImage != null? await uploadPhoto(_existingEntry.storedImage!, user, _existingEntry):null;
    _existingEntry.storedImage != null? _existingEntry.hasPhoto = true: _existingEntry.hasPhoto = false;
    List<Map<String, dynamic>> entriesAsMap = journalEntries.map((entry) => entry.toMap()).toList();
    await _db
        .collection('users_data')
        .doc(user.email)
        .set({'journalEntries': entriesAsMap}, SetOptions(merge: true));
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


  Future<void> uploadPhoto(File file, FirebaseUser user, JournalEntry subject) async{
    String firebasePath = 'images/${user.email}/${DateFormat('yyyy-MM-dd kk:mm:ss').format(subject.date!)}.jpg';
    final ref = FirebaseStorage.instance.ref().child(firebasePath);
    await ref.putFile(file);
    notifyListeners();
  }

  Future<String> retrievePhoto(DateTime date, FirebaseUser user) async{
    String firebasePath = 'images/${user.email}/${DateFormat('yyyy-MM-dd kk:mm:ss').format(date)}.jpg';
    final ref = FirebaseStorage.instance.ref().child(firebasePath);
    String url = await ref.getDownloadURL();
    return url;
  }

  Future<void> deletePhoto(DateTime date, FirebaseUser user) async{
    String firebasePath = 'images/${user.email}/${DateFormat('yyyy-MM-dd kk:mm:ss').format(date)}.jpg';
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
    _journalEntries!.forEach((entry) {
      sum+=entry.stressLevel;
    });
    return sum==0?0:double.parse((sum/_journalEntries!.length).toStringAsFixed(2));
  }

  List<MapEntry<String, int>> getMostFeltEmotions() {
    Map<String, int> emotions = {};

    // Count occurrences of each emotion
    _journalEntries?.forEach((journalEntry) {
      journalEntry.emotions?.forEach((emotion) {
        emotions[emotion] =
        emotions.containsKey(emotion) ? emotions[emotion]! + 1 : 1;
      });
    });

    List<MapEntry<String, int>> sortedEmotions = emotions.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEmotions;
  }

  String getAdviceBasedOnEmotion(String emotion) {
    Random random = Random();

    switch (emotion) {
      case 'Frustrated':
        return _frustratedAdvices[random.nextInt(_frustratedAdvices.length)];
      case 'Relaxed':
        return _relaxedAdvices[random.nextInt(_relaxedAdvices.length)];
      case 'Bored':
        return _boredAdvices[random.nextInt(_boredAdvices.length)];
      case 'Calm':
        return _calmAdvices[random.nextInt(_calmAdvices.length)];
      case 'Fascinated':
        return _fascinatedAdvices[random.nextInt(_fascinatedAdvices.length)];
      case 'Tired':
        return _tiredAdvices[random.nextInt(_tiredAdvices.length)];
      case 'Angry':
        return _angryAdvices[random.nextInt(_angryAdvices.length)];
      case 'Anxious':
        return _anxiousAdvices[random.nextInt(_anxiousAdvices.length)];
      case 'Lonely':
        return _lonelyAdvices[random.nextInt(_lonelyAdvices.length)];
      case 'Excited':
        return _excitedAdvices[random.nextInt(_excitedAdvices.length)];
      case 'Loved':
        return _lovedAdvices[random.nextInt(_lovedAdvices.length)];
      case 'Surprised':
        return _surprisedAdvices[random.nextInt(_surprisedAdvices.length)];
      default:
        return 'No advice available for this emotion.';
    }
  }
}

List<String> _frustratedAdvices = [
  'Take a deep breath and count to ten.',
  'Step back and reassess the situation.',
  'Express your feelings through writing.',
];

List<String> _relaxedAdvices = [
  'Find a quiet place and meditate.',
  'Listen to calming music.',
  'Take a leisurely walk.',
];

List<String> _boredAdvices = [
  'Try a new hobby or activity.',
  'Explore a new book or movie.',
  'Connect with friends for a fun activity.',
];

List<String> _calmAdvices = [
  'Practice mindfulness and focus on your breath.',
  'Engage in a relaxing activity.',
  'Visualize a peaceful scene.',
];

List<String> _fascinatedAdvices = [
  'Dive deeper into what fascinates you.',
  'Learn more about the subject of interest.',
  'Share your fascination with others.',
];

List<String> _tiredAdvices = [
  'Take a short nap or rest.',
  'Hydrate and ensure you\'re getting enough sleep.',
  'Delegate tasks and prioritize self-care.',
];

List<String> _angryAdvices = [
  'Take a break and walk away from the situation.',
  'Channel your anger into physical activity.',
  'Practice deep-breathing exercises.',
];

List<String> _anxiousAdvices = [
  'Identify the source of your anxiety and address it.',
  'Practice grounding techniques.',
  'Seek support from friends or professionals.',
];

List<String> _lonelyAdvices = [
  'Reach out to friends or family for connection.',
  'Join social groups or activities.',
  'Engage in activities you enjoy to lift your spirits.',
];

List<String> _excitedAdvices = [
  'Capture your excitement by jotting down your thoughts.',
  'Share your excitement with someone close to you.',
  'Plan a celebration or activity to express your enthusiasm.',
];

List<String> _lovedAdvices = [
  'Express your love and appreciation to others.',
  'Spend quality time with loved ones.',
  'Write a heartfelt message or letter.',
];

List<String> _surprisedAdvices = [
  'Embrace the unexpected and go with the flow.',
  'Reflect on the positive aspects of the surprise.',
  'Share your surprise with others to spread joy.',
];