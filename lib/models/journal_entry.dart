import 'dart:io';

class JournalEntry{
  String selectedFeeling = '';
  int stressLevel = 0;
  List<String> emotions = [];
  File? storedImage;
  File? savedImage;
  bool hasNote = false;

  JournalEntry({required this.selectedFeeling, required this.stressLevel, required this.emotions, required this.storedImage, required this.savedImage, required this.hasNote});


}