import 'package:anitrak/src/app.dart';
import 'package:anitrak/src/cubits/theme_cubit/theme_cubit.dart';
import 'package:anitrak/src/app_theme.dart';
import 'package:anitrak/src/pages/intro_screen.dart';
import 'package:anitrak/src/providers.dart';
import 'package:anitrak/src/repositories/preferences_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final PreferencesRepo _preferencesRepo = PreferencesRepo();
  final f = await _preferencesRepo.firstTime;
  runApp(MyApp(
    firstTime: f ?? true,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    this.firstTime = true,
  }) : super(key: key);

  final bool firstTime;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Providers(
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          final data = state as ThemeModeState;
          return MaterialApp(
            title: 'AniTrak',
            themeMode: data.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: firstTime
                ? IntroScreen(
                    onDone: (() {
                      final repo =
                          RepositoryProvider.of<PreferencesRepo>(context);
                      repo.setFirstTime(false);
                    }),
                  )
                : const App(),
          );
        },
      ),
    );
  }
}
