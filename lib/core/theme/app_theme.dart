import 'package:flutter/material.dart';
import 'app_colors.dart';

/// App theme configuration
class AppTheme {
  AppTheme._();

  // Font Family
  static const String fontFamily = 'NetflixSans';

  // Font Weights mapping
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight bold = FontWeight.w700;

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.netflixBlack,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.netflixRed,
        secondary: AppColors.netflixLightGray,
        surface: AppColors.netflixDarkGray,
        background: AppColors.netflixBlack,
        error: AppColors.netflixRed,
        onPrimary: AppColors.netflixWhite,
        onSecondary: AppColors.netflixWhite,
        onSurface: AppColors.netflixWhite,
        onBackground: AppColors.netflixWhite,
        onError: AppColors.netflixWhite,
      ),
      textTheme: TextTheme(
        displayLarge: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 32,
          fontWeight: bold,
          color: AppColors.netflixWhite,
        ),
        displayMedium: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 28,
          fontWeight: bold,
          color: AppColors.netflixWhite,
        ),
        displaySmall: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 24,
          fontWeight: bold,
          color: AppColors.netflixWhite,
        ),
        headlineLarge: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 22,
          fontWeight: medium,
          color: AppColors.netflixWhite,
        ),
        headlineMedium: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 20,
          fontWeight: medium,
          color: AppColors.netflixWhite,
        ),
        headlineSmall: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 18,
          fontWeight: medium,
          color: AppColors.netflixWhite,
        ),
        titleLarge: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: medium,
          color: AppColors.netflixWhite,
        ),
        titleMedium: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          fontWeight: medium,
          color: AppColors.netflixWhite,
        ),
        titleSmall: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 12,
          fontWeight: medium,
          color: AppColors.netflixWhite,
        ),
        bodyLarge: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: regular,
          color: AppColors.netflixWhite,
        ),
        bodyMedium: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          fontWeight: regular,
          color: AppColors.netflixWhite,
        ),
        bodySmall: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 12,
          fontWeight: regular,
          color: AppColors.netflixLightGray,
        ),
        labelLarge: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          fontWeight: medium,
          color: AppColors.netflixWhite,
        ),
        labelMedium: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 12,
          fontWeight: medium,
          color: AppColors.netflixWhite,
        ),
        labelSmall: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 10,
          fontWeight: medium,
          color: AppColors.netflixLightGray,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.netflixBlack,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.netflixWhite),
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          color: AppColors.netflixWhite,
          fontSize: 18,
          fontWeight: medium,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.netflixWhite,
          foregroundColor: AppColors.netflixBlack,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: medium,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.netflixWhite,
          side: const BorderSide(color: AppColors.netflixWhite, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: medium,
          ),
        ),
      ),
    );
  }
}
