import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/book.dart';
import '../models/firebase_user.dart';

class ProgressProvider with ChangeNotifier {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  List<Book> _books = [];

  List<Book> get books => _books;

  void setProgressFields(FirebaseUser user) {
    _books = user.books!;
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
    await _db
        .collection('users_data')
        .doc(userEmail)
        .update({
      'books': FieldValue.increment(pagesRead),
    });
    notifyListeners();
  }
}