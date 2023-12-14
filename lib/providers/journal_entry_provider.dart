import 'dart:io';

import 'package:flutter/material.dart';
import 'package:outwork/models/journal_entry.dart';

class JournalEntryProvider extends ChangeNotifier {
  String _selectedFeeling = '';
  int _stressLevel = 0;
  List<String> _emotions = [];
  File? _storedImage;
  File? _savedImage;
  bool _hasNote = false;

  // TODO: FORMAT IT SO JOURNAL ENTRY IS A MODEL AND THIS ONLY USES AND MANAGES IT.

  String get selectedFeeling => _selectedFeeling;
  int get stressLevel => _stressLevel;
  List<String> get emotions => _emotions;
  File? get storedImage => _storedImage;
  File? get savedImage => _savedImage;
  bool get hasNote => _hasNote;

  void updateSelectedFeeling(String feeling) {
    _selectedFeeling = feeling;
    notifyListeners();
  }

  void addEmotion(String emotion){
    _emotions.contains(emotion)?_emotions.remove(emotion):_emotions.add(emotion);
    notifyListeners();
  }

  void setStoredImage(File storedImage){
    _storedImage = storedImage;
    notifyListeners();
  }

  void setSavedImage(File savedImage){
    _savedImage = savedImage;
    notifyListeners();
  }

  void setHasNote(bool value){
    _hasNote = value;
    notifyListeners();
  }

  void setStressLevel(int stressLevel){
    _stressLevel = stressLevel;
    notifyListeners();
  }

  void clearProvider(){
    _selectedFeeling = '';
    _emotions = [];
  }

  void addEntryToFirebase(){

  }
}