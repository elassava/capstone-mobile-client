import 'package:mobile/features/content/domain/entities/content.dart';
import 'package:mobile/features/content/domain/repositories/content_repository_interface.dart';

class GetContentsByTypeUseCase {
  final ContentRepositoryInterface repository;

  GetContentsByTypeUseCase(this.repository);

  Future<List<Content>> call(String contentType) async {
    return await repository.getContentsByType(contentType);
  }
}



