import 'package:anitrak/src/bloc/anilist_account_bloc/anilist_account_bloc.dart';
import 'package:anitrak/src/bloc/kitsu_account_bloc/kitsu_account_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({Key? key}) : super(key: key);

  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  late TextEditingController _kitsuUserNameController;
  late TextEditingController _kitsuPasswordController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tracking Services"),
        elevation: 0,
      ),
      body: ListView(
        children: [
          _anilistCard(),
          _kitsuCard(),
        ],
      ),
    );
  }

  Widget _anilistCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          // side: BorderSide(
          //   color: Colors.blue[300]!,
          //   width: 1,
          // ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Anilist',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              BlocBuilder<AnilistAccountBloc, AnilistAccountState>(
                builder: (context, state) {
                  if (state is AnilistAccountLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is AnilistAccountDisconnected) {
                    return ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<AnilistAccountBloc>(context)
                            .add(AnilistAccountLogin());
                      },
                      child: const Text('Connect'),
                    );
                  }
                  final data = state as AnilistAccountConnected;
                  return Align(
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(data.anilistAvatar),
                          backgroundColor: Colors.transparent,
                          radius: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            data.anilistUserName,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text("Sync"),
                          trailing: Switch(
                            activeColor: Theme.of(context).colorScheme.primary,
                            value: data.anilistSync,
                            onChanged: (bool newValue) {
                              BlocProvider.of<AnilistAccountBloc>(context)
                                  .add(AnilistSyncToggled(newValue));
                            },
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text("Import"),
                          subtitle: const Text(
                              "Import library from your Anilist account"),
                          trailing: data.isImporting
                              ? const CircularProgressIndicator()
                              : null,
                          onTap: () async {
                            final res = await showDialog<bool>(
                              context: context,
                              builder: (context) => _getAlertDialog(),
                            );
                            if (res != null && res) {
                              BlocProvider.of<AnilistAccountBloc>(context)
                                  .add(AnilistLibraryImported());
                            }
                          },
                        ),
                        const Divider(),
                        OutlinedButton(
                          onPressed: () {
                            BlocProvider.of<AnilistAccountBloc>(context)
                                .add(AnilistAccountLogout());
                          },
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _kitsuCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Kitsu',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              BlocBuilder<KitsuAccountBloc, KitsuAccountState>(
                builder: (context, state) {
                  if (state is KitsuAccountLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is KitsuAccountDisconnected) {
                    return ElevatedButton(
                      onPressed: () async {
                        final res = await showDialog<bool>(
                            context: context,
                            builder: (context) => _getKitsuLoginDialog());
                        if (res == null || !res) {
                          return;
                        }
                        BlocProvider.of<KitsuAccountBloc>(context).add(
                          KitsuAccountLogin(
                            userName: _kitsuUserNameController.text,
                            password: _kitsuPasswordController.text,
                          ),
                        );
                      },
                      child: const Text('Connect'),
                    );
                  }
                  final data = state as KitsuAccountConnected;
                  return Align(
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(data.kitsuAvatar),
                          backgroundColor: Colors.transparent,
                          radius: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            data.kitsuUserName,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text("Sync"),
                          trailing: Switch(
                            activeColor: Theme.of(context).colorScheme.primary,
                            value: data.kitsuSync,
                            onChanged: (bool newValue) {
                              BlocProvider.of<KitsuAccountBloc>(context)
                                  .add(KitsuSyncToggled(newValue));
                            },
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text("Import"),
                          subtitle: const Text(
                              "Import library from your Kitsu account"),
                          trailing: data.isImporting
                              ? const CircularProgressIndicator()
                              : null,
                          onTap: () async {
                            final res = await showDialog<bool>(
                              context: context,
                              builder: (context) => _getAlertDialog(),
                            );
                            if (res != null && res) {
                              BlocProvider.of<KitsuAccountBloc>(context)
                                  .add(KitsuLibraryImported());
                            }
                          },
                        ),
                        const Divider(),
                        OutlinedButton(
                          onPressed: () {
                            BlocProvider.of<KitsuAccountBloc>(context)
                                .add(KitsuAccountLogout());
                          },
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getAlertDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: const Text('Warning'),
      content: const Text(
          'All the current library entries will be overwritten. Do you want to continue?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Import'),
        ),
      ],
    );
  }

  Widget _getKitsuLoginDialog() {
    _kitsuUserNameController = TextEditingController();
    _kitsuPasswordController = TextEditingController();
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: const Text('Kitsu Login'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              controller: _kitsuUserNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Username'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              controller: _kitsuPasswordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Password'),
              ),
              obscureText: true,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Login'),
        ),
      ],
    );
  }
}
