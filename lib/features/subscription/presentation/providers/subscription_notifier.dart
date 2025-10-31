import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/subscription_plan.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/usecases/get_all_plans_usecase.dart';
import '../../domain/usecases/get_my_subscription_usecase.dart';
import '../../domain/usecases/subscribe_usecase.dart';

/// Subscription State
class SubscriptionState {
  final bool isLoading;
  final List<SubscriptionPlan> plans;
  final Subscription? currentSubscription;
  final bool isSubscribing;
  final String? error;
  final bool isSuccess;

  const SubscriptionState({
    this.isLoading = false,
    this.plans = const [],
    this.currentSubscription,
    this.isSubscribing = false,
    this.error,
    this.isSuccess = false,
  });

  SubscriptionState copyWith({
    bool? isLoading,
    List<SubscriptionPlan>? plans,
    Subscription? currentSubscription,
    bool? isSubscribing,
    String? error,
    bool? isSuccess,
  }) {
    return SubscriptionState(
      isLoading: isLoading ?? this.isLoading,
      plans: plans ?? this.plans,
      currentSubscription: currentSubscription ?? this.currentSubscription,
      isSubscribing: isSubscribing ?? this.isSubscribing,
      error: error ?? this.error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

/// Subscription Notifier - Manages subscription state
class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  final GetAllPlansUseCase _getAllPlansUseCase;
  final GetMySubscriptionUseCase _getMySubscriptionUseCase;
  final SubscribeUseCase _subscribeUseCase;

  SubscriptionNotifier(
    this._getAllPlansUseCase,
    this._getMySubscriptionUseCase,
    this._subscribeUseCase,
  ) : super(const SubscriptionState());

  /// Fetch all subscription plans
  Future<void> fetchPlans() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final plans = await _getAllPlansUseCase.execute();
      state = state.copyWith(
        isLoading: false,
        plans: plans,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Check if user has an active subscription (lightweight check)
  /// Returns true if has active subscription, false otherwise
  /// This avoids unnecessary API calls when subscription doesn't exist
  Future<bool> checkHasActiveSubscription() async {
    try {
      final subscription = await _getMySubscriptionUseCase.execute();
      return subscription != null && subscription.isActive;
    } catch (e) {
      final errorMessage = e.toString().toLowerCase();
      // If it's a "not found" or "404" error, user has no subscription
      if (errorMessage.contains('not found') || 
          errorMessage.contains('404') ||
          errorMessage.contains('no active subscription')) {
        return false;
      }
      // For other errors, assume no subscription to avoid blocking user
      return false;
    }
  }

  /// Fetch current subscription
  Future<void> fetchMySubscription() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final subscription = await _getMySubscriptionUseCase.execute();
      state = state.copyWith(
        isLoading: false,
        currentSubscription: subscription,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Subscribe to a plan
  Future<void> subscribe({
    required String planName,
    required String billingCycle,
    int? paymentMethodId,
  }) async {
    state = state.copyWith(isSubscribing: true, error: null, isSuccess: false);

    try {
      final subscription = await _subscribeUseCase.execute(
        planName: planName,
        billingCycle: billingCycle,
        paymentMethodId: paymentMethodId,
      );
      state = state.copyWith(
        isSubscribing: false,
        currentSubscription: subscription,
        isSuccess: true,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isSubscribing: false,
        error: e.toString().replaceAll('Exception: ', ''),
        isSuccess: false,
      );
    }
  }

  /// Reset state
  void reset() {
    state = const SubscriptionState();
  }
}

