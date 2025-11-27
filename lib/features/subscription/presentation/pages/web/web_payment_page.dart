import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/extensions/snackbar_extension.dart';
import 'package:mobile/core/localization/app_localizations.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/netflix_logo.dart';
import 'package:mobile/core/widgets/custom_button.dart';
import 'package:mobile/core/widgets/custom_text_field.dart';
import 'package:mobile/features/subscription/domain/entities/subscription_plan.dart';
import 'package:mobile/features/subscription/presentation/providers/subscription_notifier.dart';
import 'package:mobile/features/subscription/presentation/providers/subscription_providers.dart';
import 'package:mobile/features/payment/data/datasources/payment_remote_datasource.dart';
import 'package:mobile/features/payment/data/models/add_payment_method_request_model.dart';
import 'package:mobile/features/payment/utils/card_utils.dart';

class WebPaymentPage extends ConsumerStatefulWidget {
  final SubscriptionPlan selectedPlan;

  const WebPaymentPage({super.key, required this.selectedPlan});

  @override
  ConsumerState<WebPaymentPage> createState() => _WebPaymentPageState();
}

class _WebPaymentPageState extends ConsumerState<WebPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardholderNameController = TextEditingController();

  static final _expiryDateRegex = RegExp(r'^\d{2}/\d{2}$');
  static final _cvvRegex = RegExp(r'^\d{3,4}$');

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _cardholderNameController.dispose();
    super.dispose();
  }

  String _formatCardNumber(String value) {
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    final limitedDigits = digitsOnly.length > 16
        ? digitsOnly.substring(0, 16)
        : digitsOnly;

    final buffer = StringBuffer();
    for (int i = 0; i < limitedDigits.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(limitedDigits[i]);
    }

    return buffer.toString();
  }

  String _formatExpiryDate(String value) {
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    final limitedDigits = digitsOnly.length > 4
        ? digitsOnly.substring(0, 4)
        : digitsOnly;

    if (limitedDigits.length >= 2) {
      return '${limitedDigits.substring(0, 2)}/${limitedDigits.substring(2)}';
    }

    return limitedDigits;
  }

  String _formatCvv(String value) {
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    return digitsOnly.length > 4 ? digitsOnly.substring(0, 4) : digitsOnly;
  }

  Future<void> _handlePayment() async {
    if (_formKey.currentState!.validate()) {
      try {
        final cardNumberDigitsOnly = _cardNumberController.text.replaceAll(
          ' ',
          '',
        );
        final expiryParts = _expiryDateController.text.split('/');
        final cardBrand = CardUtils.detectCardBrand(cardNumberDigitsOnly);

        final paymentRequest = AddPaymentMethodRequestModel(
          cardHolderName: _cardholderNameController.text.trim(),
          cardNumber: cardNumberDigitsOnly,
          expiryMonth: expiryParts.length == 2 ? expiryParts[0] : '',
          expiryYear: expiryParts.length == 2 ? '20${expiryParts[1]}' : '',
          cvv: _cvvController.text,
          cardBrand: cardBrand,
          setAsDefault: true,
        );

        final paymentDataSource = PaymentRemoteDataSourceImpl();
        final paymentMethod = await paymentDataSource.addPaymentMethod(
          paymentRequest,
        );

        await ref
            .read(subscriptionNotifierProvider.notifier)
            .subscribe(
              planName: widget.selectedPlan.planName,
              billingCycle: 'MONTHLY',
              paymentMethodId: paymentMethod.id,
            );
      } catch (e) {
        if (mounted) {
          final subscriptionState = ref.read(subscriptionNotifierProvider);
          if (!subscriptionState.isSuccess) {
            context.showErrorSnackBar(
              e.toString().replaceAll('Exception: ', ''),
            );
          }
        }
      }
    }
  }

  String? _validateCardNumber(String? value, AppLocalizations localizations) {
    if (value == null || value.isEmpty) {
      return localizations.cardNumberRequired;
    }

    final digitsOnly = value.replaceAll(' ', '');

    if (digitsOnly.length != 16) {
      return localizations.cardNumberInvalid;
    }

    return null;
  }

  String? _validateExpiryDate(String? value, AppLocalizations localizations) {
    if (value == null || value.isEmpty) {
      return localizations.expiryDateRequired;
    }

    if (!_expiryDateRegex.hasMatch(value)) {
      return localizations.expiryDateInvalid;
    }

    final parts = value.split('/');
    if (parts.length == 2) {
      final month = int.tryParse(parts[0]);
      if (month == null || month < 1 || month > 12) {
        return localizations.expiryDateInvalid;
      }
    }

    return null;
  }

  String? _validateCvv(String? value, AppLocalizations localizations) {
    if (value == null || value.isEmpty) {
      return localizations.cvvRequired;
    }

    if (!_cvvRegex.hasMatch(value)) {
      return localizations.cvvInvalid;
    }

    return null;
  }

  String? _validateCardholderName(
    String? value,
    AppLocalizations localizations,
  ) {
    if (value == null || value.isEmpty) {
      return localizations.cardholderNameRequired;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionState = ref.watch(subscriptionNotifierProvider);
    final localizations = AppLocalizations.of(context)!;

    ref.listen<SubscriptionState>(subscriptionNotifierProvider, (
      previous,
      next,
    ) {
      if (previous == null) return;

      if (next.isSuccess && previous.isSuccess != next.isSuccess) {
        context.showSuccessSnackBar(localizations.paymentSuccess);
        if (mounted) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/profiles', (route) => false);
        }
      } else if (next.error != null &&
          next.error!.isNotEmpty &&
          !next.isSubscribing &&
          previous.error != next.error) {
        context.showErrorSnackBar(next.error!);
      }
    });

    return PopScope(
      canPop: !subscriptionState.isSubscribing,
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: _GlassAppBar(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: subscriptionState.isSubscribing
                      ? null
                      : () => Navigator.of(context).pop(),
                ),
                const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: SizedBox(height: 25, child: NetflixLogo()),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: 120,
            bottom: 40,
            left: 24,
            right: 24,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.paymentInfo,
                      style: const TextStyle(
                        color: AppColors.netflixBlack,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      localizations.paymentInfoSubtitle,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Plan Summary Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.netflixLightGray.withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.netflixLightGray.withValues(
                            alpha: 0.3,
                          ),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.selectedPlan.displayName,
                                style: const TextStyle(
                                  color: AppColors.netflixBlack,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                localizations.monthly,
                                style: const TextStyle(
                                  color: AppColors.textGray,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '₺${widget.selectedPlan.monthlyPrice.toStringAsFixed(2)}/mo',
                            style: const TextStyle(
                              color: AppColors.netflixRed,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Card Number
                    Text(
                      localizations.cardNumber,
                      style: const TextStyle(
                        color: AppColors.netflixBlack,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _cardNumberController,
                      hintText: localizations.cardNumberPlaceholder,
                      keyboardType: TextInputType.number,
                      fillColor: Colors.white,
                      borderColor: AppColors.inputBorder,
                      hintStyle: const TextStyle(color: AppColors.inputBorder),
                      style: const TextStyle(color: AppColors.netflixBlack),
                      validator: (value) =>
                          _validateCardNumber(value, localizations),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(19),
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          final formatted = _formatCardNumber(newValue.text);
                          return TextEditingValue(
                            text: formatted,
                            selection: TextSelection.collapsed(
                              offset: formatted.length,
                            ),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Expiry Date and CVV Row
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                localizations.expiryDate,
                                style: const TextStyle(
                                  color: AppColors.netflixBlack,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              CustomTextField(
                                controller: _expiryDateController,
                                hintText: localizations.expiryDatePlaceholder,
                                keyboardType: TextInputType.number,
                                fillColor: Colors.white,
                                borderColor: AppColors.inputBorder,
                                hintStyle: const TextStyle(
                                  color: AppColors.inputBorder,
                                ),
                                style: const TextStyle(
                                  color: AppColors.netflixBlack,
                                ),
                                validator: (value) =>
                                    _validateExpiryDate(value, localizations),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(5),
                                  TextInputFormatter.withFunction((
                                    oldValue,
                                    newValue,
                                  ) {
                                    final formatted = _formatExpiryDate(
                                      newValue.text,
                                    );
                                    return TextEditingValue(
                                      text: formatted,
                                      selection: TextSelection.collapsed(
                                        offset: formatted.length,
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                localizations.cvv,
                                style: const TextStyle(
                                  color: AppColors.netflixBlack,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              CustomTextField(
                                controller: _cvvController,
                                hintText: localizations.cvvPlaceholder,
                                obscureText: true,
                                keyboardType: TextInputType.number,
                                fillColor: Colors.white,
                                borderColor: AppColors.inputBorder,
                                hintStyle: const TextStyle(
                                  color: AppColors.inputBorder,
                                ),
                                style: const TextStyle(
                                  color: AppColors.netflixBlack,
                                ),
                                validator: (value) =>
                                    _validateCvv(value, localizations),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4),
                                  TextInputFormatter.withFunction((
                                    oldValue,
                                    newValue,
                                  ) {
                                    final formatted = _formatCvv(newValue.text);
                                    return TextEditingValue(
                                      text: formatted,
                                      selection: TextSelection.collapsed(
                                        offset: formatted.length,
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Cardholder Name
                    Text(
                      localizations.cardholderName,
                      style: const TextStyle(
                        color: AppColors.netflixBlack,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _cardholderNameController,
                      hintText: localizations.cardholderNamePlaceholder,
                      fillColor: Colors.white,
                      borderColor: AppColors.inputBorder,
                      hintStyle: const TextStyle(color: AppColors.inputBorder),
                      style: const TextStyle(color: AppColors.netflixBlack),
                      validator: (value) =>
                          _validateCardholderName(value, localizations),
                    ),
                    const SizedBox(height: 40),

                    // Pay Button
                    SizedBox(
                      width: double.infinity,
                      height: 64,
                      child: CustomButton(
                        text: subscriptionState.isSubscribing
                            ? localizations.loading
                            : localizations.payNow,
                        onPressed: subscriptionState.isSubscribing
                            ? null
                            : _handlePayment,
                        backgroundColor: AppColors.netflixRed,
                        style: CustomButtonStyle.flat,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
