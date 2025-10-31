import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/repositories/auth_repository_interface.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import 'auth_notifier.dart';

/// Auth Remote Data Source Provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (_) => AuthRemoteDataSourceImpl(),
);

/// Auth Repository Provider
final authRepositoryProvider = Provider<AuthRepositoryInterface>(
  (ref) => AuthRepository(
    ref.watch(authRemoteDataSourceProvider),
  ),
);

/// Register Use Case Provider
final registerUseCaseProvider = Provider<RegisterUseCase>(
  (ref) => RegisterUseCase(
    ref.watch(authRepositoryProvider),
  ),
);

/// Login Use Case Provider
final loginUseCaseProvider = Provider<LoginUseCase>(
  (ref) => LoginUseCase(
    ref.watch(authRepositoryProvider),
  ),
);

/// Auth Notifier Provider - State management for authentication
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(
    ref.watch(registerUseCaseProvider),
    ref.watch(loginUseCaseProvider),
  ),
);

