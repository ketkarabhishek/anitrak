import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData lightTheme = ThemeData(
      // scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light().copyWith(
        secondary: Colors.redAccent,
        onPrimary: Colors.black,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
      ));

  static ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor: Color(0xff121212),
      colorScheme: const ColorScheme.dark().copyWith(secondary: Colors.red),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.black,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
      ));
}
