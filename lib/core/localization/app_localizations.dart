import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // Onboarding Strings
  String get onboardingTitle => _getLocalizedValue('onboardingTitle');
  String get signIn => _getLocalizedValue('signIn');
  String get signUp => _getLocalizedValue('signUp');

  // Login/Signup Strings
  String get loginTitle => _getLocalizedValue('loginTitle');
  String get loginSubtitle => _getLocalizedValue('loginSubtitle');
  String get emailOrPhonePlaceholder => _getLocalizedValue('emailOrPhonePlaceholder');
  String get continueButton => _getLocalizedValue('continueButton');
  String get helpText => _getLocalizedValue('helpText');
  String get recaptchaInfo => _getLocalizedValue('recaptchaInfo');
  String get learnMore => _getLocalizedValue('learnMore');
  String get signupTitle => _getLocalizedValue('signupTitle');
  String get signupSubtitle => _getLocalizedValue('signupSubtitle');
  String get emailValidationError => _getLocalizedValue('emailValidationError');
  String get emailRequiredError => _getLocalizedValue('emailRequiredError');
  String get password => _getLocalizedValue('password');
  String get confirmPassword => _getLocalizedValue('confirmPassword');
  String get passwordRequired => _getLocalizedValue('passwordRequired');
  String get passwordMinLength => _getLocalizedValue('passwordMinLength');
  String get confirmPasswordMatch => _getLocalizedValue('confirmPasswordMatch');
  String get forgotPassword => _getLocalizedValue('forgotPassword');
  String get loginSuccess => _getLocalizedValue('loginSuccess');
  String get signupSuccess => _getLocalizedValue('signupSuccess');
  String get haveAccountSignIn => _getLocalizedValue('haveAccountSignIn');
  String get continueWithGoogle => _getLocalizedValue('continueWithGoogle');
  String get continueWithFacebook => _getLocalizedValue('continueWithFacebook');
  String get loading => _getLocalizedValue('loading');

  // Subscription Strings
  String get choosePlan => _getLocalizedValue('choosePlan');
  String get choosePlanSubtitle => _getLocalizedValue('choosePlanSubtitle');
  String get monthly => _getLocalizedValue('monthly');
  String get yearly => _getLocalizedValue('yearly');
  String get subscribe => _getLocalizedValue('subscribe');
  String get currentPlan => _getLocalizedValue('currentPlan');
  String get screens => _getLocalizedValue('screens');
  String get profiles => _getLocalizedValue('profiles');
  String get videoQuality => _getLocalizedValue('videoQuality');
  String get downloadAvailable => _getLocalizedValue('downloadAvailable');
  String get adsIncluded => _getLocalizedValue('adsIncluded');
  String get noAds => _getLocalizedValue('noAds');
  String get subscribeSuccess => _getLocalizedValue('subscribeSuccess');
  String get subscriptionFailed => _getLocalizedValue('subscriptionFailed');
  String get fetchingPlans => _getLocalizedValue('fetchingPlans');
  String get subscriptionRequiredInfo => _getLocalizedValue('subscriptionRequiredInfo');
  String get subscriptionRequiredDetail => _getLocalizedValue('subscriptionRequiredDetail');
  
  // Payment Strings
  String get paymentInfo => _getLocalizedValue('paymentInfo');
  String get paymentInfoSubtitle => _getLocalizedValue('paymentInfoSubtitle');
  String get cardNumber => _getLocalizedValue('cardNumber');
  String get cardNumberPlaceholder => _getLocalizedValue('cardNumberPlaceholder');
  String get expiryDate => _getLocalizedValue('expiryDate');
  String get expiryDatePlaceholder => _getLocalizedValue('expiryDatePlaceholder');
  String get cvv => _getLocalizedValue('cvv');
  String get cvvPlaceholder => _getLocalizedValue('cvvPlaceholder');
  String get cardholderName => _getLocalizedValue('cardholderName');
  String get cardholderNamePlaceholder => _getLocalizedValue('cardholderNamePlaceholder');
  String get payNow => _getLocalizedValue('payNow');
  String get cardNumberRequired => _getLocalizedValue('cardNumberRequired');
  String get cardNumberInvalid => _getLocalizedValue('cardNumberInvalid');
  String get expiryDateRequired => _getLocalizedValue('expiryDateRequired');
  String get expiryDateInvalid => _getLocalizedValue('expiryDateInvalid');
  String get cvvRequired => _getLocalizedValue('cvvRequired');
  String get cvvInvalid => _getLocalizedValue('cvvInvalid');
  String get cardholderNameRequired => _getLocalizedValue('cardholderNameRequired');
  String get paymentSuccess => _getLocalizedValue('paymentSuccess');
  String get paymentFailed => _getLocalizedValue('paymentFailed');

  String _getLocalizedValue(String key) {
    switch (locale.languageCode) {
      case 'tr':
        return _turkishStrings[key] ?? '';
      case 'en':
        return _englishStrings[key] ?? '';
      default:
        return _turkishStrings[key] ?? '';
    }
  }

  static const Map<String, String> _turkishStrings = {
    'onboardingTitle': 'Filmler, diziler ve oyunlar birkaç dokunuş uzağınızda',
    'signIn': 'Oturum Aç',
    'signUp': 'Kayıt Ol',
    'loginTitle': 'Oturum açmak için bilgilerinizi girin',
    'loginSubtitle': 'Veya yeni bir hesap oluşturun.',
    'emailOrPhonePlaceholder': 'E-posta veya cep telefonu numarası',
    'continueButton': 'Devam Et',
    'helpText': 'Yardım Al',
    'recaptchaInfo': 'Bu sayfa robot olmadığınızı kanıtlamak için Google reCAPTCHA tarafından korunuyor.',
    'learnMore': 'Daha fazla bilgi',
    'signupTitle': 'Yeni hesap oluşturmak için bilgilerinizi girin',
    'signupSubtitle': 'Zaten bir hesabınız var mı?',
    'emailValidationError': 'Geçerli bir e-posta veya telefon numarası girin',
    'emailRequiredError': 'E-posta veya telefon numarası gereklidir',
    'password': 'Şifre',
    'confirmPassword': 'Şifreyi Onayla',
    'passwordRequired': 'Şifre gereklidir',
    'passwordMinLength': 'Şifre en az 6 karakter olmalıdır',
    'confirmPasswordMatch': 'Şifreler eşleşmiyor',
    'forgotPassword': 'Şifrenizi mi unuttunuz?',
    'loginSuccess': 'Giriş başarılı!',
    'signupSuccess': 'Kayıt başarılı!',
    'haveAccountSignIn': 'Zaten hesabınız var mı?',
    'continueWithGoogle': 'Google ile Devam Et',
    'continueWithFacebook': 'Facebook ile Devam Et',
    'loading': 'Yükleniyor...',
    'choosePlan': 'Planınızı Seçin',
    'choosePlanSubtitle': 'Size en uygun planı seçerek başlayın',
    'monthly': 'Aylık',
    'yearly': 'Yıllık',
    'subscribe': 'Abone Ol',
    'currentPlan': 'Mevcut Plan',
    'screens': 'Ekran',
    'profiles': 'Profil',
    'videoQuality': 'Video Kalitesi',
    'downloadAvailable': 'İndirme Mevcut',
    'adsIncluded': 'Reklam Dahil',
    'noAds': 'Reklamsız',
    'subscribeSuccess': 'Abonelik başarıyla oluşturuldu!',
    'subscriptionFailed': 'Abonelik oluşturulamadı',
    'fetchingPlans': 'Planlar yükleniyor...',
    'subscriptionRequiredInfo': 'Abonelik Gerekli',
    'subscriptionRequiredDetail': 'Profil oluşturmak ve içeriklere erişmek için bir abonelik planı seçmeniz gerekmektedir.',
    'paymentInfo': 'Ödeme Bilgileri',
    'paymentInfoSubtitle': 'Aboneliğinizi tamamlamak için kart bilgilerinizi girin',
    'cardNumber': 'Kart Numarası',
    'cardNumberPlaceholder': '1234 5678 9012 3456',
    'expiryDate': 'Son Kullanma Tarihi',
    'expiryDatePlaceholder': 'MM/YY',
    'cvv': 'CVV',
    'cvvPlaceholder': '123',
    'cardholderName': 'Kart Sahibi Adı',
    'cardholderNamePlaceholder': 'Ad Soyad',
    'payNow': 'Ödemeyi Tamamla',
    'cardNumberRequired': 'Kart numarası gereklidir',
    'cardNumberInvalid': 'Geçerli bir kart numarası girin (16 haneli)',
    'expiryDateRequired': 'Son kullanma tarihi gereklidir',
    'expiryDateInvalid': 'Geçerli bir tarih girin (MM/YY)',
    'cvvRequired': 'CVV gereklidir',
    'cvvInvalid': 'Geçerli bir CVV girin (3-4 haneli)',
    'cardholderNameRequired': 'Kart sahibi adı gereklidir',
    'paymentSuccess': 'Ödeme başarılı!',
    'paymentFailed': 'Ödeme başarısız oldu',
  };

  static const Map<String, String> _englishStrings = {
    'onboardingTitle': 'Movies, series and games are just a few touches away',
    'signIn': 'Sign In',
    'signUp': 'Sign Up',
    'loginTitle': 'Enter your information to sign in',
    'loginSubtitle': 'Or create a new account.',
    'emailOrPhonePlaceholder': 'Email or phone number',
    'continueButton': 'Continue',
    'helpText': 'Get Help',
    'recaptchaInfo': 'This page is protected by Google reCAPTCHA to ensure you are not a robot.',
    'learnMore': 'Learn more',
    'signupTitle': 'Enter your information to create a new account',
    'signupSubtitle': 'Already have an account?',
    'emailValidationError': 'Please enter a valid email or phone number',
    'emailRequiredError': 'Email or phone number is required',
    'password': 'Password',
    'confirmPassword': 'Confirm Password',
    'passwordRequired': 'Password is required',
    'passwordMinLength': 'Password must be at least 6 characters',
    'confirmPasswordMatch': 'Passwords do not match',
    'forgotPassword': 'Forgot password?',
    'loginSuccess': 'Login successful!',
    'signupSuccess': 'Sign up successful!',
    'haveAccountSignIn': 'Already have an account?',
    'continueWithGoogle': 'Continue with Google',
    'continueWithFacebook': 'Continue with Facebook',
    'loading': 'Loading...',
    'choosePlan': 'Choose Your Plan',
    'choosePlanSubtitle': 'Select the plan that works best for you',
    'monthly': 'Monthly',
    'yearly': 'Yearly',
    'subscribe': 'Subscribe',
    'currentPlan': 'Current Plan',
    'screens': 'Screens',
    'profiles': 'Profiles',
    'videoQuality': 'Video Quality',
    'downloadAvailable': 'Download Available',
    'adsIncluded': 'Ads Included',
    'noAds': 'No Ads',
    'subscribeSuccess': 'Subscription created successfully!',
    'subscriptionFailed': 'Failed to create subscription',
    'fetchingPlans': 'Loading plans...',
    'subscriptionRequiredInfo': 'Subscription Required',
    'subscriptionRequiredDetail': 'You need to select a subscription plan to create profiles and access content.',
    'paymentInfo': 'Payment Information',
    'paymentInfoSubtitle': 'Enter your card details to complete your subscription',
    'cardNumber': 'Card Number',
    'cardNumberPlaceholder': '1234 5678 9012 3456',
    'expiryDate': 'Expiry Date',
    'expiryDatePlaceholder': 'MM/YY',
    'cvv': 'CVV',
    'cvvPlaceholder': '123',
    'cardholderName': 'Cardholder Name',
    'cardholderNamePlaceholder': 'Full Name',
    'payNow': 'Complete Payment',
    'cardNumberRequired': 'Card number is required',
    'cardNumberInvalid': 'Please enter a valid card number (16 digits)',
    'expiryDateRequired': 'Expiry date is required',
    'expiryDateInvalid': 'Please enter a valid date (MM/YY)',
    'cvvRequired': 'CVV is required',
    'cvvInvalid': 'Please enter a valid CVV (3-4 digits)',
    'cardholderNameRequired': 'Cardholder name is required',
    'paymentSuccess': 'Payment successful!',
    'paymentFailed': 'Payment failed',
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['tr', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

