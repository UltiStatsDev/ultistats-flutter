import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
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

    inputDecorationTheme: InputDecorationThemeData(
      hintStyle: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 20,
        color: Colors.black.withValues(alpha: 0.35),
        letterSpacing: 0,
      ),
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
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

    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconSize: WidgetStatePropertyAll(36),
        iconColor: WidgetStatePropertyAll(Colors.white)
      )
    ),
    
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

    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(theme.cardBorderRadius),
      ),
    ),

    extensions: [
      AppInputTheme(
        textFieldStyleText: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 20,
          color: AppColors.grey,
          letterSpacing: 0,
        ),
      ),
      SkeletonizerConfigData(
        effect: ShimmerEffect(
          duration: Duration(seconds: 1),
          baseColor: Colors.white.withValues(alpha: 0.4),
          highlightColor: Colors.white.withValues(alpha: 0.5)
        )
      )
    ],

    textTheme: TextTheme(
      bodyLarge: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: AppColors.grey,
        letterSpacing: 0,
      ),
      bodyMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.grey,
        letterSpacing: 0,
      ),
      bodySmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.grey,
        letterSpacing: 0,
      ),

      labelLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.normal,
        color: AppColors.grey,
        letterSpacing: 0,
      ),
      labelMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.grey,
        letterSpacing: 0,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.normal,
        color: AppColors.grey,
        letterSpacing: 0,
      ),

      titleLarge: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 0,
      ),
      titleMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 0,
      ),
      titleSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 0,
      ),

      displayLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.normal,
        color: Colors.white,
        letterSpacing: 0,
      ),
      displayMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Colors.white,
        letterSpacing: 0,
      ),
      displaySmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: Colors.white,
        letterSpacing: 0,
      ),
    ),
  );
}

extension ThemeValueExtension on ThemeData {
  double get navBarBorderRadius => 10;

  double get navBarHeight => 70;

  double get navBarItemWidth => 90;

  double get navBarItemHeight => 54;

  double get cardHeight => 120;

  double get cardBorderRadius => 10;

  double get screenPadding => 12;

  double get searchBarSize => 46;

  double get searchBarBorderRadius => 10;

  double get appBarHeight => 52;

  double get textFieldHeight => 46;

  double get textFieldBorderRadius => 10;

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

///
/// Extra text themes
///
extension ThemeAppInputExtension on ThemeData {
  TextStyle get textFieldStyleText =>
      extension<AppInputTheme>()!.textFieldStyleText!;
}

class AppInputTheme extends ThemeExtension<AppInputTheme> {
  final TextStyle? textFieldStyleText;

  const AppInputTheme({required this.textFieldStyleText});

  @override
  AppInputTheme copyWith({TextStyle? textFieldStyleText}) {
    return AppInputTheme(
      textFieldStyleText: textFieldStyleText ?? this.textFieldStyleText,
    );
  }

  @override
  AppInputTheme lerp(ThemeExtension<AppInputTheme>? other, double t) {
    if (other is! AppInputTheme) return this;
    return AppInputTheme(
      textFieldStyleText: TextStyle.lerp(
        textFieldStyleText,
        other.textFieldStyleText,
        t,
      )!,
    );
  }
}
