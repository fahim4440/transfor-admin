import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:transfor_admin_dashboard/models/dashboard.dart';

class DashboardServices {
  // final String _fetchAllCountURL =
  //     'https://www.shabakh.com/TransFor/api/Api.php?apicall=FetchAllCount';

  final String _fetchAllCountURL =
      'http://128.199.42.59/api/Api.php?apicall=FetchAllCount';

  Future<AllCount?> fetchAllCount() async {
    final response = await http.post(
      Uri.parse(_fetchAllCountURL),
    );

    final DashboardResponse adminProfileResponse =
        DashboardResponse.fromJson(jsonDecode(response.body));

    if (adminProfileResponse.error == false) {
      AllCount allCount = adminProfileResponse.allCount!.first;
      return allCount;
    } else {
      return null;
    }
  }
}
