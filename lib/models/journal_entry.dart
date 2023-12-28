import 'dart:io';

class JournalEntry{
  String? feeling;
  int stressLevel;
  List<dynamic>? emotions;
  File? storedImage;
  File? savedImage;
  bool hasNote;
  bool? hasPhoto;
  DateTime? date;
  String? noteTitle;
  String? noteDescription;

  JournalEntry({this.feeling, this.stressLevel = 0, this.emotions, this.storedImage, this.savedImage, this.hasNote = false, this.date, this.noteTitle, this.noteDescription, this.hasPhoto});

  factory JournalEntry.fromMap(Map<String, dynamic> data){
    JournalEntry journalEntry = JournalEntry(
      emotions: data['emotions'],
      feeling: data['feeling'],
      hasNote: data['hasNote'],
      savedImage: data['savedImage'],
      storedImage: data['storedImage'],
      stressLevel: data['stressLevel'],
      hasPhoto: data['hasPhoto'],
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
      'hasNote':hasNote,
      'hasPhoto':hasPhoto,
      'date':date,
      'noteTitle':noteTitle,
      'noteDescription':noteDescription
    };
  }
}