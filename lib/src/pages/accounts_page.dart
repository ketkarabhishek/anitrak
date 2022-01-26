import 'package:anitrak/src/bloc/anilist_account_bloc/anilist_account_bloc.dart';
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
      body: BlocBuilder<AnilistAccountBloc, AnilistAccountState>(
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

  Widget _anilistCard(AnilistAccountState anilistState) {
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
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            data.anilistUserId,
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
                              BlocProvider.of<AnilistAccountBloc>(context)
                                  .add(AnilistLibraryImported());
                            }
                          },
                          icon: const Icon(Icons.sync),
                          label: const Text('Import Library'),
                        ),
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
