import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  static const heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );

  static const statCardHeading = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: AppColors.card,
  );

  static const whiteBoldText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.background,
  );

  static const whiteNormalText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.background,
  );

  static const subheading = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );

  static const body = TextStyle(
    fontSize: 14,
    color: AppColors.text,
  );

  static const drawerBody = TextStyle(
    fontSize: 14,
    color: AppColors.drawerTextColor,
  );

  static const statBody = TextStyle(
    fontSize: 14,
    color: AppColors.drawerTextColor,
  );

  static const buttonTextStyle = TextStyle(
    fontSize: 22,
    // fontWeight: FontWeight.bold,
    color: AppColors.background,
  );

  static const error = TextStyle(fontSize: 14, color: AppColors.error,);
}
