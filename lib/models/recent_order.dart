class RecentOrdersResponse {
  bool? error;
  String? message;
  List<RecentOrder>? recentOrders;

  RecentOrdersResponse({
    this.error,
    this.message,
    this.recentOrders,
  });

  factory RecentOrdersResponse.fromJson(Map<String, dynamic> json) => RecentOrdersResponse(
    error: json["error"],
    message: json["message"],
    recentOrders: json["RecentOrders"] == null
        ? []
        : List<RecentOrder>.from(json["RecentOrders"]!.map((x) => RecentOrder.fromJson(x))),
  );
}

class RecentOrder {
  final String type; // 'orders' or 'transport'
  final int id;
  final String orderNumber;
  final double amount;
  final String date;
  final String status; // '0'=completed, '-1'=cancelled, '1'=ongoing, '2'=pending
  final String customerName;
  final String? customerProfile;

  RecentOrder({
    required this.type,
    required this.id,
    required this.orderNumber,
    required this.amount,
    required this.date,
    required this.status,
    required this.customerName,
    this.customerProfile,
  });

  factory RecentOrder.fromJson(Map<String, dynamic> json) => RecentOrder(
    type: json['type'] ?? '',
    id: json['OID'] ?? 0,
    orderNumber: json['ONUMBER'] ?? '',
    amount: (json['AMOUNT'] ?? 0).toDouble(),
    date: json['ODATE'] ?? '',
    status: json['OSTATUS']?.toString() ?? '0',
    customerName: json['UNAME'] ?? '',
    customerProfile: json['UPROF'],
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
