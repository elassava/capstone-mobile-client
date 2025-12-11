import 'package:mobile/features/profile/domain/entities/profile.dart';
import 'package:mobile/features/profile/domain/repositories/profile_repository_interface.dart';
import 'package:mobile/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:mobile/features/profile/data/models/create_profile_request_model.dart';

/// Profile Repository Implementation
class ProfileRepository implements ProfileRepositoryInterface {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepository(this._remoteDataSource);

  @override
  Future<List<Profile>> getProfilesByAccountId(String accountId) async {
    final models = await _remoteDataSource.getProfilesByAccountId(accountId);
    return models;
  }

  @override
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
  }) async {
    final request = CreateProfileRequestModel(
      accountId: accountId,
      profileName: profileName,
      avatarUrl: avatarUrl,
      isChildProfile: isChildProfile,
      maturityLevel: maturityLevel,
      language: language,
      isPinProtected: isPinProtected,
      pin: pin,
      isDefault: isDefault,
    );
    final model = await _remoteDataSource.createProfile(request);
    return model;
  }

  @override
  Future<void> deleteProfile({
    required String profileId,
    required String accountId,
  }) async {
    await _remoteDataSource.deleteProfile(profileId, accountId);
  }
}

