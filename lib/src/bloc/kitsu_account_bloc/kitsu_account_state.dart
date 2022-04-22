part of 'kitsu_account_bloc.dart';

abstract class KitsuAccountState {}

class KitsuAccountLoading extends KitsuAccountState {}

class KitsuAccountDisconnected extends KitsuAccountState {}

class KitsuAccountConnected extends KitsuAccountState {
  KitsuAccountConnected({
    required this.kitsuUserId,
    required this.kitsuUserName,
    required this.kitsuAvatar,
    required this.kitsuSync,
    required this.isImporting,
  });

  final String kitsuUserId;
  final String kitsuUserName;
  final String kitsuAvatar;
  final bool kitsuSync;
  final bool isImporting;

  KitsuAccountConnected copyWith({bool? kitsuSync, bool? isImporting}){
    return KitsuAccountConnected(
      kitsuAvatar: kitsuAvatar,
      kitsuUserId: kitsuUserId,
      kitsuUserName: kitsuUserName,
      kitsuSync: kitsuSync ?? this.kitsuSync,
      isImporting: isImporting ?? this.isImporting,
    );
  }
}
