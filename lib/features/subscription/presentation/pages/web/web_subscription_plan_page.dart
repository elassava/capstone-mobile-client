import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/localization/app_localizations.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/web_responsive.dart';
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
    final scaler = context.responsive;
    
    return await showDialog<bool>(
          context: context,
          barrierColor: Colors.black.withValues(alpha: 0.6),
          builder: (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: scaler.borderRadius(8),
              ),
              backgroundColor: Colors.transparent,
              child: ClipRRect(
                borderRadius: scaler.borderRadius(8),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: scaler.w(400)),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.75),
                      borderRadius: scaler.borderRadius(8),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                    padding: scaler.padding(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.leavePageTitle,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: scaler.sp(20),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        scaler.verticalSpace(12),
                        Text(
                          localizations.leavePageMessage,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: scaler.sp(14),
                          ),
                        ),
                        scaler.verticalSpace(24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: CustomButton(
                                text: localizations.stay,
                                onPressed: () => Navigator.of(context).pop(false),
                                backgroundColor: Colors.white.withValues(alpha: 0.2),
                                style: CustomButtonStyle.flat,
                                fontSize: scaler.sp(16),
                              ),
                            ),
                            scaler.horizontalSpace(12),
                            Expanded(
                              child: CustomButton(
                                text: localizations.leave,
                                onPressed: () => Navigator.of(context).pop(true),
                                backgroundColor: AppColors.netflixRed,
                                style: CustomButtonStyle.flat,
                                fontSize: scaler.sp(16),
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
    final scaler = context.responsive;

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
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(scaler.h(80)),
          child: _GlassAppBar(
            child: Row(
              children: [
                Padding(
                  padding: scaler.padding(24),
                  child: SizedBox(
                    height: scaler.h(25),
                    child: const NetflixLogo(),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    localizations.signOut,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: scaler.sp(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                scaler.horizontalSpace(24),
              ],
            ),
          ),
        ),
        body: subscriptionState.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.netflixRed),
              )
            : SingleChildScrollView(
                padding: scaler.paddingOnly(
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
                        constraints: BoxConstraints(maxWidth: scaler.w(1000)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizations.choosePlan,
                              style: TextStyle(
                                color: AppColors.netflixBlack,
                                fontSize: scaler.sp(32),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            scaler.verticalSpace(16),
                            Text(
                              localizations.choosePlanSubtitle,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: scaler.sp(18),
                              ),
                            ),
                            scaler.verticalSpace(40),

                            // Plan Cards
                            if (subscriptionState.plans.isNotEmpty)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: subscriptionState.plans
                                    .where((plan) => plan.isActive)
                                    .map(
                                      (plan) => Expanded(
                                        child: Padding(
                                          padding: scaler.paddingSymmetric(horizontal: 8),
                                          child: _WebPlanCard(
                                            plan: plan,
                                            isSelected: _selectedPlan?.id == plan.id,
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

                            scaler.verticalSpace(40),

                            Center(
                              child: SizedBox(
                                width: scaler.w(400),
                                height: scaler.h(64),
                                child: CustomButton(
                                  text: localizations.subscribe,
                                  onPressed: _selectedPlan != null ? _handleSubscribe : null,
                                  backgroundColor: _selectedPlan != null
                                      ? AppColors.netflixRed
                                      : AppColors.netflixGray,
                                  style: CustomButtonStyle.flat,
                                  fontSize: scaler.sp(24),
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
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.8),
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.2),
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
    final scaler = context.responsive;
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: scaler.padding(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: scaler.borderRadius(12),
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
                    blurRadius: scaler.s(15),
                    offset: Offset(0, scaler.h(8)),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: scaler.s(5),
                    offset: Offset(0, scaler.h(2)),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: scaler.paddingSymmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: planColor,
                borderRadius: scaler.borderRadius(4),
              ),
              child: Text(
                plan.planName,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: scaler.sp(14),
                ),
              ),
            ),
            scaler.verticalSpace(16),
            Text(
              plan.displayName,
              style: TextStyle(
                color: AppColors.netflixBlack,
                fontSize: scaler.sp(24),
                fontWeight: FontWeight.bold,
              ),
            ),
            scaler.verticalSpace(8),
            Text(
              "₺${plan.monthlyPrice}/mo",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: scaler.sp(18),
              ),
            ),
            scaler.verticalSpace(24),
            _FeatureRow(
              text: "${plan.videoQuality} ${localizations.videoQuality}",
              iconColor: planColor,
            ),
            scaler.verticalSpace(12),
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
    final scaler = context.responsive;
    
    return Row(
      children: [
        Icon(Icons.check, color: iconColor, size: scaler.s(20)),
        scaler.horizontalSpace(12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.textGray,
              fontSize: scaler.sp(14),
            ),
          ),
        ),
      ],
    );
  }
}
