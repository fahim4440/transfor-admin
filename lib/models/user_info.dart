class UserInfoResponse {
  bool? error;
  String? message;
  List<UserInfo>? userInfos;

  UserInfoResponse({
    this.error,
    this.message,
    this.userInfos,
  });

  factory UserInfoResponse.fromJson(Map<String, dynamic> json) => UserInfoResponse(
    error: json["error"],
    message: json["message"],
    userInfos: json["UserProfile"] == null ? [] : List<UserInfo>.from(json["UserProfile"]!.map((x) => UserInfo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "UserProfile": userInfos == null ? [] : List<dynamic>.from(userInfos!.map((x) => x.toJson())),
  };
}



class UserInfo {
  final String id;
  final String name;
  final String email;
  final String mobile;
  final String ccode;
  final String? profile;
  final String type;
  final String status;
  final String adminConfirmation;
  final String emailVerify;
  final DateTime createdAt;
  final String? serviceProviderId;

  UserInfo({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.ccode,
    this.profile,
    required this.type,
    required this.status,
    required this.adminConfirmation,
    required this.emailVerify,
    required this.createdAt,
    this.serviceProviderId,
  });

  bool get isCompanyDriver => serviceProviderId != null && serviceProviderId!.isNotEmpty;

  // Factory method to create UserModel from JSON
  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      mobile: json['mobile'] as String,
      ccode: json['ccode'] as String,
      profile: json['profile'] as String?,
      type: json['type'] as String,
      status: json['status'] as String,
      adminConfirmation: json['admin_confirmation'] as String,
      emailVerify: json['email_verify'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      serviceProviderId: json['service_provider_id'] as String?,
    );
  }

  // Method to convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
      'ccode': ccode,
      'profile': profile,
      'type': type,
      'status': status,
      'admin_confirmation': adminConfirmation,
      'email_verify': emailVerify,
      'created_at': createdAt.toIso8601String(),
      'service_provider_id': serviceProviderId,
    };
  }
}