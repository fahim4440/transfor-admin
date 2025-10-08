import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:transfor_admin_dashboard/models/order.dart';

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
}