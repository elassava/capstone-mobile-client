import '../entities/subscription.dart';
import '../repositories/subscription_repository_interface.dart';

/// Subscribe Use Case
class SubscribeUseCase {
  final SubscriptionRepositoryInterface _repository;

  SubscribeUseCase(this._repository);

  Future<Subscription> execute({
    required String planName,
    required String billingCycle,
    int? paymentMethodId,
  }) async {
    return await _repository.subscribe(
      planName: planName,
      billingCycle: billingCycle,
      paymentMethodId: paymentMethodId,
    );
  }
}

