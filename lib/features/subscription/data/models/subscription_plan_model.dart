import '../../domain/entities/subscription_plan.dart';

/// Subscription Plan Model (DTO) - Extends SubscriptionPlan entity
class SubscriptionPlanModel extends SubscriptionPlan {
  SubscriptionPlanModel({
    required super.id,
    required super.planName,
    required super.displayName,
    required super.description,
    required super.monthlyPrice,
    required super.yearlyPrice,
    required super.maxScreens,
    required super.maxProfiles,
    required super.videoQuality,
    required super.downloadAvailable,
    required super.adsIncluded,
    required super.isActive,
  });

  /// Convert JSON to SubscriptionPlanModel
  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      id: json['id'] as int,
      planName: json['planName'] as String,
      displayName: json['displayName'] as String,
      description: json['description'] as String? ?? '',
      monthlyPrice: (json['monthlyPrice'] as num).toDouble(),
      yearlyPrice: (json['yearlyPrice'] as num).toDouble(),
      maxScreens: json['maxScreens'] as int,
      maxProfiles: json['maxProfiles'] as int,
      videoQuality: json['videoQuality'] as String,
      downloadAvailable: json['downloadAvailable'] as bool,
      adsIncluded: json['adsIncluded'] as bool,
      isActive: json['isActive'] as bool,
    );
  }

  /// Convert SubscriptionPlanModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'planName': planName,
      'displayName': displayName,
      'description': description,
      'monthlyPrice': monthlyPrice,
      'yearlyPrice': yearlyPrice,
      'maxScreens': maxScreens,
      'maxProfiles': maxProfiles,
      'videoQuality': videoQuality,
      'downloadAvailable': downloadAvailable,
      'adsIncluded': adsIncluded,
      'isActive': isActive,
    };
  }
}

