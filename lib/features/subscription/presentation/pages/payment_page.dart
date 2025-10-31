import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/snackbar_extension.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/widgets/netflix_logo.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../domain/entities/subscription_plan.dart';
import '../providers/subscription_notifier.dart';
import '../providers/subscription_providers.dart';
import '../../../payment/data/datasources/payment_remote_datasource.dart';
import '../../../payment/data/models/add_payment_method_request_model.dart';
import '../../../payment/utils/card_utils.dart';
import '../../../profile/presentation/pages/profile_list_page.dart';

class PaymentPage extends ConsumerStatefulWidget {
  final SubscriptionPlan selectedPlan;
  final String billingCycle;

  const PaymentPage({
    super.key,
    required this.selectedPlan,
    required this.billingCycle,
  });

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardholderNameController = TextEditingController();

  final _cardNumberFocusNode = FocusNode();
  final _expiryDateFocusNode = FocusNode();
  final _cvvFocusNode = FocusNode();
  final _cardholderNameFocusNode = FocusNode();

  // Cached values for performance
  double? _horizontalPadding;
  double? _spacing;
  AppLocalizations? _localizations;

  // Static regex patterns for better performance
  static final _expiryDateRegex = RegExp(r'^\d{2}/\d{2}$');
  static final _cvvRegex = RegExp(r'^\d{3,4}$');

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _cardholderNameController.dispose();
    _cardNumberFocusNode.dispose();
    _expiryDateFocusNode.dispose();
    _cvvFocusNode.dispose();
    _cardholderNameFocusNode.dispose();
    super.dispose();
  }

  String _formatCardNumber(String value) {
    // Remove all non-digits
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    
    // Limit to 16 digits
    final limitedDigits = digitsOnly.length > 16 
        ? digitsOnly.substring(0, 16) 
        : digitsOnly;
    
    // Add spaces every 4 digits
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
    // Remove all non-digits
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    
    // Limit to 4 digits
    final limitedDigits = digitsOnly.length > 4 
        ? digitsOnly.substring(0, 4) 
        : digitsOnly;
    
    // Add slash after 2 digits
    if (limitedDigits.length >= 2) {
      return '${limitedDigits.substring(0, 2)}/${limitedDigits.substring(2)}';
    }
    
    return limitedDigits;
  }

  String _formatCvv(String value) {
    // Remove all non-digits and limit to 4
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    return digitsOnly.length > 4 ? digitsOnly.substring(0, 4) : digitsOnly;
  }

  Future<void> _handlePayment() async {
    if (_formKey.currentState!.validate()) {
      try {
        // First, add payment method
        final cardNumberDigitsOnly = _cardNumberController.text.replaceAll(' ', '');
        final expiryParts = _expiryDateController.text.split('/');
        final cardBrand = CardUtils.detectCardBrand(cardNumberDigitsOnly);
        
        final paymentRequest = AddPaymentMethodRequestModel(
          cardHolderName: _cardholderNameController.text.trim(),
          cardNumber: cardNumberDigitsOnly,
          expiryMonth: expiryParts.length == 2 ? expiryParts[0] : '',
          expiryYear: expiryParts.length == 2 
              ? '20${expiryParts[1]}' // Convert YY to YYYY
              : '',
          cvv: _cvvController.text,
          cardBrand: cardBrand,
          setAsDefault: true,
        );
        
        // Add payment method
        final paymentDataSource = PaymentRemoteDataSourceImpl();
        final paymentMethod = await paymentDataSource.addPaymentMethod(paymentRequest);
        
        // Then subscribe with payment method ID
        await ref.read(subscriptionNotifierProvider.notifier).subscribe(
              planName: widget.selectedPlan.planName,
              billingCycle: widget.billingCycle,
              paymentMethodId: paymentMethod.id,
            );
      } catch (e) {
        // Only show error if subscription state is not successful
        // If subscription succeeded, the listener will handle success message
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

  String? _validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return _localizations?.cardNumberRequired ?? 
          AppLocalizations.of(context)!.cardNumberRequired;
    }
    
    // Remove spaces for validation
    final digitsOnly = value.replaceAll(' ', '');
    
    if (digitsOnly.length != 16) {
      return _localizations?.cardNumberInvalid ?? 
          AppLocalizations.of(context)!.cardNumberInvalid;
    }
    
    return null;
  }

  String? _validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return _localizations?.expiryDateRequired ?? 
          AppLocalizations.of(context)!.expiryDateRequired;
    }
    
    if (!_expiryDateRegex.hasMatch(value)) {
      return _localizations?.expiryDateInvalid ?? 
          AppLocalizations.of(context)!.expiryDateInvalid;
    }
    
    // Validate month (01-12)
    final parts = value.split('/');
    if (parts.length == 2) {
      final month = int.tryParse(parts[0]);
      if (month == null || month < 1 || month > 12) {
        return _localizations?.expiryDateInvalid ?? 
            AppLocalizations.of(context)!.expiryDateInvalid;
      }
    }
    
    return null;
  }

  String? _validateCvv(String? value) {
    if (value == null || value.isEmpty) {
      return _localizations?.cvvRequired ?? 
          AppLocalizations.of(context)!.cvvRequired;
    }
    
    if (!_cvvRegex.hasMatch(value)) {
      return _localizations?.cvvInvalid ?? 
          AppLocalizations.of(context)!.cvvInvalid;
    }
    
    return null;
  }

  String? _validateCardholderName(String? value) {
    if (value == null || value.isEmpty) {
      return _localizations?.cardholderNameRequired ?? 
          AppLocalizations.of(context)!.cardholderNameRequired;
    }
    
    return null;
  }

  String _formatPrice(double price) {
    return '₺${price.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}';
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionState = ref.watch(subscriptionNotifierProvider);

    // Handle subscription success
    ref.listen<SubscriptionState>(subscriptionNotifierProvider, (previous, next) {
      // Only process state changes (not initial state)
      if (previous == null) return;
      
      if (next.isSuccess && previous.isSuccess != next.isSuccess) {
        // Success state changed to true
        context.showSuccessSnackBar(
          _localizations?.paymentSuccess ?? AppLocalizations.of(context)!.paymentSuccess,
        );
        // Navigate to ProfileListPage and clear navigation stack
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const ProfileListPage(),
            ),
            (route) => false, // Clear all previous routes
          );
        }
      } else if (next.error != null && 
                 next.error!.isNotEmpty && 
                 !next.isSubscribing &&
                 previous.error != next.error) {
        // Error state changed and not currently subscribing
        context.showErrorSnackBar(
          next.error!,
        );
      }
    });

    // Cache values on first build only
    _horizontalPadding ??= ResponsiveHelper.getResponsiveHorizontalPadding(context);
    _spacing ??= ResponsiveHelper.getResponsiveSpacing(context);
    _localizations ??= AppLocalizations.of(context)!;

    final horizontalPadding = _horizontalPadding!;
    final spacing = _spacing!;
    final localizations = _localizations!;

    final price = widget.billingCycle == 'MONTHLY' 
        ? widget.selectedPlan.monthlyPrice 
        : widget.selectedPlan.yearlyPrice;
    final pricePeriod = widget.billingCycle == 'MONTHLY' ? '/ay' : '/yıl';

    return Scaffold(
      backgroundColor: AppColors.netflixBlack,
      body: Stack(
        children: [
          // Background with gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.onboardingBackgroundGradient,
              ),
              child: Stack(
                children: [
                  // Blur Overlay
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(
                      color: AppColors.netflixBlack.withValues(alpha: 0.05),
                    ),
                  ),
                  // Dark Overlay
                  Container(
                    color: AppColors.netflixBlack.withValues(alpha: 0.85),
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
                // Header
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
                // Content
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
                            localizations.paymentInfo,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 28),
                                ),
                          ),
                          SizedBox(height: spacing * 0.5),
                          // Subtitle
                          Text(
                            localizations.paymentInfoSubtitle,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppColors.netflixLightGray,
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
                                ),
                          ),
                          SizedBox(height: spacing * 2),
                          // Plan Summary Card
                          Container(
                            padding: EdgeInsets.all(spacing * 1.5),
                            decoration: BoxDecoration(
                              color: AppColors.netflixDarkGray.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.netflixGray,
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
                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 18),
                                          ),
                                    ),
                                    SizedBox(height: spacing * 0.25),
                                    Text(
                                      widget.billingCycle == 'MONTHLY' 
                                          ? localizations.monthly 
                                          : localizations.yearly,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: AppColors.netflixLightGray,
                                            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
                                          ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${_formatPrice(price)}$pricePeriod',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        color: AppColors.netflixRed,
                                        fontWeight: FontWeight.bold,
                                        fontSize: ResponsiveHelper.getResponsiveFontSize(context, 18),
                                      ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: spacing * 3),
                          // Card Number
                          Text(
                            localizations.cardNumber,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
                                ),
                          ),
                          SizedBox(height: spacing * 0.5),
                          CustomTextField(
                            controller: _cardNumberController,
                            focusNode: _cardNumberFocusNode,
                            hintText: localizations.cardNumberPlaceholder,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            validator: _validateCardNumber,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(19), // 16 digits + 3 spaces
                              TextInputFormatter.withFunction((oldValue, newValue) {
                                final formatted = _formatCardNumber(newValue.text);
                                return TextEditingValue(
                                  text: formatted,
                                  selection: TextSelection.collapsed(offset: formatted.length),
                                );
                              }),
                            ],
                            onSubmitted: (_) => _expiryDateFocusNode.requestFocus(),
                          ),
                          SizedBox(height: spacing),
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
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
                                          ),
                                    ),
                                    SizedBox(height: spacing * 0.5),
                                    CustomTextField(
                                      controller: _expiryDateController,
                                      focusNode: _expiryDateFocusNode,
                                      hintText: localizations.expiryDatePlaceholder,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      validator: _validateExpiryDate,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(5), // MM/YY
                                        TextInputFormatter.withFunction((oldValue, newValue) {
                                          final formatted = _formatExpiryDate(newValue.text);
                                          return TextEditingValue(
                                            text: formatted,
                                            selection: TextSelection.collapsed(offset: formatted.length),
                                          );
                                        }),
                                      ],
                                      onSubmitted: (_) => _cvvFocusNode.requestFocus(),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: spacing),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      localizations.cvv,
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
                                          ),
                                    ),
                                    SizedBox(height: spacing * 0.5),
                                    CustomTextField(
                                      controller: _cvvController,
                                      focusNode: _cvvFocusNode,
                                      hintText: localizations.cvvPlaceholder,
                                      obscureText: true,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      validator: _validateCvv,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(4),
                                        TextInputFormatter.withFunction((oldValue, newValue) {
                                          final formatted = _formatCvv(newValue.text);
                                          return TextEditingValue(
                                            text: formatted,
                                            selection: TextSelection.collapsed(offset: formatted.length),
                                          );
                                        }),
                                      ],
                                      onSubmitted: (_) => _cardholderNameFocusNode.requestFocus(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: spacing),
                          // Cardholder Name
                          Text(
                            localizations.cardholderName,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
                                ),
                          ),
                          SizedBox(height: spacing * 0.5),
                          CustomTextField(
                            controller: _cardholderNameController,
                            focusNode: _cardholderNameFocusNode,
                            hintText: localizations.cardholderNamePlaceholder,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            validator: _validateCardholderName,
                            onSubmitted: (_) => _handlePayment(),
                          ),
                          SizedBox(height: spacing * 3),
                        ],
                      ),
                    ),
                  ),
                ),
                // Footer with Pay Button
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    spacing,
                    horizontalPadding,
                    MediaQuery.of(context).padding.bottom + horizontalPadding,
                  ),
                  child: CustomButton(
                    text: subscriptionState.isSubscribing
                        ? localizations.loading
                        : localizations.payNow,
                    style: CustomButtonStyle.flat,
                    backgroundColor: AppColors.netflixRed,
                    foregroundColor: AppColors.netflixWhite,
                    onPressed: subscriptionState.isSubscribing ? null : _handlePayment,
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

