import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:outwork/models/daily_checkin.dart';
import 'package:outwork/models/journal_entry.dart';
import 'package:flutter/material.dart';
import 'package:outwork/models/project.dart';

import 'book.dart';

class FirebaseUser {
  String? displayName;
  String? email;

  // String? familyID;
  String? photoURL;
  int? xpAmount;
  int? workedSeconds;
  List<dynamic>? morningRoutines;
  List<dynamic>? nightRoutines;
  List<dynamic>? subscriptions;
  List<dynamic>? referrals;
  int? subLimit;
  double? refBalance;
  List<DailyCheckin>? dailyCheckins;
  List<JournalEntry>? journalEntries;
  List<Book>? books;
  bool? isPremiumUser;
  DateTime? lastUpdated;
  int? streak;
  bool? toughModeSelected;
  List<dynamic>? projectsIDList;
  Map<dynamic, dynamic>? endOfTheDayJournal;
  Map<dynamic, dynamic>? pomodoroSettings;

  FirebaseUser(
      {this.displayName,
      this.email,
      this.photoURL,
        this.toughModeSelected,
      this.morningRoutines,
      this.nightRoutines,
      this.journalEntries,
      this.dailyCheckins,
        this.refBalance,
        this.referrals,
      this.endOfTheDayJournal,
        this.lastUpdated,
        this.subLimit,
  this.subscriptions,
        this.isPremiumUser,
      this.projectsIDList,
      this.xpAmount,
        this.streak,
        this.books,
      this.workedSeconds,
      this.pomodoroSettings});

  factory FirebaseUser.fromMap(Map<String, dynamic> data) {
    print('SUBSKRYPCE');
    print(data['subscriptions']);
    List<JournalEntry> journalEntries = [];
    data['journalEntries'].forEach((unorganizedJournalEntry) =>
        {journalEntries.add(JournalEntry.fromMap(unorganizedJournalEntry))});

    List<DailyCheckin> dailyCheckins = [];
    data['dailyCheckins'].forEach((unorganizedDailyCheckin) =>
        {dailyCheckins.add(DailyCheckin.fromMap(unorganizedDailyCheckin))});
    List<Book> books = [];
    data['books'].forEach((unorganizedBook) =>
    {books.add(Book.fromMap(unorganizedBook))});
    // TODO: MAKE USER FROM PROJECTS CREATE ONLY SIMPLE USER WITH DISPLAY NAME AND AVATAR, ADD REST WHEN USER CLICKS ON print(data['displayName']);
    FirebaseUser user = FirebaseUser(
      displayName: data['displayName'],
      email: data['email'],
      xpAmount: data['xpAmount'],
      // familyID: data['familyID'],
      photoURL: data['photoURL'],
      refBalance: data['refBalance']==0?data['refBalance'].toDouble():data['refBalance'],
      toughModeSelected: data['toughMode'],
      referrals: data['referrals'],
      morningRoutines: data['morningRoutines'],
      nightRoutines: data['nightRoutines'],
      journalEntries: journalEntries,
        subLimit: data['subLimit'],
        subscriptions: data['subscriptions'],
      workedSeconds: data['workedSeconds'],
      dailyCheckins: dailyCheckins,
      books: books,
      streak: data['streak'],
      projectsIDList: data['projectsIDList'],
      endOfTheDayJournal: data['endOfTheDayJournal'],
      pomodoroSettings: data['pomodoroSettings'],
      lastUpdated: data['lastUpdate'].toDate()
    );
    return user;
  }

  static Future<FirebaseUser?> getUserByMail(String email) async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;

    try {
      final QuerySnapshot querySnapshot = await _db
          .collection('users_data')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        dynamic userData = querySnapshot.docs.first.data();
        return FirebaseUser.fromMap(userData);
      }
    } catch (e) {
      // Handle error
      print(e.toString());
    }
    return null;
  }
}
