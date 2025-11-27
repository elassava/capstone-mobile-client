import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/subscription/data/datasources/subscription_remote_datasource.dart';
import 'package:mobile/features/subscription/data/repositories/subscription_repository.dart';
import 'package:mobile/features/subscription/domain/repositories/subscription_repository_interface.dart';
import 'package:mobile/features/subscription/domain/usecases/get_all_plans_usecase.dart';
import 'package:mobile/features/subscription/domain/usecases/get_my_subscription_usecase.dart';
import 'package:mobile/features/subscription/domain/usecases/subscribe_usecase.dart';
import 'package:mobile/features/subscription/presentation/providers/subscription_notifier.dart';

/// Subscription Remote Data Source Provider
final subscriptionRemoteDataSourceProvider = Provider<SubscriptionRemoteDataSource>(
  (_) => SubscriptionRemoteDataSourceImpl(),
);

/// Subscription Repository Provider
final subscriptionRepositoryProvider = Provider<SubscriptionRepositoryInterface>(
  (ref) => SubscriptionRepository(
    ref.watch(subscriptionRemoteDataSourceProvider),
  ),
);

/// Get All Plans Use Case Provider
final getAllPlansUseCaseProvider = Provider<GetAllPlansUseCase>(
  (ref) => GetAllPlansUseCase(
    ref.watch(subscriptionRepositoryProvider),
  ),
);

/// Get My Subscription Use Case Provider
final getMySubscriptionUseCaseProvider = Provider<GetMySubscriptionUseCase>(
  (ref) => GetMySubscriptionUseCase(
    ref.watch(subscriptionRepositoryProvider),
  ),
);

/// Subscribe Use Case Provider
final subscribeUseCaseProvider = Provider<SubscribeUseCase>(
  (ref) => SubscribeUseCase(
    ref.watch(subscriptionRepositoryProvider),
  ),
);

/// Subscription Notifier Provider - State management for subscription
final subscriptionNotifierProvider =
    StateNotifierProvider<SubscriptionNotifier, SubscriptionState>(
  (ref) => SubscriptionNotifier(
    ref.watch(getAllPlansUseCaseProvider),
    ref.watch(getMySubscriptionUseCaseProvider),
    ref.watch(subscribeUseCaseProvider),
  ),
);

