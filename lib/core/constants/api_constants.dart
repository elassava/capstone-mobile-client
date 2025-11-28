import 'package:flutter/foundation.dart';

/// API Constants - Base URLs and endpoints
class ApiConstants {
  ApiConstants._();

  // Base URL - Backend API Gateway
  // Development: localhost (emulator için 10.0.2.2 kullanılır)
  // Production: Gerçek API Gateway URL'i
  // Base URL - Backend API Gateway
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://172.16.8.179';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8765';
    } else {
      return 'http://localhost:8765';
    }
  }

  // API Endpoints
  static const String authenticationBasePath = '/authentication';
  static const String userServiceBasePath = '/user-service';
  static const String subscriptionBasePath = '/subscription';

  // Subscription Endpoints
  static const String subscriptionPlansEndpoint = '/api/subscription/plans';
  static const String mySubscriptionEndpoint =
      '/api/subscription/my-subscription';
  static const String subscribeEndpoint = '/api/subscription/subscribe';

  // Payment Endpoints
  static const String paymentBasePath = '/subscription';
  static const String addPaymentMethodEndpoint = '/api/payment/methods';

  // Profile Endpoints
  static const String profileBasePath = '/profile-service';
  static const String getProfilesByAccountEndpoint = '/api/profiles/account';
  static const String createProfileEndpoint = '/api/profiles';

  // Authentication Endpoints
  static const String registerEndpoint = '/api/auth/register';
  static const String loginEndpoint = '/api/auth/login';
  static const String googleLoginEndpoint = '/api/auth/google';
  static const String logoutEndpoint = '/api/auth/logout';

  // Request Timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
