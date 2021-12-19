part of 'accounts_bloc.dart';

abstract class AccountsEvent {}

class AccountsInitializedEvent extends AccountsEvent{}

class AnilistLoginEvent extends AccountsEvent{}

class AnilistLogoutEvent extends AccountsEvent{}

class AnilistLibraryImported extends AccountsEvent{}