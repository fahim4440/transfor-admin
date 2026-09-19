import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:transfor_admin_dashboard/models/api_response.dart';
import 'package:transfor_admin_dashboard/models/app_version.dart';

class AppUpdateServices {
  static const String _baseUrl = 'http://128.199.42.59/api/Api.php?apicall=';

  /// This admin app's own key in the app_versions table.
  static const String adminAppKey = 'admin_windows';

  Future<AppVersion?> checkAppVersion(String appKey) async {
    try {
      final response = await http.post(
        Uri.parse('${_baseUrl}CheckAppVersion'),
        body: {'app': appKey},
      );

      final json = jsonDecode(response.body);
      if (json['error'] == true) return null;
      return AppVersion.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  Future<List<AppVersion>> fetchAllAppVersions() async {
    final response = await http.post(Uri.parse('${_baseUrl}FetchAllAppVersions'));
    final json = jsonDecode(response.body);

    if (json['error'] == true) return [];

    final List<dynamic> rows = json['AppVersions'] ?? [];
    return rows.map((row) => AppVersion.fromJson(row)).toList();
  }

  Future<bool> saveAppVersion(AppVersion version) async {
    final response = await http.post(
      Uri.parse('${_baseUrl}SaveAppVersion'),
      body: {
        'app_key': version.appKey,
        'latest_version': version.latestVersion,
        'min_version': version.minVersion,
        'force_update': version.forceUpdate ? '1' : '0',
        'store_url': version.storeUrl,
        'changelog': version.changelog,
      },
    );

    final apiResponse = ApiResponse.fromJson(jsonDecode(response.body));
    return apiResponse.error == false;
  }

  Future<String> currentVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  /// True if [current] is strictly lower than [minimum].
  /// Compares dotted numeric segments (e.g. "1.2.10" > "1.2.9").
  static bool isBelowMinVersion(String current, String minimum) {
    final currentParts = _parse(current);
    final minParts = _parse(minimum);
    final length = currentParts.length > minParts.length ? currentParts.length : minParts.length;

    for (var i = 0; i < length; i++) {
      final c = i < currentParts.length ? currentParts[i] : 0;
      final m = i < minParts.length ? minParts[i] : 0;
      if (c != m) return c < m;
    }
    return false;
  }

  static List<int> _parse(String version) {
    return version.split('+').first.split('.').map((part) => int.tryParse(part.trim()) ?? 0).toList();
  }
}
