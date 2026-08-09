class OrderStatsResponse {
  bool? error;
  String? message;
  OrderStats? orderStats;

  OrderStatsResponse({
    this.error,
    this.message,
    this.orderStats,
  });

  factory OrderStatsResponse.fromJson(Map<String, dynamic> json) => OrderStatsResponse(
    error: json["error"],
    message: json["message"],
    orderStats: json["OrderStats"] != null ? OrderStats.fromJson(json["OrderStats"]) : null,
  );
}

class OrderStats {
  final int completed;
  final int cancelled;
  final int processing;
  final int driverAssigned;

  OrderStats({
    required this.completed,
    required this.cancelled,
    required this.processing,
    required this.driverAssigned,
  });

  factory OrderStats.fromJson(Map<String, dynamic> json) => OrderStats(
    completed: json['completed'] ?? 0,
    cancelled: json['cancelled'] ?? 0,
    processing: json['processing'] ?? 0,
    driverAssigned: json['driver_assigned'] ?? 0,
  );

  int get total => completed + cancelled + processing + driverAssigned;
}
