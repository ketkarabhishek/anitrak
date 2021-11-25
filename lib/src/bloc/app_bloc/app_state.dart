part of 'app_bloc.dart';

class AppState extends Equatable {
  const AppState({
    this.importingAnilist = false,
  });

  final bool importingAnilist;

  AppState copyWith({
    bool? importingAnilist,
  }){
    return AppState(
      importingAnilist: importingAnilist ?? this.importingAnilist, 
    );
  }
  @override
  List<Object> get props => [];
}