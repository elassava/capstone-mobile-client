import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:mobile/features/profile/data/repositories/profile_repository.dart';
import 'package:mobile/features/profile/domain/repositories/profile_repository_interface.dart';
import 'package:mobile/features/profile/domain/usecases/get_profiles_usecase.dart';
import 'package:mobile/features/profile/domain/usecases/create_profile_usecase.dart';
import 'package:mobile/features/profile/domain/usecases/delete_profile_usecase.dart';
import 'package:mobile/features/profile/presentation/providers/profile_notifier.dart';

/// Profile Remote Data Source Provider
final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>(
  (_) => ProfileRemoteDataSourceImpl(),
);

/// Profile Repository Provider
final profileRepositoryProvider = Provider<ProfileRepositoryInterface>(
  (ref) => ProfileRepository(
    ref.watch(profileRemoteDataSourceProvider),
  ),
);

/// Get Profiles Use Case Provider
final getProfilesUseCaseProvider = Provider<GetProfilesUseCase>(
  (ref) => GetProfilesUseCase(
    ref.watch(profileRepositoryProvider),
  ),
);

/// Create Profile Use Case Provider
final createProfileUseCaseProvider = Provider<CreateProfileUseCase>(
  (ref) => CreateProfileUseCase(
    ref.watch(profileRepositoryProvider),
  ),
);

/// Delete Profile Use Case Provider
final deleteProfileUseCaseProvider = Provider<DeleteProfileUseCase>(
  (ref) => DeleteProfileUseCase(
    ref.watch(profileRepositoryProvider),
  ),
);

/// Profile Notifier Provider - State management for profiles
final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>(
  (ref) => ProfileNotifier(
    ref.watch(getProfilesUseCaseProvider),
    ref.watch(createProfileUseCaseProvider),
    ref.watch(deleteProfileUseCaseProvider),
  ),
);

