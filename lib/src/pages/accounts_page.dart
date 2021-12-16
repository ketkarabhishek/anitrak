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
              _anilistCard(state.anilistAuth),
            ],
          );
        },
      ),
    );
  }

  Widget _anilistCard(bool anilistState) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Anilist',
              style: Theme.of(context).textTheme.headline4,
            ),
            const Divider(),
            anilistState
                ? OutlinedButton(
                    onPressed: () {
                      BlocProvider.of<AccountsBloc>(context)
                          .add(AnilistLogoutEvent());
                    },
                    child: const Text('Logout'),
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
    );
  }
}
