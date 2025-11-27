import 'package:mobile/features/auth/domain/entities/auth_response.dart';
import 'package:mobile/features/auth/domain/repositories/auth_repository_interface.dart';

/// Register Use Case
/// Business logic for user registration
class RegisterUseCase {
  final AuthRepositoryInterface _repository;

  RegisterUseCase(this._repository);

  /// Execute register
  /// Returns AuthResponse on success
  /// Throws exception on failure
  Future<AuthResponse> execute({
    required String email,
    required String password,
  }) async {
    // Input validation
    if (email.isEmpty) {
      throw Exception('Email cannot be empty');
    }
    if (password.isEmpty) {
      throw Exception('Password cannot be empty');
    }
    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    // Call repository
    return await _repository.register(email: email, password: password);
  }
}

