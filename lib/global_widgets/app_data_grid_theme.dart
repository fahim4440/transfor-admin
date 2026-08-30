import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:transfor_admin_dashboard/utilities/colors.dart';

/// Shared dark theme for every SfDataGrid in the app - keeps header/filter-popup
/// colors consistent instead of repeating this block per table.
final appDataGridTheme = SfDataGridThemeData(
  headerColor: AppColors.primary,
  gridLineColor: AppColors.border,
  rowHoverColor: AppColors.primary.withValues(alpha: 0.08),
  selectionColor: AppColors.primary.withValues(alpha: 0.15),
  sortIconColor: Colors.white,
  filterIconColor: Colors.white,
  filterPopupBackgroundColor: AppColors.card,
  filterPopupTextStyle: const TextStyle(color: AppColors.text),
  filterPopupIconColor: AppColors.text,
);

Widget dataGridHeaderText(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Text(
      text,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
    ),
  );
}
