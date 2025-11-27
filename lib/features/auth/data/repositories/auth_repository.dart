import 'package:mobile/features/auth/domain/entities/auth_response.dart';
import 'package:mobile/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:mobile/features/auth/data/datasources/auth_remote_datasource.dart';

/// Auth Repository Implementation
class AuthRepository implements AuthRepositoryInterface {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepository(this._remoteDataSource);

  @override
  Future<AuthResponse> register({
    required String email,
    required String password,
  }) async {
    try {
      final responseModel = await _remoteDataSource.register(
        email: email,
        password: password,
      );

      // Convert model to domain entity
      return AuthResponse(
        token: responseModel.token,
        user: responseModel.user,
      );
    } catch (e) {
      // Re-throw with proper error handling
      throw Exception('Registration failed: $e');
    }
  }

  @override
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final responseModel = await _remoteDataSource.login(
        email: email,
        password: password,
      );

      // Convert model to domain entity
      return AuthResponse(
        token: responseModel.token,
        user: responseModel.user,
      );
    } catch (e) {
      // Re-throw with proper error handling
      throw Exception('Login failed: $e');
    }
  }
}

