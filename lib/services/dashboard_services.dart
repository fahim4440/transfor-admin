import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:transfor_admin_dashboard/models/dashboard_summary.dart';
import 'package:transfor_admin_dashboard/models/dashboard_growth.dart';
import 'package:transfor_admin_dashboard/models/revenue_stats.dart';
import 'package:transfor_admin_dashboard/models/revenue_data.dart';
import 'package:transfor_admin_dashboard/models/recent_order.dart';
import 'package:transfor_admin_dashboard/models/order_stats.dart';
import 'package:transfor_admin_dashboard/models/user_growth.dart';
import 'package:transfor_admin_dashboard/models/financial_rankings.dart';

class DashboardServices {
  final String _baseURL = 'http://128.199.42.59/api/Api.php';

  Future<AdminFinancialRankings> fetchFinancialRankings({
    required String period,
    required DateTime date,
  }) async {
    const secureStorage = FlutterSecureStorage();
    final token = await secureStorage.read(key: 'admin_auth_token');
    if (token == null || token.isEmpty) {
      throw Exception('Admin session expired. Please sign in again.');
    }

    final response = await http.post(
      Uri.parse('$_baseURL?apicall=FetchAdminFinancialRankings'),
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'period': period,
        'date':
            '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      },
    );
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200 || decoded['error'] == true) {
      throw Exception(
        decoded['message']?.toString() ?? 'Could not load financial rankings',
      );
    }
    final rankings = decoded['FinancialRankings'];
    if (rankings is! Map<String, dynamic>) {
      throw const FormatException('Invalid financial rankings response');
    }
    return AdminFinancialRankings.fromJson(rankings);
  }

  Future<RevenueStats?> fetchRevenueStats() async {
    final response = await http.post(
      Uri.parse('$_baseURL?apicall=FetchRevenueStats'),
    );

    final RevenueStatsResponse statsResponse = RevenueStatsResponse.fromJson(
      jsonDecode(response.body),
    );

    if (statsResponse.error == false && statsResponse.revenueStats != null) {
      return statsResponse.revenueStats;
    } else {
      return null;
    }
  }

  Future<List<RevenuePoint>?> fetchRevenueData() async {
    final response = await http.post(
      Uri.parse('$_baseURL?apicall=FetchRevenueData'),
    );

    final RevenueDataResponse dataResponse = RevenueDataResponse.fromJson(
      jsonDecode(response.body),
    );

    if (dataResponse.error == false && dataResponse.revenueData != null) {
      return dataResponse.revenueData;
    } else {
      return null;
    }
  }

  Future<List<RecentOrder>?> fetchRecentOrders({int limit = 10}) async {
    final response = await http.post(
      Uri.parse('$_baseURL?apicall=FetchRecentOrders'),
      body: {'limit': limit.toString()},
    );

    final RecentOrdersResponse ordersResponse = RecentOrdersResponse.fromJson(
      jsonDecode(response.body),
    );

    if (ordersResponse.error == false && ordersResponse.recentOrders != null) {
      return ordersResponse.recentOrders;
    } else {
      return null;
    }
  }

  Future<OrderStats?> fetchOrderStats() async {
    final response = await http.post(
      Uri.parse('$_baseURL?apicall=FetchOrderStats'),
    );

    final OrderStatsResponse statsResponse = OrderStatsResponse.fromJson(
      jsonDecode(response.body),
    );

    if (statsResponse.error == false && statsResponse.orderStats != null) {
      return statsResponse.orderStats;
    } else {
      return null;
    }
  }

  Future<List<UserGrowthPoint>?> fetchUserGrowthData() async {
    final response = await http.post(
      Uri.parse('$_baseURL?apicall=FetchUserGrowthData'),
    );

    final UserGrowthResponse growthResponse = UserGrowthResponse.fromJson(
      jsonDecode(response.body),
    );

    if (growthResponse.error == false &&
        growthResponse.userGrowthData != null) {
      return growthResponse.userGrowthData;
    } else {
      return null;
    }
  }

  Future<DashboardSummary?> fetchDashboardSummary() async {
    final response = await http.post(
      Uri.parse('$_baseURL?apicall=FetchDashboardSummary'),
    );

    final DashboardSummaryResponse summaryResponse =
        DashboardSummaryResponse.fromJson(jsonDecode(response.body));

    if (summaryResponse.error == false &&
        summaryResponse.dashboardSummary != null) {
      return summaryResponse.dashboardSummary;
    } else {
      return null;
    }
  }

  Future<DashboardGrowth?> fetchDashboardGrowth() async {
    final response = await http.post(
      Uri.parse('$_baseURL?apicall=FetchDashboardGrowth'),
    );

    final DashboardGrowthResponse growthResponse =
        DashboardGrowthResponse.fromJson(jsonDecode(response.body));

    if (growthResponse.error == false &&
        growthResponse.dashboardGrowth != null) {
      return growthResponse.dashboardGrowth;
    } else {
      return null;
    }
  }
}
