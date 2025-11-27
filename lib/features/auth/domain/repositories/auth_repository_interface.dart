import 'package:mobile/features/auth/domain/entities/auth_response.dart';

/// Auth Repository Interface - Domain layer
/// Defines contract for authentication operations
abstract class AuthRepositoryInterface {
  /// Register new user
  Future<AuthResponse> register({
    required String email,
    required String password,
  });

  /// Login user
  Future<AuthResponse> login({
    required String email,
    required String password,
  });
}

