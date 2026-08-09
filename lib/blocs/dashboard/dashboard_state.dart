part of 'dashboard_bloc.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();
}

final class DashboardInitial extends DashboardState {
  @override
  List<Object> get props => [];
}

final class DashboardLoading extends DashboardState {
  @override
  List<Object?> get props => [];
}

final class DashboardLoaded extends DashboardState {
  final DashboardSummary? dashboardSummary;
  final DashboardGrowth? dashboardGrowth;
  final RevenueStats? revenueStats;
  final List<RevenuePoint>? revenueData;
  final List<UserGrowthPoint>? userGrowthData;
  final List<RecentOrder>? recentOrders;
  final OrderStats? orderStats;

  const DashboardLoaded({
    this.dashboardSummary,
    this.dashboardGrowth,
    this.revenueStats,
    this.revenueData,
    this.userGrowthData,
    this.recentOrders,
    this.orderStats,
  });

  @override
  List<Object?> get props => [dashboardSummary, dashboardGrowth, revenueStats, revenueData, userGrowthData, recentOrders, orderStats];
}

final class DashboardFailure extends DashboardState {
  final String errorMessage;
  const DashboardFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
