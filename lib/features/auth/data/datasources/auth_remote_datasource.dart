import 'package:dio/dio.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/di/service_locator.dart';
import 'package:mobile/core/network/dio_client.dart';
import 'package:mobile/features/auth/data/models/auth_response_model.dart';
import 'package:mobile/features/auth/data/models/login_request_model.dart';
import 'package:mobile/features/auth/data/models/register_request_model.dart';

/// Abstract interface for Auth Remote Data Source
abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> register({
    required String email,
    required String password,
  });

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });
}

/// Implementation of Auth Remote Data Source
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl() : _dio = serviceLocator.get<DioClient>().dio;

  @override
  Future<AuthResponseModel> register({
    required String email,
    required String password,
  }) async {
    try {
      final requestModel = RegisterRequestModel(
        email: email,
        password: password,
      );

      final response = await _dio.post(
        ApiConstants.registerEndpoint,
        data: requestModel.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return AuthResponseModel.fromJsonWithDates(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw Exception('Registration failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Handle Dio errors
      if (e.response != null) {
        final errorData = e.response?.data;
        final errorMessage = errorData is Map<String, dynamic>
            ? errorData['message'] ?? errorData['error'] ?? 'Registration failed'
            : 'Registration failed';
        throw Exception(errorMessage);
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final requestModel = LoginRequestModel(
        email: email,
        password: password,
      );

      final response = await _dio.post(
        ApiConstants.loginEndpoint,
        data: requestModel.toJson(),
      );

      if (response.statusCode == 200) {
        return AuthResponseModel.fromJsonWithDates(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Handle Dio errors
      if (e.response != null) {
        final errorData = e.response?.data;
        final errorMessage = errorData is Map<String, dynamic>
            ? errorData['message'] ?? errorData['error'] ?? 'Login failed'
            : 'Login failed';
        throw Exception(errorMessage);
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}

