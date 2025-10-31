import '../entities/profile.dart';

/// Profile Repository Interface
abstract class ProfileRepositoryInterface {
  Future<List<Profile>> getProfilesByAccountId(int accountId);
  Future<Profile> createProfile({
    required int accountId,
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
    required int profileId,
    required int accountId,
  });
}

