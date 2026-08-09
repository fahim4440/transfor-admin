class UserProfileResponse {
  bool? error;
  String? message;
  List<UserProfile>? userProfiles;

  UserProfileResponse({
    this.error,
    this.message,
    this.userProfiles,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) => UserProfileResponse(
    error: json["error"],
    message: json["message"],
    userProfiles: json["AllUsers"] == null ? [] : List<UserProfile>.from(json["AllUsers"]!.map((x) => UserProfile.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "AllUsers": userProfiles == null ? [] : List<dynamic>.from(userProfiles!.map((x) => x.toJson())),
  };
}



class UserProfile {
  final String id;
  final String name;
  final String email;
  final String mobile;
  final String ccode;
  final String? profile;
  final String type;
  final DateTime createdAt;
  final String? serviceProviderId;
  final String? providerType;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.ccode,
    required this.profile,
    required this.type,
    required this.createdAt,
    this.serviceProviderId,
    this.providerType,
  });

  bool get isCompanyDriver => serviceProviderId != null && serviceProviderId!.isNotEmpty;

  String get providerTypeLabel {
    switch (providerType?.toLowerCase()) {
      case 'product':
        return 'Product Provider';
      case 'delivery':
        return 'Delivery Provider';
      default:
        return 'Both';
    }
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      mobile: json['mobile'] as String,
      ccode: json['ccode'] as String,
      profile: json['profile'],
      type: json['type'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      serviceProviderId: json['service_provider_id'] as String?,
      providerType: json['provider_type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
      'ccode': ccode,
      'profile': profile,
      'type': type,
      'created_at': createdAt.toIso8601String(),
      'service_provider_id': serviceProviderId,
      'provider_type': providerType,
    };
  }
}