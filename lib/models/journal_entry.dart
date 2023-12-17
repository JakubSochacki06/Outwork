import 'dart:io';

class JournalEntry{
  String? feeling;
  int stressLevel;
  List<dynamic>? emotions;
  File? storedImage;
  File? savedImage;
  bool hasNote;
  DateTime? date;
  String? noteTitle;
  String? noteDescription;

  JournalEntry({this.feeling, this.stressLevel = 0, this.emotions, this.storedImage, this.savedImage, this.hasNote = false, this.date, this.noteTitle, this.noteDescription});

  factory JournalEntry.fromMap(Map<String, dynamic> data){
    JournalEntry journalEntry = JournalEntry(
      emotions: data['emotions'],
      feeling: data['feeling'],
      hasNote: data['hasNote'],
      savedImage: data['savedImage'],
      storedImage: data['storedImage'],
      stressLevel: data['stressLevel'],
      date: data['date'].toDate(),
      noteTitle:data['noteTitle'],
      noteDescription:data['noteDescription']

    );
    return journalEntry;
  }

  Map<String, dynamic> toMap() {
    return {
      'feeling': feeling,
      'stressLevel': stressLevel,
      'emotions':emotions,
      'storedImage':storedImage,
      'savedImage':savedImage,
      'hasNote':hasNote,
      'date':date,
      'noteTitle':noteTitle,
      'noteDescription':noteDescription
    };
  }
}