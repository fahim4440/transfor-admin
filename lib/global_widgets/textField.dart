import 'package:flutter/material.dart';
import 'package:transfor_admin_dashboard/utilities/colors.dart';

TextField textFieldDisabled({required String labelText, required TextEditingController textController, required bool isReadOnly,}) {
  return TextField(
    readOnly: isReadOnly,
    decoration: InputDecoration(
      labelText: labelText,
      disabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.black)
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary,)
      )
    ),
    controller: textController,
  );
}
