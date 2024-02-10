import 'package:flutter/material.dart';

import '../models/book.dart';
import '../models/firebase_user.dart';

class ProgressProvider with ChangeNotifier {
  List<Book> _books = [];

  List<Book> get books => _books;

  void setProgressFields(FirebaseUser user) {
    _books = user.books!;
  }
}