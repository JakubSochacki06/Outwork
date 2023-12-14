import 'package:outwork/models/journal_entry.dart';

class FirebaseUser {
  String? displayName;
  String? email;
  // String? familyID;
  String? photoURL;
  List<dynamic>? morningRoutines;
  List<dynamic>? nightRoutines;
  List<JournalEntry>? journalEntries;

  FirebaseUser({this.displayName, this.email, this.photoURL, this.morningRoutines, this.nightRoutines, this.journalEntries});

  factory FirebaseUser.fromMap(Map<String, dynamic> data){
    List<JournalEntry> journalEntries = [];
    data['journalEntries'].forEach((unorganizedJournalEntry) => {
      journalEntries.add(JournalEntry.fromMap(unorganizedJournalEntry))
    });

    FirebaseUser user = FirebaseUser(
      displayName: data['displayName'],
      email: data['email'],
      // familyID: data['familyID'],
      photoURL: data['photoURL'],
      morningRoutines: data['morningRoutines'],
      nightRoutines: data['nightRoutines'],
      journalEntries: journalEntries,
    );
    return user;
  }

}