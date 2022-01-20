import 'package:anitrak/src/cubits/theme_cubit/theme_cubit.dart';
import 'package:anitrak/src/pages/accounts_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';

class MorePage extends StatelessWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("More"),
        elevation: 0,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(
              Icons.sync_outlined,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: const Text("Tracking"),
            subtitle: const Text("Manage your anime tracking accounts"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountsPage()),
              );
            },
          ),
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              final data = state as ThemeModeState;
              return ListTile(
                leading: Icon(
                  Icons.color_lens_outlined,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                title: const Text("Theme"),
                subtitle: Text(data.themeTitle),
                onTap: () async {
                  final themeMode = await showDialog<ThemeMode>(
                      context: context,
                      builder: (context) => _getThemeDialog(context));
                  if(themeMode != null){
                    final themeCubit = BlocProvider.of<ThemeCubit>(context);
                    themeCubit.setAppTheme(themeMode.index);
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _getThemeDialog(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: const Text('Select App Theme'),
      children: [
        SimpleDialogOption(
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'System',
              style: TextStyle(fontSize: 18),
            ),
          ),
          onPressed: () => Navigator.pop(context, ThemeMode.system),
        ),
        SimpleDialogOption(
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Light',
              style: TextStyle(fontSize: 18),
            ),
          ),
          onPressed: () => Navigator.pop(context, ThemeMode.light),
        ),
        SimpleDialogOption(
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Dark',
              style: TextStyle(fontSize: 18),
            ),
          ),
          onPressed: () => Navigator.pop(context, ThemeMode.dark),
        ),
      ],
    );
  }
}
