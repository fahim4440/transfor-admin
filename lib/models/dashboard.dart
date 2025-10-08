class DashboardResponse {
  bool? error;
  String? message;
  List<AllCount>? allCount;

  DashboardResponse({
    this.error,
    this.message,
    this.allCount,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) => DashboardResponse(
    error: json["error"],
    message: json["message"],
    allCount: json["AllCount"] == null ? [] : List<AllCount>.from(json["AllCount"]!.map((x) => AllCount.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "AllCount": allCount == null ? [] : List<dynamic>.from(allCount!.map((x) => x.toJson())),
  };
}


class AllCount {
  final int users;
  final int providers;
  final int drivers;
  final int onGoingOrders;
  final int cancelOrder;
  final int pastOrder;
  final int products;
  final int services;

  AllCount({
    required this.users,
    required this.providers,
    required this.drivers,
    required this.onGoingOrders,
    required this.cancelOrder,
    required this.pastOrder,
    required this.products,
    required this.services,
  });

  // Factory constructor to create a User from JSON
  factory AllCount.fromJson(Map<String, dynamic> json) {
    return AllCount(
      users: json['Users'],
      providers: json['Provider'],
      drivers: json['Driver'],
      onGoingOrders: json['OngoingOrder'],
      cancelOrder: json['CancelOrder'],
      pastOrder: json['PastOrder'],
      products: json['Products'],
      services: json['Services'],
    );
  }

  // Method to convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'Users': users,
      'Provider': providers,
      'Driver': drivers,
      'OngoingOrder': onGoingOrders,
      'CancelOrder': cancelOrder,
      'PastOrder': pastOrder,
      'Products': products,
      'Services': services,
    };
  }
}