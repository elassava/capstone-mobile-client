import 'package:mobile/features/profile/domain/entities/profile.dart';

/// Profile Model (DTO) - Extends Profile entity
class ProfileModel extends Profile {
  ProfileModel({
    required super.id,
    required super.accountId,
    required super.profileName,
    super.avatarUrl,
    required super.isChildProfile,
    required super.maturityLevel,
    required super.language,
    required super.isPinProtected,
    required super.isActive,
    required super.isDefault,
    required super.createdAt,
    required super.updatedAt,
  });

  /// Convert JSON to ProfileModel
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as int,
      accountId: json['accountId'] as int,
      profileName: json['profileName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      isChildProfile: json['isChildProfile'] as bool? ?? false,
      maturityLevel: json['maturityLevel'] as String? ?? 'ALL',
      language: json['language'] as String? ?? 'tr',
      isPinProtected: json['isPinProtected'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      isDefault: json['isDefault'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert ProfileModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'accountId': accountId,
      'profileName': profileName,
      'avatarUrl': avatarUrl,
      'isChildProfile': isChildProfile,
      'maturityLevel': maturityLevel,
      'language': language,
      'isPinProtected': isPinProtected,
      'isActive': isActive,
      'isDefault': isDefault,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

