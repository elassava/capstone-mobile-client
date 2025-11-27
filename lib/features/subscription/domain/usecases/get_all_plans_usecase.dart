import 'package:mobile/features/subscription/domain/entities/subscription_plan.dart';
import 'package:mobile/features/subscription/domain/repositories/subscription_repository_interface.dart';

/// Get All Plans Use Case
class GetAllPlansUseCase {
  final SubscriptionRepositoryInterface _repository;

  GetAllPlansUseCase(this._repository);

  Future<List<SubscriptionPlan>> execute() async {
    return await _repository.getAllPlans();
  }
}

