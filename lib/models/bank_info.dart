class BankInfoResponse {
  bool? error;
  String? message;
  List<BankInfo>? bankInfos;

  BankInfoResponse({
    this.error,
    this.message,
    this.bankInfos,
  });

  factory BankInfoResponse.fromJson(Map<String, dynamic> json) => BankInfoResponse(
    error: json["error"],
    message: json["message"],
    bankInfos: json["BankDetails"] == null ? [] : List<BankInfo>.from(json["BankDetails"]!.map((x) => BankInfo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "BankDetails": bankInfos == null ? [] : List<dynamic>.from(bankInfos!.map((x) => x.toJson())),
  };
}



class BankInfo {
  final String id;
  final String userId;
  final String ibanNo;
  final String ibanImage;
  final String crImage;
  final String bStatus;
  final DateTime createdAt;

  BankInfo({
    required this.id,
    required this.userId,
    required this.ibanNo,
    required this.ibanImage,
    required this.crImage,
    required this.bStatus,
    required this.createdAt,
  });

  factory BankInfo.fromJson(Map<String, dynamic> json) {
    return BankInfo(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      ibanNo: json['iban_no'] as String,
      ibanImage: json['iban_image'] as String,
      crImage: json['cr_image'] as String,
      bStatus: json['b_status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'iban_no': ibanNo,
      'iban_image': ibanImage,
      'cr_image': crImage,
      'b_status': bStatus,
      'created_at': createdAt.toIso8601String(),
    };
  }
}