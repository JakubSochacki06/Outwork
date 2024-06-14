import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:outwork/theme/dark_theme.dart';
import 'package:outwork/theme/light_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = darkTheme;
  Locale? _selectedLocale;

  ThemeData get themeData => _themeData;
  Locale? get selectedLocale => _selectedLocale;

  void enableLightTheme(bool value){
    value == true?_themeData = lightTheme:_themeData = darkTheme;
    print(themeData.colorScheme.background);
    notifyListeners();
  }

  // Future<void> changeSelectedLanguage(String language, String userEmail) async{
  //   _selectedLocale = language;
  //   await FirebaseFirestore.instance.collection('users_data').doc(userEmail).update({
  //     'selectedLanguage': language,
  //   });
  //   notifyListeners();
  // }

  Future<void> setUserLocale(Locale savedLocale) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', savedLocale.languageCode);
    _selectedLocale = savedLocale;
    notifyListeners();
  }

  void setStartingLocale(Locale startingLocale) async{
    _selectedLocale = startingLocale;
    print('SET STARTING LOCALE AS ${startingLocale.languageCode}');
  }

  bool isDarkTheme(){
    return _themeData == darkTheme;
  }

  bool isLightTheme(){
    return _themeData == lightTheme;
  }
}