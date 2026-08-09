import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:transfor_admin_dashboard/models/order.dart';
import 'package:transfor_admin_dashboard/models/order_detail.dart';

class OrdersServices {
  // final String _fetchCurrentOrdersUrl =
  //     'https://www.shabakh.com/TransFor/api/Api.php?apicall=FetchAdminOrders';

  // final String _fetchCompletedCancelledOrdersUrl =
  //     'https://www.shabakh.com/TransFor/api/Api.php?apicall=FetchAdminPastOrders';

  final String _fetchCurrentOrdersUrl =
      'http://128.199.42.59/api/Api.php?apicall=FetchAdminOrders';

  final String _fetchCompletedCancelledOrdersUrl =
      'http://128.199.42.59/api/Api.php?apicall=FetchAdminPastOrders';

  Future<List<Order>?> fetchCurrentOrders(String key) async {
    final response = await http.post(
      Uri.parse(_fetchCurrentOrdersUrl),
      body: {
        'key': key,
      }
    );

    final OrderInfoResponse orderInfoResponse =
        OrderInfoResponse.fromJson(jsonDecode(response.body));

    if (orderInfoResponse.error == false) {
      List<Order> orders = orderInfoResponse.orders!;
      return orders;
    } else {
      return null;
    }
  }

  Future<List<Order>?> fetchCompletedCancelledOrders(String key, String status) async {
    final response = await http.post(
      Uri.parse(_fetchCompletedCancelledOrdersUrl),
      body: {
        'key': key,
        'status': status,
      }
    );

    final OrderInfoResponse orderInfoResponse =
        OrderInfoResponse.fromJson(jsonDecode(response.body));

    if (orderInfoResponse.error == false) {
      List<Order> orders = orderInfoResponse.orders!;
      return orders;
    } else {
      return null;
    }
  }

  Future<ProductOrderDetail?> fetchProductOrderDetails(String orderId) async {
    final response = await http.post(
      Uri.parse('http://128.199.42.59/api/Api.php?apicall=FetchOrderDetails'),
      body: {'OID': orderId},
    );

    final ProductOrderDetailResponse detailResponse =
        ProductOrderDetailResponse.fromJson(jsonDecode(response.body));

    return detailResponse.error == false ? detailResponse.detail : null;
  }

  Future<TransportOrderDetail?> fetchTransportOrderDetails(String orderId) async {
    final response = await http.post(
      Uri.parse('http://128.199.42.59/api/Api.php?apicall=fetchTransportOrderDetails'),
      body: {'ID': orderId},
    );

    final TransportOrderDetailResponse detailResponse =
        TransportOrderDetailResponse.fromJson(jsonDecode(response.body));

    return detailResponse.error == false ? detailResponse.detail : null;
  }
}