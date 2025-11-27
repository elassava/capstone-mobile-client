import 'package:dio/dio.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/network/interceptors/auth_interceptor.dart';
import 'package:mobile/core/network/interceptors/logging_interceptor.dart';

/// Dio HTTP Client setup with interceptors
class DioClient {
  late final Dio _dio;
  final AuthInterceptor? _authInterceptor;

  DioClient({AuthInterceptor? authInterceptor}) 
      : _authInterceptor = authInterceptor {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(LoggingInterceptor());
    // Add auth interceptor if provided
    if (_authInterceptor != null) {
      _dio.interceptors.add(_authInterceptor!);
    }
  }

  /// Get Dio instance
  Dio get dio => _dio;

  /// Dispose Dio instance
  void dispose() {
    _dio.close();
  }
}

