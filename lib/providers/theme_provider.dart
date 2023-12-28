import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:outwork/theme/dark_theme.dart';
import 'package:outwork/theme/light_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = darkTheme;

  ThemeData get themeData => _themeData;

  bool isDarkTheme(){
    return _themeData == darkTheme;
  }

  bool isLightTheme(){
    return _themeData == lightTheme;
  }
}