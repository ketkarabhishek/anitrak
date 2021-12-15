import 'package:anitrak/src/repositories/accounts_repo.dart';
import 'package:bloc/bloc.dart';

part 'accounts_event.dart';
part 'accounts_state.dart';

class AccountsBloc extends Bloc<AccountsEvent, AccountsState> {
  AccountsBloc(this._accountsRepo) : super(const AccountsState()) {
    on<AccountsInitializedEvent>((event, emit) async {
      final anilistToken = await _initializeAnilistAccount();
      final state = AccountsState(anilistAuth: anilistToken);
      emit(state);
    });

    on<AnilistLoginEvent>((event, emit) async {
      final anilistToken = await _loginAnilist();
      emit(AccountsState(anilistAuth: anilistToken?.isNotEmpty ?? false));
    });

    on<AnilistLogoutEvent>((event, emit) async {
      await _accountsRepo.deleteAnilistToken();
      emit(const AccountsState());
    });
  }

  final AccountsRepo _accountsRepo;

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

}
