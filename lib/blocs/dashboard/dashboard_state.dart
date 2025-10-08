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
  final AllCount allCount;
  const DashboardLoaded({required this.allCount});

  @override
  List<Object?> get props => [allCount];
}

final class DashboardFailure extends DashboardState {
  final String errorMessage;
  const DashboardFailure({required this.errorMessage});
  
  @override
  List<Object?> get props => [errorMessage];
}
