import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/network/dio_client.dart';
import '../models/subscription_plan_model.dart';
import '../models/subscription_response_model.dart';
import '../models/subscribe_request_model.dart';

/// Abstract interface for Subscription Remote Data Source
abstract class SubscriptionRemoteDataSource {
  Future<List<SubscriptionPlanModel>> getAllPlans();
  Future<SubscriptionResponseModel?> getMySubscription();
  Future<SubscriptionResponseModel> subscribe(SubscribeRequestModel request);
}

/// Implementation of Subscription Remote Data Source
class SubscriptionRemoteDataSourceImpl implements SubscriptionRemoteDataSource {
  final Dio _dio;

  SubscriptionRemoteDataSourceImpl() : _dio = serviceLocator.get<DioClient>().dio;

  @override
  Future<List<SubscriptionPlanModel>> getAllPlans() async {
    try {
      final response = await _dio.get(
        ApiConstants.subscriptionPlansEndpoint,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data
            .map((json) => SubscriptionPlanModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to fetch plans: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response?.data;
        final errorMessage = errorData is Map<String, dynamic>
            ? errorData['message'] ?? errorData['error'] ?? 'Failed to fetch plans'
            : 'Failed to fetch plans';
        throw Exception(errorMessage);
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<SubscriptionResponseModel?> getMySubscription() async {
    try {
      final response = await _dio.get(
        ApiConstants.mySubscriptionEndpoint,
      );

      if (response.statusCode == 200) {
        return SubscriptionResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw Exception('Failed to fetch subscription: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // No subscription found
        return null;
      }
      if (e.response != null) {
        final errorData = e.response?.data;
        final errorMessage = errorData is Map<String, dynamic>
            ? errorData['message'] ?? errorData['error'] ?? 'Failed to fetch subscription'
            : 'Failed to fetch subscription';
        throw Exception(errorMessage);
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<SubscriptionResponseModel> subscribe(SubscribeRequestModel request) async {
    try {
      final response = await _dio.post(
        ApiConstants.subscribeEndpoint,
        data: request.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        try {
          return SubscriptionResponseModel.fromJson(
            response.data as Map<String, dynamic>,
          );
        } catch (parseError) {
          // Parse hatası varsa daha detaylı hata mesajı
          throw Exception('Failed to parse subscription response: $parseError');
        }
      } else {
        throw Exception('Subscription failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response?.data;
        final errorMessage = errorData is Map<String, dynamic>
            ? errorData['message'] ?? errorData['error'] ?? 'Subscription failed'
            : 'Subscription failed';
        throw Exception(errorMessage);
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      // Re-throw if it's already an Exception, otherwise wrap it
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Unexpected error: $e');
    }
  }
}

