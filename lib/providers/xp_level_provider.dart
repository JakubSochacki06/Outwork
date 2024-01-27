import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:outwork/models/firebase_user.dart';

class XPLevelProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  int _xpAmount = 0;
  int _xpLevel = 0;
  double _levelProgress = 0.0;
  List<int> levelThresholds = [0, 30, 70, 130, 200, 280, 370, 470, 580, 700, 830, 970, 1120, 1280, 1450, 1630, 1820];

  int get xpAmount => _xpAmount;
  int get xpLevel => _xpLevel;
  double get levelProgress => _levelProgress;

  void setXPAmount(FirebaseUser user) {
    _xpAmount = user.xpAmount!;
    _updateLevel();
  }

  Future<void> addXpAmount(int amount, String userEmail) async {
    _xpAmount += amount;
    await _db.collection('users_data').doc(userEmail).update({
      'xpAmount': FieldValue.increment(amount),
    });
    _updateLevel();
    notifyListeners();
  }

  String getUserLevelDescription() {
    switch (_xpLevel) {
      case 1:
        return 'Weak procrastinator';
      case 2:
        return 'They are laughing at you';
      case 3:
        return 'Grindset ready';
      case 4:
        return 'Goggins Wannabe';
      case 5:
        return 'Fresh starter';
      case 6:
        return 'They don\'t know me son!';
      case 7:
        return 'Im different.';
      case 8:
        return 'Routine keeper';
      case 9:
        return 'Winning is the only option';
      case 10:
        return 'Future millionaire';
      case 11:
        return 'Certified grinder';
      case 12:
        return 'Love the struggle';
      case 13:
        return 'You are killing it.';
      case 14:
        return 'Iron mindset';
      case 15:
        return 'Gigachad';
      case 16:
        return 'It doesn\'t hurt anymore';
      case 17:
        return 'You are HIM';
      default:
        return 'Grinded too much - we don\'t have more names :(';
    }
  }

  Future<void> removeXpAmount(int amount, String userEmail) async {
    _xpAmount -= amount;
    await _db.collection('users_data').doc(userEmail).update({
      'xpAmount': FieldValue.increment(-amount),
    });
    _updateLevel();
    notifyListeners();
  }

  void _updateLevel() {
    for (int i = 0; i < levelThresholds.length; i++) {
      if (_xpAmount < levelThresholds[i]) {
        _xpLevel = i;
        int currentLevelThreshold = i > 0 ? levelThresholds[i - 1] : 0;
        int nextLevelThreshold = levelThresholds[i];
        int xpInRange = _xpAmount - currentLevelThreshold;
        int xpRange = nextLevelThreshold - currentLevelThreshold;
        _levelProgress = xpInRange / xpRange;
        break;
      }
    }
  }

  int getNextLevelThreshold() {
    if (_xpLevel < levelThresholds.length) {
      return levelThresholds[_xpLevel];
    } else {
      return 0;
    }
  }
}
