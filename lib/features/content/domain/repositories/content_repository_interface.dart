import 'package:mobile/features/content/domain/entities/content.dart';

abstract class ContentRepositoryInterface {
  Future<List<Content>> getAllContents();
  Future<Content?> getContentById(int contentId);
  Future<List<Content>> getContentsByType(String contentType);
  Future<List<Content>> getFeaturedContents();
}



