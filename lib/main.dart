import 'package:anitrak/src/app.dart';
import 'package:anitrak/src/bloc/app_bloc/app_bloc.dart';
import 'package:anitrak/src/db/database.dart';
import 'package:anitrak/src/db/dbhelper.dart';
import 'package:anitrak/src/mytheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = await DbHelper.database;
  runApp(MyApp(
    database: db,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.database}) : super(key: key);

  final DataBase database;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    return RepositoryProvider(
      create: (context) => database,
      child: BlocProvider(
        create: (context) => AppBloc(database),
        child: MaterialApp(
          title: 'AniTrak',
          themeMode: ThemeMode.light,
          theme: MyTheme.lightTheme,
          darkTheme: MyTheme.darkTheme,
          home: const App(),
        ),
      ),
    );
  }
}
