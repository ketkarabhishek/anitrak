import 'dart:async';

import 'package:anitrak/src/models/library_update.dart';
import 'package:anitrak/src/models/media_entry.dart';
import 'package:anitrak/src/models/media_model.dart';
import 'package:anitrak/src/repositories/accounts_repo.dart';
import 'package:anitrak/src/repositories/media_library_repo.dart';
import 'package:anitrak/src/repositories/preferences_repo.dart';
import 'package:bloc/bloc.dart';

part 'kitsu_account_event.dart';
part 'kitsu_account_state.dart';

class KitsuAccountBloc extends Bloc<KitsuAccountEvent, KitsuAccountState> {
  KitsuAccountBloc(
    this._accountsRepo,
    this._mediaLibraryRepo,
    this._preferencesRepo,
  ) : super(KitsuAccountLoading()) {
    on<KitsuAccountInitialized>((event, emit) async {
      final kitsuToken = await _initializeKitsuAccount();
      if (!kitsuToken) {
        emit(KitsuAccountDisconnected());
        return;
      }
      final kitsuUserId = await _preferencesRepo.kitsuUserId;
      final kitsuUserName = await _preferencesRepo.kitsuUserName;
      final kitsuAvatar = await _preferencesRepo.kitsuAvatar;
      final kitsuSync = await _preferencesRepo.kitsuSync;
      _syncKitsu();
      emit(KitsuAccountConnected(
        kitsuUserId: kitsuUserId ?? "",
        kitsuUserName: kitsuUserName ?? "",
        kitsuAvatar: kitsuAvatar ?? "",
        kitsuSync: kitsuSync ?? false,
        isImporting: false,
      ));
    });

    on<KitsuAccountLogin>((event, emit) async {
      emit(KitsuAccountLoading());
      try {
        final kitsuToken = await _loginKitsu(
            userName: event.userName, password: event.password);
        if (!kitsuToken) {
          emit(KitsuAccountDisconnected());
          return;
        }
        final kitsuUserId = await _fetchAndSaveKitsuUserData();
        final kitsuUserName = await _preferencesRepo.kitsuUserName;
        final kitsuAvatar = await _preferencesRepo.kitsuAvatar;
        final kitsuSync = await _preferencesRepo.kitsuSync;
        _syncKitsu();
        emit(KitsuAccountConnected(
            kitsuUserId: kitsuUserId,
            kitsuUserName: kitsuUserName ?? "",
            kitsuAvatar: kitsuAvatar ?? "",
            kitsuSync: kitsuSync ?? false,
            isImporting: false));
      } catch (e) {
        emit(KitsuAccountDisconnected());
        return;
      }
    });

    on<KitsuAccountLogout>((event, emit) async {
      emit(KitsuAccountLoading());
      await _preferencesRepo.deleteKitsuToken();
      emit(KitsuAccountDisconnected());
    });

    on<KitsuLibraryImported>((event, emit) async {
      final data = state as KitsuAccountConnected;
      emit(data.copyWith(isImporting: true));
      final kitsuUserId = await _preferencesRepo.kitsuUserId;
      if (kitsuUserId == null) return;
      await _importKitsuLibrary(kitsuUserId);
      emit(data.copyWith(isImporting: false));
    });

    on<KitsuSyncToggled>((event, emit) async {
      _preferencesRepo.setKitsuSync(event.newSync);
      final data = state as KitsuAccountConnected;
      emit(data.copyWith(kitsuSync: event.newSync));
    });
  }

  final AccountsRepo _accountsRepo;
  final PreferencesRepo _preferencesRepo;
  final MediaLibraryRepo _mediaLibraryRepo;

  Future<bool> _initializeKitsuAccount() async {
    final accessToken = await _preferencesRepo.kitsuAccessToken;
    if (accessToken == null) return false;

    final expiresIn = await _preferencesRepo.kitsuExpiresIn;
    if (DateTime.now().difference(DateTime.parse(expiresIn!)).inDays > 0) {
      // TODO - Implement refresh token
      return false;
    }
    return true;
  }

  Future<bool> _loginKitsu(
      {required String userName, required String password}) async {
    final tokenMap =
        await _accountsRepo.kitsuLogin(userName: userName, password: password);
    await _preferencesRepo.saveKitsuToken(tokenMap);
    final accessToken = await _preferencesRepo.kitsuAccessToken;
    if (accessToken == null || accessToken.isEmpty) {
      return false;
    }
    return true;
  }

