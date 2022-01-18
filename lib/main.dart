import 'package:anitrak/src/app.dart';
import 'package:anitrak/src/mytheme.dart';
import 'package:anitrak/src/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        // systemNavigationBarColor: Colors.grey[850],
        statusBarIconBrightness: Brightness.light
      ),
    );
    return Providers(
      child: MaterialApp(
        title: 'AniTrak',
        themeMode: ThemeMode.dark,
        theme: MyTheme.lightTheme,
        darkTheme: MyTheme.darkTheme,
        home: const App(),
      ),
    );
  }
}
