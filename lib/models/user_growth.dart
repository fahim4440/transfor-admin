class UserGrowthResponse {
  bool? error;
  String? message;
  List<UserGrowthPoint>? userGrowthData;

  UserGrowthResponse({
    this.error,
    this.message,
    this.userGrowthData,
  });

  factory UserGrowthResponse.fromJson(Map<String, dynamic> json) => UserGrowthResponse(
    error: json["error"],
    message: json["message"],
    userGrowthData: json["UserGrowthData"] == null
        ? []
        : List<UserGrowthPoint>.from(json["UserGrowthData"]!.map((x) => UserGrowthPoint.fromJson(x))),
  );
}

class UserGrowthPoint {
  final String date;
  final String label;
  final int users;

  UserGrowthPoint({
    required this.date,
    required this.label,
    required this.users,
  });

  factory UserGrowthPoint.fromJson(Map<String, dynamic> json) => UserGrowthPoint(
    date: json['date'] ?? '',
    label: json['label'] ?? '',
    users: json['users'] ?? 0,
  );
}
