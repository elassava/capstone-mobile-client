import 'package:flutter/material.dart';
import 'package:mobile/core/localization/app_localizations.dart';

/// Utility class for handling and localizing error messages
class ErrorHandler {
  /// Converts API error messages to user-friendly localized messages
  static String getLocalizedErrorMessage(
    BuildContext context,
    String? apiError,
  ) {
    final localizations = AppLocalizations.of(context)!;

    if (apiError == null || apiError.isEmpty) {
      return localizations.errorGeneric;
    }

    // Clean up the error message
    final cleanError = apiError
        .replaceAll('Exception: ', '')
        .replaceAll('Error: ', '')
        .trim();

    final errorLower = cleanError.toLowerCase();

    // Auth errors
    if (errorLower.contains('user not found') ||
        errorLower.contains('no user found')) {
      return localizations.errorUserNotFound;
    }

    if (errorLower.contains('invalid credentials') ||
        errorLower.contains('wrong password') ||
        errorLower.contains('incorrect password') ||
        errorLower.contains('authentication failed')) {
      return localizations.errorInvalidCredentials;
    }

    if (errorLower.contains('email already') ||
        errorLower.contains('already exists') ||
        errorLower.contains('already registered') ||
        errorLower.contains('email in use')) {
      return localizations.errorEmailAlreadyExists;
    }

    if (errorLower.contains('weak password') ||
        errorLower.contains('password too weak')) {
      return localizations.errorWeakPassword;
    }

    if (errorLower.contains('unauthorized') ||
        errorLower.contains('not authorized')) {
      return localizations.errorAuthFailed;
    }

    // Payment errors
    if (errorLower.contains('payment declined') ||
        errorLower.contains('card declined') ||
        errorLower.contains('insufficient funds')) {
      return localizations.errorPaymentDeclined;
    }

    if (errorLower.contains('invalid payment') ||
        errorLower.contains('invalid card') ||
        errorLower.contains('card invalid')) {
      return localizations.errorInvalidPaymentMethod;
    }

    // Subscription errors
    if (errorLower.contains('subscription failed') ||
        errorLower.contains('failed to subscribe')) {
      return localizations.errorSubscriptionFailed;
    }

    // Profile errors
    if (errorLower.contains('profile') && errorLower.contains('create')) {
      return localizations.errorProfileCreateFailed;
    }

    if (errorLower.contains('profile') && errorLower.contains('delete')) {
      return localizations.errorProfileDeleteFailed;
    }

    if (errorLower.contains('profile') && errorLower.contains('update')) {
      return localizations.errorProfileUpdateFailed;
    }

    // Content errors
    if (errorLower.contains('content') &&
        (errorLower.contains('not available') ||
            errorLower.contains('unavailable'))) {
      return localizations.errorContentNotAvailable;
    }

    if (errorLower.contains('content') &&
        (errorLower.contains('load') || errorLower.contains('fetch'))) {
      return localizations.errorContentLoadFailed;
    }

    // Network errors
    if (errorLower.contains('network') ||
        errorLower.contains('connection') ||
        errorLower.contains('timeout') ||
        errorLower.contains('no internet')) {
      return localizations.errorNetwork;
    }

    // Default fallback
    return localizations.errorGeneric;
  }
}
