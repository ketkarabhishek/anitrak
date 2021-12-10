part of 'accounts_bloc.dart';

class AccountsState {
  const AccountsState({
    this.anilistAuth = "",
  });

  final String anilistAuth;

  bool get isAnilistAuth {
    return anilistAuth.isNotEmpty;
  }

  // @override
  // List<Object?> get props => [];
}
