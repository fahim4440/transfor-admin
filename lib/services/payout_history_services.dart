import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:transfor_admin_dashboard/models/payout_history.dart';

class PayoutHistoryServices {
  final String _payoutHistoryUrl =
      'http://128.199.42.59/api/Api.php?apicall=FetchPayoutHistory';

  Future<List<PayoutHistory>?> fetchPayoutHistories() async {
    final response = await http.post(Uri.parse(_payoutHistoryUrl));

    print(response.body);

    final PayoutHistoryResponse payoutHistoryResponse =
        PayoutHistoryResponse.fromJson(jsonDecode(response.body));

    if (payoutHistoryResponse.error == false) {
      List<PayoutHistory> payoutHistories =
          payoutHistoryResponse.payoutHistories!;
      return payoutHistories;
    } else {
      return null;
    }
  }
}
