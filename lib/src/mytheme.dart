import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData lightTheme = ThemeData(
      // scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light().copyWith(
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

  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xff121212),
    colorScheme: const ColorScheme.dark().copyWith(
      secondary: Colors.red,
      secondaryVariant: Colors.red,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xff121212),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff121212),
    ),
    cardColor: const Color(0xff121212),
  );
}
