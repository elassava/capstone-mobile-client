import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/di/service_locator.dart';
import 'package:mobile/core/network/interceptors/auth_interceptor.dart';
import 'package:mobile/core/localization/app_localizations.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/web_responsive.dart';
import 'package:mobile/core/utils/error_handler.dart';
import 'package:mobile/core/widgets/netflix_logo.dart';
import 'package:mobile/core/widgets/custom_button.dart';
import 'package:mobile/core/widgets/custom_text_field.dart';
import 'package:mobile/core/extensions/snackbar_extension.dart';
import 'package:mobile/features/auth/presentation/providers/auth_notifier.dart';
import 'package:mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:mobile/features/subscription/presentation/providers/subscription_providers.dart';

class WebLoginPage extends ConsumerStatefulWidget {
  const WebLoginPage({super.key});

  @override
  ConsumerState<WebLoginPage> createState() => _WebLoginPageState();
}

class _WebLoginPageState extends ConsumerState<WebLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      await ref
          .read(authNotifierProvider.notifier)
          .login(email: email, password: password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final localizations = AppLocalizations.of(context)!;
    final scaler = context.responsive;

    ref.listen<AuthState>(authNotifierProvider, (previous, next) async {
      if (next.isSuccess && next.authResponse != null) {
        final authInterceptor = serviceLocator.get<AuthInterceptor>();
        authInterceptor.setToken(next.authResponse!.token);

        context.showSuccessSnackBar(localizations.loginSuccess, isDarkBackground: false);

        final hasSubscriptionResult = await ref
            .read(subscriptionNotifierProvider.notifier)
            .checkHasActiveSubscription();

        if (!mounted) return;

        if (!hasSubscriptionResult) {
          Navigator.pushReplacementNamed(context, '/plans');
        } else {
          await ref
              .read(subscriptionNotifierProvider.notifier)
              .fetchMySubscription();
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/profiles');
        }
      } else if (next.error != null && next.error!.isNotEmpty) {
        context.showErrorSnackBar(
          ErrorHandler.getLocalizedErrorMessage(context, next.error),
          isDarkBackground: false,
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.netflixBlack,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/web_background.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.5),
                    Colors.black.withValues(alpha: 0.2),
                    Colors.black.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          ),

          // Content
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Header
                        Padding(
                          padding: scaler.paddingSymmetric(
                            horizontal: 60,
                            vertical: 24,
                          ),
                          child: Row(children: [const NetflixLogo()]),
                        ),

                        const Spacer(),

                        // Login Card - iOS 26 Liquid Glass
                        Center(
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, child) {
                              return Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(0, 30 * (1 - value)),
                                  child: Transform.scale(
                                    scale: 0.95 + (0.05 * value),
                                    child: child,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: scaler.w(450),
                              decoration: BoxDecoration(
                                borderRadius: scaler.borderRadius(24),
                                boxShadow: [
                                  // Outer glow - Netflix red tint
                                  BoxShadow(
                                    color: AppColors.netflixRed.withValues(alpha: 0.15),
                                    blurRadius: 60,
                                    spreadRadius: -10,
                                    offset: const Offset(0, 20),
                                  ),
                                  // Soft ambient shadow
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    blurRadius: 40,
                                    spreadRadius: -5,
                                    offset: const Offset(0, 25),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: scaler.borderRadius(24),
                                child: Stack(
                                  children: [
                                    // Ultra blur layer
                                    BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: scaler.borderRadius(24),
                                        ),
                                      ),
                                    ),
                                    
                                    // Base glass layer
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: scaler.borderRadius(24),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.white.withValues(alpha: 0.12),
                                            Colors.white.withValues(alpha: 0.06),
                                            Colors.white.withValues(alpha: 0.02),
                                          ],
                                          stops: const [0.0, 0.5, 1.0],
                                        ),
                                      ),
                                    ),
                                    
                                    // Spectral border effect
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: scaler.borderRadius(24),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            AppColors.netflixRed.withValues(alpha: 0.3),
                                            const Color(0xFFE879F9).withValues(alpha: 0.2),
                                            const Color(0xFF60A5FA).withValues(alpha: 0.2),
                                            AppColors.netflixRed.withValues(alpha: 0.3),
                                          ],
                                        ),
                                      ),
                                    ),
                                    
                                    // Inner glass fill
                                    Container(
                                      margin: const EdgeInsets.all(1.5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(22.5),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            const Color(0xFF1A1A2E).withValues(alpha: 0.92),
                                            const Color(0xFF0F0F1A).withValues(alpha: 0.88),
                                          ],
                                        ),
                                      ),
                                    ),
                                    
                                    // Top highlight reflection
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      height: 80,
                                      child: Container(
                                        margin: const EdgeInsets.all(1.5),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(22.5),
                                            topRight: Radius.circular(22.5),
                                          ),
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.white.withValues(alpha: 0.12),
                                              Colors.white.withValues(alpha: 0.0),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    
                                    // Content
                                    Padding(
                                      padding: scaler.padding(60),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          localizations.signIn,
                                          style: TextStyle(
                                            color: AppColors.netflixWhite,
                                            fontSize: scaler.sp(32),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        scaler.verticalSpace(28),

                                        CustomTextField(
                                          controller: _emailController,
                                          hintText: localizations
                                              .emailOrPhonePlaceholder,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          fillColor: AppColors.inputFill,
                                          hintStyle: const TextStyle(
                                            color: AppColors.inputBorder,
                                          ),
                                          style: const TextStyle(
                                            color: AppColors.netflixWhite,
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return localizations
                                                  .emailRequiredError;
                                            }
                                            if (!value.contains('@') ||
                                                !value.contains('.')) {
                                              return localizations
                                                  .emailValidationError;
                                            }
                                            return null;
                                          },
                                        ),
                                        scaler.verticalSpace(16),

                                        CustomTextField(
                                          controller: _passwordController,
                                          hintText: localizations.password,
                                          obscureText: true,
                                          fillColor: AppColors.inputFill,
                                          hintStyle: const TextStyle(
                                            color: AppColors.inputBorder,
                                          ),
                                          style: const TextStyle(
                                            color: AppColors.netflixWhite,
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return localizations
                                                  .passwordRequired;
                                            }
                                            if (value.length < 6) {
                                              return localizations
                                                  .passwordMinLength;
                                            }
                                            return null;
                                          },
                                        ),
                                        scaler.verticalSpace(40),

                                        SizedBox(
                                          width: double.infinity,
                                          height: scaler.h(48),
                                          child: CustomButton(
                                            text: authState.isLoading
                                                ? localizations.loading
                                                : localizations.signIn,
                                            onPressed: authState.isLoading
                                                ? null
                                                : _handleLogin,
                                            backgroundColor:
                                                AppColors.netflixRed,
                                            style: CustomButtonStyle.flat,
                                            borderRadius: 4,
                                            fontSize: scaler.sp(16),
                                          ),
                                        ),

                                        scaler.verticalSpace(16),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  height: scaler.s(24),
                                                  width: scaler.s(24),
                                                  child: Checkbox(
                                                    value: true,
                                                    onChanged: (value) {},
                                                    fillColor:
                                                        WidgetStateProperty.all(
                                                          AppColors.textGray,
                                                        ),
                                                    checkColor: Colors.black,
                                                    side: BorderSide.none,
                                                  ),
                                                ),
                                                scaler.horizontalSpace(4),
                                                Text(
                                                  localizations.rememberMe,
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.textLightGray,
                                                    fontSize: scaler.sp(13),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            TextButton(
                                              onPressed: () {},
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                                minimumSize: Size.zero,
                                                tapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                              ),
                                              child: Text(
                                                localizations.needHelp,
                                                style: TextStyle(
                                                  color:
                                                      AppColors.textLightGray,
                                                  fontSize: scaler.sp(13),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        scaler.verticalSpace(40),

                                        Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            Text(
                                              '${localizations.signupSubtitle} ',
                                              style: TextStyle(
                                                color: AppColors.textGray,
                                                fontSize: scaler.sp(16),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  '/register',
                                                );
                                              },
                                              child: Text(
                                                localizations.signUp,
                                                style: TextStyle(
                                                  color: AppColors.netflixWhite,
                                                  fontSize: scaler.sp(16),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        scaler.verticalSpace(12),
                                        Text(
                                          localizations.recaptchaInfo,
                                          style: TextStyle(
                                            color: AppColors.inputBorder,
                                            fontSize: scaler.sp(13),
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
                          ),
                        ),

                        const Spacer(),

                        scaler.verticalSpace(40),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
