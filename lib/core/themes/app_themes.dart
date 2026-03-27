import 'package:flutter/material.dart';
import 'package:ultistats/core/themes/app_colors.dart';

ThemeData createLightTheme() {
  final theme = ThemeData();
  return ThemeData(
    fontFamily: "Montserrat",
    primaryColor: AppColors.purple,
    scaffoldBackgroundColor: AppColors.purple,
    colorScheme: theme.colorScheme.copyWith(onPrimaryContainer: Colors.white),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.white,
      selectedIconTheme: IconThemeData(color: Colors.white, size: 36),
      unselectedItemColor: AppColors.purple,
      unselectedIconTheme: IconThemeData(color: AppColors.purple, size: 36),
      selectedLabelStyle: TextStyle(
        height: 1,
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),
      unselectedLabelStyle: TextStyle(
        height: 1,
        color: AppColors.purple,
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),
    ),

    textTheme: TextTheme(
      bodyLarge: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        color: AppColors.grey,
        letterSpacing: 0,
      ),
      bodyMedium: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 16,
        color: AppColors.grey,
        letterSpacing: 0,
      ),
    ),
  );
}

// TODO поменять название
extension ThemeExtension on ThemeData {
  double get bottomNavigationBarBorderRadius => 10;

  double get bottomNavigationBarHeight => 70;

  double get teamCardHeight => 120;

  double get teamCardBorderRadius => 10;

  double get screenPadding => 12;
}
