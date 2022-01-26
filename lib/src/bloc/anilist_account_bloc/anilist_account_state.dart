part of 'anilist_account_bloc.dart';

class AnilistAccountState {
  const AnilistAccountState({
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
