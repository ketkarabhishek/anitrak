part of 'dashboard_bloc.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardData extends DashboardState {
  DashboardData(
    this.recentsList,
    this.totalEntries,
    this.currentCount,
    this.completedCount,
    this.plannedCount,
    this.onHoldCount,
    this.droppedCount,
    this.totalEpisodes,
    this.totalTime,
  );

  final List<LibraryItem> recentsList;
  final int totalEntries;
  final int currentCount;
  final int completedCount;
  final int plannedCount;
  final int onHoldCount;
  final int droppedCount;

  final int totalEpisodes;
  final int totalTime;
}
