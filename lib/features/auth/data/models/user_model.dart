import '../../domain/entities/user.dart';

/// User Model (DTO) - Extends User entity
class UserModel extends User {
  UserModel({
    required super.id,
    required super.userId,
    required super.email,
    required super.isGoogleUser,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Convert JSON to UserModel with proper date parsing
  factory UserModel.fromJsonWithDates(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      email: json['email'] as String,
      isGoogleUser: json['isGoogleUser'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
