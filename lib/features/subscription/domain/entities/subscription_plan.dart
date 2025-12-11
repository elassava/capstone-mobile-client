/// Subscription Plan Entity
class SubscriptionPlan {
  final String id;
  final String planName;
  final String displayName;
  final String description;
  final double monthlyPrice;
  final double yearlyPrice;
  final int maxScreens;
  final int maxProfiles;
  final String videoQuality;
  final bool downloadAvailable;
  final bool adsIncluded;
  final bool isActive;

  SubscriptionPlan({
    required this.id,
    required this.planName,
    required this.displayName,
    required this.description,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.maxScreens,
    required this.maxProfiles,
    required this.videoQuality,
    required this.downloadAvailable,
    required this.adsIncluded,
    required this.isActive,
  });
}