  void _syncKitsu() async {
    _mediaLibraryRepo.getLibraryUpdates(kitsu: false).listen((updates) async {
      if (!(state as KitsuAccountConnected).kitsuSync) return;

      await Future.wait(
        updates.map(
          (e) async {
            final entry = await _mediaLibraryRepo.getLibraryItem(
                mediaEntryId: e.mediaEntryId);
            switch (e.updateType) {
              case LibraryUpdateType.create:
                return _mediaLibraryRepo.createKitsuEntry(entry.mediaEntry,
                    mediaId: entry.media.kitsuMediaId);
              case LibraryUpdateType.update:
                return _mediaLibraryRepo.updateKitsuEntry(
                  entry.mediaEntry,
                );
              case LibraryUpdateType.delete:
                await _mediaLibraryRepo.deleteKitsuEntry(
                    mediaEntryId: e.kitsuEntryId);
                return;
            }
          },
        ),
      );

      await Future.wait(updates.map((e) {
        final ue = e.copyWith(kitsu: true);
        return _mediaLibraryRepo.updateLibraryUpdate(ue);
      },),);
    });
  }

  // void _syncCreated() async {
  // _mediaLibraryRepo
  //     .getLibraryUpdates(type: LibraryUpdateType.create, kitsu: false)
  //     .listen(
  //   (entries) async {
  //     if (!(state as KitsuAccountConnected).kitsuSync) return;
  //     final libItems = await Future.wait(
  //       entries.map((e) =>
  //           _mediaLibraryRepo.getLibraryItem(mediaEntryId: e.mediaEntryId)),
  //     );

  //     await Future.wait(
  //       libItems.map(
  //         (e) => _mediaLibraryRepo.saveKitsuEntry(
  //           e.mediaEntry,
  //           mediaId: e.media.alMediaId,
  //         ),
  //       ),
  //     );

  //   await Future.wait(entries.map((e) {
  //     final ue = e.copyWith(kitsu: true);
  //     return _mediaLibraryRepo.updateLibraryUpdate(ue);
  //   }));
  // },
  // );
  // }

  // void _syncUpdated() async {
  // _mediaLibraryRepo
  //     .getLibraryUpdates(type: LibraryUpdateType.update, kitsu: false)
  //     .listen(
  //   (entries) async {
  //     if (!(state as KitsuAccountConnected).kitsuSync) return;
  //     final libItems = await Future.wait(
  //       entries.map((e) =>
  //           _mediaLibraryRepo.getLibraryItem(mediaEntryId: e.mediaEntryId)),
  //     );

  //     await Future.wait(
  //       libItems.map(
  //         (e) => _mediaLibraryRepo.saveKitsuEntry(
  //           e.mediaEntry,
  //           mediaId: e.media.alMediaId,
  //         ),
  //       ),
  //     );

  //     await Future.wait(entries.map((e) {
  //       final ue = e.copyWith(kitsu: true);
  //       return _mediaLibraryRepo.updateLibraryUpdate(ue);
  //     }));
  //   },
  // );
  // }

  // void _syncDeleted() async {
  // _mediaLibraryRepo
  //     .getLibraryUpdates(type: LibraryUpdateType.delete, kitsu: false)
  //     .listen(
  //   (entries) async {
  //     if (!(state as KitsuAccountConnected).kitsuSync) return;
  //     await Future.wait(
  //       entries.map(
  //         (e) async {
  //           final res = await _mediaLibraryRepo.deleteKitsuEntry(
  //               mediaId: e.alEntryId);
  //           if (res) {
  //             final ue = e.copyWith(kitsu: true);
  //             return _mediaLibraryRepo.updateLibraryUpdate(ue);
  //           }
  //           return;
  //         },
  //       ),
  //     );
  //   },
  // );
  // }

  Future<String> _fetchAndSaveKitsuUserData() async {
    final res = await _accountsRepo.fetchKitsuUserData();
    final userId = res['userId'].toString();
    final userName = res['userName'].toString();
    final avatar = res['avatar'].toString();
    await _preferencesRepo.saveKitsuUserData(
        userId: userId, userName: userName, avatar: avatar);
    return userId;
  }

  Future<void> _importKitsuLibrary(String userId) async {
    final jsonList = await _mediaLibraryRepo.getUserKitsuLibrary(userId);
    var mediaList = <MediaModel>[];
    var mediaEntryList = <MediaEntry>[];

    for (var e in jsonList) {
      final media = MediaModel.fromKitsuJson(e['media']);
      final mediaEntry = MediaEntry.fromKitsuJson(e, media.id);
      mediaList.add(media);
      mediaEntryList.add(mediaEntry);
    }

    await _mediaLibraryRepo.deleteLibrary();
    await _mediaLibraryRepo.insertAllMedia(mediaList);
    await _mediaLibraryRepo.insertAllMediaEntries(mediaEntryList);
  }
}
