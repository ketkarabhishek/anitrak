part of 'accounts_bloc.dart';

class AccountsState {
  const AccountsState({
    this.anilistUserId = '',
    this.anilistUserName = '',
    this.anilistAvatar = ''
  });
  final String anilistUserId;
  final String anilistUserName;
  final String anilistAvatar;

  bool get anilistAuth {
    return anilistUserId.isNotEmpty;
  }
}
