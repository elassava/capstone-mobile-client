import '../entities/content.dart';
import '../repositories/content_repository_interface.dart';

class GetAllContentsUseCase {
  final ContentRepositoryInterface repository;

  GetAllContentsUseCase(this.repository);

  Future<List<Content>> call() async {
    return await repository.getAllContents();
  }
}



