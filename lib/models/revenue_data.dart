class RevenueDataResponse {
  bool? error;
  String? message;
  List<RevenuePoint>? revenueData;

  RevenueDataResponse({
    this.error,
    this.message,
    this.revenueData,
  });

  factory RevenueDataResponse.fromJson(Map<String, dynamic> json) => RevenueDataResponse(
    error: json["error"],
    message: json["message"],
    revenueData: json["RevenueData"] == null
        ? []
        : List<RevenuePoint>.from(json["RevenueData"]!.map((x) => RevenuePoint.fromJson(x))),
  );
}

class RevenuePoint {
  final String date;
  final String label;
  final double revenue;

  RevenuePoint({
    required this.date,
    required this.label,
    required this.revenue,
  });

  factory RevenuePoint.fromJson(Map<String, dynamic> json) => RevenuePoint(
    date: json['date'] ?? '',
    label: json['label'] ?? '',
    revenue: (json['revenue'] ?? 0).toDouble(),
  );
}
