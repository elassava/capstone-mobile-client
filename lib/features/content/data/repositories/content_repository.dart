import '../../domain/entities/content.dart';
import '../../domain/repositories/content_repository_interface.dart';
import '../datasources/content_remote_datasource.dart';

class ContentRepository implements ContentRepositoryInterface {
  final ContentRemoteDataSource _remoteDataSource;

  ContentRepository(this._remoteDataSource);

  @override
  Future<List<Content>> getAllContents() async {
    final models = await _remoteDataSource.getAllContents();
    return models.cast<Content>();
  }

  @override
  Future<Content?> getContentById(int contentId) async {
    final model = await _remoteDataSource.getContentById(contentId);
    return model;
  }

  @override
  Future<List<Content>> getContentsByType(String contentType) async {
    final models = await _remoteDataSource.getContentsByType(contentType);
    return models.cast<Content>();
  }

  @override
  Future<List<Content>> getFeaturedContents() async {
    final models = await _remoteDataSource.getFeaturedContents();
    return models.cast<Content>();
  }
}

