class DriverRatingSummaryResponse {
  bool? error;
  String? message;
  DriverRatingSummary? ratingSummary;

  DriverRatingSummaryResponse({
    this.error,
    this.message,
    this.ratingSummary,
  });

  factory DriverRatingSummaryResponse.fromJson(Map<String, dynamic> json) => DriverRatingSummaryResponse(
    error: json["error"],
    message: json["message"],
    ratingSummary: json["rating_summary"] != null ? DriverRatingSummary.fromJson(json["rating_summary"]) : null,
  );
}

class DriverRatingSummary {
  final double avgRating;
  final int totalReviews;

  DriverRatingSummary({
    required this.avgRating,
    required this.totalReviews,
  });

  factory DriverRatingSummary.fromJson(Map<String, dynamic> json) => DriverRatingSummary(
    avgRating: (json['avg_rating'] ?? 0).toDouble(),
    totalReviews: json['total_reviews'] ?? 0,
  );
}
