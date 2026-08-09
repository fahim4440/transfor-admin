import 'package:flutter/material.dart';
import 'package:transfor_admin_dashboard/screens/users_screen/users_screen.dart';
import 'package:transfor_admin_dashboard/utilities/app_strings.dart';
import 'package:transfor_admin_dashboard/utilities/colors.dart';
import 'package:transfor_admin_dashboard/utilities/dimensions.dart';

class ProviderScreen extends StatefulWidget {
  const ProviderScreen({super.key});

  @override
  State<ProviderScreen> createState() => _ProviderScreenState();
}

class _ProviderScreenState extends State<ProviderScreen> {
  bool isPending = false;
  String selectedProviderType = 'product';

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
          if (!isPending) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                _tabButton(
                  label: AppStrings.productProvider.translate(context),
                  selected: selectedProviderType == 'product',
                  onTap: () => setState(() => selectedProviderType = 'product'),
                ),
                const SizedBox(width: 8),
                _tabButton(
                  label: AppStrings.deliveryProvider.translate(context),
                  selected: selectedProviderType == 'delivery',
                  onTap: () => setState(() => selectedProviderType = 'delivery'),
                ),
                const SizedBox(width: 8),
                _tabButton(
                  label: AppStrings.both.translate(context),
                  selected: selectedProviderType == 'both',
                  onTap: () => setState(() => selectedProviderType = 'both'),
                ),
              ],
            ),
          ],
          const Divider(height: 1),
          Expanded(
            child: UsersScreen(
              key: ValueKey(isPending),
              userType: 'Service Provider',
              isPending: isPending,
              providerTypeFilter: isPending ? null : selectedProviderType,
              showProviderTypeColumn: isPending,
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
