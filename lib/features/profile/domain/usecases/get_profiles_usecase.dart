import 'package:mobile/features/profile/domain/entities/profile.dart';
import 'package:mobile/features/profile/domain/repositories/profile_repository_interface.dart';

/// Get Profiles Use Case
class GetProfilesUseCase {
  final ProfileRepositoryInterface _repository;

  GetProfilesUseCase(this._repository);

  Future<List<Profile>> execute(String accountId) async {
    return await _repository.getProfilesByAccountId(accountId);
  }
}

