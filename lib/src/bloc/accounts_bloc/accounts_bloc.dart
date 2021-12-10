import 'package:anitrak/src/repositories/accounts_repo.dart';
import 'package:bloc/bloc.dart';

part 'accounts_event.dart';
part 'accounts_state.dart';

class AccountsBloc extends Bloc<AccountsEvent, AccountsState> {
  AccountsBloc(this._accountsRepo) : super(const AccountsState()) {
    on<AccountsInitializedEvent>((event, emit) async {
      final anilistToken = await _initializeAlilistAccount();
      emit(AccountsState(anilistAuth: anilistToken ?? ""));
    });

    on<AnilistLoginEvent>((event, emit) async {
      final anilistToken = await _loginAnilist();
      emit(AccountsState(anilistAuth: anilistToken!));
    });

    on<AnilistLogoutEvent>((event, emit) async {
      await _accountsRepo.deleteAnilistToken();
      emit(const AccountsState(anilistAuth: ""));
    });
  }

  final AccountsRepo _accountsRepo;

  Future<String?> _initializeAlilistAccount() async {
    final accessToken = await _accountsRepo.anilistAccessToken;
    if(accessToken == null){
      return null;
    }
    final expiresIn = await _accountsRepo.anilistExpiresIn;
    if(DateTime.now().difference(DateTime.parse(expiresIn!)).inDays > 0){
      // TODO - Implement refresh token
      return null;
    }
    return accessToken;
  }

  Future<String?> _loginAnilist() async{
    final tokenMap = await _accountsRepo.anilistLogin();
    await _accountsRepo.saveAnilistToken(tokenMap);
    final accessToken = await _accountsRepo.anilistAccessToken;
    return accessToken;
  }

}
