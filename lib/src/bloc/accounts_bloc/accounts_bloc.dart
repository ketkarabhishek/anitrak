import 'package:anitrak/src/repositories/accounts_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'accounts_event.dart';
part 'accounts_state.dart';

class AccountsBloc extends Bloc<AccountsEvent, AccountsState> {
  AccountsBloc(this.accountsRepo) : super(const AccountsState()) {
    on<AccountsInitializedEvent>((event, emit) async {
      final anilistToken = await _initializeAlilistAccount();
      emit(AccountsState(anilistAuth: anilistToken));
    });
  }

  final AccountsRepo accountsRepo;

  Future<String?> _initializeAlilistAccount() async {
    final accessToken = await accountsRepo.anilistAccessToken;
    if(accessToken == null){
      return null;
    }
    final expiresIn = await accountsRepo.anilistExpiresIn;
    if(DateTime.now().difference(DateTime.parse(expiresIn!)).inDays > 0){
      // TODO - Implement refresh token
      return null;
    }
    return accessToken;
  }
}
