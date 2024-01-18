import 'package:flutter/material.dart';

String fontFamily = 'Poppins';
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Color(0xFF101010),
    onBackground: Colors.white,
    primary: Color(0xFF2B2B2B),
    // onBackground: ,
    onPrimaryContainer: Color(0xFF404040),
    secondary: Color(0xFFB2F042),
    onSecondaryContainer: Color(0xFF101010),
    error: Color(0xFFFF7280),
    // IMPORTANT
    onError: Color(0xFFB286FD),
    // URGENT
    onErrorContainer: Color(0xFFffdd3c),
  ),
  checkboxTheme: CheckboxThemeData(
    checkColor:  MaterialStateProperty.all<Color>(Color(0xFFB2F042)),
    shape: CircleBorder(),
    side: BorderSide(
      color: Color(0xFF404040),
      width: 1.5
    )
    // fillColor: MaterialStateProperty.all<Color>(Color(0xFF404040))
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: InputBorder.none,
  ),
  iconTheme: IconThemeData(
    color: Colors.white
  ),
  // typography: Typography(),
  // bottomNavigationBarTheme: BottomNavigationBarThemeData(
  //   backgroundColor: Colors.red
  // ),
    primaryTextTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 60,
        fontFamily: fontFamily,
        // color: Colors.white
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontFamily: fontFamily,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontFamily: fontFamily,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontFamily: fontFamily,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontFamily: fontFamily,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontFamily: fontFamily,
      ),
      // titleLarge: TextStyle(
      //   fontSize: 22,
      //   fontFamily: fontFamily,
      // ),
      // titleMedium: TextStyle(
      //   fontSize: 20,
      //   fontFamily: fontFamily,
      // ),
      // titleSmall: TextStyle(
      //   fontSize: 18,
      //   fontFamily: fontFamily,
      // ),
      bodyLarge: TextStyle(
        fontSize: 22,
        fontFamily: fontFamily,
      ),
      bodyMedium: TextStyle(
        fontSize: 20,
        fontFamily: fontFamily,
      ),
      bodySmall: TextStyle(
        fontSize: 18,
        fontFamily: fontFamily,
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        fontFamily: fontFamily,
      ),
      labelMedium: TextStyle(
        fontSize: 14,
        fontFamily: fontFamily,
      ),
      labelSmall: TextStyle(
        fontSize: 12,
        fontFamily: fontFamily,
      ),
    ),
  textTheme: TextTheme(
    displayLarge: TextStyle(
        fontSize: 60,
        fontFamily: fontFamily,
        // color: Colors.white
        fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
        fontSize: 45,
        fontFamily: fontFamily,
        fontWeight: FontWeight.bold,
    ),
    displaySmall: TextStyle(
        fontSize: 36,
        fontFamily: fontFamily,
        fontWeight: FontWeight.bold,
    ),
    headlineLarge: TextStyle(
      fontSize: 32,
      fontFamily: fontFamily,
      fontWeight: FontWeight.bold,
    ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontFamily: fontFamily,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontFamily: fontFamily,
        fontWeight: FontWeight.bold,
      ),
    // titleLarge: TextStyle(
    //     fontSize: 22,
    //     fontFamily: fontFamily,
    //     fontWeight: FontWeight.bold,
    // ),
    // titleMedium: TextStyle(
    //     fontSize: 20,
    //     fontFamily: fontFamily,
    //     fontWeight: FontWeight.bold,
    // ),
    // titleSmall: TextStyle(
    //     fontSize: 18,
    //     fontFamily: fontFamily,
    //     fontWeight: FontWeight.bold,
    // ),
    bodyLarge: TextStyle(
      fontSize: 22,
      fontFamily: fontFamily,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: TextStyle(
      fontSize: 20,
      fontFamily: fontFamily,
      fontWeight: FontWeight.bold,
    ),
    bodySmall: TextStyle(
      fontSize: 18,
      fontFamily: fontFamily,
      fontWeight: FontWeight.bold,
    ),
    labelLarge: TextStyle(
      fontSize: 16,
      fontFamily: fontFamily,
      fontWeight: FontWeight.bold,
    ),
    labelMedium: TextStyle(
      fontSize: 14,
      fontFamily: fontFamily,
      fontWeight: FontWeight.bold,
    ),
    labelSmall: TextStyle(
      fontSize: 12,
      fontFamily: fontFamily,
      fontWeight: FontWeight.bold,
    ),
  )
);