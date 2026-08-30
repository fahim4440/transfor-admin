class CustomerOrdersResponse {
  bool? error;
  String? message;
  List<CustomerOrder>? orders;
  int totalOrders;

  CustomerOrdersResponse({
    this.error,
    this.message,
    this.orders,
    this.totalOrders = 0,
  });

  factory CustomerOrdersResponse.fromJson(Map<String, dynamic> json) => CustomerOrdersResponse(
    error: json["error"],
    message: json["message"],
    orders: json["orders"] == null
        ? []
        : List<CustomerOrder>.from(json["orders"]!.map((x) => CustomerOrder.fromJson(x))),
    totalOrders: json["total_orders"] ?? 0,
  );
}

class CustomerOrder {
  final int id;
  final String orderNumber;
  final double amount;
  final String status;
  final String date;
  final String type;
  final double? rating;
  final String? feedback;

  CustomerOrder({
    required this.id,
    required this.orderNumber,
    required this.amount,
    required this.status,
    required this.date,
    required this.type,
    this.rating,
    this.feedback,
  });

  factory CustomerOrder.fromJson(Map<String, dynamic> json) => CustomerOrder(
    id: json['id'] ?? 0,
    orderNumber: json['order_number'] ?? '',
    amount: (json['amount'] ?? 0).toDouble(),
    status: json['status'] ?? '0',
    date: json['date'] ?? '',
    type: json['type'] ?? 'order',
    rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
    feedback: json['feedback'],
  );

  String getStatusLabel() {
    switch (status) {
      case '0':
        return 'Completed';
      case '-1':
        return 'Cancelled';
      case '1':
        return 'Processing';
      case '2':
        return 'Driver Assigned';
      default:
        return 'Unknown';
    }
  }
}
