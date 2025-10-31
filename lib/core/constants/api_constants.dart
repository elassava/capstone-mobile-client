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



