import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/localization/app_localizations.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/custom_button.dart';
import 'package:mobile/core/widgets/netflix_logo.dart';
import 'package:mobile/features/subscription/domain/entities/subscription_plan.dart';
import 'package:mobile/features/subscription/presentation/providers/subscription_providers.dart';

class WebSubscriptionPlanPage extends ConsumerStatefulWidget {
  const WebSubscriptionPlanPage({super.key});

  @override
  ConsumerState<WebSubscriptionPlanPage> createState() =>
      _WebSubscriptionPlanPageState();
}

class _WebSubscriptionPlanPageState
    extends ConsumerState<WebSubscriptionPlanPage> {
  SubscriptionPlan? _selectedPlan;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(subscriptionNotifierProvider.notifier).fetchPlans();
    });
  }

  void _handleSubscribe() {
    if (_selectedPlan == null) return;
    Navigator.pushNamed(context, '/payment', arguments: _selectedPlan);
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

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    return await showDialog<bool>(
          context: context,
          barrierColor: Colors.black.withValues(alpha: 0.6),
          builder: (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.leavePageTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          localizations.leavePageMessage,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: CustomButton(
                                text: localizations.stay,
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.2,
                                ),
                                style: CustomButtonStyle.flat,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomButton(
                                text: localizations.leave,
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                backgroundColor: AppColors.netflixRed,
                                style: CustomButtonStyle.flat,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionState = ref.watch(subscriptionNotifierProvider);
    final localizations = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _showExitConfirmationDialog(context);
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true, // Important for glass effect
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: _GlassAppBar(
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: SizedBox(
                    height: 25, // Reduced logo size
                    child: NetflixLogo(),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // Sign out logic
                  },
                  child: Text(
                    localizations.signOut,
                    style: const TextStyle(
                      color: Colors.white, // White text for dark navbar
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
              ],
            ),
          ),
        ),
        body: subscriptionState.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.netflixRed),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.only(
                  top: 120,
                  bottom: 40,
                  left: 24,
                  right: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1000),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizations.choosePlan,
                              style: const TextStyle(
                                color: AppColors.netflixBlack,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              localizations.choosePlanSubtitle,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 40),

                            // Plan Cards
                            if (subscriptionState.plans.isNotEmpty)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: subscriptionState.plans
                                    .where((plan) => plan.isActive)
                                    .map(
                                      (plan) => Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          child: _WebPlanCard(
                                            plan: plan,
                                            isSelected:
                                                _selectedPlan?.id == plan.id,
                                            planColor: _getPlanColor(plan),
                                            onTap: () {
                                              setState(() {
                                                _selectedPlan = plan;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),

                            const SizedBox(height: 40),

                            Center(
                              child: SizedBox(
                                width: 400,
                                height: 64,
                                child: CustomButton(
                                  text: localizations.subscribe,
                                  onPressed: _selectedPlan != null
                                      ? _handleSubscribe
                                      : null,
                                  backgroundColor: _selectedPlan != null
                                      ? AppColors
                                            .netflixRed // Always red when active
                                      : AppColors.netflixGray,
                                  style: CustomButtonStyle.flat,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _GlassAppBar extends StatelessWidget {
  final Widget child;

  const _GlassAppBar({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), // Increased blur
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.8), // Darker background
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withValues(
                  alpha: 0.2,
                ), // Silver/Glass border
                width: 0.5,
              ),
            ),
          ),
          child: SafeArea(child: child),
        ),
      ),
    );
  }
}

class _WebPlanCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final bool isSelected;
  final Color planColor;
  final VoidCallback onTap;

  const _WebPlanCard({
    required this.plan,
    required this.isSelected,
    required this.planColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? planColor
                : AppColors.netflixLightGray.withValues(alpha: 0.4),
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: planColor.withValues(alpha: 0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: planColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                plan.planName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              plan.displayName,
              style: const TextStyle(
                color: AppColors.netflixBlack,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "₺${plan.monthlyPrice}/mo",
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 24),
            _FeatureRow(
              text: "${plan.videoQuality} ${localizations.videoQuality}",
              iconColor: planColor,
            ),
            const SizedBox(height: 12),
            _FeatureRow(
              text: localizations.watchOnDevices,
              iconColor: planColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String text;
  final Color iconColor;

  const _FeatureRow({required this.text, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.check, color: iconColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: AppColors.textGray, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
