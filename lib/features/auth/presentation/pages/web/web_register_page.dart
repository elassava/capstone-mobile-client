import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/di/service_locator.dart';
import 'package:mobile/core/network/interceptors/auth_interceptor.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/localization/app_localizations.dart';
import 'package:mobile/core/widgets/netflix_logo.dart';
import 'package:mobile/core/widgets/custom_button.dart';
import 'package:mobile/core/widgets/custom_text_field.dart';
import 'package:mobile/features/auth/presentation/providers/auth_notifier.dart';
import 'package:mobile/features/auth/presentation/providers/auth_providers.dart';

class WebRegisterPage extends ConsumerStatefulWidget {
  const WebRegisterPage({super.key});

  @override
  ConsumerState<WebRegisterPage> createState() => _WebRegisterPageState();
}

class _WebRegisterPageState extends ConsumerState<WebRegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.confirmPasswordMatch),
          ),
        );
        return;
      }

      final email = _emailController.text.trim();
      final password = _passwordController.text;

      await ref
          .read(authNotifierProvider.notifier)
          .register(email: email, password: password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final localizations = AppLocalizations.of(context)!;

    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next.isSuccess && next.authResponse != null) {
        final authInterceptor = serviceLocator.get<AuthInterceptor>();
        authInterceptor.setToken(next.authResponse!.token);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(localizations.signupSuccess)));

        Navigator.pushReplacementNamed(context, '/plans');
      } else if (next.error != null && next.error!.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error!)));
      }
    });

    return Scaffold(
      backgroundColor: AppColors.netflixWhite,
      body: Row(
        children: [
          // Left Side - Registration Form
          Expanded(
            flex: 1,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo and Back Button
                        Row(
                          children: [
                            const NetflixLogo(),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              child: Text(
                                localizations.signIn,
                                style: const TextStyle(
                                  color: AppColors.netflixBlack,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),

                        Text(
                          localizations.createPasswordTitle,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          localizations.createPasswordSubtitle,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 32),

                        CustomTextField(
                          controller: _emailController,
                          hintText: localizations.emailPlaceholder,
                          keyboardType: TextInputType.emailAddress,
                          fillColor: AppColors.netflixWhite,
                          borderColor: AppColors.inputBorder,
                          hintStyle: const TextStyle(
                            color: AppColors.inputBorder,
                          ),
                          style: const TextStyle(color: AppColors.netflixBlack),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return localizations.emailRequiredError;
                            }
                            if (!value.contains('@') || !value.contains('.')) {
                              return localizations.emailValidationError;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        CustomTextField(
                          controller: _passwordController,
                          hintText: localizations.addPasswordPlaceholder,
                          obscureText: true,
                          fillColor: AppColors.netflixWhite,
                          borderColor: AppColors.inputBorder,
                          hintStyle: const TextStyle(
                            color: AppColors.inputBorder,
                          ),
                          style: const TextStyle(color: AppColors.netflixBlack),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return localizations.passwordRequired;
                            }
                            if (value.length < 6) {
                              return localizations.passwordMinLength;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        CustomTextField(
                          controller: _confirmPasswordController,
                          hintText: localizations.confirmPassword,
                          obscureText: true,
                          fillColor: AppColors.netflixWhite,
                          borderColor: AppColors.inputBorder,
                          hintStyle: const TextStyle(
                            color: AppColors.inputBorder,
                          ),
                          style: const TextStyle(color: AppColors.netflixBlack),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return localizations.confirmPassword;
                            }
                            if (value != _passwordController.text) {
                              return localizations.confirmPasswordMatch;
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 32),

                        SizedBox(
                          width: double.infinity,
                          height: 64,
                          child: CustomButton(
                            text: authState.isLoading
                                ? localizations.loading
                                : localizations.nextButton,
                            onPressed: authState.isLoading
                                ? null
                                : _handleRegister,
                            backgroundColor: AppColors.netflixRed,
                            style: CustomButtonStyle.flat,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Right Side - Image
          Expanded(
            flex: 1,
            child: Container(
              color: AppColors.netflixWhite, // Matches page background
              padding: const EdgeInsets.all(24), // Added padding
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOutQuart,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(
                        40 * (1 - value),
                        0,
                      ), // Slide in from right
                      child: Transform.scale(
                        scale:
                            1.05 -
                            (0.05 *
                                value), // Subtle zoom out effect (1.05 -> 1.0)
                        child: child,
                      ),
                    ),
                  );
                },
                child: Image.asset(
                  'assets/images/onboarding_welcome.png',
                  fit: BoxFit.contain,
                  height: double.infinity,
                  width: double.infinity,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
