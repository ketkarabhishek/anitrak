import 'package:anitrak/src/bloc/anilist_account_bloc/anilist_account_bloc.dart';
import 'package:anitrak/src/bloc/kitsu_account_bloc/kitsu_account_bloc.dart';
import 'package:anitrak/src/cubits/theme_cubit/theme_cubit.dart';
import 'package:anitrak/src/database/database.dart';
import 'package:anitrak/src/repositories/accounts_repo.dart';
import 'package:anitrak/src/repositories/media_library_repo.dart';
import 'package:anitrak/src/repositories/preferences_repo.dart';
import 'package:anitrak/src/services/anilist/anilist_client.dart';
import 'package:anitrak/src/services/kitsu/kitsu.dart';
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
    final kitsuClient = Kitsu.create(repo: _preferencesRepo);
    _accountsRepo = AccountsRepo(anilistClient: anilistClient, kitsuClient: kitsuClient);
    _mediaLibraryRepo = MediaLibraryRepo(
      mediaLibraryDao: _db.mediaLibraryDao,
      anilistClient: anilistClient,
      libraryUpdateDao: _db.libraryUpdateDao,
      kitsuClient: kitsuClient,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: false,
            create: (context) => AnilistAccountBloc(
              _accountsRepo,
              _mediaLibraryRepo,
              _preferencesRepo,
            )..add(
                AnilistAccountInitialized(),
              ),
          ),
          BlocProvider(
            lazy: false,
            create: (context) => KitsuAccountBloc(
              _accountsRepo,
              _mediaLibraryRepo,
              _preferencesRepo,
            )..add(
                KitsuAccountInitialized(),
              ),
          ),
          BlocProvider(
            lazy: false,
            create: (context) => ThemeCubit()..initializeTheme(),
          ),
        ],
        child: MultiRepositoryProvider(
          providers: [
            RepositoryProvider<MediaLibraryRepo>(
              create: (_) => _mediaLibraryRepo,
            ),
            RepositoryProvider<PreferencesRepo>(
              create: (_) => _preferencesRepo,
            ),
          ],
          child: widget.child,
        ));
  }
}
