import 'package:anitrak/src/bloc/accounts_bloc/accounts_bloc.dart';
import 'package:anitrak/src/cubits/theme_cubit/theme_cubit.dart';
import 'package:anitrak/src/database/database.dart';
import 'package:anitrak/src/repositories/accounts_repo.dart';
import 'package:anitrak/src/repositories/media_library_repo.dart';
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
  late final MediaLibraryRepo _mediaLibraryRepo;

  @override
  void initState() {
    final anilistClient = AnilistClient.create(repo: _preferencesRepo);
    _accountsRepo = AccountsRepo(anilistClient: anilistClient);
    _mediaLibraryRepo = MediaLibraryRepo(
      mediaLibraryDao: _db.mediaLibraryDao,
      client: anilistClient,
      libraryUpdateDao: _db.libraryUpdateDao,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) => AccountsBloc(
            _accountsRepo,
            _mediaLibraryRepo,
            _preferencesRepo,
          )..add(
              AccountsInitializedEvent(),
            ),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => ThemeCubit()..initializeTheme(),
        ),
      ],
      child: RepositoryProvider<MediaLibraryRepo>(
        create: (_) {
          return _mediaLibraryRepo;
        },
        child: widget.child,
      ),
    );
  }
}
