import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light().copyWith(
      primary: Colors.red,
      secondary: Colors.redAccent,
      onPrimary: Colors.black,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: Colors.black,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: Colors.white),
    cardTheme: CardTheme(
      shadowColor: Colors.black,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
    ),
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.black,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: Colors.red,
      secondary: Colors.red,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
    ),
    bottomNavigationBarTheme:
        const BottomNavigationBarThemeData(backgroundColor: Colors.black),
    dialogBackgroundColor: Colors.grey[900],
    cardTheme: CardTheme(
      color: Colors.grey[900],
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
    )
  );
}
