class ProductOrderItem {
  final String productId;
  final String productName;
  final String productPrice;
  final String? productImage;
  final String quantity;
  final String providerId;
  final String? providerName;
  final String? providerMobile;
  final String? providerEmail;

  ProductOrderItem({
    required this.productId,
    required this.productName,
    required this.productPrice,
    this.productImage,
    required this.quantity,
    required this.providerId,
    this.providerName,
    this.providerMobile,
    this.providerEmail,
  });

  factory ProductOrderItem.fromJson(Map<String, dynamic> json) => ProductOrderItem(
        productId: json['product_id']?.toString() ?? '',
        productName: json['product_name'] ?? '',
        productPrice: json['product_price']?.toString() ?? '0',
        productImage: json['product_image'],
        quantity: json['quantity']?.toString() ?? '0',
        providerId: json['provider_id']?.toString() ?? '',
        providerName: json['provider_name'],
        providerMobile: json['provider_mobile'],
        providerEmail: json['provider_email'],
      );
}

class ProductOrderDetailResponse {
  bool? error;
  String? message;
  ProductOrderDetail? detail;

  ProductOrderDetailResponse({this.error, this.message, this.detail});

  factory ProductOrderDetailResponse.fromJson(Map<String, dynamic> json) => ProductOrderDetailResponse(
        error: json['error'],
        message: json['message'],
        detail: json['OrderDetails'] != null && (json['OrderDetails'] as List).isNotEmpty
            ? ProductOrderDetail.fromJson(json['OrderDetails'][0])
            : null,
      );
}

class ProductOrderDetail {
  final String id;
  final String userId;
  final String? customerName;
  final String? customerMobile;
  final String? customerEmail;
  final String? customerImage;
  final String? driverId;
  final String? driverName;
  final String? driverMobile;
  final String? driverEmail;
  final String? driverImage;
  final String orderNumber;
  final String? orderAmount;
  final String? platformFee;
  final String? productDeliveryCharge;
  final String? taxAmount;
  final String? totalAmount;
  final String? dropAddress;
  final double? dropLatitude;
  final double? dropLongitude;
  final String? dropCity;
  final String? paymentMethod;
  final String? transactionId;
  final int totalQuantity;
  final String status;
  final String? deliveryMethod;
  final String? pickupAddress;
  final double? pickupLatitude;
  final double? pickupLongitude;
  final String? reason;
  final List<ProductOrderItem> products;
  final String? createdAt;
  final bool deliveryRequestRejected;
  final String? rejectedByCompany;

  ProductOrderDetail({
    required this.id,
    required this.userId,
    this.customerName,
    this.customerMobile,
    this.customerEmail,
    this.customerImage,
    this.driverId,
    this.driverName,
    this.driverMobile,
    this.driverEmail,
    this.driverImage,
    required this.orderNumber,
    this.orderAmount,
    this.platformFee,
    this.productDeliveryCharge,
    this.taxAmount,
    this.totalAmount,
    this.dropAddress,
    this.dropLatitude,
    this.dropLongitude,
    this.dropCity,
    this.paymentMethod,
    this.transactionId,
    required this.totalQuantity,
    required this.status,
    this.deliveryMethod,
    this.pickupAddress,
    this.pickupLatitude,
    this.pickupLongitude,
    this.reason,
    required this.products,
    this.createdAt,
    this.deliveryRequestRejected = false,
    this.rejectedByCompany,
  });

  factory ProductOrderDetail.fromJson(Map<String, dynamic> json) => ProductOrderDetail(
        id: json['id']?.toString() ?? '',
        userId: json['user_id']?.toString() ?? '',
        customerName: json['customer_name'],
        customerMobile: json['customer_mobile'],
        customerEmail: json['customer_email'],
        customerImage: json['customer_image'],
        driverId: json['driver_id']?.toString(),
        driverName: json['driver_name'],
        driverMobile: json['driver_mobile'],
        driverEmail: json['driver_email'],
        driverImage: json['driver_image'],
        orderNumber: json['order_number']?.toString() ?? '',
        orderAmount: json['order_amount']?.toString(),
        platformFee: json['platform_fee']?.toString(),
        productDeliveryCharge: json['product_delivery_charge']?.toString(),
        taxAmount: json['tax_amount']?.toString(),
        totalAmount: json['total_amount']?.toString(),
        dropAddress: json['drop_address'],
        dropLatitude: double.tryParse(json['drop_latitude']?.toString() ?? ''),
        dropLongitude: double.tryParse(json['drop_longitude']?.toString() ?? ''),
        dropCity: json['drop_city'],
        paymentMethod: json['payment_method'],
        transactionId: json['transaction_id'],
        totalQuantity: int.tryParse(json['total_quntity']?.toString() ?? '') ?? 0,
        status: json['status']?.toString() ?? '',
        deliveryMethod: json['delivery_method'],
        pickupAddress: json['pickup_address'],
        pickupLatitude: double.tryParse(json['pickup_latitude']?.toString() ?? ''),
        pickupLongitude: double.tryParse(json['pickup_longitude']?.toString() ?? ''),
        reason: json['reason'],
        products: json['AllProducts'] == null
            ? []
            : List<ProductOrderItem>.from(json['AllProducts'].map((x) => ProductOrderItem.fromJson(x))),
        createdAt: json['created_at'],
        deliveryRequestRejected: json['delivery_request_rejected'] == true,
        rejectedByCompany: json['rejected_by_company'],
      );
}

