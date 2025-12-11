import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/extensions/snackbar_extension.dart';
import 'package:mobile/core/localization/app_localizations.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/responsive_helper.dart';
import 'package:mobile/core/widgets/netflix_logo.dart';
import 'package:mobile/core/widgets/custom_button.dart';
import 'package:mobile/core/widgets/custom_text_field.dart';
import 'package:mobile/core/utils/page_transitions.dart';
import 'package:mobile/features/auth/presentation/providers/auth_notifier.dart';
import 'package:mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:mobile/features/auth/presentation/pages/mobile/signup_page.dart';
import 'package:mobile/features/subscription/presentation/pages/subscription_plan_page.dart';
import 'package:mobile/features/subscription/presentation/providers/subscription_providers.dart';
import 'package:mobile/features/profile/presentation/pages/profile_list_page.dart';
import 'package:mobile/core/di/service_locator.dart';
import 'package:mobile/core/network/interceptors/auth_interceptor.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _obscurePassword = true;

  // Cached values for performance (computed once in first build)
  double? _horizontalPadding;
  double? _spacing;
  AppLocalizations? _localizations;

  // Static regex patterns for better performance
  static final _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final _phoneRegex = RegExp(r'^[0-9+\-\s()]+$');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // Call login through Riverpod
      await ref.read(authNotifierProvider.notifier).login(
            email: email,
            password: password,
          );
    }
  }

  void _handleSignUp() {
    Navigator.push(
      context,
      SlidePageRoute(child: const SignupPage(), slideFromRight: true),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return _localizations?.emailRequiredError ?? AppLocalizations.of(context)!.emailRequiredError;
    }
    // Use static regex patterns for better performance
    if (!_emailRegex.hasMatch(value) && !_phoneRegex.hasMatch(value)) {
      return _localizations?.emailValidationError ?? AppLocalizations.of(context)!.emailValidationError;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return _localizations?.passwordRequired ?? AppLocalizations.of(context)!.passwordRequired;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Watch auth state
    final authState = ref.watch(authNotifierProvider);

    // Handle success and error states
    ref.listen<AuthState>(authNotifierProvider, (previous, next) async {
      if (next.isSuccess && next.authResponse != null) {
        // Set token to auth interceptor for subsequent requests
        final authInterceptor = serviceLocator.get<AuthInterceptor>();
        authInterceptor.setToken(next.authResponse!.token);
        
        context.showSuccessSnackBar(
          _localizations?.loginSuccess ?? AppLocalizations.of(context)!.loginSuccess,
          isDarkBackground: false,
        );
        // Check subscription and navigate accordingly
        // First, try to check if user has active subscription (lightweight check)
        // If not found, user has no subscription and should select a plan
        final hasSubscriptionResult = await ref.read(subscriptionNotifierProvider.notifier).checkHasActiveSubscription();
        
        if (!hasSubscriptionResult) {
          // No active subscription, navigate to plan selection
          if (mounted) {
            Navigator.pushReplacement(
              context,
              SlideFadePageRoute(child: const SubscriptionPlanPage()),
            );
          }
        } else {
          // Has active subscription, fetch full details and navigate to profile list
          await ref.read(subscriptionNotifierProvider.notifier).fetchMySubscription();
          // Navigate to profile list page
          if (mounted) {
            Navigator.pushReplacement(
              context,
              SlideFadePageRoute(child: const ProfileListPage()),
            );
          }
        }
      } else if (next.error != null && next.error!.isNotEmpty) {
        context.showErrorSnackBar(next.error!, isDarkBackground: false);
      }
    });

    // Cache values on first build only
    _horizontalPadding ??= ResponsiveHelper.getResponsiveHorizontalPadding(context);
    _spacing ??= ResponsiveHelper.getResponsiveSpacing(context);
    _localizations ??= AppLocalizations.of(context)!;

    final horizontalPadding = _horizontalPadding!;
    final spacing = _spacing!;
    final localizations = _localizations!;

    return Scaffold(
      backgroundColor: AppColors.netflixBlack,
      body: Stack(
        children: [
          // Background Image with Blur - Using onboarding background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.onboardingBackgroundGradient,
              ),
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
                    color: AppColors.netflixBlack.withValues(alpha: 0.8),
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
                // Header Section
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: spacing,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: AppColors.netflixWhite,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 8),
                      const NetflixLogo(),
                    ],
                  ),
                ),
                // Content Section
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: spacing * 2),
                          // Title
                          Text(
                            localizations.loginTitle,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 24),
                                ),
                          ),
                          SizedBox(height: spacing),
                          // Subtitle
                          Text(
                            localizations.loginSubtitle,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppColors.netflixLightGray,
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
                                ),
                          ),
                          SizedBox(height: spacing * 2),
                          // Email/Phone Input
                          CustomTextField(
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            hintText: localizations.emailOrPhonePlaceholder,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: _validateEmail,
                            onSubmitted: (_) => _passwordFocusNode.requestFocus(),
                          ),
                          SizedBox(height: spacing),
                          // Password Input
                          CustomTextField(
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            hintText: localizations.password,
                            obscureText: _obscurePassword,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                            validator: _validatePassword,
                            onSubmitted: (_) => _handleContinue(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                color: AppColors.netflixLightGray,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: spacing * 2),
                          // Sign In Button
                          CustomButton(
                            text: authState.isLoading
                                ? localizations.loading
                                : localizations.signIn,
                            style: CustomButtonStyle.flat,
                            backgroundColor: AppColors.netflixRed,
                            foregroundColor: AppColors.netflixWhite,
                            onPressed: authState.isLoading ? null : _handleContinue,
                          ),
                          SizedBox(height: spacing * 3),
                          // Sign Up Link
                          Center(
                            child: GestureDetector(
                              onTap: _handleSignUp,
                              child: RichText(
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: AppColors.netflixWhite,
                                      ),
                                  children: [
                                    TextSpan(
                                      text: '${localizations.signupSubtitle} ',
                                    ),
                                    TextSpan(
                                      text: localizations.signUp,
                                      style: const TextStyle(
                                        color: AppColors.netflixRed,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: spacing * 2),
                        ],
                      ),
                    ),
                  ),
                ),
                // Footer Section
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    0,
                    horizontalPadding,
                    MediaQuery.of(context).padding.bottom + horizontalPadding,
                  ),
                  child: Column(
                    children: [
                      // Forgot Password Link
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            // TODO: Navigate to forgot password page
                          },
                          child: Text(
                            localizations.forgotPassword,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.netflixRed,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                      ),
                      SizedBox(height: spacing),
                      Text(
                        localizations.recaptchaInfo,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.netflixWhite.withValues(alpha: 0.8),
                              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 12),
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () {
                          // TODO: Open learn more link
                        },
                        child: Text(
                          localizations.learnMore,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.blue,
fontWeight: FontWeight.w800,
                                fontSize: ResponsiveHelper.getResponsiveFontSize(context, 12),
                              ),
                          textAlign: TextAlign.center,
                        ),
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
