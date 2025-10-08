import 'package:shared_preferences/shared_preferences.dart';
import 'package:transfor_admin_dashboard/models/admin_profile.dart';

class ProfileServices {
  Future<AdminProfile?> fetchAdminProfileFromSharedPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? name = await preferences.getString('name');
    final String? email = await preferences.getString('email');
    final String? isSuperAdmin = await preferences.getString('isSuperAdmin');
    if (name != null && email != null && isSuperAdmin != null) {
      return AdminProfile(
        id: '1',
        name: name,
        email: email,
        superadmin: isSuperAdmin,
        status: '0',
        createdAt: DateTime.now(),
      );
    } else {
      return null;
    }
  }
}
