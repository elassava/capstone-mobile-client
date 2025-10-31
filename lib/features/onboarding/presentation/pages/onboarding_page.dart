import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/widgets/netflix_logo.dart';
import '../../../../core/widgets/custom_button.dart';
import '../widgets/pagination_indicator.dart';
import '../../../../features/auth/presentation/pages/login_page.dart';
import '../../../../features/auth/presentation/pages/signup_page.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // Responsive values
    final horizontalPadding = ResponsiveHelper.getResponsiveHorizontalPadding(context);
    final verticalPadding = ResponsiveHelper.getResponsivePadding(context);
    final spacing = ResponsiveHelper.getResponsiveSpacing(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Blur and Dark Overlay
          Positioned.fill(
            child: Stack(
              children: [
                // Background Image
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/onboarding_background.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.netflixDarkGray,
                      );
                    },
                  ),
                ),
                // Blur Overlay
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    color: AppColors.netflixBlack.withValues(alpha: 0.05),
                  ),
                ),
                // Dark Overlay
                Container(
                  color: AppColors.netflixBlack.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                // Header Section
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const NetflixLogo(),
                      IconButton(
                        icon: const Icon(
                          Icons.more_vert,
                          color: AppColors.netflixWhite,
                        ),
                        onPressed: () {
                          // Menu action
                        },
                      ),
                    ],
                  ),
                ),
                // Content Section
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: spacing * 2),
                        // Welcome Ticket Image - Centered
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: screenWidth * 0.9,
                            maxHeight: screenHeight * 0.5,
                          ),
                          child: Image.asset(
                            'assets/images/onboarding_welcome.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 400,
                                height: 400,
                                color: AppColors.netflixDarkGray,
                              );
                            },
                          ),
                        ),
                        SizedBox(height: spacing * 2),
                        // Main Title
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                          child: Text(
                            localizations.onboardingTitle,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 24),
                                ),
                          ),
                        ),
                        SizedBox(height: spacing),
                        // Pagination Indicator
                        const PaginationIndicator(
                          currentIndex: 0,
                          totalPages: 2,
                        ),
                        SizedBox(height: spacing * 2),
                      ],
                    ),
                  ),
                ),
                // Bottom Buttons Section
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    spacing,
                    horizontalPadding,
                    MediaQuery.of(context).padding.bottom + horizontalPadding,
                  ),
                  child: Column(
                    children: [
                      CustomButton(
                        text: localizations.signIn,
                        style: CustomButtonStyle.outlined,
                        borderColor: AppColors.netflixRed,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
                      ),
                      SizedBox(height: spacing * 0.5),
                      CustomButton(
                        text: localizations.signUp,
                        style: CustomButtonStyle.flat,
                        backgroundColor: AppColors.netflixRed,
                        foregroundColor: AppColors.netflixWhite,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignupPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
