part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ImportAnilistAppEvent extends AppEvent{}
class InitialAppEvent extends AppEvent{
  InitialAppEvent(this.mediaEntryDao);
  final MediaEntryDao mediaEntryDao;
}