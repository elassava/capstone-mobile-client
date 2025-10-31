import '../entities/profile.dart';
import '../repositories/profile_repository_interface.dart';

/// Get Profiles Use Case
class GetProfilesUseCase {
  final ProfileRepositoryInterface _repository;

  GetProfilesUseCase(this._repository);

  Future<List<Profile>> execute(int accountId) async {
    return await _repository.getProfilesByAccountId(accountId);
  }
}

