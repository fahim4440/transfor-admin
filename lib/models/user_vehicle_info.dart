class UserVehicleInfoResponse {
  bool? error;
  String? message;
  List<UserVehicleInfo>? userVehicleInfos;

  UserVehicleInfoResponse({
    this.error,
    this.message,
    this.userVehicleInfos,
  });

  factory UserVehicleInfoResponse.fromJson(Map<String, dynamic> json) => UserVehicleInfoResponse(
    error: json["error"],
    message: json["message"],
    userVehicleInfos: json["VehicalData"] == null ? [] : List<UserVehicleInfo>.from(json["VehicalData"]!.map((x) => UserVehicleInfo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "VehicalData": userVehicleInfos == null ? [] : List<dynamic>.from(userVehicleInfos!.map((x) => x.toJson())),
  };
}



class UserVehicleInfo {
  final String id;
  final String userId;
  final String vsSmall;
  final String vsMedium;
  final String vsBig;
  final String truckCerty;
  final String transportData;
  final String vImage;
  final String lFront;
  final String lBack;
  final DateTime createdAt;

  UserVehicleInfo({
    required this.id,
    required this.userId,
    required this.vsSmall,
    required this.vsMedium,
    required this.vsBig,
    required this.truckCerty,
    required this.transportData,
    required this.vImage,
    required this.lFront,
    required this.lBack,
    required this.createdAt,
  });

  factory UserVehicleInfo.fromJson(Map<String, dynamic> json) {
    return UserVehicleInfo(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      vsSmall: json['vs_small'] as String,
      vsMedium: json['vs_medium'] as String,
      vsBig: json['vs_big'] as String,
      truckCerty: json['truck_certy'] as String,
      transportData: json['transport_data'] as String,
      vImage: json['v_image'] as String,
      lFront: json['l_front'] as String,
      lBack: json['l_back'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'vs_small': vsSmall,
      'vs_medium': vsMedium,
      'vs_big': vsBig,
      'truck_certy': truckCerty,
      'transport_data': transportData,
      'v_image': vImage,
      'l_front': lFront,
      'l_back': lBack,
      'created_at': createdAt.toIso8601String(),
    };
  }
}