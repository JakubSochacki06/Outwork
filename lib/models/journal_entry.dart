import 'dart:io';

class JournalEntry{
  String feeling = '';
  int stressLevel = 0;
  List<dynamic> emotions = [];
  File? storedImage;
  File? savedImage;
  bool hasNote = false;

  JournalEntry({required this.feeling, required this.stressLevel, required this.emotions, required this.storedImage, required this.savedImage, required this.hasNote});

  factory JournalEntry.fromMap(Map<String, dynamic> data){
    JournalEntry journalEntry = JournalEntry(
      emotions: data['emotions'],
      feeling: data['feeling'],
      hasNote: data['hasNote'],
      savedImage: data['savedImage'],
      storedImage: data['storedImage'],
      stressLevel: data['stressLevel'],
    );
    return journalEntry;
  }
}