import 'package:mobile/features/auth/domain/entities/auth_response.dart';
import 'package:mobile/features/auth/data/models/user_model.dart';

/// Auth Response Model (DTO) - Extends AuthResponse entity
class AuthResponseModel extends AuthResponse {
  AuthResponseModel({
    required super.token,
    required super.user,
  });

  /// Convert JSON to AuthResponseModel with proper parsing
  factory AuthResponseModel.fromJsonWithDates(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json['token'] as String,
      user: UserModel.fromJsonWithDates(json['user'] as Map<String, dynamic>),
    );
  }
}
