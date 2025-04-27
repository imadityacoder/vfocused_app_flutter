import 'package:flutter/material.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'Sora',

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Orbitron',
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: AppColors.neonPurple,
      ),
      titleLarge: TextStyle(
        fontFamily: 'SpaceGrotesk',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      bodyMedium: TextStyle(fontSize: 16, color: AppColors.textSecondary),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.neonPurple,
        foregroundColor: AppColors.buttonText,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.card,
      titleTextStyle: TextStyle(
        fontFamily: 'Orbitron',
        fontSize: 20,
        color: AppColors.textPrimary,
      ),
      centerTitle: true,
    ),

    cardColor: AppColors.card,
    iconTheme: const IconThemeData(color: AppColors.neonPurple),
    colorScheme: ColorScheme.dark(
      primary: AppColors.neonPurple,
      secondary: AppColors.neonBlue,
      surface: AppColors.background,
      onPrimary: AppColors.buttonText,
    ),
  );
}
