class DashboardGrowthResponse {
  bool? error;
  String? message;
  DashboardGrowth? dashboardGrowth;

  DashboardGrowthResponse({
    this.error,
    this.message,
    this.dashboardGrowth,
  });

  factory DashboardGrowthResponse.fromJson(Map<String, dynamic> json) => DashboardGrowthResponse(
    error: json["error"],
    message: json["message"],
    dashboardGrowth: json["DashboardGrowth"] != null ? DashboardGrowth.fromJson(json["DashboardGrowth"]) : null,
  );
}

class DashboardGrowth {
  final double usersGrowth;
  final double activeOrdersGrowth;
  final double revenueGrowth;
  final double allOrdersGrowth;

  DashboardGrowth({
    required this.usersGrowth,
    required this.activeOrdersGrowth,
    required this.revenueGrowth,
    required this.allOrdersGrowth,
  });

  factory DashboardGrowth.fromJson(Map<String, dynamic> json) => DashboardGrowth(
    usersGrowth: (json['users_growth'] ?? 0).toDouble(),
    activeOrdersGrowth: (json['active_orders_growth'] ?? 0).toDouble(),
    revenueGrowth: (json['revenue_growth'] ?? 0).toDouble(),
    allOrdersGrowth: (json['all_orders_growth'] ?? 0).toDouble(),
  );
}
