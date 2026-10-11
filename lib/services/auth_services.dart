import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/admin_profile.dart';

class AuthService {
  // final String loginUrl =
  //     'https://www.shabakh.com/TransFor/api/Api.php?apicall=LoginAdmin';

  final String loginUrl = 'http://128.199.42.59/api/Api.php?apicall=LoginAdmin';

  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(loginUrl),
      body: {'Username': email, 'Password': password},
    );

    final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
    final AdminProfileResponse adminProfileResponse =
        AdminProfileResponse.fromJson(responseJson);

    if (adminProfileResponse.error == false) {
      AdminProfile admin = adminProfileResponse.adminProfiles!.first;
      final token = responseJson['auth_token']?.toString();
      if (token == null || token.isEmpty) {
        throw Exception('Admin session was not returned');
      }
      await const FlutterSecureStorage().write(
        key: 'admin_auth_token',
        value: token,
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('name', admin.name);
      await prefs.setString('email', admin.email);
      await prefs.setString('isSuperAdmin', admin.superadmin);
      return adminProfileResponse.message!;
    } else {
      return adminProfileResponse.message!;
    }
  }

  Future<void> logout() async {
    const secureStorage = FlutterSecureStorage();
    final token = await secureStorage.read(key: 'admin_auth_token');
    if (token != null && token.isNotEmpty) {
      try {
        await http.post(
          Uri.parse('http://128.199.42.59/api/Api.php?apicall=LogoutAdmin'),
          headers: {'Authorization': 'Bearer $token'},
        );
      } catch (_) {}
    }
    await secureStorage.delete(key: 'admin_auth_token');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('isSuperAdmin');
  }
}
