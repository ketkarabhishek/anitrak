part of 'dashboard_bloc.dart';

abstract class DashboardState{}

class DashboardInitial extends DashboardState {}

class DashboardData extends DashboardState{
  DashboardData(this.recentsStream);

  final Stream<List<MediaEntry>> recentsStream;
}