import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/snackbar_extension.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/widgets/netflix_logo.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../providers/auth_notifier.dart';
import '../providers/auth_providers.dart';
import 'login_page.dart';
import '../../../subscription/presentation/pages/subscription_plan_page.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/network/interceptors/auth_interceptor.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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
    _confirmPasswordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // Call register through Riverpod
      await ref.read(authNotifierProvider.notifier).register(
            email: email,
            password: password,
          );
    }
  }

  void _handleSignIn() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
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
    if (value.length < 6) {
      return _localizations?.passwordMinLength ?? AppLocalizations.of(context)!.passwordMinLength;
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return _localizations?.passwordRequired ?? AppLocalizations.of(context)!.passwordRequired;
    }
    if (value != _passwordController.text) {
      return _localizations?.confirmPasswordMatch ?? AppLocalizations.of(context)!.confirmPasswordMatch;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Watch auth state
    final authState = ref.watch(authNotifierProvider);

    // Handle success and error states
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next.isSuccess && next.authResponse != null) {
        // Set token to auth interceptor for subsequent requests
        final authInterceptor = serviceLocator.get<AuthInterceptor>();
        authInterceptor.setToken(next.authResponse!.token);
        
        context.showSuccessSnackBar(
          _localizations?.signupSuccess ?? AppLocalizations.of(context)!.signupSuccess,
        );
        // Navigate to subscription plan page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SubscriptionPlanPage(),
          ),
        );
      } else if (next.error != null && next.error!.isNotEmpty) {
        context.showErrorSnackBar(next.error!);
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
                            localizations.signupTitle,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 24),
                                ),
                          ),
                          SizedBox(height: spacing),
                          // Subtitle
                          Text(
                            localizations.signupSubtitle,
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
                            textInputAction: TextInputAction.next,
                            validator: _validatePassword,
                            onSubmitted: (_) => _confirmPasswordFocusNode.requestFocus(),
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
                          SizedBox(height: spacing),
                          // Confirm Password Input
                          CustomTextField(
                            controller: _confirmPasswordController,
                            focusNode: _confirmPasswordFocusNode,
                            hintText: localizations.confirmPassword,
                            obscureText: _obscureConfirmPassword,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                            validator: _validateConfirmPassword,
                            onSubmitted: (_) => _handleContinue(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                                color: AppColors.netflixLightGray,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: spacing * 2),
                          // Sign Up Button
                          CustomButton(
                            text: authState.isLoading
                                ? localizations.loading
                                : localizations.signUp,
                            style: CustomButtonStyle.flat,
                            backgroundColor: AppColors.netflixRed,
                            foregroundColor: AppColors.netflixWhite,
                            onPressed: authState.isLoading ? null : _handleContinue,
                          ),
                          SizedBox(height: spacing * 2),
                          // Sign In Link
                          Center(
                            child: GestureDetector(
                              onTap: _handleSignIn,
                              child: RichText(
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: AppColors.netflixWhite,
                                      ),
                                  children: [
                                    TextSpan(
                                      text: localizations.haveAccountSignIn + ' ',
                                    ),
                                    TextSpan(
                                      text: localizations.signIn,
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
