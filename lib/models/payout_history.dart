class PayoutHistoryResponse {
  bool? error;
  String? message;
  List<PayoutHistory>? payoutHistories;

  PayoutHistoryResponse({this.error, this.message, this.payoutHistories});

  factory PayoutHistoryResponse.fromJson(Map<String, dynamic> json) =>
      PayoutHistoryResponse(
        error: json["error"],
        message: json["message"],
        payoutHistories:
            json["PayoutHistories"] == null
                ? []
                : List<PayoutHistory>.from(
                  json["PayoutHistories"]!.map((x) => PayoutHistory.fromJson(x)),
                ),
      );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "PayoutHistories":
        payoutHistories == null
            ? []
            : List<dynamic>.from(payoutHistories!.map((x) => x.toJson())),
  };
}

class PayoutHistory {
  final String id;
  final String orderNumber;
  final String userId;
  final String payStatus;
  final double tAmount;
  final String name;
  final String ccode;
  final String mobile;
  final DateTime updatedAt;
  final String? type;

  PayoutHistory({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.payStatus,
    required this.tAmount,
    required this.name,
    required this.ccode,
    required this.mobile,
    required this.updatedAt,
    this.type,
  });

  factory PayoutHistory.fromJson(Map<String, dynamic> json) {
    return PayoutHistory(
      id: json['id'] as String,
      orderNumber: json['order_number']?.toString() ?? '',
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
      'order_number': orderNumber,
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