import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/admin_profile.dart';

class AuthService {
  // final String loginUrl =
  //     'https://www.shabakh.com/TransFor/api/Api.php?apicall=LoginAdmin';

  final String loginUrl =
      'http://128.199.42.59/api/Api.php?apicall=LoginAdmin';

  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(loginUrl),
      body: {'Username': email, 'Password': password},
    );

    final AdminProfileResponse adminProfileResponse =
        AdminProfileResponse.fromJson(jsonDecode(response.body));

    if (adminProfileResponse.error == false) {
      AdminProfile admin = adminProfileResponse.adminProfiles!.first;
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

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('isSuperAdmin');
  }
}
