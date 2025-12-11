import 'package:dio/dio.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/di/service_locator.dart';
import 'package:mobile/core/network/dio_client.dart';
import 'package:mobile/features/profile/data/models/profile_model.dart';
import 'package:mobile/features/profile/data/models/create_profile_request_model.dart';

/// Abstract interface for Profile Remote Data Source
abstract class ProfileRemoteDataSource {
  Future<List<ProfileModel>> getProfilesByAccountId(String accountId);
  Future<ProfileModel> createProfile(CreateProfileRequestModel request);
  Future<void> deleteProfile(String profileId, String accountId);
}

/// Implementation of Profile Remote Data Source
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio _dio;

  ProfileRemoteDataSourceImpl() : _dio = serviceLocator.get<DioClient>().dio;

  @override
  Future<List<ProfileModel>> getProfilesByAccountId(String accountId) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.getProfilesByAccountEndpoint}/$accountId',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data
            .map((json) => ProfileModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to fetch profiles: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404 || e.response?.statusCode == 200) {
        // No profiles found - return empty list (not an error)
        return [];
      }
      if (e.response != null) {
        final errorData = e.response?.data;
        final errorMessage = errorData is Map<String, dynamic>
            ? errorData['message'] ?? errorData['error'] ?? 'Failed to fetch profiles'
            : 'Failed to fetch profiles';
        throw Exception(errorMessage);
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      // If it's already an exception, rethrow
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<ProfileModel> createProfile(CreateProfileRequestModel request) async {
    try {
      final response = await _dio.post(
        ApiConstants.createProfileEndpoint,
        data: request.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ProfileModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw Exception('Failed to create profile: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response?.data;
        final errorMessage = errorData is Map<String, dynamic>
            ? errorData['message'] ?? errorData['error'] ?? 'Failed to create profile'
            : 'Failed to create profile';
        throw Exception(errorMessage);
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<void> deleteProfile(String profileId, String accountId) async {
    try {
      final response = await _dio.delete(
        '${ApiConstants.profileBasePath}/api/profiles/$profileId/account/$accountId',
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to delete profile: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response?.data;
        final errorMessage = errorData is Map<String, dynamic>
            ? errorData['message'] ?? errorData['error'] ?? 'Failed to delete profile'
            : 'Failed to delete profile';
        throw Exception(errorMessage);
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Unexpected error: $e');
    }
  }
}

