import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.grey[100],
      colorScheme: const ColorScheme.light().copyWith(
        primary: Colors.red,
        secondary: Colors.redAccent,
        secondaryVariant: Colors.red,
        onPrimary: Colors.black,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: Colors.black,
      ));

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor:  Colors.grey[900],
    colorScheme: const ColorScheme.dark().copyWith(
      primary: Colors.red,
      secondary: Colors.red,
      secondaryVariant: Colors.red,
    ),
    // bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    //   backgroundColor: Color(0xff121212),
    // ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[850],
    ),
    cardColor: Colors.grey[850],
  );
}
