import 'package:flutter/material.dart';
import 'package:ultistats/core/themes/app_colors.dart';

ThemeData createLightTheme() {
  final theme = ThemeData();
  return ThemeData(
    fontFamily: "Montserrat",
    primaryColor: AppColors.purple,
    scaffoldBackgroundColor: AppColors.purple,
    colorScheme: theme.colorScheme.copyWith(
      primaryContainer: Colors.white,
      surfaceContainerHighest: Colors.white,
      onSurfaceVariant: AppColors.purple,
      error: Color(0xFFDA2121),
    ),
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

    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        iconSize: WidgetStatePropertyAll(20),
        backgroundColor: WidgetStatePropertyAll(AppColors.purpleDark),
        iconColor: WidgetStatePropertyAll(Colors.white),
        textStyle: WidgetStatePropertyAll(
          TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.normal,
            fontSize: 16,
            color: Colors.white,
            letterSpacing: 0,
          ),
        ),
      ),
    ),

    textTheme: TextTheme(
      headlineMedium: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 20,
        color: Colors.white,
        letterSpacing: 0,
      ),

      ///Cards
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

      ///Text fields
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

      ///Scores
      displayLarge: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 40,
        color: AppColors.grey,
        letterSpacing: 0,
      ),
      displaySmall: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 10,
        letterSpacing: 0,
        color: AppColors.grey,
      ),
    ),
  );
}

extension ThemeExtension on ThemeData {
  double get bottomNavigationBarBorderRadius => 10;

  double get bottomNavigationBarHeight => 70;

  double get cardHeight => 120;

  double get cardBorderRadius => 10;

  double get screenPadding => 12;

  double get searchBarSize => 46;

  List<BoxShadow> get bottomNavigationBarBoxShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      blurRadius: 12,
      offset: const Offset(0, -4),
    ),
  ];

  List<BoxShadow> get cardBoxShadow => [
    BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), blurRadius: 12),
  ];
}
