part of 'anilist_account_bloc.dart';

abstract class AnilistAccountState {}

class AnilistAccountLoading extends AnilistAccountState {}

class AnilistAccountDisconnected extends AnilistAccountState {}

class AnilistAccountConnected extends AnilistAccountState {
  AnilistAccountConnected({
    required this.anilistUserId,
    required this.anilistUserName,
    required this.anilistAvatar,
    required this.anilistSync,
  });

  final String anilistUserId;
  final String anilistUserName;
  final String anilistAvatar;
  final bool anilistSync;

  AnilistAccountConnected copyWith({bool? anilistSync}){
    return AnilistAccountConnected(
      anilistAvatar: anilistAvatar,
      anilistUserId: anilistUserId,
      anilistUserName: anilistUserName,
      anilistSync: anilistSync ?? this.anilistSync,
    );
  }
}
