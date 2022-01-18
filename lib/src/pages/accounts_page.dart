import 'package:anitrak/src/bloc/accounts_bloc/accounts_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({Key? key}) : super(key: key);

  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tracking Services"),
        elevation: 0,
      ),
      body: BlocBuilder<AccountsBloc, AccountsState>(
        builder: (context, state) {
          return ListView(
            children: [
              _anilistCard(state),
            ],
          );
        },
      ),
    );
  }

  Widget _anilistCard(AccountsState anilistState) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            // color: Colors.white60,
            width: 1,
          ),
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
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              anilistState.anilistAuth
                  ? Align(
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(anilistState.anilistAvatar),
                            backgroundColor: Colors.transparent,
                            radius: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              anilistState.anilistUserName,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              anilistState.anilistUserId,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              final res = await showDialog<bool>(
                                context: context,
                                builder: (context) => _getAlertDialog(),
                              );
                              if (res != null && res) {
                                BlocProvider.of<AccountsBloc>(context)
                                    .add(AnilistLibraryImported());
                              }
                            },
                            icon: const Icon(Icons.sync),
                            label: const Text('Import Library'),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              BlocProvider.of<AccountsBloc>(context)
                                  .add(AnilistLogoutEvent());
                            },
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<AccountsBloc>(context)
                            .add(AnilistLoginEvent());
                      },
                      child: const Text('Connect'),
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
          child: const Text('OK'),
        ),
      ],
    );
  }
}
