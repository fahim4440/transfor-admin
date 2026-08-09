import 'package:flutter/material.dart';
import 'package:transfor_admin_dashboard/utilities/colors.dart';

TextField textFieldDisabled({required String labelText, required TextEditingController textController, required bool isReadOnly, TextStyle? style,}) {
  return TextField(
    readOnly: isReadOnly,
    style: style,
    decoration: InputDecoration(
      labelText: labelText,
      disabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.border)
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary,)
      )
    ),
    controller: textController,
  );
}
