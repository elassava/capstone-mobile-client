import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/extensions/snackbar_extension.dart';
import 'package:mobile/core/localization/app_localizations.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/responsive_helper.dart';
import 'package:mobile/core/utils/page_transitions.dart';
import 'package:mobile/core/widgets/netflix_logo.dart';
import 'package:mobile/core/widgets/confirmation_dialog.dart';
import 'package:mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:mobile/features/subscription/data/datasources/subscription_remote_datasource.dart';
import 'package:mobile/features/subscription/data/models/subscription_plan_model.dart';
import 'package:mobile/features/content/presentation/pages/home_page.dart';
import 'package:mobile/features/profile/presentation/providers/profile_providers.dart';
import 'package:mobile/features/profile/presentation/providers/profile_notifier.dart';
import 'package:mobile/features/profile/presentation/pages/add_profile_page.dart';

class ProfileListPage extends ConsumerStatefulWidget {
  const ProfileListPage({super.key});

  @override
  ConsumerState<ProfileListPage> createState() => _ProfileListPageState();
}

class _ProfileListPageState extends ConsumerState<ProfileListPage> {
  // Cached values for performance
  double? _horizontalPadding;
  double? _spacing;
  AppLocalizations? _localizations;
  String? _accountId;
  int? _maxProfiles;
  bool _isEditMode = false;

