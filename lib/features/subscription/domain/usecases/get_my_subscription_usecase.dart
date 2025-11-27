import 'package:mobile/features/subscription/domain/entities/subscription.dart';
import 'package:mobile/features/subscription/domain/repositories/subscription_repository_interface.dart';

/// Get My Subscription Use Case
class GetMySubscriptionUseCase {
  final SubscriptionRepositoryInterface _repository;

  GetMySubscriptionUseCase(this._repository);

  Future<Subscription?> execute() async {
    return await _repository.getMySubscription();
  }
}

