class PayoutRequestResponse {
  bool? error;
  String? message;
  List<PayoutRequest>? payoutRequests;

  PayoutRequestResponse({this.error, this.message, this.payoutRequests});

  factory PayoutRequestResponse.fromJson(Map<String, dynamic> json) =>
      PayoutRequestResponse(
        error: json["error"],
        message: json["message"],
        payoutRequests:
            json["PayoutRequest"] == null
                ? []
                : List<PayoutRequest>.from(
                  json["PayoutRequest"]!.map((x) => PayoutRequest.fromJson(x)),
                ),
      );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "PayoutRequest":
        payoutRequests == null
            ? []
            : List<dynamic>.from(payoutRequests!.map((x) => x.toJson())),
  };
}

class PayoutRequest {
  final String id;
  final String userId;
  final String payStatus;
  final double tAmount;
  final String name;
  final String ccode;
  final String mobile;
  final DateTime updatedAt;
  final String? type;

  PayoutRequest({
    required this.id,
    required this.userId,
    required this.payStatus,
    required this.tAmount,
    required this.name,
    required this.ccode,
    required this.mobile,
    required this.updatedAt,
    this.type,
  });

  factory PayoutRequest.fromJson(Map<String, dynamic> json) {
    return PayoutRequest(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      payStatus: json['pay_status'] as String,
      tAmount: double.parse(json['TAMOUNT'] as String),
      name: json['name'] as String,
      ccode: json['ccode'] as String,
      mobile: json['mobile'] as String,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      type: json['type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'pay_status': payStatus,
      'TAMOUNT': tAmount.toString(),
      'name': name,
      'ccode': ccode,
      'mobile': mobile,
      'updated_at': updatedAt.toIso8601String(),
      'type': type,
    };
  }
}