import 'package:flutter/material.dart';

/// Utility class for responsive design calculations
class ResponsiveHelper {
  ResponsiveHelper._();

  /// Get responsive padding based on screen width
  /// Small screens (<360px): 12px
  /// Medium screens (<600px): 16px
  /// Large screens (<900px): 24px
  /// Extra large screens: 32px
  static double getResponsivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) return 12.0;
    if (width < 600) return 16.0;
    if (width < 900) return 24.0;
    return 32.0;
  }

  /// Get responsive horizontal padding based on screen width
  /// Same as getResponsivePadding but semantically named for horizontal use
  static double getResponsiveHorizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) return 12.0;
    if (width < 600) return 16.0;
    if (width < 900) return 24.0;
    return 32.0;
  }

  /// Get responsive title padding based on screen width
  /// Small screens (<360px): 16px
  /// Medium screens (<600px): 24px
  /// Large screens (<900px): 32px
  /// Extra large screens: 48px
  static double getResponsiveTitlePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) return 16.0;
    if (width < 600) return 24.0;
    if (width < 900) return 32.0;
    return 48.0;
  }

  /// Get responsive spacing based on screen height
  /// Small screens (<600px): 8px
  /// Medium screens (<800px): 12px
  /// Large screens (<1000px): 16px
  /// Extra large screens: 24px
  static double getResponsiveSpacing(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    if (height < 600) return 8.0;
    if (height < 800) return 12.0;
    if (height < 1000) return 16.0;
    return 24.0;
  }

  /// Get responsive bottom offset based on screen height and orientation
  /// Landscape: 15% of screen height
  /// Portrait: 20px-60px based on height
  static double getResponsiveBottomOffset(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final orientation = MediaQuery.of(context).orientation;

    if (orientation == Orientation.landscape) {
      return height * 0.15;
    }

    if (height < 600) return 20.0;
    if (height < 800) return 40.0;
    if (height < 1000) return 50.0;
    return 60.0;
  }

  /// Get responsive font size based on screen width
  /// Scales from base size with min 85% and max 120%
  /// Base width reference: 375px (iPhone standard)
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    final width = MediaQuery.of(context).size.width;
    final scaleFactor = width / 375; // Base width for iPhone
    final newSize = baseSize * scaleFactor;

    // Clamp between min and max
    if (width < 360) return baseSize * 0.85;
    if (width > 1200) return baseSize * 1.2;
    return newSize.clamp(baseSize * 0.85, baseSize * 1.2);
  }

  /// Get maximum image width based on screen width and orientation
  /// Landscape: 70% of screen width
  /// Portrait: Full width on small screens, 600-800px max on larger screens
  static double getMaxImageWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;

    if (orientation == Orientation.landscape) {
      return width * 0.7;
    }

    if (width < 600) return double.infinity;
    if (width < 900) return 600;
    return 800;
  }

  /// Get minimum image height based on screen height and orientation
  /// Landscape: 50% of screen height
  /// Portrait: 30%-50% of screen height based on height
  static double getMinImageHeight(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final orientation = MediaQuery.of(context).orientation;

    if (orientation == Orientation.landscape) {
      return height * 0.5;
    }

    if (height < 600) return height * 0.3;
    if (height < 800) return height * 0.4;
    return height * 0.5;
  }

  /// Check if device is in landscape mode
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Check if device is in portrait mode
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  /// Get screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get screen height
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Check if screen is considered small (< 600px width)
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  /// Check if screen is considered medium (600px - 900px width)
  static bool isMediumScreen(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 900;
  }

  /// Check if screen is considered large (>= 900px width)
  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 900;
  }
}





