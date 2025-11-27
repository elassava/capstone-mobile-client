import 'package:mobile/features/subscription/domain/entities/subscription_plan.dart';
import 'package:mobile/features/subscription/domain/entities/subscription.dart';
import 'package:mobile/features/subscription/domain/repositories/subscription_repository_interface.dart';
import 'package:mobile/features/subscription/data/datasources/subscription_remote_datasource.dart';
import 'package:mobile/features/subscription/data/models/subscribe_request_model.dart';

/// Subscription Repository Implementation
class SubscriptionRepository implements SubscriptionRepositoryInterface {
  final SubscriptionRemoteDataSource _remoteDataSource;

  SubscriptionRepository(this._remoteDataSource);

  @override
  Future<List<SubscriptionPlan>> getAllPlans() async {
    final models = await _remoteDataSource.getAllPlans();
    return models;
  }

  @override
  Future<Subscription?> getMySubscription() async {
    final model = await _remoteDataSource.getMySubscription();
    return model;
  }

  @override
  Future<Subscription> subscribe({
    required String planName,
    required String billingCycle,
    int? paymentMethodId,
  }) async {
    final request = SubscribeRequestModel(
      planName: planName,
      billingCycle: billingCycle,
      paymentMethodId: paymentMethodId,
    );
    final model = await _remoteDataSource.subscribe(request);
    return model;
  }
}

