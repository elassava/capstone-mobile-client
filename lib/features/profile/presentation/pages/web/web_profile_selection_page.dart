import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/extensions/snackbar_extension.dart';
import 'package:mobile/core/localization/app_localizations.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/web_responsive.dart';
import 'package:mobile/core/utils/error_handler.dart';
import 'package:mobile/core/widgets/netflix_logo.dart';
import 'package:mobile/core/widgets/confirmation_dialog.dart';
import 'package:mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:mobile/features/subscription/data/datasources/subscription_remote_datasource.dart';
import 'package:mobile/features/subscription/data/models/subscription_plan_model.dart';
import 'package:mobile/features/profile/presentation/providers/profile_providers.dart';
import 'package:mobile/features/profile/presentation/providers/profile_notifier.dart';
import 'package:mobile/features/profile/presentation/pages/web/web_add_profile_page.dart';
import 'package:mobile/features/content/presentation/pages/web/web_home_page.dart';

class WebProfileSelectionPage extends ConsumerStatefulWidget {
  const WebProfileSelectionPage({super.key});

  @override
  ConsumerState<WebProfileSelectionPage> createState() =>
      _WebProfileSelectionPageState();
}

class _WebProfileSelectionPageState
    extends ConsumerState<WebProfileSelectionPage> {
  int? _accountId;
  int? _maxProfiles;
  bool _isEditMode = false;

  final List<Color> _profileColors = [
    const Color(0xFF0071EB),
    const Color(0xFFE50914),
    const Color(0xFF00D474),
    const Color(0xFF564D4D),
    const Color(0xFFB81D24),
    const Color(0xFF0072EB),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authState = ref.read(authNotifierProvider);
      if (authState.authResponse?.user != null) {
        _accountId = authState.authResponse!.user.userId;
        await _loadMaxProfiles();
        if (_accountId != null) {
          await ref
              .read(profileNotifierProvider.notifier)
              .fetchProfiles(_accountId!);
          if (_maxProfiles != null) {
            ref
                .read(profileNotifierProvider.notifier)
                .setMaxProfiles(_maxProfiles!);
          }
        }
      }
    });
  }

  Future<void> _loadMaxProfiles() async {
    try {
      final subscriptionRemoteDataSource = SubscriptionRemoteDataSourceImpl();
      final subscription = await subscriptionRemoteDataSource
          .getMySubscription();

      if (subscription != null) {
        final allPlans = await subscriptionRemoteDataSource.getAllPlans();
        SubscriptionPlanModel? matchingPlan;
        try {
          matchingPlan = allPlans.firstWhere(
            (plan) => plan.planName == subscription.planName,
          );
        } catch (e) {
          if (allPlans.isNotEmpty) {
            matchingPlan = allPlans.first;
          }
        }

        if (matchingPlan != null) {
          final maxProfiles = matchingPlan.maxProfiles;
          setState(() {
            _maxProfiles = maxProfiles;
          });
          ref
              .read(profileNotifierProvider.notifier)
              .setMaxProfiles(maxProfiles);
        }
      }
    } catch (e) {
      debugPrint('Failed to load maxProfiles: $e');
    }
  }

  Future<void> _handleAddProfile() async {
    final localizations = AppLocalizations.of(context)!;
    if (_accountId == null) {
      context.showErrorSnackBar(localizations.maxProfilesReached);
      return;
    }

    final profileState = ref.read(profileNotifierProvider);
    if (_maxProfiles != null && profileState.profiles.length >= _maxProfiles!) {
      context.showErrorSnackBar(localizations.maxProfilesReached);
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebAddProfilePage(accountId: _accountId!),
      ),
    );

    if (result == true && _accountId != null) {
      await ref
          .read(profileNotifierProvider.notifier)
          .fetchProfiles(_accountId!);
    }
  }

  Future<void> _handleDeleteProfile(int profileId, String profileName) async {
    final localizations = AppLocalizations.of(context)!;
    if (_accountId == null) return;

    final profileState = ref.read(profileNotifierProvider);

    if (profileState.profiles.length <= 1) {
      context.showErrorSnackBar(localizations.cannotDeleteLastProfile);
      return;
    }

    final confirmed = await ConfirmationDialog.show(
      context,
      title: localizations.confirmDeleteProfile,
      message: '${localizations.confirmDeleteProfileMessage}\n\n$profileName',
      confirmText: localizations.delete,
      cancelText: localizations.cancel,
      confirmColor: AppColors.netflixRed,
      icon: Icons.delete_outline,
    );

    if (confirmed == true && _accountId != null) {
      await ref
          .read(profileNotifierProvider.notifier)
          .deleteProfile(profileId: profileId, accountId: _accountId!);
      await ref
          .read(profileNotifierProvider.notifier)
          .fetchProfiles(_accountId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);
    final localizations = AppLocalizations.of(context)!;
    final scaler = context.responsive;

    ref.listen<ProfileState>(profileNotifierProvider, (previous, next) {
      if (next.isSuccess && previous?.isSuccess != true) {
        if (previous?.profiles.length != null &&
            next.profiles.length < previous!.profiles.length) {
          context.showSuccessSnackBar(localizations.profileDeleted);
          if (profileState.profiles.isEmpty && _isEditMode) {
            setState(() => _isEditMode = false);
          }
        } else {
          context.showSuccessSnackBar(localizations.profileCreated);
        }
      } else if (next.error != null && next.error!.isNotEmpty) {
        context.showErrorSnackBar(
          ErrorHandler.getLocalizedErrorMessage(context, next.error),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.netflixBlack,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  AppColors.netflixDarkGray.withValues(alpha: 0.3),
                  AppColors.netflixBlack,
                ],
              ),
            ),
          ),

          Column(
            children: [
              // Navbar
              Padding(
                padding: scaler.paddingSymmetric(horizontal: 48, vertical: 24),
                child: Row(
                  children: [
                    SizedBox(height: scaler.h(35), child: const NetflixLogo()),
                    const Spacer(),
                  ],
                ),
              ),

              Expanded(
                child: Center(
                  child: profileState.isLoading
                      ? const CircularProgressIndicator(
                          color: AppColors.netflixRed,
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              localizations.whosWatching,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: scaler.sp(48),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            scaler.verticalSpace(48),

                            // Profiles Grid
                            Wrap(
                              spacing: scaler.w(32),
                              runSpacing: scaler.h(32),
                              alignment: WrapAlignment.center,
                              children: [
                                ...profileState.profiles.asMap().entries.map((
                                  entry,
                                ) {
                                  final index = entry.key;
                                  final profile = entry.value;
                                  return _WebProfileCard(
                                    profile: profile,
                                    index: index,
                                    isEditMode: _isEditMode,
                                    onTap: () {
                                      if (_isEditMode) {
                                        // Edit profile logic
                                      } else {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const WebHomePage(),
                                          ),
                                        );
                                      }
                                    },
                                    onDelete: () => _handleDeleteProfile(
                                      profile.id,
                                      profile.profileName,
                                    ),
                                    color:
                                        _profileColors[index %
                                            _profileColors.length],
                                  );
                                }),
                                if (_maxProfiles == null ||
                                    profileState.profiles.length <
                                        _maxProfiles!)
                                  _WebAddProfileCard(onTap: _handleAddProfile),
                              ],
                            ),

                            scaler.verticalSpace(80),

                            // Manage Profiles Button
                            OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _isEditMode = !_isEditMode;
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                padding: scaler.paddingSymmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              child: Text(
                                _isEditMode
                                    ? localizations.done
                                    : localizations.manageProfiles,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: scaler.sp(18),
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WebProfileCard extends StatefulWidget {
  final dynamic profile;
  final int index;
  final bool isEditMode;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final Color color;

  const _WebProfileCard({
    required this.profile,
    required this.index,
    required this.isEditMode,
    required this.onTap,
    required this.onDelete,
    required this.color,
  });

  @override
  State<_WebProfileCard> createState() => _WebProfileCardState();
}

class _WebProfileCardState extends State<_WebProfileCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getAvatarPath(int index) {
    final iconNumber = (index % 5) + 1;
    return 'assets/icons/$iconNumber.png';
  }

  @override
  Widget build(BuildContext context) {
    final scaler = context.responsive;
    final cardSize = scaler.s(160);

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: cardSize,
                    height: cardSize,
                    decoration: BoxDecoration(
                      borderRadius: scaler.borderRadius(4),
                      border: _isHovered && !widget.isEditMode
                          ? Border.all(color: Colors.white, width: scaler.s(3))
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius: scaler.borderRadius(4),
                      child:
                          widget.profile.avatarUrl != null &&
                              widget.profile.avatarUrl!.isNotEmpty
                          ? Image.network(
                              widget.profile.avatarUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _buildPlaceholder(),
                            )
                          : _buildPlaceholder(),
                    ),
                  ),
                ),

                // Edit Overlay
                if (widget.isEditMode)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: scaler.borderRadius(4),
                      ),
                      child: Center(
                        child: Container(
                          padding: scaler.padding(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: scaler.s(2),
                            ),
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: scaler.s(24),
                          ),
                        ),
                      ),
                    ),
                  ),

                // Delete Button
                if (widget.isEditMode)
                  Positioned(
                    top: scaler.h(-10),
                    right: scaler.w(-10),
                    child: GestureDetector(
                      onTap: widget.onDelete,
                      child: Container(
                        padding: scaler.padding(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: scaler.s(16),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            scaler.verticalSpace(12),
            Text(
              widget.profile.profileName,
              style: TextStyle(
                color: _isHovered ? Colors.white : Colors.grey,
                fontSize: scaler.sp(18),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    final scaler = context.responsive;
    return Image.asset(
      _getAvatarPath(widget.index),
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: widget.color,
        child: Icon(Icons.person, color: Colors.white, size: scaler.s(64)),
      ),
    );
  }
}

class _WebAddProfileCard extends StatefulWidget {
  final VoidCallback onTap;

  const _WebAddProfileCard({required this.onTap});

  @override
  State<_WebAddProfileCard> createState() => _WebAddProfileCardState();
}

class _WebAddProfileCardState extends State<_WebAddProfileCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scaler = context.responsive;
    final cardSize = scaler.s(160);
    final localizations = AppLocalizations.of(context)!;

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: cardSize,
                height: cardSize,
                decoration: BoxDecoration(
                  color: _isHovered ? Colors.white : Colors.transparent,
                  borderRadius: scaler.borderRadius(4),
                  border: Border.all(
                    color: _isHovered
                        ? Colors.white
                        : Colors.grey.withValues(alpha: 0.7),
                    width: scaler.s(2),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.add_circle,
                    size: scaler.s(64),
                    color: _isHovered ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ),
            scaler.verticalSpace(12),
            Text(
              localizations.addProfile,
              style: TextStyle(
                color: _isHovered ? Colors.white : Colors.grey,
                fontSize: scaler.sp(18),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
