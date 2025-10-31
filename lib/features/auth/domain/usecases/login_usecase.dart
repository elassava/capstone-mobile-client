import '../entities/auth_response.dart';
import '../repositories/auth_repository_interface.dart';

/// Login Use Case
/// Business logic for user authentication
class LoginUseCase {
  final AuthRepositoryInterface _repository;

  LoginUseCase(this._repository);

  /// Execute login
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

    // Call repository
    return await _repository.login(email: email, password: password);
  }
}


