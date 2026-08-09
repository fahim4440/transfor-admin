class RevenueStatsResponse {
  bool? error;
  String? message;
  RevenueStats? revenueStats;

  RevenueStatsResponse({
    this.error,
    this.message,
    this.revenueStats,
  });

  factory RevenueStatsResponse.fromJson(Map<String, dynamic> json) => RevenueStatsResponse(
    error: json["error"],
    message: json["message"],
    revenueStats: json["RevenueStats"] != null ? RevenueStats.fromJson(json["RevenueStats"]) : null,
  );
}

class RevenueStats {
  final double totalRevenue;
  final double monthRevenue;
  final double weekRevenue;

  RevenueStats({
    required this.totalRevenue,
    required this.monthRevenue,
    required this.weekRevenue,
  });

  factory RevenueStats.fromJson(Map<String, dynamic> json) => RevenueStats(
    totalRevenue: (json['total_revenue'] ?? 0).toDouble(),
    monthRevenue: (json['month_revenue'] ?? 0).toDouble(),
    weekRevenue: (json['week_revenue'] ?? 0).toDouble(),
  );
}
