import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:transfor_admin_dashboard/models/bank_info.dart';
import 'package:transfor_admin_dashboard/models/company_info.dart';
import 'package:transfor_admin_dashboard/models/api_response.dart';
import 'package:transfor_admin_dashboard/models/user_info.dart';
import 'package:transfor_admin_dashboard/models/user_vehicle_info.dart';
import 'package:transfor_admin_dashboard/models/users_profile.dart';

class UsersServices {
  // final String _fetchUsersUrl =
  //     'https://www.shabakh.com/TransFor/api/Api.php?apicall=FetchUsers';

  // final String _fetchUserInfoUrl =
  //     'https://www.shabakh.com/TransFor/api/Api.php?apicall=FetchUserData';

  // final String _fetchUserCompanyInfoUrl =
  //     'https://www.shabakh.com/TransFor/api/Api.php?apicall=FetchUserCompanyData';

  // final String _fetchUserBankInfoUrl =
  //     'https://www.shabakh.com/TransFor/api/Api.php?apicall=FetchUserBankDetails';

  // final String _fetchUserVehicleInfoUrl =
  //     'https://www.shabakh.com/TransFor/api/Api.php?apicall=FetchUserVehicalData';

  // final String _updateUserStatusUrl =
  //     'https://www.shabakh.com/TransFor/api/Api.php?apicall=UpdateUserStatus';
  
  // final String _deleteUserUrl =
  //     'https://www.shabakh.com/TransFor/api/Api.php?apicall=DeleteUser';

  final String _fetchUsersUrl =
      'http://128.199.42.59/api/Api.php?apicall=FetchUsers';

  final String _fetchUserInfoUrl =
      'http://128.199.42.59/api/Api.php?apicall=FetchUserData';

  final String _fetchUserCompanyInfoUrl =
      'http://128.199.42.59/api/Api.php?apicall=FetchUserCompanyData';

  final String _fetchUserBankInfoUrl =
      'http://128.199.42.59/api/Api.php?apicall=FetchUserBankDetails';

  final String _fetchUserVehicleInfoUrl =
      'http://128.199.42.59/api/Api.php?apicall=FetchUserVehicalData';

  final String _updateUserStatusUrl =
      'http://128.199.42.59/api/Api.php?apicall=UpdateUserStatus';

  final String _deleteUserUrl =
      'http://128.199.42.59/api/Api.php?apicall=DeleteUser';

  Future<List<UserProfile>?> fetchUsers(String flag) async {
    final response = await http.post(
      Uri.parse(_fetchUsersUrl),
      body: {'FLAG': flag},
    );

    final UserProfileResponse userProfileResponse =
        UserProfileResponse.fromJson(jsonDecode(response.body));

    if (userProfileResponse.error == false) {
      List<UserProfile> users = userProfileResponse.userProfiles!;
      return users;
    } else {
      return null;
    }
  }

  Future<UserInfo?> fetchUserData(String id) async {
    final response = await http.post(
      Uri.parse(_fetchUserInfoUrl),
      body: {'ID': id},
    );

    final UserInfoResponse userInfoResponse = UserInfoResponse.fromJson(
      jsonDecode(response.body),
    );

    if (userInfoResponse.error == false) {
      UserInfo userInfo = userInfoResponse.userInfos!.first;
      return userInfo;
    } else {
      return null;
    }
  }

  Future<Company?> fetchUserCompanyData(String id) async {
    final response = await http.post(
      Uri.parse(_fetchUserCompanyInfoUrl),
      body: {'Uid': id},
    );

    final CompanyInfoResponse companyInfoResponse =
        CompanyInfoResponse.fromJson(jsonDecode(response.body));

    if (companyInfoResponse.error == false) {
      Company company = companyInfoResponse.companies!.first;
      return company;
    } else {
      return null;
    }
  }

  Future<BankInfo?> fetchUserBankData(String id) async {
    final response = await http.post(
      Uri.parse(_fetchUserBankInfoUrl),
      body: {'UID': id},
    );

    final BankInfoResponse bankInfoResponse = BankInfoResponse.fromJson(
      jsonDecode(response.body),
    );

    if (bankInfoResponse.error == false) {
      BankInfo bankInfo = bankInfoResponse.bankInfos!.first;
      return bankInfo;
    } else {
      return null;
    }
  }

  Future<UserVehicleInfo?> fetchUserVehicleData(String id) async {
    final response = await http.post(
      Uri.parse(_fetchUserVehicleInfoUrl),
      body: {'Uid': id},
    );

    final UserVehicleInfoResponse userVehicleInfoResponse =
        UserVehicleInfoResponse.fromJson(jsonDecode(response.body));

    if (userVehicleInfoResponse.error == false) {
      UserVehicleInfo userVehicleInfo =
          userVehicleInfoResponse.userVehicleInfos!.first;
      return userVehicleInfo;
    } else {
      return null;
    }
  }

  Future<String?> updateUserStatus(String id, String status) async {
    final response = await http.post(
      Uri.parse(_updateUserStatusUrl),
      body: {'Id': id, 'Status': status},
    );

    final ApiResponse apiResponse = ApiResponse.fromJson(
      jsonDecode(response.body),
    );

    if (apiResponse.error == false) {
      return apiResponse.message;
    } else {
      return null;
    }
  }

  Future<String?> deleteUser(String id) async {
    final response = await http.post(
      Uri.parse(_deleteUserUrl),
      body: {'Id': id},
    );

    final ApiResponse apiResponse = ApiResponse.fromJson(
      jsonDecode(response.body),
    );

    if (apiResponse.error == false) {
      return apiResponse.message;
    } else {
      return null;
    }
  }
}
