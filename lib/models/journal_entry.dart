import 'dart:io';
import 'package:outwork/string_extension.dart';
import 'package:intl/intl.dart';

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

  String getEmotionsText() {
    String emotionsText = '';
    for (int i = 0; i < emotions!.length; i++) {
      emotionsText += emotions![i];
      if (i + 1 != emotions!.length) emotionsText += ', ';
    }
    return emotionsText;
  }


  String getFeelingAsTitle() {
    switch (feeling) {
      case 'sad':
      case 'unhappy':
      case 'neutral':
      case 'happy':
        return feeling!.capitalize();
    }
    return 'Very happy';
  }

  String getDateAsString() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = DateTime(now.year, now.month, now.day - 1);
    DateTime dateFormatted = DateTime(date!.year, date!.month, date!.day);
    String monthName = DateFormat('MMMM').format(dateFormatted);
    String minutes;
    date!.minute.toString().length == 1
        ? minutes = '0${date!.minute}'
        : minutes = date!.minute.toString();
    if (dateFormatted == today) {
      return 'Today, ${date!.hour}:$minutes';
    } else if (dateFormatted == yesterday) {
      if(getFeelingAsTitle() == 'Very happy' && hasNote != true){
        return 'Yesterday';
      }
      return 'Yesterday, ${date!.hour}:$minutes';
    } else {
      return '${date!.day} $monthName';
    }
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