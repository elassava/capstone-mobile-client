/// User entity - Domain layer
class User {
  final int id;
  final int userId;
  final String email;
  final bool isGoogleUser;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.userId,
    required this.email,
    required this.isGoogleUser,
    required this.createdAt,
    required this.updatedAt,
  });
}


