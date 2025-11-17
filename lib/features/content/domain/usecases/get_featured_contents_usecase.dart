import '../entities/content.dart';
import '../repositories/content_repository_interface.dart';

class GetFeaturedContentsUseCase {
  final ContentRepositoryInterface repository;

  GetFeaturedContentsUseCase(this.repository);

  Future<List<Content>> call() async {
    return await repository.getFeaturedContents();
  }
}



