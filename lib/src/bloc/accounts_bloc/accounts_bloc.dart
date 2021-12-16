import 'dart:async';

import 'package:anitrak/src/models/media_entry.dart';
import 'package:anitrak/src/repositories/accounts_repo.dart';
import 'package:anitrak/src/repositories/media_entries_repo.dart';
import 'package:bloc/bloc.dart';

part 'accounts_event.dart';
part 'accounts_state.dart';

class AccountsBloc extends Bloc<AccountsEvent, AccountsState> {
  AccountsBloc(this._accountsRepo, this._mediaEntriesRepo) : super(const AccountsState()) {
    on<AccountsInitializedEvent>((event, emit) async {
      final anilistToken = await _initializeAnilistAccount();
      final state = AccountsState(anilistAuth: anilistToken);
      _unsyncedStream = _mediaEntriesRepo.getUnsyncedMediaEntries();
      if(anilistToken){
        _syncAnilist();
      }
      emit(state);
    });

    on<AnilistLoginEvent>((event, emit) async {
      final anilistToken = await _loginAnilist();
      if(anilistToken != null && anilistToken.isNotEmpty){
        _syncAnilist();
      }
      emit(AccountsState(anilistAuth: anilistToken?.isNotEmpty ?? false));
    });

    on<AnilistLogoutEvent>((event, emit) async {
      await _accountsRepo.deleteAnilistToken();
      _unsyncedStreamSub.cancel();
      emit(const AccountsState());
    });
  }

  final AccountsRepo _accountsRepo;
  final MediaEntriesRepo _mediaEntriesRepo;

  late StreamSubscription<List<MediaEntry>> _unsyncedStreamSub;
  late Stream<List<MediaEntry>> _unsyncedStream;

  Future<bool> _initializeAnilistAccount() async {
    final accessToken = await _accountsRepo.anilistAccessToken;
    if(accessToken == null){
      return false;
    }
    final expiresIn = await _accountsRepo.anilistExpiresIn;
    if(DateTime.now().difference(DateTime.parse(expiresIn!)).inDays > 0){
      // TODO - Implement refresh token
      return false;
    }
    return true;
  }

  Future<String?> _loginAnilist() async{
    final tokenMap = await _accountsRepo.anilistLogin();
    await _accountsRepo.saveAnilistToken(tokenMap);
    final accessToken = await _accountsRepo.anilistAccessToken;
    return accessToken;
  }

  Future<void> _syncAnilist() async {
    _unsyncedStreamSub = _unsyncedStream.listen((entries) async {
      await Future.wait(entries.map((e) => _mediaEntriesRepo.updateAnilistEntry(e)));
    });

  }

}
