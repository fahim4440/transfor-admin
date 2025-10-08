class CompanyInfoResponse {
  bool? error;
  String? message;
  List<Company>? companies;

  CompanyInfoResponse({
    this.error,
    this.message,
    this.companies,
  });

  factory CompanyInfoResponse.fromJson(Map<String, dynamic> json) => CompanyInfoResponse(
    error: json["error"],
    message: json["message"],
    companies: json["CompanyData"] == null ? [] : List<Company>.from(json["CompanyData"]!.map((x) => Company.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "CompanyData": companies == null ? [] : List<dynamic>.from(companies!.map((x) => x.toJson())),
  };
}


class Company {
  final String id;
  final String userId;
  final String companyName;
  final String? companyLogo;
  final String companyDesc;
  final DateTime createdAt;

  Company({
    required this.id,
    required this.userId,
    required this.companyName,
    this.companyLogo,
    required this.companyDesc,
    required this.createdAt,
  });

  // Factory constructor to create a Company from JSON
  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      companyName: json['company_name'] as String,
      companyLogo: json['comapny_logo'] as String?,
      companyDesc: json['company_desc'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  // Method to convert Company to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'company_name': companyName,
      'comapny_logo': companyLogo,
      'company_desc': companyDesc,
      'created_at': createdAt.toIso8601String(),
    };
  }
}