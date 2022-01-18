import 'dart:async';

import 'package:anitrak/src/models/media_entry.dart';
import 'package:anitrak/src/models/media_model.dart';
import 'package:anitrak/src/repositories/accounts_repo.dart';
import 'package:anitrak/src/repositories/media_library_repo.dart';
import 'package:anitrak/src/repositories/preferences_repo.dart';
import 'package:bloc/bloc.dart';

part 'accounts_event.dart';
part 'accounts_state.dart';

class AccountsBloc extends Bloc<AccountsEvent, AccountsState> {
  AccountsBloc(
    this._accountsRepo,
    this._mediaLibraryRepo,
    this._preferencesRepo,
  ) : super(const AccountsState()) {
    on<AccountsInitializedEvent>((event, emit) async {
      final anilistToken = await _initializeAnilistAccount();
      _unsyncedStream = _mediaLibraryRepo.getUnsyncedMediaEntries();
      if (anilistToken) {
        // _syncAnilist();
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
      await _importAnilistLibrary(state.anilistUserId);
    });
  }

  final AccountsRepo _accountsRepo;
  final PreferencesRepo _preferencesRepo;
  final MediaLibraryRepo _mediaLibraryRepo;

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
        entries.map(
          (e) => _mediaLibraryRepo.updateAnilistEntry(e),
        ),
      );
       await Future.wait(
        entries.map(
          (e){
            final updated = e.copyWith(synced: true);
            return _mediaLibraryRepo.updateMediaEntry(updated);
          },
        ),
      );
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

  Future<void> _importAnilistLibrary(String userId) async {
    final jsonList = await _mediaLibraryRepo.getUserMediaList(userId);
    var mediaList = <MediaModel>[];
    var mediaEntryList = <MediaEntry>[];

    for (var e in jsonList) {
      final media = MediaModel.fromAnilistJson(e['media']);
      final mediaEntry = MediaEntry.fromAnilistJson(e, media.id);
      mediaList.add(media);
      mediaEntryList.add(mediaEntry);
    }

    await _mediaLibraryRepo.replaceAllMedia(mediaList);
    await _mediaLibraryRepo.replaceAllMediaEntries(mediaEntryList);
  }
}
