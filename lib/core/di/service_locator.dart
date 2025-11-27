import 'package:get_it/get_it.dart';
import 'package:mobile/core/network/dio_client.dart';
import 'package:mobile/core/network/interceptors/auth_interceptor.dart';

/// Service Locator - Dependency Injection Container
/// GetIt instance singleton
final GetIt serviceLocator = GetIt.instance;

/// Initialize all dependencies
Future<void> setupServiceLocator() async {
  // Auth Interceptor (for token management) - Must be created first
  serviceLocator.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(),
  );
  
  // Network - Pass auth interceptor to Dio client
  serviceLocator.registerLazySingleton<DioClient>(
    () => DioClient(
      authInterceptor: serviceLocator<AuthInterceptor>(),
    ),
  );

  // Note: Repositories and UseCases are managed by Riverpod providers
  // Service locator is mainly for infrastructure dependencies (Dio, Interceptors, etc.)
}

/// Dispose all dependencies
Future<void> disposeServiceLocator() async {
  // Dispose Dio client
  if (serviceLocator.isRegistered<DioClient>()) {
    serviceLocator<DioClient>().dispose();
  }
  
  await serviceLocator.reset();
}

