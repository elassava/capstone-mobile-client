import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/extensions/snackbar_extension.dart';
import 'package:mobile/core/localization/app_localizations.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/responsive_helper.dart';
import 'package:mobile/core/widgets/netflix_logo.dart';
import 'package:mobile/core/widgets/custom_button.dart';
import 'package:mobile/features/subscription/domain/entities/subscription_plan.dart';
import 'package:mobile/features/subscription/presentation/providers/subscription_notifier.dart';
import 'package:mobile/features/subscription/presentation/providers/subscription_providers.dart';
import 'package:mobile/features/subscription/presentation/pages/payment_page.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/features/subscription/presentation/pages/web/web_subscription_plan_page.dart';

class SubscriptionPlanPage extends ConsumerStatefulWidget {
  const SubscriptionPlanPage({super.key});

  @override
  ConsumerState<SubscriptionPlanPage> createState() =>
      _SubscriptionPlanPageState();
}

class _SubscriptionPlanPageState extends ConsumerState<SubscriptionPlanPage> {
  String _selectedBillingCycle = 'MONTHLY'; // MONTHLY or YEARLY
  SubscriptionPlan? _selectedPlan;

  // Cached values for performance
  double? _horizontalPadding;
  double? _spacing;
  AppLocalizations? _localizations;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(subscriptionNotifierProvider.notifier).fetchPlans();
    });
  }

  void _handleSubscribe() {
    if (_selectedPlan == null) {
      context.showErrorSnackBar(
        _localizations?.subscriptionFailed ??
            AppLocalizations.of(context)!.subscriptionFailed,
      );
      return;
    }

    // Navigate to payment page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          selectedPlan: _selectedPlan!,
          billingCycle: _selectedBillingCycle,
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    return '₺${price.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  Color _getPlanColor(SubscriptionPlan plan) {
    switch (plan.planName.toUpperCase()) {
      case 'BASIC':
        return AppColors.netflixGray;
      case 'STANDARD':
        return AppColors.netflixRed;
      case 'PREMIUM':
        return Colors.amber;
      default:
        return AppColors.netflixGray;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const WebSubscriptionPlanPage();
    }

    final subscriptionState = ref.watch(subscriptionNotifierProvider);

    // Handle subscription success
    ref.listen<SubscriptionState>(subscriptionNotifierProvider, (
      previous,
      next,
    ) {
      if (next.isSuccess) {
        context.showSuccessSnackBar(
          _localizations?.subscribeSuccess ??
              AppLocalizations.of(context)!.subscribeSuccess,
        );
        // Navigate back or to home
        Navigator.of(context).pop();
      } else if (next.error != null && next.error!.isNotEmpty) {
        context.showErrorSnackBar(next.error!);
      }
    });

    // Cache values on first build only
    _horizontalPadding ??= ResponsiveHelper.getResponsiveHorizontalPadding(
      context,
    );
    _spacing ??= ResponsiveHelper.getResponsiveSpacing(context);
    _localizations ??= AppLocalizations.of(context)!;

    final horizontalPadding = _horizontalPadding!;
    final spacing = _spacing!;
    final localizations = _localizations!;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        // Prevent back navigation - user must complete subscription
        if (didPop) {
          // This should not happen, but if it does, we'll handle it
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.netflixBlack,
        body: Stack(
          children: [
            // Background with gradient
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.onboardingBackgroundGradient,
                ),
                child: Stack(
                  children: [
                    // Blur Overlay
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: Container(
                        color: AppColors.netflixBlack.withValues(alpha: 0.05),
                      ),
                    ),
                    // Dark Overlay
                    Container(
                      color: AppColors.netflixBlack.withValues(alpha: 0.85),
                    ),
                  ],
                ),
              ),
            ),
            // Content
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: spacing,
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 48), // Space for alignment
                        const Expanded(child: Center(child: NetflixLogo())),
                        const SizedBox(width: 48), // Space for alignment
                      ],
                    ),
                  ),
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: spacing * 2),
                          // Title
                          Text(
                            localizations.choosePlan,
                            style: Theme.of(context).textTheme.displaySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      ResponsiveHelper.getResponsiveFontSize(
                                        context,
                                        28,
                                      ),
                                ),
                          ),
                          SizedBox(height: spacing * 0.5),
                          // Subtitle
                          Text(
                            localizations.choosePlanSubtitle,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: AppColors.netflixLightGray,
                                  fontSize:
                                      ResponsiveHelper.getResponsiveFontSize(
                                        context,
                                        16,
                                      ),
                                ),
                          ),
                          SizedBox(height: spacing * 2),
                          // Subscription Required Info Card
                          Container(
                            padding: EdgeInsets.all(spacing * 1.5),
                            decoration: BoxDecoration(
                              color: AppColors.netflixRed.withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.netflixRed.withValues(
                                  alpha: 0.5,
                                ),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: AppColors.netflixRed,
                                  size: 24,
                                ),
                                SizedBox(width: spacing),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        localizations.subscriptionRequiredInfo,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color: AppColors.netflixWhite,
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  ResponsiveHelper.getResponsiveFontSize(
                                                    context,
                                                    16,
                                                  ),
                                            ),
                                      ),
                                      SizedBox(height: spacing * 0.5),
                                      Text(
                                        localizations
                                            .subscriptionRequiredDetail,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: AppColors.netflixLightGray,
                                              fontSize:
                                                  ResponsiveHelper.getResponsiveFontSize(
                                                    context,
                                                    14,
                                                  ),
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: spacing * 2),
                          // Billing Cycle Toggle
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.netflixDarkGray.withValues(
                                alpha: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.netflixGray,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _BillingCycleButton(
                                    label: localizations.monthly,
                                    isSelected:
                                        _selectedBillingCycle == 'MONTHLY',
                                    onTap: () {
                                      setState(() {
                                        _selectedBillingCycle = 'MONTHLY';
                                        _selectedPlan = null;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: _BillingCycleButton(
                                    label: localizations.yearly,
                                    isSelected:
                                        _selectedBillingCycle == 'YEARLY',
                                    onTap: () {
                                      setState(() {
                                        _selectedBillingCycle = 'YEARLY';
                                        _selectedPlan = null;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: spacing * 3),
                          // Plans List
                          if (subscriptionState.isLoading)
                            Center(
                              child: Padding(
                                padding: EdgeInsets.all(spacing * 4),
                                child: Column(
                                  children: [
                                    const CircularProgressIndicator(
                                      color: AppColors.netflixRed,
                                    ),
                                    SizedBox(height: spacing),
                                    Text(
                                      localizations.fetchingPlans,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppColors.netflixLightGray,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else if (subscriptionState.error != null)
                            Center(
                              child: Padding(
                                padding: EdgeInsets.all(spacing * 4),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: AppColors.netflixRed,
                                      size: 48,
                                    ),
                                    SizedBox(height: spacing),
                                    Text(
                                      subscriptionState.error!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppColors.netflixRed,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: spacing),
                                    CustomButton(
                                      text: localizations.continueButton,
                                      style: CustomButtonStyle.flat,
                                      backgroundColor: AppColors.netflixRed,
                                      foregroundColor: AppColors.netflixWhite,
                                      onPressed: () {
                                        ref
                                            .read(
                                              subscriptionNotifierProvider
                                                  .notifier,
                                            )
                                            .fetchPlans();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            ...subscriptionState.plans
                                .where((plan) => plan.isActive)
                                .map(
                                  (plan) => Padding(
                                    padding: EdgeInsets.only(bottom: spacing),
                                    child: _PlanCard(
                                      plan: plan,
                                      billingCycle: _selectedBillingCycle,
                                      isSelected: _selectedPlan?.id == plan.id,
                                      onTap: () {
                                        setState(() {
                                          _selectedPlan = plan;
                                        });
                                      },
                                      formatPrice: _formatPrice,
                                      getPlanColor: _getPlanColor,
                                      localizations: localizations,
                                    ),
                                  ),
                                ),
                          SizedBox(height: spacing * 2),
                        ],
                      ),
                    ),
                  ),
                  // Footer with Subscribe Button
                  if (!subscriptionState.isLoading &&
                      subscriptionState.error == null)
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        spacing,
                        horizontalPadding,
                        MediaQuery.of(context).padding.bottom +
                            horizontalPadding,
                      ),
                      child: Column(
                        children: [
                          CustomButton(
                            text: subscriptionState.isSubscribing
                                ? localizations.loading
                                : localizations.subscribe,
                            style: CustomButtonStyle.flat,
                            backgroundColor: _selectedPlan != null
                                ? AppColors.netflixRed
                                : AppColors.netflixGray.withValues(alpha: 0.5),
                            foregroundColor: AppColors.netflixWhite,
                            onPressed:
                                (_selectedPlan != null &&
                                    !subscriptionState.isSubscribing)
                                ? _handleSubscribe
                                : null,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BillingCycleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _BillingCycleButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.netflixRed : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.netflixWhite,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final String billingCycle;
  final bool isSelected;
  final VoidCallback onTap;
  final String Function(double) formatPrice;
  final Color Function(SubscriptionPlan) getPlanColor;
  final AppLocalizations localizations;

  const _PlanCard({
    required this.plan,
    required this.billingCycle,
    required this.isSelected,
    required this.onTap,
    required this.formatPrice,
    required this.getPlanColor,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    final price = billingCycle == 'MONTHLY'
        ? plan.monthlyPrice
        : plan.yearlyPrice;
    final pricePeriod = billingCycle == 'MONTHLY' ? '/ay' : '/yıl';
    final spacing = ResponsiveHelper.getResponsiveSpacing(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(spacing * 1.5),
        decoration: BoxDecoration(
          color: AppColors.netflixDarkGray.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? getPlanColor(plan) : AppColors.netflixGray,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plan Name and Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.displayName,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: ResponsiveHelper.getResponsiveFontSize(
                                context,
                                20,
                              ),
                            ),
                      ),
                      SizedBox(height: spacing * 0.25),
                      Row(
                        children: [
                          Text(
                            formatPrice(price),
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: getPlanColor(plan),
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      ResponsiveHelper.getResponsiveFontSize(
                                        context,
                                        18,
                                      ),
                                ),
                          ),
                          Text(
                            pricePeriod,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppColors.netflixLightGray,
                                  fontSize:
                                      ResponsiveHelper.getResponsiveFontSize(
                                        context,
                                        14,
                                      ),
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: getPlanColor(plan),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: AppColors.netflixWhite,
                      size: 20,
                    ),
                  ),
              ],
            ),
            if (plan.description.isNotEmpty) ...[
              SizedBox(height: spacing),
              Text(
                plan.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.netflixLightGray,
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
                ),
              ),
            ],
            SizedBox(height: spacing * 1.5),
            // Features
            _FeatureItem(
              icon: Icons.devices,
              text: '${plan.maxScreens} ${localizations.screens}',
            ),
            SizedBox(height: spacing * 0.5),
            _FeatureItem(
              icon: Icons.person,
              text: '${plan.maxProfiles} ${localizations.profiles}',
            ),
            SizedBox(height: spacing * 0.5),
            _FeatureItem(
              icon: Icons.high_quality,
              text: '${plan.videoQuality} ${localizations.videoQuality}',
            ),
            SizedBox(height: spacing * 0.5),
            _FeatureItem(
              icon: plan.downloadAvailable ? Icons.check : Icons.close,
              text: plan.downloadAvailable
                  ? localizations.downloadAvailable
                  : '${localizations.downloadAvailable} Yok',
              isAvailable: plan.downloadAvailable,
            ),
            SizedBox(height: spacing * 0.5),
            _FeatureItem(
              icon: plan.adsIncluded ? Icons.close : Icons.check,
              text: plan.adsIncluded
                  ? localizations.adsIncluded
                  : localizations.noAds,
              isAvailable: !plan.adsIncluded,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isAvailable;

  const _FeatureItem({
    required this.icon,
    required this.text,
    this.isAvailable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: isAvailable
              ? AppColors.netflixRed
              : AppColors.netflixLightGray.withValues(alpha: 0.5),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isAvailable
                  ? AppColors.netflixWhite
                  : AppColors.netflixLightGray.withValues(alpha: 0.5),
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 13),
            ),
          ),
        ),
      ],
    );
  }
}
