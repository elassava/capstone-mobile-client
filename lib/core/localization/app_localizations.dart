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

