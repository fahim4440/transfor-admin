import 'package:flutter/material.dart';
import 'package:transfor_admin_dashboard/utilities/colors.dart';
import 'package:transfor_admin_dashboard/utilities/dimensions.dart';

Container dropdownButton({
  required String selectedCategory,
  required void Function(String newUserType) fetchPayoutRequestByCategory,
}) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.primary),
      borderRadius: BorderRadius.circular(8),
    ),
    child: DropdownButton<String>(
      value: selectedCategory,
      hint: const Text('User Type'),
      items:
          <String>[
            'User',
            'Service Provider',
            'Driver',
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          fetchPayoutRequestByCategory(newValue);
        }
      },
      isExpanded: true,
      underline: const SizedBox(),
      borderRadius: BorderRadius.circular(8.0),
      dropdownColor: AppColors.primary,
      icon: Icon(Icons.person, color: AppColors.primary),
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.normalSpacing),
      focusColor: AppColors.primary,
    ),
  );
}
