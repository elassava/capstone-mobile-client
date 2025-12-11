import 'package:mobile/features/subscription/domain/entities/subscription.dart';
import 'package:mobile/features/subscription/domain/repositories/subscription_repository_interface.dart';

/// Subscribe Use Case
class SubscribeUseCase {
  final SubscriptionRepositoryInterface _repository;

  SubscribeUseCase(this._repository);

  Future<Subscription> execute({
    required String planName,
    required String billingCycle,
    String? paymentMethodId,
  }) async {
    return await _repository.subscribe(
      planName: planName,
      billingCycle: billingCycle,
      paymentMethodId: paymentMethodId,
    );
  }
}

