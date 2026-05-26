import 'package:flutter/material.dart';

class AppColors {
  static const green = Color(0xFF06960B);
  static const darkGreen = Color(0xFF047A09);
  static const yellow = Color(0xFFF6D15D);
  static const paleYellow = Color(0xFFF7EDBC);
  static const softPanel = Color(0xFFF4F4F4);
  static const text = Color(0xFF202020);
  static const mutedText = Color(0xFF5C5C5C);

  const AppColors._();
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: false,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: AppColors.green,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.green,
      ).copyWith(
        primary: AppColors.green,
        secondary: AppColors.yellow,
        surface: Colors.white,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.green,
      ),
    );
  }

  const AppTheme._();
}
