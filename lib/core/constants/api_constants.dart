/// API Constants - Base URLs and endpoints
class ApiConstants {
  ApiConstants._();

  // Base URL - Backend API Gateway
  // Development: localhost (emulator için 10.0.2.2 kullanılır)
  // Production: Gerçek API Gateway URL'i
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8765',
  );

  // API Endpoints
  static const String authenticationBasePath = '/authentication';
  static const String userServiceBasePath = '/user-service';
  static const String subscriptionBasePath = '/subscription';
  
  // Subscription Endpoints
  static const String subscriptionPlansEndpoint = '$subscriptionBasePath/api/subscription/plans';
  static const String mySubscriptionEndpoint = '$subscriptionBasePath/api/subscription/my-subscription';
  static const String subscribeEndpoint = '$subscriptionBasePath/api/subscription/subscribe';
  
  // Payment Endpoints
  static const String paymentBasePath = '/subscription';
  static const String addPaymentMethodEndpoint = '$paymentBasePath/api/payment/methods';
  
  // Profile Endpoints
  static const String profileBasePath = '/profile-service';
  static const String getProfilesByAccountEndpoint = '$profileBasePath/api/profiles/account';
  static const String createProfileEndpoint = '$profileBasePath/api/profiles';

  // Authentication Endpoints
  static const String registerEndpoint = '$authenticationBasePath/api/auth/register';
  static const String loginEndpoint = '$authenticationBasePath/api/auth/login';
  static const String googleLoginEndpoint = '$authenticationBasePath/api/auth/google';
  static const String logoutEndpoint = '$authenticationBasePath/api/auth/logout';

  // Request Timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}



