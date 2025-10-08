class SettingsResponse {
  bool? error;
  String? message;
  List<Setting>? settings;

  SettingsResponse({this.error, this.message, this.settings});

  factory SettingsResponse.fromJson(Map<String, dynamic> json) =>
      SettingsResponse(
        error: json["error"],
        message: json["message"],
        settings:
            json["Setting"] == null
                ? []
                : List<Setting>.from(
                  json["Setting"]!.map((x) => Setting.fromJson(x)),
                ),
      );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "Setting":
        settings == null
            ? []
            : List<dynamic>.from(settings!.map((x) => x.toJson())),
  };
}


class Setting {
  final String id;
  final String deliveryCharge;
  final String tax;

  Setting({
    required this.id,
    required this.deliveryCharge,
    required this.tax,
  });

  factory Setting.fromJson(Map<String, dynamic> json) {
    return Setting(
      id: json['id'] as String,
      deliveryCharge: json['d_cahrge'] as String,
      tax: json['tax_charge'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'd_cahrge': deliveryCharge,
      'tax_charge': tax,
    };
  }
}