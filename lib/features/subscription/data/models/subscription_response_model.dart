import '../../domain/entities/subscription.dart';

/// Subscription Response Model (DTO) - Extends Subscription entity
class SubscriptionResponseModel extends Subscription {
  SubscriptionResponseModel({
    required super.id,
    required super.planName,
    required super.status,
    required super.billingCycle,
    required super.startDate,
    required super.endDate,
    super.cancelledAt,
  });

  /// Convert JSON to SubscriptionResponseModel
  factory SubscriptionResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      // Backend response'da planName plan objesi içinde nested geliyor
      String planName;
      if (json.containsKey('plan') && json['plan'] is Map<String, dynamic>) {
        final plan = json['plan'] as Map<String, dynamic>;
        planName = plan['planName'] as String? ?? '';
      } else {
        // Fallback: eğer direkt planName varsa onu kullan
        planName = json['planName'] as String? ?? '';
      }
      
      // Parse dates safely
      DateTime? parseDateTime(dynamic value) {
        if (value == null) return null;
        if (value is String) {
          try {
            return DateTime.parse(value);
          } catch (e) {
            return null;
          }
        }
        return null;
      }
      
      return SubscriptionResponseModel(
        id: json['id'] as int,
        planName: planName,
        status: json['status'] as String? ?? 'ACTIVE',
        billingCycle: json['billingCycle'] as String? ?? 'MONTHLY',
        startDate: parseDateTime(json['startDate']) ?? DateTime.now(),
        endDate: parseDateTime(json['endDate']) ?? DateTime.now().add(const Duration(days: 30)),
        cancelledAt: parseDateTime(json['cancelledAt']),
      );
    } catch (e) {
      throw Exception('Failed to parse subscription response: $e. JSON: $json');
    }
  }

  /// Convert SubscriptionResponseModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'planName': planName,
      'status': status,
      'billingCycle': billingCycle,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'cancelledAt': cancelledAt?.toIso8601String(),
    };
  }
}

