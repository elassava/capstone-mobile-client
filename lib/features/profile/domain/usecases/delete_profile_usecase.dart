import 'package:mobile/features/profile/domain/repositories/profile_repository_interface.dart';

/// Delete Profile Use Case
class DeleteProfileUseCase {
  final ProfileRepositoryInterface _repository;

  DeleteProfileUseCase(this._repository);

  Future<void> execute({
    required String profileId,
    required String accountId,
  }) async {
    return await _repository.deleteProfile(
      profileId: profileId,
      accountId: accountId,
    );
  }
}

