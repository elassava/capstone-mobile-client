/// Profile Entity
class Profile {
  final String id;
  final String accountId;
  final String profileName;
  final String? avatarUrl;
  final bool isChildProfile;
  final String maturityLevel;
  final String language;
  final bool isPinProtected;
  final bool isActive;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  Profile({
    required this.id,
    required this.accountId,
    required this.profileName,
    this.avatarUrl,
    required this.isChildProfile,
    required this.maturityLevel,
    required this.language,
    required this.isPinProtected,
    required this.isActive,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });
}

