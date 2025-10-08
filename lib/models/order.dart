class OrderInfoResponse {
  bool? error;
  String? message;
  List<Order>? orders;

  OrderInfoResponse({this.error, this.message, this.orders});

  factory OrderInfoResponse.fromJson(Map<String, dynamic> json) =>
      OrderInfoResponse(
        error: json["error"],
        message: json["message"],
        orders:
            json["CurrentOrder"] == null
                ? []
                : List<Order>.from(
                  json["CurrentOrder"]!.map((x) => Order.fromJson(x)),
                ),
      );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "CurrentOrder":
        orders == null
            ? []
            : List<dynamic>.from(orders!.map((x) => x.toJson())),
  };
}

class Order {
  final String id;
  final String userName;
  final String userCode;
  final String userMobile;
  final String userEmail;
  final String orderNumber;
  final String totalAmount;
  final int totalQuantity;
  final String status;
  final String type;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.userName,
    required this.userCode,
    required this.userMobile,
    required this.userEmail,
    required this.orderNumber,
    required this.totalAmount,
    required this.totalQuantity,
    required this.status,
    required this.type,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      userName: json['user_name'] as String,
      userCode: json['user_code'] as String,
      userMobile: json['user_mobile'] as String,
      userEmail: json['user_email'] as String,
      orderNumber: json['order_number'] as String,
      totalAmount: json['total_amount'] as String,
      totalQuantity: json['total_quntity'] as int,
      status: Order._intStatusToString(json['status']),
      type: json['type'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  static String _intStatusToString(String status) {
    switch (status) {
      case '1':
        return 'Order Placed';
      case '2':
        return 'Processing';
      case '0':
        return 'Completed';
      case '-1':
        return 'Cancelled';
      default:
        return status;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_name': userName,
      'user_code': userCode,
      'user_mobile': userMobile,
      'user_email': userEmail,
      'order_number': orderNumber,
      'total_amount': totalAmount,
      'total_quntity': totalQuantity,
      'status': status,
      'type': type,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
