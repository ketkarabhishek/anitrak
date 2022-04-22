part of 'kitsu_account_bloc.dart';

abstract class KitsuAccountEvent {}

class KitsuAccountInitialized extends KitsuAccountEvent {}

class KitsuAccountLogin extends KitsuAccountEvent {
  final String userName;
  final String password;

  KitsuAccountLogin({required this.userName, required this.password});
}

class KitsuAccountLogout extends KitsuAccountEvent {}

class KitsuLibraryImported extends KitsuAccountEvent {}

class KitsuSyncToggled extends KitsuAccountEvent {
  final bool newSync;

  KitsuSyncToggled(this.newSync);
}
