part of 'theme_cubit.dart';

abstract class ThemeState {}

class ThemeModeState extends ThemeState {
  final ThemeMode themeMode;

  ThemeModeState({this.themeMode = ThemeMode.dark});

  Color get navColor {
    switch (themeMode) {
      case ThemeMode.dark:
        return Colors.grey[900]!;
      case ThemeMode.system:
        if (SchedulerBinding.instance!.window.platformBrightness ==
            Brightness.dark) {
          return Colors.grey[900]!;
        }
        break;
      default:
        return Colors.white;
    }
    return Colors.white;
  }

  String get themeTitle {
     switch (themeMode) {
      case ThemeMode.dark:
        return "Dark";
      case ThemeMode.system:
        return "System";
      default:
        return "Light";
    }
  }
}
