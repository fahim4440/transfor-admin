class PayoutRequestItemsResponse {
  bool? error;
  String? message;
  List<PayoutRequestItem>? items;

  PayoutRequestItemsResponse({this.error, this.message, this.items});

  factory PayoutRequestItemsResponse.fromJson(Map<String, dynamic> json) =>
      PayoutRequestItemsResponse(
        error: json["error"],
        message: json["message"],
        items: json["items"] == null
            ? []
            : List<PayoutRequestItem>.from(json["items"]!.map((x) => PayoutRequestItem.fromJson(x))),
      );
}

class PayoutRequestItem {
  final int orderId;
  final String orderNumber;
  final double amount;
  final String date;
  // 'orders' or 'service' - matches Order.type. Null when this item has no
  // underlying order to drill into (e.g. a top-up refund).
  final String? type;
  final String status;

  PayoutRequestItem({
    required this.orderId,
    required this.orderNumber,
    required this.amount,
    required this.date,
    this.type,
    required this.status,
  });

  factory PayoutRequestItem.fromJson(Map<String, dynamic> json) => PayoutRequestItem(
        orderId: json['order_id'] is int ? json['order_id'] : int.tryParse(json['order_id']?.toString() ?? '') ?? 0,
        orderNumber: json['order_number'] ?? '',
        amount: (json['amount'] ?? 0).toDouble(),
        date: json['date'] ?? '',
        type: json['type'],
        status: json['status'] ?? '',
      );
}
