part of 'anilist_account_bloc.dart';

abstract class AnilistAccountState {}

class AnilistAccountLoading extends AnilistAccountState {}

class AnilistAccountDisconnected extends AnilistAccountState {}

class AnilistAccountConnected extends AnilistAccountState {
  AnilistAccountConnected({
    required this.anilistUserId,
    required this.anilistUserName,
    required this.anilistAvatar,
  });

  final String anilistUserId;
  final String anilistUserName;
  final String anilistAvatar;

  bool get anilistAuth {
    return anilistUserId.isNotEmpty;
  }
}
