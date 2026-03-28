import 'package:flutter/material.dart';
import 'package:ultistats/core/themes/app_colors.dart';

ThemeData createLightTheme() {
  final theme = ThemeData();
  return ThemeData(
    fontFamily: "Montserrat",
    primaryColor: AppColors.purple,
    scaffoldBackgroundColor: AppColors.purple,
    colorScheme: theme.colorScheme.copyWith(primaryContainer: Colors.white),
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
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.white,
      iconSize: 44,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      sizeConstraints: BoxConstraints.tightFor(width: 68, height: 68),
      foregroundColor: AppColors.purple,
      elevation: 3,
    ),

    // CircularProgressIndicator
    progressIndicatorTheme: ProgressIndicatorThemeData(color: Colors.white),

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
      labelMedium: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 20,
        color: AppColors.grey,
        letterSpacing: 0,
      ),
      labelLarge: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 20,
        color: Colors.black,
        letterSpacing: 0,
      ),
    ),
  );
}

// TODO поменять название
// TODO вынести boxShadows сюда
extension ThemeExtension on ThemeData {
  double get bottomNavigationBarBorderRadius => 10;

  double get bottomNavigationBarHeight => 70;

  double get teamCardHeight => 120;

  double get teamCardBorderRadius => 10;

  double get screenPadding => 12;

  double get searchBarSize => 46;
}
