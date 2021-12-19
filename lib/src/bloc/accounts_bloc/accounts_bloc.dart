import 'dart:async';

import 'package:anitrak/src/models/media_entry.dart';
import 'package:anitrak/src/repositories/accounts_repo.dart';
import 'package:anitrak/src/repositories/media_entries_repo.dart';
import 'package:anitrak/src/repositories/preferences_repo.dart';
import 'package:bloc/bloc.dart';

part 'accounts_event.dart';
part 'accounts_state.dart';

class AccountsBloc extends Bloc<AccountsEvent, AccountsState> {
  AccountsBloc(
      this._accountsRepo, this._mediaEntriesRepo, this._preferencesRepo)
      : super(const AccountsState()) {
    on<AccountsInitializedEvent>((event, emit) async {
      final anilistToken = await _initializeAnilistAccount();
      _unsyncedStream = _mediaEntriesRepo.getUnsyncedMediaEntries();
      if (anilistToken) {
        _syncAnilist();
      }
      final anilistUserId = await _preferencesRepo.anilistUserId;
      final anilistUserName = await _preferencesRepo.anilistUserName;
      final anilistAvatar = await _preferencesRepo.anilistAvatar;
      emit(AccountsState(
        anilistUserId: anilistUserId ?? "",
        anilistUserName: anilistUserName ?? "",
        anilistAvatar: anilistAvatar ?? "",
      ));
    });

    on<AnilistLoginEvent>((event, emit) async {
      final anilistToken = await _loginAnilist();
      if (!anilistToken) {
        return;
      }
      final anilistUserId = await _fetchAndSaveAniistUserData();
      final anilistUserName = await _preferencesRepo.anilistUserName;
      final anilistAvatar = await _preferencesRepo.anilistAvatar;
      _syncAnilist();
      emit(AccountsState(
        anilistUserId: anilistUserId,
        anilistUserName: anilistUserName ?? "",
        anilistAvatar: anilistAvatar ?? "",
      ));
    });

    on<AnilistLogoutEvent>((event, emit) async {
      await _preferencesRepo.deleteAnilistToken();
      _unsyncedStreamSub.cancel();
      emit(const AccountsState());
    });

    on<AnilistLibraryImported>((event, emit) async {
      await _mediaEntriesRepo.importAnilistLibrary();
    });
  }

  final AccountsRepo _accountsRepo;
  final PreferencesRepo _preferencesRepo;
  final MediaEntriesRepo _mediaEntriesRepo;

  late StreamSubscription<List<MediaEntry>> _unsyncedStreamSub;
  late Stream<List<MediaEntry>> _unsyncedStream;

  Future<bool> _initializeAnilistAccount() async {
    final accessToken = await _preferencesRepo.anilistAccessToken;
    if (accessToken == null) {
      return false;
    }
    final expiresIn = await _preferencesRepo.anilistExpiresIn;
    if (DateTime.now().difference(DateTime.parse(expiresIn!)).inDays > 0) {
      // TODO - Implement refresh token
      return false;
    }
    return true;
  }

  Future<bool> _loginAnilist() async {
    final tokenMap = await _accountsRepo.anilistLogin();
    await _preferencesRepo.saveAnilistToken(tokenMap);
    final accessToken = await _preferencesRepo.anilistAccessToken;
    if (accessToken == null || accessToken.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> _syncAnilist() async {
    _unsyncedStreamSub = _unsyncedStream.listen((entries) async {
      await Future.wait(
          entries.map((e) => _mediaEntriesRepo.updateAnilistEntry(e)));
    });
  }

  Future<String> _fetchAndSaveAniistUserData() async {
    final res = await _accountsRepo.fetchAnilistUserData();
    final userId = res['id'].toString();
    final userName = res['name'].toString();
    final avatar = res['avatar']['medium'].toString();
    await _preferencesRepo.saveAnilistUserData(
        userId: userId, userName: userName, avatar: avatar);
    return userId;
  }
}
