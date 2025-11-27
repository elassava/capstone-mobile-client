import 'package:mobile/features/subscription/domain/entities/subscription_plan.dart';
import 'package:mobile/features/subscription/domain/entities/subscription.dart';

/// Subscription Repository Interface
abstract class SubscriptionRepositoryInterface {
  Future<List<SubscriptionPlan>> getAllPlans();
  Future<Subscription?> getMySubscription();
  Future<Subscription> subscribe({
    required String planName,
    required String billingCycle,
    int? paymentMethodId,
  });
}

