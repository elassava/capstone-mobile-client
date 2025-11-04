import 'user.dart';

/// Auth Response entity - Domain layer
class AuthResponse {
  final String token;
  final User user;

  const AuthResponse({
    required this.token,
    required this.user,
  });
}



