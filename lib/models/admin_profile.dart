class AdminProfileResponse {
  bool? error;
  String? message;
  List<AdminProfile>? adminProfiles;

  AdminProfileResponse({this.error, this.message, this.adminProfiles});

  factory AdminProfileResponse.fromJson(Map<String, dynamic> json) =>
      AdminProfileResponse(
        error: json["error"],
        message: json["message"],
        adminProfiles:
            json["AdminProfile"] == null
                ? []
                : List<AdminProfile>.from(
                  json["AdminProfile"]!.map((x) => AdminProfile.fromJson(x)),
                ),
      );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "AdminProfile":
        adminProfiles == null
            ? []
            : List<dynamic>.from(adminProfiles!.map((x) => x.toJson())),
  };
}

class AdminProfile {
  final String id;
  final String name;
  final String email;
  final String superadmin;
  final String status;
  final DateTime createdAt;

  AdminProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.superadmin,
    required this.status,
    required this.createdAt,
  });

  // Factory constructor to create a User from JSON
  factory AdminProfile.fromJson(Map<String, dynamic> json) {
    return AdminProfile(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      superadmin: json['superadmin']?.toString() ?? '0',
      status: json['status']?.toString() ?? '0',
      createdAt: DateTime.parse(json['created_at'].toString()),
    );
  }

  // Method to convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'superadmin': superadmin,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
