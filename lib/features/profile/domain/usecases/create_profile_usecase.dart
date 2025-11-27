import 'package:mobile/features/profile/domain/entities/profile.dart';
import 'package:mobile/features/profile/domain/repositories/profile_repository_interface.dart';

/// Create Profile Use Case
class CreateProfileUseCase {
  final ProfileRepositoryInterface _repository;

  CreateProfileUseCase(this._repository);

  Future<Profile> execute({
    required int accountId,
    required String profileName,
    String? avatarUrl,
    bool isChildProfile = false,
    String maturityLevel = 'ALL',
    String language = 'tr',
    bool isPinProtected = false,
    String? pin,
    bool isDefault = false,
  }) async {
    return await _repository.createProfile(
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
  }
}

