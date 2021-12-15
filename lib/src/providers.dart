import 'package:anitrak/src/bloc/accounts_bloc/accounts_bloc.dart';
import 'package:anitrak/src/database/database.dart';
import 'package:anitrak/src/repositories/accounts_repo.dart';
import 'package:anitrak/src/repositories/media_entries_repo.dart';
import 'package:anitrak/src/services/anilist/anilist_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Providers extends StatefulWidget {
  const Providers({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<Providers> createState() => _ProvidersState();
}

class _ProvidersState extends State<Providers> {
  final MyDatabase db = MyDatabase();
  final AccountsRepo accountsRepo = AccountsRepo();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountsBloc(accountsRepo)
        ..add(
          AccountsInitializedEvent(),
        ),
      child: RepositoryProvider<MediaEntriesRepo>(
        create: (_) {
          final anilistClient = AnilistClient.create(repo: accountsRepo);
          return MediaEntriesRepo(
              mediaEntriesDao: db.mediaEntriesDao, client: anilistClient);
        },
        child: widget.child,
      ),
    );
  }
}
