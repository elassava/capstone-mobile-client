import 'package:dio/dio.dart';

/// Auth Interceptor for Dio
/// Adds Authorization header with JWT token to requests
/// Token storage will be implemented later (SharedPreferences, SecureStorage, etc.)
class AuthInterceptor extends Interceptor {
  // TODO: Token'ı secure storage'dan alacak şekilde güncellenecek
  String? _token;

  /// Set authentication token
  void setToken(String? token) {
    _token = token;
  }

  /// Clear authentication token
  void clearToken() {
    _token = null;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Public endpoints (authentication gerektirmeyen)
    final publicPaths = [
      '/authentication/api/auth/register',
      '/authentication/api/auth/login',
      '/authentication/api/auth/google',
      '/subscription/api/subscription/plans',
      '/subscription/api/subscription/health',
    ];

    final isPublicPath = publicPaths.any((path) => 
      options.path.contains(path)
    );

    // Public endpoint değilse token ekle
    if (!isPublicPath && _token != null && _token!.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $_token';
    }

    super.onRequest(options, handler);
  }
}



