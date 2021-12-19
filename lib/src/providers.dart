import 'package:anitrak/src/bloc/accounts_bloc/accounts_bloc.dart';
import 'package:anitrak/src/database/database.dart';
import 'package:anitrak/src/repositories/accounts_repo.dart';
import 'package:anitrak/src/repositories/media_entries_repo.dart';
import 'package:anitrak/src/repositories/preferences_repo.dart';
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
  final MyDatabase _db = MyDatabase();
  late final AccountsRepo _accountsRepo;
  final PreferencesRepo _preferencesRepo = PreferencesRepo();
  late final MediaEntriesRepo _mediaEntriesRepo; 

  @override
  void initState() {
    final anilistClient = AnilistClient.create(repo: _preferencesRepo);
    _accountsRepo = AccountsRepo(anilistClient: anilistClient);
    _mediaEntriesRepo = MediaEntriesRepo(
              mediaEntriesDao: _db.mediaEntriesDao, client: anilistClient);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => AccountsBloc(_accountsRepo, _mediaEntriesRepo, _preferencesRepo)
        ..add(
          AccountsInitializedEvent(),
        ),
      child: RepositoryProvider<MediaEntriesRepo>(
        create: (_) {
          return _mediaEntriesRepo;
        },
        child: widget.child,
      ),
    );
  }
}
