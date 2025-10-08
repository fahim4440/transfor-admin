class ApiResponse {
  bool error;
  String message;

  ApiResponse({
    required this.error,
    required this.message,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
    error: json["error"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
  };
}