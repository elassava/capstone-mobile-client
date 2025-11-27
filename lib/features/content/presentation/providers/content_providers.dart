import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/content/data/datasources/content_remote_datasource.dart';
import 'package:mobile/features/content/data/repositories/content_repository.dart';
import 'package:mobile/features/content/domain/usecases/get_all_contents_usecase.dart';
import 'package:mobile/features/content/domain/usecases/get_featured_contents_usecase.dart';
import 'package:mobile/features/content/domain/usecases/get_contents_by_type_usecase.dart';
import 'package:mobile/features/content/presentation/providers/content_notifier.dart';

// Data Source Provider
final contentRemoteDataSourceProvider = Provider<ContentRemoteDataSource>((ref) {
  return ContentRemoteDataSourceImpl();
});

// Repository Provider
final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  final remoteDataSource = ref.watch(contentRemoteDataSourceProvider);
  return ContentRepository(remoteDataSource);
});

// Use Case Providers
final getAllContentsUseCaseProvider = Provider<GetAllContentsUseCase>((ref) {
  final repository = ref.watch(contentRepositoryProvider);
  return GetAllContentsUseCase(repository);
});

final getFeaturedContentsUseCaseProvider = Provider<GetFeaturedContentsUseCase>((ref) {
  final repository = ref.watch(contentRepositoryProvider);
  return GetFeaturedContentsUseCase(repository);
});

final getContentsByTypeUseCaseProvider = Provider<GetContentsByTypeUseCase>((ref) {
  final repository = ref.watch(contentRepositoryProvider);
  return GetContentsByTypeUseCase(repository);
});

// Notifier Provider
final contentNotifierProvider =
    StateNotifierProvider<ContentNotifier, ContentState>((ref) {
  final getAllContentsUseCase = ref.watch(getAllContentsUseCaseProvider);
  final getFeaturedContentsUseCase = ref.watch(getFeaturedContentsUseCaseProvider);
  final getContentsByTypeUseCase = ref.watch(getContentsByTypeUseCaseProvider);

  return ContentNotifier(
    getAllContentsUseCase,
    getFeaturedContentsUseCase,
    getContentsByTypeUseCase,
  );
});

