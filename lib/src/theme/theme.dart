import 'package:flutter/material.dart';
import 'package:flutter_course/src/theme/app_colors.dart';

final theme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.background,
  cardTheme: const CardTheme(
    elevation: 0,
    color: AppColors.white,
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 32,
      fontWeight: FontWeight.w600,
      height: 1.2,
      letterSpacing: 0,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.5,
      letterSpacing: 0.15,
    ),
    titleSmall: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.43,
      letterSpacing: 0.25,
    ),
    labelMedium: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.33,
      letterSpacing: 0.4,
    ),
  ),
);
