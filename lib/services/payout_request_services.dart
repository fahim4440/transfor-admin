import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:transfor_admin_dashboard/models/api_response.dart';
import 'package:transfor_admin_dashboard/models/payout_request.dart';

class PayoutRequestServices {
  // final String _userPayoutRequestUrl =
  //     'https://www.shabakh.com/TransFor/api/Api.php?apicall=FetchUserPayoutRequest';

  // final String _providerPayoutRequestUrl =
  //     'https://www.shabakh.com/TransFor/api/Api.php?apicall=FetchProviderPayoutRequest';

  // final String _driverPayoutRequestUrl =
  //     'https://www.shabakh.com/TransFor/api/Api.php?apicall=FetchDriverPayoutRequest';

  // final String _payToUserUrl =
  //     'https://www.shabakh.com/TransFor/api/Api.php?apicall=UpdateUserPayoutRequest';

  // final String _payToProviderUrl =
  //     'https://www.shabakh.com/TransFor/api/Api.php?apicall=UpdateProviderPayoutRequest';

  // final String _payToDriverUrl =
  //     'https://www.shabakh.com/TransFor/api/Api.php?apicall=UpdatePayoutRequest';

  final String _userPayoutRequestUrl =
      'http://128.199.42.59/api/Api.php?apicall=FetchUserPayoutRequest';

  final String _providerPayoutRequestUrl =
      'http://128.199.42.59/api/Api.php?apicall=FetchProviderPayoutRequest';

  final String _driverPayoutRequestUrl =
      'http://128.199.42.59/api/Api.php?apicall=FetchDriverPayoutRequest';

  final String _payToUserUrl =
      'http://128.199.42.59/api/Api.php?apicall=UpdateUserPayoutRequest';

  final String _payToProviderUrl =
      'http://128.199.42.59/api/Api.php?apicall=UpdateProviderPayoutRequest';

  final String _payToDriverUrl =
      'http://128.199.42.59/api/Api.php?apicall=UpdatePayoutRequest';

  Future<List<PayoutRequest>?> fetchUserPayoutRequest() async {
    final response = await http.post(Uri.parse(_userPayoutRequestUrl));
    print("Response body: ${response.body}");

    final PayoutRequestResponse payoutRequestResponse =
        PayoutRequestResponse.fromJson(jsonDecode(response.body));
    
    if (payoutRequestResponse.error == false) {
      List<PayoutRequest> payoutRequests =
          payoutRequestResponse.payoutRequests!;
      return payoutRequests;
    } else {
      return null;
    }
  }

  Future<List<PayoutRequest>?> fetchProviderPayoutRequest() async {
    final response = await http.post(Uri.parse(_providerPayoutRequestUrl));

    final PayoutRequestResponse payoutRequestResponse =
        PayoutRequestResponse.fromJson(jsonDecode(response.body));

    if (payoutRequestResponse.error == false) {
      List<PayoutRequest> payoutRequests =
          payoutRequestResponse.payoutRequests!;
      return payoutRequests;
    } else {
      return null;
    }
  }

  Future<List<PayoutRequest>?> fetchDriverPayoutRequest() async {
    final response = await http.post(Uri.parse(_driverPayoutRequestUrl));

    final PayoutRequestResponse payoutRequestResponse =
        PayoutRequestResponse.fromJson(jsonDecode(response.body));

    if (payoutRequestResponse.error == false) {
      List<PayoutRequest> payoutRequests =
          payoutRequestResponse.payoutRequests!;
      return payoutRequests;
    } else {
      return null;
    }
  }

  Future<String?> payToUser({required String userId, required String orderType}) async {
    final response = await http.post(
      Uri.parse(_payToUserUrl),
      body: {
        'user_id': userId,
        'type': orderType
      }
    );

    final ApiResponse apiResponse = ApiResponse.fromJson(
      jsonDecode(response.body),
    );

    return apiResponse.message;
  }

  Future<String?> payToProvider({required String orderId, required String orderType}) async {
    final response = await http.post(
      Uri.parse(_payToProviderUrl),
      body: {
        'order_id': orderId,
        'type': orderType
      }
    );

    final ApiResponse apiResponse = ApiResponse.fromJson(
      jsonDecode(response.body),
    );

    return apiResponse.message;
  }

  Future<String?> payToDriver({required String driverId}) async {
    final response = await http.post(
      Uri.parse(_payToDriverUrl),
      body: {
        'user_id': driverId,
      }
    );

    final ApiResponse apiResponse = ApiResponse.fromJson(
      jsonDecode(response.body),
    );

    return apiResponse.message;
  }
}
