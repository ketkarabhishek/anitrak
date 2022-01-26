import 'dart:async';

import 'package:anitrak/src/models/library_update.dart';
import 'package:anitrak/src/models/media_entry.dart';
import 'package:anitrak/src/models/media_model.dart';
import 'package:anitrak/src/repositories/accounts_repo.dart';
import 'package:anitrak/src/repositories/media_library_repo.dart';
import 'package:anitrak/src/repositories/preferences_repo.dart';
import 'package:bloc/bloc.dart';

part 'anilist_account_event.dart';
part 'anilist_account_state.dart';

class AnilistAccountBloc
    extends Bloc<AnilistAccountEvent, AnilistAccountState> {
  AnilistAccountBloc(
    this._accountsRepo,
    this._mediaLibraryRepo,
    this._preferencesRepo,
  ) : super(AnilistAccountLoading()) {
    on<AnilistAccountInitialized>((event, emit) async {
      final anilistToken = await _initializeAnilistAccount();
      if (!anilistToken) {
        emit(AnilistAccountDisconnected());
        return;
      }
      _syncAnilist();
      final anilistUserId = await _preferencesRepo.anilistUserId;
      final anilistUserName = await _preferencesRepo.anilistUserName;
      final anilistAvatar = await _preferencesRepo.anilistAvatar;
      emit(AnilistAccountConnected(
        anilistUserId: anilistUserId ?? "",
        anilistUserName: anilistUserName ?? "",
        anilistAvatar: anilistAvatar ?? "",
      ));
    });

    on<AnilistAccountLogin>((event, emit) async {
      emit(AnilistAccountLoading());
      final anilistToken = await _loginAnilist();
      if (!anilistToken) {
        emit(AnilistAccountDisconnected());
        return;
      }
      final anilistUserId = await _fetchAndSaveAniistUserData();
      final anilistUserName = await _preferencesRepo.anilistUserName;
      final anilistAvatar = await _preferencesRepo.anilistAvatar;
      _syncAnilist();
      emit(AnilistAccountConnected(
        anilistUserId: anilistUserId,
        anilistUserName: anilistUserName ?? "",
        anilistAvatar: anilistAvatar ?? "",
      ));
    });

    on<AnilistAccountLogout>((event, emit) async {
      emit(AnilistAccountLoading());
      await _preferencesRepo.deleteAnilistToken();
      emit(AnilistAccountDisconnected());
    });

    on<AnilistLibraryImported>((event, emit) async {
      final anilistUserId = await _preferencesRepo.anilistUserId;
      if(anilistUserId == null) return;
      await _importAnilistLibrary(anilistUserId);
    });
  }

  final AccountsRepo _accountsRepo;
  final PreferencesRepo _preferencesRepo;
  final MediaLibraryRepo _mediaLibraryRepo;

  Future<bool> _initializeAnilistAccount() async {
    final accessToken = await _preferencesRepo.anilistAccessToken;
    if (accessToken == null) return false;

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
    _syncCreated();
    _syncUpdated();
  }

  void _syncCreated() async {
    _mediaLibraryRepo
        .getLibraryUpdates(type: LibraryUpdateType.create, anilist: false)
        .listen(
      (entries) async {
        final libItems = await Future.wait(
          entries.map((e) =>
              _mediaLibraryRepo.getLibraryItem(mediaEntryId: e.mediaEntryId)),
        );

        await Future.wait(
          libItems.map(
            (e) => _mediaLibraryRepo.saveAnilistEntry(
              e.mediaEntry,
              mediaId: e.media.alMediaId,
            ),
          ),
        );

        await Future.wait(entries.map((e) {
          final ue = e.copyWith(anilist: true);
          return _mediaLibraryRepo.updateLibraryUpdate(ue);
        }));
      },
    );
  }

  void _syncUpdated() async {
    _mediaLibraryRepo
        .getLibraryUpdates(type: LibraryUpdateType.create, anilist: false)
        .listen(
      (entries) async {
        final libItems = await Future.wait(
          entries.map((e) =>
              _mediaLibraryRepo.getLibraryItem(mediaEntryId: e.mediaEntryId)),
        );

        await Future.wait(
          libItems.map(
            (e) => _mediaLibraryRepo.saveAnilistEntry(
              e.mediaEntry,
              mediaId: e.media.alMediaId,
            ),
          ),
        );

        await Future.wait(entries.map((e) {
          final ue = e.copyWith(anilist: true);
          return _mediaLibraryRepo.updateLibraryUpdate(ue);
        }));
      },
    );
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
