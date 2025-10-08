import 'package:flutter/material.dart';
import 'package:transfor_admin_dashboard/models/admin_profile.dart';
import 'package:transfor_admin_dashboard/services/profile_services.dart';
import 'package:transfor_admin_dashboard/utilities/app_strings.dart';
import 'package:transfor_admin_dashboard/utilities/dimensions.dart';

import '../../global_widgets/textField.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileServices _services = ProfileServices();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _services.fetchAdminProfileFromSharedPrefs(),
      builder: (context, AsyncSnapshot<AdminProfile?> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Padding(
            padding: const EdgeInsets.all(AppDimensions.biggerSpacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  AppStrings.adminProfile.translate(context),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: textFieldDisabled(
                        labelText: AppStrings.name.translate(context),
                        textController: TextEditingController(
                          text: snapshot.data!.name,
                        ),
                        isReadOnly: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: textFieldDisabled(
                        labelText: AppStrings.email.translate(context),
                        textController: TextEditingController(
                          text: snapshot.data!.email,
                        ),
                        isReadOnly: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
