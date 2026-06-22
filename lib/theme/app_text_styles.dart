import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const title = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const heading = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const subtitle = TextStyle(
    fontSize: 16,
    color: AppColors.textGrey,
    height: 1.5,
  );

  static const body = TextStyle(
    fontSize: 15,
    color: AppColors.textDark,
  );

  static const button = TextStyle(
    fontSize: 16,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  static const small = TextStyle(
    fontSize: 13,
    color: AppColors.textGrey,
  );
}