  // Color palette for profile cards fallback (when icon not found)
  final List<Color> _profileColors = [
    const Color(0xFF0071EB), // Blue
    const Color(0xFFE50914), // Red
    const Color(0xFF00D474), // Green
    const Color(0xFF564D4D), // Gray
    const Color(0xFFB81D24), // Netflix Red
    const Color(0xFF0072EB), // Light Blue
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Get accountId from auth state
      final authState = ref.read(authNotifierProvider);
      if (authState.authResponse?.user != null) {
        _accountId = authState.authResponse!.user.userId;
        
        // Get maxProfiles from subscription plan
        await _loadMaxProfiles();
        
        // Fetch profiles
        if (_accountId != null) {
          await ref.read(profileNotifierProvider.notifier).fetchProfiles(_accountId!);
          
          // Set maxProfiles if available
          if (_maxProfiles != null) {
            ref.read(profileNotifierProvider.notifier).setMaxProfiles(_maxProfiles!);
          }
        }
      }
    });
  }

  Future<void> _loadMaxProfiles() async {
    try {
      // Try to get subscription and extract maxProfiles from plan
      final subscriptionRemoteDataSource = SubscriptionRemoteDataSourceImpl();
      final subscription = await subscriptionRemoteDataSource.getMySubscription();
      
      if (subscription != null) {
        // Get all plans to find the one matching subscription
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
          ref.read(profileNotifierProvider.notifier).setMaxProfiles(maxProfiles);
        }
      }
    } catch (e) {
      // If subscription fetch fails, continue without maxProfiles
      print('Failed to load maxProfiles: $e');
    }
  }

  Future<void> _handleAddProfile() async {
    if (_accountId == null) {
      context.showErrorSnackBar(_localizations?.maxProfilesReached ?? AppLocalizations.of(context)!.maxProfilesReached);
      return;
    }

    // Check if max profiles reached
    final profileState = ref.read(profileNotifierProvider);
    if (_maxProfiles != null && profileState.profiles.length >= _maxProfiles!) {
      context.showErrorSnackBar(
        _localizations?.maxProfilesReached ?? AppLocalizations.of(context)!.maxProfilesReached,
      );
      return;
    }

    // Navigate to add profile page
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProfilePage(accountId: _accountId!),
      ),
    );

    // Refresh profiles if a profile was created
    if (result == true && _accountId != null) {
      await ref.read(profileNotifierProvider.notifier).fetchProfiles(_accountId!);
    }
  }

  Future<void> _handleDeleteProfile(String profileId, String profileName) async {
    if (_accountId == null) {
      context.showErrorSnackBar('User not found');
      return;
    }

    final profileState = ref.read(profileNotifierProvider);
    
    // Check if this is the last profile
    if (profileState.profiles.length <= 1) {
      context.showErrorSnackBar(
        _localizations?.cannotDeleteLastProfile ?? 
        AppLocalizations.of(context)!.cannotDeleteLastProfile,
      );
      return;
    }

    // Show confirmation dialog
    final confirmed = await ConfirmationDialog.show(
      context,
      title: _localizations?.confirmDeleteProfile ?? 
          AppLocalizations.of(context)!.confirmDeleteProfile,
      message: '${_localizations?.confirmDeleteProfileMessage ?? AppLocalizations.of(context)!.confirmDeleteProfileMessage}\n\n$profileName',
      confirmText: _localizations?.delete ?? AppLocalizations.of(context)!.delete,
      cancelText: _localizations?.cancel ?? AppLocalizations.of(context)!.cancel,
      confirmColor: AppColors.netflixRed,
      icon: Icons.delete_outline,
    );

    if (confirmed == true && _accountId != null) {
      await ref.read(profileNotifierProvider.notifier).deleteProfile(
            profileId: profileId,
            accountId: _accountId!,
          );
      
      // Refresh profiles after deletion
      await ref.read(profileNotifierProvider.notifier).fetchProfiles(_accountId!);
    }
  }

  String _getAvatarPath(int index) {
    // Cycle through available icons: 1.png through 5.png
    final iconNumber = (index % 5) + 1;
    return 'assets/icons/$iconNumber.png';
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);
    final authState = ref.watch(authNotifierProvider);

    // Cache values on first build only
    _horizontalPadding ??= ResponsiveHelper.getResponsiveHorizontalPadding(context);
    _spacing ??= ResponsiveHelper.getResponsiveSpacing(context);
    _localizations ??= AppLocalizations.of(context)!;

    // Handle profile creation and deletion success
    ref.listen<ProfileState>(profileNotifierProvider, (previous, next) {
      if (next.isSuccess && previous?.isSuccess != true) {
        // Check if it was a deletion (profile count decreased)
        if (previous?.profiles.length != null && 
            next.profiles.length < previous!.profiles.length) {
          // Profile was deleted
          context.showSuccessSnackBar(
            _localizations?.profileDeleted ?? AppLocalizations.of(context)!.profileDeleted,
          );
          // Exit edit mode after deletion
          if (_isEditMode) {
            setState(() {
              _isEditMode = false;
            });
          }
        } else {
          // Profile was created
          context.showSuccessSnackBar(
            _localizations?.profileCreated ?? AppLocalizations.of(context)!.profileCreated,
          );
        }
      } else if (next.error != null && next.error!.isNotEmpty) {
        final errorMessage = next.error!;
        if (errorMessage.toLowerCase().contains('last profile') || 
            errorMessage.toLowerCase().contains('cannot delete')) {
          context.showErrorSnackBar(
            _localizations?.cannotDeleteLastProfile ?? 
            AppLocalizations.of(context)!.cannotDeleteLastProfile,
          );
        } else {
          context.showErrorSnackBar(errorMessage);
        }
      }
    });

    // Get accountId if not set
    if (_accountId == null && authState.authResponse?.user != null) {
      _accountId = authState.authResponse!.user.userId;
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 400;

    return Scaffold(
      backgroundColor: AppColors.netflixBlack,
      body: SafeArea(
        child: Stack(
          children: [
            // Solid black background
            Container(
              color: AppColors.netflixBlack,
            ),

            // Content
            Column(
              children: [
                // Top spacing
                SizedBox(height: screenHeight * 0.04),

                // Netflix Logo (centered) and Edit Icon (right)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: _horizontalPadding!),
                  child: Stack(
                    children: [
                      // Netflix Logo (centered)
                      const Center(
                        child: NetflixLogo(),
                      ),
                      // Edit Icon (right)
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return RotationTransition(
                                turns: Tween<double>(
                                  begin: 0.0,
                                  end: 0.5,
                                ).animate(CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeInOut,
                                )),
                                child: ScaleTransition(
                                  scale: Tween<double>(
                                    begin: 0.8,
                                    end: 1.0,
                                  ).animate(CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOutBack,
                                  )),
                                  child: FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                                ),
                              );
                            },
                            child: Icon(
                              _isEditMode ? Icons.close : Icons.edit_outlined,
                              key: ValueKey<bool>(_isEditMode),
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _isEditMode = !_isEditMode;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),

                // "Who's Watching?" Title
                Center(
                  child: Text(
                    _localizations!.whosWatching,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 26 : 32,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.06),

                // Profiles Section
                Expanded(
                  child: profileState.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.netflixRed,
                          ),
                        )
                      : profileState.profiles.isEmpty
                          ? _buildEmptyState(screenHeight)
                          : _buildProfilesList(profileState, screenWidth, isSmallScreen, screenHeight),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(double screenHeight) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final padding = _horizontalPadding! * 2;
    final spacing = isSmallScreen ? 16.0 : 20.0;
    final cardSize = ((screenWidth - padding - spacing) / 2).clamp(120.0, 180.0);

    return Center(
      child: _buildAddProfileCard(cardSize),
    );
  }

  Widget _buildProfilesList(
    ProfileState profileState,
    double screenWidth,
    bool isSmallScreen,
    double screenHeight,
  ) {
    final profiles = profileState.profiles;
    final profileCount = profiles.length;
    final showAddCard = _maxProfiles == null || profiles.length < _maxProfiles!;
    final totalItems = profileCount + (showAddCard ? 1 : 0);
    
    // Calculate card size - Netflix style: fixed size squares
    final padding = _horizontalPadding! * 2;
    final spacing = isSmallScreen ? 16.0 : 20.0;
    double cardSize;
    
    if (totalItems <= 4) {
      cardSize = ((screenWidth - padding - spacing) / 2).clamp(120.0, 180.0);
    } else {
      cardSize = ((screenWidth - padding - spacing) / 2).clamp(100.0, 150.0);
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: _horizontalPadding!),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Profile Grid (2 columns)
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: spacing,
              runSpacing: spacing,
              children: [
                // Existing Profiles
                ...profiles.map((profile) => _buildProfileCard(
                      profile,
                      cardSize,
                      profiles.indexOf(profile),
                      isEditMode: _isEditMode,
                      onTap: () {
                        if (!_isEditMode) {
                          // Navigate to home page with selected profile
                          Navigator.pushReplacement(
                            context,
                            SlideFadePageRoute(
                              child: const HomePage(),
                            ),
                          );
                        }
                      },
                      onDelete: () {
                        _handleDeleteProfile(profile.id, profile.profileName);
                      },
                    )),
              ],
            ),
          ),
          
          // Add Profile Card (centered below grid if there's space)
          if (showAddCard)
            Padding(
              padding: EdgeInsets.only(top: spacing),
              child: _buildAddProfileCard(cardSize),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(
    profile,
    double cardSize,
    int index, {
    bool isEditMode = false,
    VoidCallback? onTap,
    VoidCallback? onDelete,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Column(
            children: [
              // Square card with rounded corners (Netflix style)
              Container(
                width: cardSize,
                height: cardSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty
                      ? Image.network(
                          profile.avatarUrl!,
                          width: cardSize,
                          height: cardSize,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildAvatarIcon(cardSize, index);
                          },
                        )
                      : _buildAvatarIcon(cardSize, index),
                ),
              ),
              SizedBox(height: 12),
              // Profile Name
              SizedBox(
                width: cardSize,
                child: Text(
                  profile.profileName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          // Delete button (shown in edit mode with animation)
          if (onDelete != null)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              top: isEditMode ? 4 : -40,
              right: isEditMode ? 4 : -40,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: isEditMode ? 1.0 : 0.0,
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutBack,
                  scale: isEditMode ? 1.0 : 0.5,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onDelete,
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.netflixRed,
                              AppColors.netflixRed.withValues(alpha: 0.85),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.netflixRed.withValues(alpha: 0.5),
                              blurRadius: 12,
                              spreadRadius: 0,
                              offset: const Offset(0, 4),
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.4),
                              blurRadius: 8,
                              spreadRadius: -2,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.25),
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatarIcon(double cardSize, int index) {
    final avatarPath = _getAvatarPath(index);

    return Image.asset(
      avatarPath,
      width: cardSize,
      height: cardSize,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to default smiley if icon not found
        final backgroundColor = _profileColors[index % _profileColors.length];
        return Container(
          width: cardSize,
          height: cardSize,
          color: backgroundColor,
          child: _buildDefaultSmiley(cardSize * 0.5),
        );
      },
    );
  }

  Widget _buildDefaultSmiley(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Stack(
        children: [
          // Eyes
          Positioned(
            left: size * 0.25,
            top: size * 0.35,
            child: Container(
              width: size * 0.08,
              height: size * 0.08,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            right: size * 0.25,
            top: size * 0.35,
            child: Container(
              width: size * 0.08,
              height: size * 0.08,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
            ),
          ),
          // Mouth (smile)
          Positioned(
            left: size * 0.25,
            top: size * 0.5,
            right: size * 0.25,
            child: Container(
              height: size * 0.15,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(size * 0.25),
                  bottomRight: Radius.circular(size * 0.25),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddProfileCard(double cardSize) {
    return GestureDetector(
      onTap: _handleAddProfile,
      child: Column(
        children: [
          // Add Profile Square Card (Netflix style)
          Container(
            width: cardSize,
            height: cardSize,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.add,
                size: cardSize * 0.4,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ),
          SizedBox(height: 12),
          // "Add Profile" Text
          SizedBox(
            width: cardSize,
            child: Text(
              _localizations!.addProfile,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
