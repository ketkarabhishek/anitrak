import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeModeState());

  final String themeModeKey = "thememode";

  void initializeTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeIndex = prefs.getInt(themeModeKey);
    if (themeModeIndex != null) {
      final newState =
          ThemeModeState(themeMode: ThemeMode.values[themeModeIndex]);
      emit(newState);
      // SystemChrome.setSystemUIOverlayStyle(
      //   SystemUiOverlayStyle(
      //       statusBarColor: Colors.transparent,
      //       systemNavigationBarColor: newState.navColor,
      //       statusBarIconBrightness: Brightness.light),
      // );
    }
  }

  void setAppTheme(int themeModeIndex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(themeModeKey, themeModeIndex);
    final newState =
        ThemeModeState(themeMode: ThemeMode.values[themeModeIndex]);
    emit(newState);
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //       statusBarColor: Colors.transparent,
    //       systemNavigationBarColor: newState.navColor,
    //       statusBarIconBrightness: Brightness.light),
    // );
  }
}
