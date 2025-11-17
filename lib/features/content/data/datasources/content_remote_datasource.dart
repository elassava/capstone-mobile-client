import '../../../../core/constants/api_constants.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/network/dio_client.dart';
import '../models/content_model.dart';

abstract class ContentRemoteDataSource {
  Future<List<ContentModel>> getAllContents();
  Future<ContentModel?> getContentById(int contentId);
  Future<List<ContentModel>> getContentsByType(String contentType);
  Future<List<ContentModel>> getFeaturedContents();
}

class ContentRemoteDataSourceImpl implements ContentRemoteDataSource {
  final DioClient _dioClient = serviceLocator.get<DioClient>();

  @override
  Future<List<ContentModel>> getAllContents() async {
    try {
      final response = await _dioClient.dio.get(
        '${ApiConstants.baseUrl}/content-management/api/contents',
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data;
        return data.map((json) => ContentModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch contents: $e');
    }
  }

  @override
  Future<ContentModel?> getContentById(int contentId) async {
    try {
      final response = await _dioClient.dio.get(
        '${ApiConstants.baseUrl}/content-management/api/contents/$contentId',
      );

      if (response.statusCode == 200 && response.data != null) {
        return ContentModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch content: $e');
    }
  }

  @override
  Future<List<ContentModel>> getContentsByType(String contentType) async {
    try {
      final response = await _dioClient.dio.get(
        '${ApiConstants.baseUrl}/content-management/api/contents/type/$contentType',
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data;
        return data.map((json) => ContentModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch contents by type: $e');
    }
  }

  @override
  Future<List<ContentModel>> getFeaturedContents() async {
    try {
      final allContents = await getAllContents();
      return allContents
          .where((content) => content.isFeatured == true && content.isPublished)
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch featured contents: $e');
    }
  }
}

