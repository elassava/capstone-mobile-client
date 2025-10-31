import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository.dart';
import '../../domain/repositories/profile_repository_interface.dart';
import '../../domain/usecases/get_profiles_usecase.dart';
import '../../domain/usecases/create_profile_usecase.dart';
import 'profile_notifier.dart';

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

/// Profile Notifier Provider - State management for profiles
final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>(
  (ref) => ProfileNotifier(
    ref.watch(getProfilesUseCaseProvider),
    ref.watch(createProfileUseCaseProvider),
  ),
);

