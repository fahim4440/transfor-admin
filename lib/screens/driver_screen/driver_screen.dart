import 'package:flutter/material.dart';
import 'package:transfor_admin_dashboard/screens/users_screen/users_screen.dart';
import 'package:transfor_admin_dashboard/utilities/app_strings.dart';
import 'package:transfor_admin_dashboard/utilities/colors.dart';
import 'package:transfor_admin_dashboard/utilities/dimensions.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  bool isPending = false;
  String selectedDriverType = 'single';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppDimensions.padding, left: AppDimensions.padding, right: AppDimensions.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _tabButton(
                label: AppStrings.approved.translate(context),
                selected: !isPending,
                onTap: () => setState(() => isPending = false),
              ),
              const SizedBox(width: 8),
              _tabButton(
                label: AppStrings.pending.translate(context),
                selected: isPending,
                onTap: () => setState(() => isPending = true),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _tabButton(
                label: AppStrings.singleDriver.translate(context),
                selected: selectedDriverType == 'single',
                onTap: () => setState(() => selectedDriverType = 'single'),
              ),
              const SizedBox(width: 8),
              _tabButton(
                label: AppStrings.companyDriver.translate(context),
                selected: selectedDriverType == 'company',
                onTap: () => setState(() => selectedDriverType = 'company'),
              ),
            ],
          ),
          const Divider(height: 1),
          Expanded(
            child: UsersScreen(
              key: ValueKey(isPending),
              userType: 'Driver',
              isPending: isPending,
              driverTypeFilter: selectedDriverType,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabButton({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.text,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
