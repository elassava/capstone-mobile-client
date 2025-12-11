import 'package:flutter/material.dart';
import 'package:mobile/core/widgets/modern_snackbar.dart';

/// SnackBar Extension for consistent modern snackbar display across the app
extension SnackBarExtension on BuildContext {
  /// Determine if the current scaffold has a dark background
  bool _isDarkBackground(BuildContext context) {
    try {
      final theme = Theme.of(context);
      final backgroundColor = theme.scaffoldBackgroundColor;
      final brightness = backgroundColor.computeLuminance();
      return brightness < 0.5;
    } catch (e) {
      return true;
    }
  }

  /// Show success snackbar with glassmorphism effect
  /// 
  /// [message] - The message to display
  /// [isDarkBackground] - Optional: manually specify if background is dark.
  ///                      If null, will auto-detect from theme.
  void showSuccessSnackBar(String message, {bool? isDarkBackground}) {
    final isDark = isDarkBackground ?? _isDarkBackground(this);
    ScaffoldMessenger.of(this).clearSnackBars();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: ModernSnackbar(
          message: message, 
          type: SnackbarType.success,
          isDarkBackground: isDark,
        ),
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        duration: const Duration(seconds: 4),
        dismissDirection: DismissDirection.horizontal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  /// Show error snackbar with glassmorphism effect
  /// 
  /// [message] - The message to display
  /// [isDarkBackground] - Optional: manually specify if background is dark.
  ///                      If null, will auto-detect from theme.
  void showErrorSnackBar(String message, {bool? isDarkBackground}) {
    final isDark = isDarkBackground ?? _isDarkBackground(this);
    ScaffoldMessenger.of(this).clearSnackBars();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: ModernSnackbar(
          message: message, 
          type: SnackbarType.error,
          isDarkBackground: isDark,
        ),
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        duration: const Duration(seconds: 4),
        dismissDirection: DismissDirection.horizontal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  /// Show info snackbar with glassmorphism effect
  /// 
  /// [message] - The message to display
  /// [isDarkBackground] - Optional: manually specify if background is dark.
  ///                      If null, will auto-detect from theme.
  void showInfoSnackBar(String message, {bool? isDarkBackground}) {
    final isDark = isDarkBackground ?? _isDarkBackground(this);
    ScaffoldMessenger.of(this).clearSnackBars();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: ModernSnackbar(
          message: message, 
          type: SnackbarType.info,
          isDarkBackground: isDark,
        ),
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        duration: const Duration(seconds: 4),
        dismissDirection: DismissDirection.horizontal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
