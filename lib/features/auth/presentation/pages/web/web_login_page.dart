import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/di/service_locator.dart';
import 'package:mobile/core/network/interceptors/auth_interceptor.dart';
import 'package:mobile/core/localization/app_localizations.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/netflix_logo.dart';
import 'package:mobile/core/widgets/custom_button.dart';
import 'package:mobile/core/widgets/custom_text_field.dart';
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

    ref.listen<AuthState>(authNotifierProvider, (previous, next) async {
      if (next.isSuccess && next.authResponse != null) {
        final authInterceptor = serviceLocator.get<AuthInterceptor>();
        authInterceptor.setToken(next.authResponse!.token);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(localizations.loginSuccess)));

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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error!)));
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 60,
                            vertical: 24,
                          ),
                          child: Row(children: [const NetflixLogo()]),
                        ),

                        const Spacer(),

                        // Login Card
                        Center(
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeOut,
                            builder: (context, value, child) {
                              return Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(0, 20 * (1 - value)),
                                  child: child,
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 15,
                                  sigmaY: 15,
                                ),
                                child: Container(
                                  width: 450,
                                  padding: const EdgeInsets.all(60),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.3,
                                        ),
                                        blurRadius: 30,
                                        offset: const Offset(0, 15),
                                      ),
                                    ],
                                  ),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          localizations.signIn,
                                          style: const TextStyle(
                                            color: AppColors.netflixWhite,
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 28),

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
                                        const SizedBox(height: 16),

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
                                        const SizedBox(height: 40),

                                        SizedBox(
                                          width: double.infinity,
                                          height: 48,
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
                                            fontSize: 16,
                                          ),
                                        ),

                                        const SizedBox(height: 16),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  height: 24,
                                                  width: 24,
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
                                                const SizedBox(width: 4),
                                                Text(
                                                  localizations.rememberMe,
                                                  style: const TextStyle(
                                                    color:
                                                        AppColors.textLightGray,
                                                    fontSize: 13,
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
                                                style: const TextStyle(
                                                  color:
                                                      AppColors.textLightGray,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 40),

                                        Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            Text(
                                              '${localizations.signupSubtitle} ',
                                              style: const TextStyle(
                                                color: AppColors.textGray,
                                                fontSize: 16,
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
                                                style: const TextStyle(
                                                  color: AppColors.netflixWhite,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          localizations.recaptchaInfo,
                                          style: const TextStyle(
                                            color: AppColors.inputBorder,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const Spacer(),

                        // Footer spacing if needed, but using Spacer now
                        const SizedBox(height: 40),
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
