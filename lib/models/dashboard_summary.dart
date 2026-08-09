class DashboardSummaryResponse {
  bool? error;
  String? message;
  DashboardSummary? dashboardSummary;

  DashboardSummaryResponse({
    this.error,
    this.message,
    this.dashboardSummary,
  });

  factory DashboardSummaryResponse.fromJson(Map<String, dynamic> json) => DashboardSummaryResponse(
    error: json["error"],
    message: json["message"],
    dashboardSummary: json["DashboardSummary"] != null ? DashboardSummary.fromJson(json["DashboardSummary"]) : null,
  );
}

class DashboardSummary {
  final int totalUsers;
  final int activeOrders;
  final int allOrders;

  DashboardSummary({
    required this.totalUsers,
    required this.activeOrders,
    required this.allOrders,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) => DashboardSummary(
    totalUsers: json['total_users'] ?? 0,
    activeOrders: json['active_orders'] ?? 0,
    allOrders: json['all_orders'] ?? 0,
  );
}
