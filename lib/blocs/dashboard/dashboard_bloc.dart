import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:transfor_admin_dashboard/models/dashboard_summary.dart';
import 'package:transfor_admin_dashboard/models/dashboard_growth.dart';
import 'package:transfor_admin_dashboard/models/revenue_stats.dart';
import 'package:transfor_admin_dashboard/models/revenue_data.dart';
import 'package:transfor_admin_dashboard/models/recent_order.dart';
import 'package:transfor_admin_dashboard/models/order_stats.dart';
import 'package:transfor_admin_dashboard/models/user_growth.dart';
import 'package:transfor_admin_dashboard/services/dashboard_services.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardServices dashboardServices = DashboardServices();
  DashboardBloc() : super(DashboardInitial()) {
    on<DashboardInitiate>((event, emit) async {
      emit(DashboardLoading());
      try {
        // Fetch data separately to avoid type casting issues
        final dashboardSummary = await dashboardServices.fetchDashboardSummary();
        final dashboardGrowth = await dashboardServices.fetchDashboardGrowth();
        final revenueStats = await dashboardServices.fetchRevenueStats();
        final revenueData = await dashboardServices.fetchRevenueData();
        final userGrowthData = await dashboardServices.fetchUserGrowthData();
        final recentOrders = await dashboardServices.fetchRecentOrders(limit: 5);
        final orderStats = await dashboardServices.fetchOrderStats();

        if (dashboardSummary != null) {
          emit(DashboardLoaded(
            dashboardSummary: dashboardSummary,
            dashboardGrowth: dashboardGrowth,
            revenueStats: revenueStats,
            revenueData: revenueData,
            userGrowthData: userGrowthData,
            recentOrders: recentOrders,
            orderStats: orderStats,
          ));
        } else {
          emit(DashboardFailure(errorMessage: 'Failed to load dashboard data'));
        }
      } catch (e) {
        print('Error fetching dashboard data: $e');
        emit(DashboardFailure(errorMessage: 'Something went wrong: $e'));
      }
    });
  }
}
