part of 'anilist_account_bloc.dart';

abstract class AnilistAccountEvent {}

class AnilistAccountInitialized extends AnilistAccountEvent {}

class AnilistAccountLogin extends AnilistAccountEvent {}

class AnilistAccountLogout extends AnilistAccountEvent {}

class AnilistLibraryImported extends AnilistAccountEvent {}

class AnilistSyncToggled extends AnilistAccountEvent {
  final bool newSync;

  AnilistSyncToggled(this.newSync);
}
