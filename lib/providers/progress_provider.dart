import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/book.dart';
import '../models/firebase_user.dart';

class ProgressProvider with ChangeNotifier {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  List<Book> _books = [];
  List<dynamic> _subscriptions = [];
  int _subLimit = 0;

  List<Book> get books => _books;
  List<dynamic> get subscriptions => _subscriptions;
  int get subLimit => _subLimit;

  void setProgressFields(FirebaseUser user) {
    print('POCZATEK PROGRESS');
    _books = user.books!;
    _subscriptions = user.subscriptions!;
    _subLimit = user.subLimit!;
  }

  Future<void> addBookToDatabase(Book book, String userEmail) async {
    _books.add(book);
    await _db
        .collection('users_data')
        .doc(userEmail)
        .update({
          'books': FieldValue.arrayUnion([book.toMap()]),
        });
    notifyListeners();
  }

  Future<void> addSubscriptionToDatabase(Map<String, dynamic> subscription, String userEmail) async {
    _subscriptions.add(subscription);
    await _db
        .collection('users_data')
        .doc(userEmail)
        .update({
      'subscriptions': FieldValue.arrayUnion([subscription]),
    });
    notifyListeners();
  }

  Future<void> removeSubscriptionFromDatabase(Map<String, dynamic> subscription, String userEmail) async {
    _subscriptions.remove(subscription);
    await _db
        .collection('users_data')
        .doc(userEmail)
        .update({
      'subscriptions': FieldValue.arrayRemove([subscription]),
    });
    notifyListeners();
  }

  double findLowestSub(){
    if(_subscriptions.length == 0) return 0;
    double lowest = _subscriptions[0]['price'];
    _subscriptions.forEach((element) {
      if(element['price']<lowest){
        lowest = element['price'];
      }
    });
    return lowest;
  }

  double findHighestSub(){
    if(_subscriptions.length == 0) return 0;
    double highest = _subscriptions[0]['price'];
    _subscriptions.forEach((element) {
      if(element['price']>highest){
        highest = element['price'];
      }
    });
    return highest;
  }

  double sumExpenses(){
    double sum = 0;
    _subscriptions.forEach((element) {
      sum += element['price'];
    });
    return sum;
  }

  Future<void> updateExpensesSettings(int limit, String email) async{
    _subLimit = limit;
    await _db
        .collection('users_data')
        .doc(email)
        .update({'subLimit': limit});
    notifyListeners();
  }

  Future<void> removeBookFromDatabase(Book book, String userEmail) async {
    _books.remove(book);
    await _db
        .collection('users_data')
        .doc(userEmail)
        .update({
      'books': FieldValue.arrayRemove([book.toMap()]),
    });
    notifyListeners();
  }

  Future<void> addReadPagesToDatabase(Book book, int pagesRead, String userEmail) async {
    int bookIndex = _books.indexOf(book);
    _books[bookIndex].readPages = _books[bookIndex].readPages! + pagesRead;
    List<dynamic> rawBooks = [];
    _books.forEach((element) {rawBooks.add(element.toMap());});
    await _db
        .collection('users_data')
        .doc(userEmail)
        .update({
      'books': rawBooks,
    });
    notifyListeners();
  }
}