class TransportOrderDetailResponse {
  bool? error;
  String? message;
  TransportOrderDetail? detail;

  TransportOrderDetailResponse({this.error, this.message, this.detail});

  factory TransportOrderDetailResponse.fromJson(Map<String, dynamic> json) => TransportOrderDetailResponse(
        error: json['error'],
        message: json['message'],
        detail: json['TransportOrderDetails'] != null && (json['TransportOrderDetails'] as List).isNotEmpty
            ? TransportOrderDetail.fromJson(json['TransportOrderDetails'][0])
            : null,
      );
}

class TransportOrderDetail {
  final String id;
  final String userId;
  final String? customerName;
  final String? customerMobile;
  final String? customerEmail;
  final String? customerImage;
  final String? companyName;
  final String? providerId;
  final String orderNumber;
  final String? serviceId;
  final String? driverId;
  final String? driverName;
  final String? driverMobile;
  final String? driverImage;
  final String? pickupAddress;
  final double? pickupLatitude;
  final double? pickupLongitude;
  final String? dropAddress;
  final double? dropLatitude;
  final double? dropLongitude;
  final String? pickupCity;
  final String? dropCity;
  final String? distance;
  final String? serviceName;
  final String? transportType;
  final String? shippingFee;
  final String? appServiceFee;
  final String? taxAmount;
  final String? deliveryCharge;
  final String? purchaseReceipt;
  final String? deliveryNote;
  final String? vehicleSize;
  final String? vehicleSide;
  final String? quantity;
  final String? paymentMethod;
  final String? transactionId;
  final String status;
  final String? pickupTime;
  final String? reason;
  final String? createdAt;

  TransportOrderDetail({
    required this.id,
    required this.userId,
    this.customerName,
    this.customerMobile,
    this.customerEmail,
    this.customerImage,
    this.companyName,
    this.providerId,
    required this.orderNumber,
    this.serviceId,
    this.driverId,
    this.driverName,
    this.driverMobile,
    this.driverImage,
    this.pickupAddress,
    this.pickupLatitude,
    this.pickupLongitude,
    this.dropAddress,
    this.dropLatitude,
    this.dropLongitude,
    this.pickupCity,
    this.dropCity,
    this.distance,
    this.serviceName,
    this.transportType,
    this.shippingFee,
    this.appServiceFee,
    this.taxAmount,
    this.deliveryCharge,
    this.purchaseReceipt,
    this.deliveryNote,
    this.vehicleSize,
    this.vehicleSide,
    this.quantity,
    this.paymentMethod,
    this.transactionId,
    required this.status,
    this.pickupTime,
    this.reason,
    this.createdAt,
  });

  factory TransportOrderDetail.fromJson(Map<String, dynamic> json) => TransportOrderDetail(
        id: json['id']?.toString() ?? '',
        userId: json['user_id']?.toString() ?? '',
        customerName: json['customer_name'],
        customerMobile: json['customer_mobile'],
        customerEmail: json['customer_email'],
        customerImage: json['customer_image'],
        companyName: json['company_name'],
        providerId: json['provider_id']?.toString(),
        orderNumber: json['order_number']?.toString() ?? '',
        serviceId: json['service_id']?.toString(),
        driverId: json['driver_id']?.toString(),
        driverName: json['driver_name'],
        driverMobile: json['driver_mobile'],
        driverImage: json['driver_image'],
        pickupAddress: json['pickup_address'],
        pickupLatitude: double.tryParse(json['pickup_latitude']?.toString() ?? ''),
        pickupLongitude: double.tryParse(json['pickup_longitude']?.toString() ?? ''),
        dropAddress: json['drop_address'],
        dropLatitude: double.tryParse(json['drop_latitude']?.toString() ?? ''),
        dropLongitude: double.tryParse(json['drop_longitude']?.toString() ?? ''),
        pickupCity: json['pickup_city'],
        dropCity: json['drop_city'],
        distance: json['distance']?.toString(),
        serviceName: json['service_name'],
        transportType: json['transport_type'],
        shippingFee: json['shipping_fee']?.toString(),
        appServiceFee: json['app_service_fee']?.toString(),
        taxAmount: json['tax_amount']?.toString(),
        deliveryCharge: json['delivery_charge']?.toString(),
        purchaseReceipt: json['purchase_receipt'],
        deliveryNote: json['delivery_note'],
        vehicleSize: json['vehicle_size'],
        vehicleSide: json['vehicle_side'],
        quantity: json['quantity']?.toString(),
        paymentMethod: json['payment_method'],
        transactionId: json['transaction_id'],
        status: json['status']?.toString() ?? '',
        pickupTime: json['pickup_time'],
        reason: json['reason'],
        createdAt: json['created_at'],
      );
}
