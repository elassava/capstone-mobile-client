import 'package:mobile/features/profile/domain/entities/profile.dart';

/// Profile Repository Interface
abstract class ProfileRepositoryInterface {
  Future<List<Profile>> getProfilesByAccountId(String accountId);
  Future<Profile> createProfile({
    required String accountId,
    required String profileName,
    String? avatarUrl,
    bool isChildProfile = false,
    String maturityLevel = 'ALL',
    String language = 'tr',
    bool isPinProtected = false,
    String? pin,
    bool isDefault = false,
  });
  Future<void> deleteProfile({
    required String profileId,
    required String accountId,
  });
}

