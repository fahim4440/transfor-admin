import 'package:flutter/material.dart';
import 'package:transfor_admin_dashboard/utilities/colors.dart';

ElevatedButton saveButton({required String text, required VoidCallback? onPressed}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.green,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 23.0, vertical: 18.0),
      textStyle: const TextStyle(fontSize: 16.0, color: Colors.white),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.save, color: Colors.white),
        const SizedBox(width: 8.0),
        Text(text, style: TextStyle(color: Colors.white)),
      ],
    ),
  );
}
