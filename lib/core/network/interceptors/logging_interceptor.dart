import 'package:dio/dio.dart';

/// Logging Interceptor for Dio
/// Logs all HTTP requests and responses
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('🚀 [REQUEST] ${options.method} ${options.path}');
    if (options.queryParameters.isNotEmpty) {
      print('   Query Parameters: ${options.queryParameters}');
    }
    if (options.data != null) {
      print('   Body: ${options.data}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('✅ [RESPONSE] ${response.statusCode} ${response.requestOptions.path}');
    print('   Data: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('❌ [ERROR] ${err.requestOptions.method} ${err.requestOptions.path}');
    print('   Status Code: ${err.response?.statusCode}');
    print('   Message: ${err.message}');
    if (err.response?.data != null) {
      print('   Error Data: ${err.response?.data}');
    }
    super.onError(err, handler);
  }
}



