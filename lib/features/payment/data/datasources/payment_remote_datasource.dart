import 'package:dio/dio.dart';
import 'package:mobile/core/constants/api_constants.dart';
import 'package:mobile/core/di/service_locator.dart';
import 'package:mobile/core/network/dio_client.dart';
import 'package:mobile/features/payment/data/models/add_payment_method_request_model.dart';
import 'package:mobile/features/payment/data/models/payment_method_response_model.dart';

/// Abstract interface for Payment Remote Data Source
abstract class PaymentRemoteDataSource {
  Future<PaymentMethodResponseModel> addPaymentMethod(AddPaymentMethodRequestModel request);
}

/// Implementation of Payment Remote Data Source
class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final Dio _dio;

  PaymentRemoteDataSourceImpl() : _dio = serviceLocator.get<DioClient>().dio;

  @override
  Future<PaymentMethodResponseModel> addPaymentMethod(AddPaymentMethodRequestModel request) async {
    try {
      final response = await _dio.post(
        ApiConstants.addPaymentMethodEndpoint,
        data: request.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return PaymentMethodResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw Exception('Failed to add payment method: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response?.data;
        final errorMessage = errorData is Map<String, dynamic>
            ? errorData['message'] ?? errorData['error'] ?? 'Failed to add payment method'
            : 'Failed to add payment method';
        throw Exception(errorMessage);
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}

