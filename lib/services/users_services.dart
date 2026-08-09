import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:transfor_admin_dashboard/models/bank_info.dart';
import 'package:transfor_admin_dashboard/models/company_info.dart';
import 'package:transfor_admin_dashboard/models/api_response.dart';
import 'package:transfor_admin_dashboard/models/user_info.dart';
import 'package:transfor_admin_dashboard/models/user_vehicle_info.dart';
import 'package:transfor_admin_dashboard/models/users_profile.dart';
import 'package:transfor_admin_dashboard/models/customer_order.dart';
import 'package:transfor_admin_dashboard/models/wallet_transaction.dart';

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

  final String _fetchPendingUsersUrl =
      'http://128.199.42.59/api/Api.php?apicall=FetchPendingUsers';

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

  final String _updateAdminConfirmationUrl =
      'http://128.199.42.59/api/Api.php?apicall=UpdateAdminConfirmation';

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

  Future<List<UserProfile>?> fetchPendingUsers(String flag) async {
    final response = await http.post(
      Uri.parse(_fetchPendingUsersUrl),
      body: {'FLAG': flag},
    );

    final UserProfileResponse userProfileResponse =
        UserProfileResponse.fromJson(jsonDecode(response.body));

    if (userProfileResponse.error == false) {
      List<UserProfile> users = userProfileResponse.userProfiles!;
      return users;
    } else if (userProfileResponse.message == "User not found") {
      return [];
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

  Future<String?> updateAdminConfirmation(String id) async {
    final response = await http.post(
      Uri.parse(_updateAdminConfirmationUrl),
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

  // Customer Orders
  Future<List<CustomerOrder>?> getCustomerOrders(String userId, {int limit = 5, int offset = 0}) async {
    final response = await http.post(
      Uri.parse('http://128.199.42.59/api/Api.php?apicall=GetCustomerOrders'),
      body: {
        'user_id': userId,
        'limit': limit.toString(),
        'offset': offset.toString(),
      },
    );

    final CustomerOrdersResponse ordersResponse =
        CustomerOrdersResponse.fromJson(jsonDecode(response.body));

    if (ordersResponse.error == false && ordersResponse.orders != null) {
      return ordersResponse.orders;
    } else {
      return null;
    }
  }

  // Wallet Summary
  Future<WalletSummary?> getCustomerWalletSummary(String userId) async {
    final response = await http.post(
      Uri.parse('http://128.199.42.59/api/Api.php?apicall=GetCustomerWalletSummary'),
      body: {'user_id': userId},
    );

    final WalletSummaryResponse summaryResponse =
        WalletSummaryResponse.fromJson(jsonDecode(response.body));

    if (summaryResponse.error == false && summaryResponse.walletSummary != null) {
      return summaryResponse.walletSummary;
    } else {
      return null;
    }
  }

  // Wallet Transactions
  Future<List<WalletTransaction>?> getCustomerWalletTransactions(String userId, {int limit = 5, int offset = 0}) async {
    final response = await http.post(
      Uri.parse('http://128.199.42.59/api/Api.php?apicall=GetCustomerWalletTransactions'),
      body: {
        'user_id': userId,
        'limit': limit.toString(),
        'offset': offset.toString(),
      },
    );

    final WalletTransactionsResponse transactionsResponse =
        WalletTransactionsResponse.fromJson(jsonDecode(response.body));

    if (transactionsResponse.error == false && transactionsResponse.transactions != null) {
      return transactionsResponse.transactions;
    } else {
      return null;
    }
  }

  // Profile Orders (Individual / Driver / Service Provider)
  // dateFrom/dateTo expected as 'yyyy-MM-dd'; when both set, orders + totalOrders are scoped to that range.
  // status: order status code ('0' completed, '-1' cancelled, '1' processing, '2' driver assigned).
  Future<CustomerOrdersResponse?> getProfileOrders(
    String id,
    String userType, {
    int limit = 5,
    int offset = 0,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) async {
    final response = await http.post(
      Uri.parse('http://128.199.42.59/api/Api.php?apicall=GetProfileOrders'),
      body: {
        'id': id,
        'user_type': userType,
        'limit': limit.toString(),
        'offset': offset.toString(),
        if (dateFrom != null) 'date_from': dateFrom,
        if (dateTo != null) 'date_to': dateTo,
        if (status != null) 'status': status,
      },
    );

    final CustomerOrdersResponse ordersResponse =
        CustomerOrdersResponse.fromJson(jsonDecode(response.body));

    if (ordersResponse.error == false && ordersResponse.orders != null) {
      return ordersResponse;
    } else {
      return null;
    }
  }

  // Profile Wallet Summary (Individual / Driver / Service Provider)
  Future<WalletSummary?> getProfileWalletSummary(String id, String userType) async {
    final response = await http.post(
      Uri.parse('http://128.199.42.59/api/Api.php?apicall=GetProfileWalletSummary'),
      body: {'id': id, 'user_type': userType},
    );

    final WalletSummaryResponse summaryResponse =
        WalletSummaryResponse.fromJson(jsonDecode(response.body));

    if (summaryResponse.error == false && summaryResponse.walletSummary != null) {
      return summaryResponse.walletSummary;
    } else {
      return null;
    }
  }

  // Profile Wallet Transactions (Individual / Driver / Service Provider)
  Future<List<WalletTransaction>?> getProfileWalletTransactions(String id, String userType, {int limit = 5, int offset = 0}) async {
    final response = await http.post(
      Uri.parse('http://128.199.42.59/api/Api.php?apicall=GetProfileWalletTransactions'),
      body: {
        'id': id,
        'user_type': userType,
        'limit': limit.toString(),
        'offset': offset.toString(),
      },
    );

    final WalletTransactionsResponse transactionsResponse =
        WalletTransactionsResponse.fromJson(jsonDecode(response.body));

    if (transactionsResponse.error == false && transactionsResponse.transactions != null) {
      return transactionsResponse.transactions;
    } else {
      return null;
    }
  }

  // Register/Add Customer
  Future<dynamic> registerUser({
    required String name,
    required String email,
    required String mobile,
    required String ccode,
    required String password,
    required String type,
    String profile = '',
  }) async {
    final response = await http.post(
      Uri.parse('http://128.199.42.59/api/Api.php?apicall=RegisterUser'),
      body: {
        'Name': name,
        'Email': email,
        'Mobile': mobile,
        'Code': ccode,
        'Profile': profile,
        'Type': type,
        'Password': password,
        'EmailVerify': '0',
        'AdminConfirmation': '1',
        'service_provider_id': '0',
      },
    );

    final ApiResponse apiResponse = ApiResponse.fromJson(
      jsonDecode(response.body),
    );

    if (apiResponse.error == false) {
      return apiResponse.message;
    } else {
      return apiResponse.message;
    }
  }
}
