import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:transfor_admin_dashboard/models/api_response.dart';

import '../models/settings.dart';

class SettingsServices {
  // final String _fetchSettingsUrl =
  //     'https://www.shabakh.com/TransFor/api/Api.php?apicall=fetchSettings';

  // final String _saveSettingsUrl =
  //     'https://www.shabakh.com/TransFor/api/Api.php?apicall=UpdateSetting';

  final String _fetchSettingsUrl =
      'http://128.199.42.59/api/Api.php?apicall=fetchSettings';

  final String _saveSettingsUrl =
      'http://128.199.42.59/api/Api.php?apicall=UpdateSetting';

  Future<Setting?> fetchSettings(String key) async {
    final response = await http.post(
      Uri.parse(_fetchSettingsUrl),
      body: {
        'key': key,
      }
    );

    final SettingsResponse settingsResponse =
        SettingsResponse.fromJson(jsonDecode(response.body));

    if (settingsResponse.error == false) {
      Setting setting = settingsResponse.settings!.first;
      return setting;
    } else {
      return null;
    }
  }

  Future<String?> saveSettings(Setting setting) async {
    final response = await http.post(
      Uri.parse(_saveSettingsUrl),
      body: {
        'id': setting.id,
        'd_cahrge': setting.deliveryCharge,
        'tax_charge': setting.tax,
      }
    );

    final ApiResponse apiResponse =
        ApiResponse.fromJson(jsonDecode(response.body));

    if (apiResponse.error == false) {
      String message = apiResponse.message;
      return message;
    } else {
      return null;
    }
  }
}
