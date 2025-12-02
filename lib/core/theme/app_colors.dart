import 'package:flutter/material.dart';
import 'package:smooth_gradient/smooth_gradient.dart';

/// Netflix color palette and theme colors
class AppColors {
  AppColors._();

  // Netflix Brand Colors
  static const Color netflixRed = Color.fromARGB(255, 226, 9, 19);
  static const Color netflixBlack = Color(0xFF000000);
  static const Color netflixDarkGray = Color(0xFF141414);
  static const Color netflixGray = Color(0xFF2F2F2F);
  static const Color netflixLightGray = Color(0xFF808080);
  static const Color netflixWhite = Color(0xFFFFFFFF);
  static const Color netflixTransparent = Color.fromARGB(73, 255, 255, 255);

  // Text & Input Colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color inputBorder = Color(0xFF8C8C8C);
  static const Color inputFill = Color(0xFF333333);
  static const Color textGray = Color(0xFF737373);
  static const Color textLightGray = Color(0xFFB3B3B3);
  static const Color sectionTitle = Color(0xFFE5E5E5);
  static const Color top10Border = Color(0xFF595959);

  // Gradient Colors for Onboarding
  static const Color onboardingGradientTop = Color(0xFF0F0D12);
  static const Color onboardingGradientTopMid = Color(0xFF0F0D0F);
  static const Color onboardingGradientMid = Color(0xFF0F0A0F);
  static const Color onboardingGradientMidBottom = Color(0xFF0F0710);
  static const Color onboardingGradientBottomMid = Color(0xFF1A0A15);
  static const Color onboardingGradientBottom = Color(0xFF2A0F1A);

  // Onboarding Background Gradient
  static Gradient get onboardingBackgroundGradient {
    return SmoothGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      curve: Curves.easeInOut,
      from: Color.fromARGB(255, 54, 13, 15),
      to: Color(0xff17151a),
      steps: 8,
    );
  }

  // Login/Signup Background Gradient (siyahtan kırmızıya)
  static Gradient get authBackgroundGradient {
    return SmoothGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      curve: Curves.easeInOut,
      from: Color.fromARGB(255, 37, 7, 7), // Koyu kırmızı
      to: Color(0xFF000000), // Siyah
      steps: 8,
    );
  }
}
