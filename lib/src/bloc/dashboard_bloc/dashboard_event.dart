part of 'dashboard_bloc.dart';

abstract class DashboardEvent{}

class DashboardInitialized extends DashboardEvent{}

class RecentsUpdated extends DashboardEvent{
  final MediaEntry updatedMediaEntry;

  RecentsUpdated(this.updatedMediaEntry);
}

class DashboardStateUpdated extends DashboardEvent{
  final DashboardState dashboardState;

  DashboardStateUpdated(this.dashboardState);
}