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
  String get emailOrPhonePlaceholder =>
      _getLocalizedValue('emailOrPhonePlaceholder');
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
  String get subscriptionRequiredInfo =>
      _getLocalizedValue('subscriptionRequiredInfo');
  String get subscriptionRequiredDetail =>
      _getLocalizedValue('subscriptionRequiredDetail');
  String get signOut => _getLocalizedValue('signOut');
  String get watchOnDevices => _getLocalizedValue('watchOnDevices');
  String get leavePageTitle => _getLocalizedValue('leavePageTitle');
  String get leavePageMessage => _getLocalizedValue('leavePageMessage');
  String get stay => _getLocalizedValue('stay');
  String get leave => _getLocalizedValue('leave');

  // Payment Strings
  String get paymentInfo => _getLocalizedValue('paymentInfo');
  String get paymentInfoSubtitle => _getLocalizedValue('paymentInfoSubtitle');
  String get cardNumber => _getLocalizedValue('cardNumber');
  String get cardNumberPlaceholder =>
      _getLocalizedValue('cardNumberPlaceholder');
  String get expiryDate => _getLocalizedValue('expiryDate');
  String get expiryDatePlaceholder =>
      _getLocalizedValue('expiryDatePlaceholder');
  String get cvv => _getLocalizedValue('cvv');
  String get cvvPlaceholder => _getLocalizedValue('cvvPlaceholder');
  String get cardholderName => _getLocalizedValue('cardholderName');
  String get cardholderNamePlaceholder =>
      _getLocalizedValue('cardholderNamePlaceholder');
  String get payNow => _getLocalizedValue('payNow');
  String get cardNumberRequired => _getLocalizedValue('cardNumberRequired');
  String get cardNumberInvalid => _getLocalizedValue('cardNumberInvalid');
  String get expiryDateRequired => _getLocalizedValue('expiryDateRequired');
  String get expiryDateInvalid => _getLocalizedValue('expiryDateInvalid');
  String get cvvRequired => _getLocalizedValue('cvvRequired');
  String get cvvInvalid => _getLocalizedValue('cvvInvalid');
  String get cardholderNameRequired =>
      _getLocalizedValue('cardholderNameRequired');
  String get paymentSuccess => _getLocalizedValue('paymentSuccess');
  String get paymentFailed => _getLocalizedValue('paymentFailed');

  // Profile Strings
  String get manageProfiles => _getLocalizedValue('manageProfiles');
  String get manageProfilesSubtitle =>
      _getLocalizedValue('manageProfilesSubtitle');
  String get addProfile => _getLocalizedValue('addProfile');
  String get noProfiles => _getLocalizedValue('noProfiles');
  String get noProfilesSubtitle => _getLocalizedValue('noProfilesSubtitle');
  String get profileName => _getLocalizedValue('profileName');
  String get profileNamePlaceholder =>
      _getLocalizedValue('profileNamePlaceholder');
  String get profileNameRequired => _getLocalizedValue('profileNameRequired');
  String get createProfile => _getLocalizedValue('createProfile');
  String get createProfileSubtitle =>
      _getLocalizedValue('createProfileSubtitle');
  String get selectingAvatar => _getLocalizedValue('selectingAvatar');
  String get selectingLanguage => _getLocalizedValue('selectingLanguage');
  String get selectingMaturityLevel =>
      _getLocalizedValue('selectingMaturityLevel');
  String get profileCreated => _getLocalizedValue('profileCreated');
  String get profileCreateFailed => _getLocalizedValue('profileCreateFailed');
  String get maxProfilesReached => _getLocalizedValue('maxProfilesReached');
  String get maxProfilesReachedSubtitle =>
      _getLocalizedValue('maxProfilesReachedSubtitle');
  String get profileLimit => _getLocalizedValue('profileLimit');
  String get profilesUsed => _getLocalizedValue('profilesUsed');
  String get whosWatching => _getLocalizedValue('whosWatching');
  String get deleteProfile => _getLocalizedValue('deleteProfile');
  String get confirmDeleteProfile => _getLocalizedValue('confirmDeleteProfile');
  String get confirmDeleteProfileMessage =>
      _getLocalizedValue('confirmDeleteProfileMessage');
  String get profileDeleted => _getLocalizedValue('profileDeleted');
  String get cannotDeleteLastProfile =>
      _getLocalizedValue('cannotDeleteLastProfile');
  String get cancel => _getLocalizedValue('cancel');
  String get delete => _getLocalizedValue('delete');
  String get done => _getLocalizedValue('done');

  // Home Page Strings
  String get home => _getLocalizedValue('home');
  String get search => _getLocalizedValue('search');
  String get downloads => _getLocalizedValue('downloads');
  String get profile => _getLocalizedValue('profile');
  String get featuredContent => _getLocalizedValue('featuredContent');
  String get trendingNow => _getLocalizedValue('trendingNow');
  String get popularMovies => _getLocalizedValue('popularMovies');
  String get tvSeries => _getLocalizedValue('tvSeries');
  String get newReleases => _getLocalizedValue('newReleases');
  String get play => _getLocalizedValue('play');
  String get myList => _getLocalizedValue('myList');
  String forProfile(String profileName) =>
      _getLocalizedValue('forProfile').replaceAll('{profileName}', profileName);
  String continueWatching(String profileName) => _getLocalizedValue(
    'continueWatching',
  ).replaceAll('{profileName}', profileName);
  String get series => _getLocalizedValue('series');
  String get movies => _getLocalizedValue('movies');
  String get categories => _getLocalizedValue('categories');
  String get newAndPopular => _getLocalizedValue('newAndPopular');
  String get myNetflix => _getLocalizedValue('myNetflix');
  String get rememberMe => _getLocalizedValue('rememberMe');
  String get needHelp => _getLocalizedValue('needHelp');
  String get createPasswordTitle => _getLocalizedValue('createPasswordTitle');
  String get createPasswordSubtitle =>
      _getLocalizedValue('createPasswordSubtitle');
  String get emailPlaceholder => _getLocalizedValue('emailPlaceholder');
  String get addPasswordPlaceholder =>
      _getLocalizedValue('addPasswordPlaceholder');
  String get nextButton => _getLocalizedValue('nextButton');
  String get moreInfo => _getLocalizedValue('moreInfo');

  // Error Messages
  String get errorGeneric => _getLocalizedValue('errorGeneric');
  String get errorNetwork => _getLocalizedValue('errorNetwork');
  String get errorUnknown => _getLocalizedValue('errorUnknown');
  String get errorInvalidCredentials =>
      _getLocalizedValue('errorInvalidCredentials');
  String get errorUserNotFound => _getLocalizedValue('errorUserNotFound');
  String get errorEmailAlreadyExists =>
      _getLocalizedValue('errorEmailAlreadyExists');
  String get errorWeakPassword => _getLocalizedValue('errorWeakPassword');
  String get errorAuthFailed => _getLocalizedValue('errorAuthFailed');
  String get errorSubscriptionFailed =>
      _getLocalizedValue('errorSubscriptionFailed');
  String get errorPaymentDeclined => _getLocalizedValue('errorPaymentDeclined');
  String get errorInvalidPaymentMethod =>
      _getLocalizedValue('errorInvalidPaymentMethod');
  String get errorProfileCreateFailed =>
      _getLocalizedValue('errorProfileCreateFailed');
  String get errorProfileDeleteFailed =>
      _getLocalizedValue('errorProfileDeleteFailed');
  String get errorProfileUpdateFailed =>
      _getLocalizedValue('errorProfileUpdateFailed');
  String get errorContentLoadFailed =>
      _getLocalizedValue('errorContentLoadFailed');
  String get errorContentNotAvailable =>
      _getLocalizedValue('errorContentNotAvailable');

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
    'recaptchaInfo':
        'Bu sayfa robot olmadığınızı kanıtlamak için Google reCAPTCHA tarafından korunuyor.',
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
    'subscriptionRequiredDetail':
        'Profil oluşturmak ve içeriklere erişmek için bir abonelik planı seçmeniz gerekmektedir.',
    'signOut': 'Oturumu Kapat',
    'watchOnDevices': 'TV, bilgisayar, cep telefonu ve tabletinizde izleyin',
    'leavePageTitle': 'Ayrılmak istediğinize emin misiniz?',
    'leavePageMessage':
        'Abonelik işlemini tamamlamadan ayrılırsanız ilerlemeniz kaybolabilir.',
    'stay': 'Kal',
    'leave': 'Ayrıl',
    'paymentInfo': 'Ödeme Bilgileri',
    'paymentInfoSubtitle':
        'Aboneliğinizi tamamlamak için kart bilgilerinizi girin',
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
    'manageProfiles': 'Profilleri Yönet',
    'manageProfilesSubtitle': 'Profilinizi oluşturun veya düzenleyin',
    'addProfile': 'Profil Ekle',
    'noProfiles': 'Henüz profil yok',
    'noProfilesSubtitle': 'İlk profilinizi oluşturarak başlayın',
    'profileName': 'Profil Adı',
    'profileNamePlaceholder': 'Profil adınızı girin',
    'profileNameRequired': 'Profil adı gereklidir',
    'createProfile': 'Profil Oluştur',
    'createProfileSubtitle': 'Yeni bir profil oluşturun',
    'selectingAvatar': 'Avatar Seçimi',
    'selectingLanguage': 'Dil Seçimi',
    'selectingMaturityLevel': 'Olgunluk Seviyesi',
    'profileCreated': 'Profil başarıyla oluşturuldu!',
    'profileCreateFailed': 'Profil oluşturulamadı',
    'maxProfilesReached': 'Maksimum Profil Sayısına Ulaşıldı',
    'maxProfilesReachedSubtitle':
        'Daha fazla profil eklemek için planınızı yükseltin',
    'profileLimit': 'Profil Limiti',
    'profilesUsed': 'Profiller Kullanılıyor',
    'whosWatching': 'Kim İzliyor?',
    'deleteProfile': 'Profili Sil',
    'confirmDeleteProfile': 'Profili Sil',
    'confirmDeleteProfileMessage':
        'Bu profili silmek istediğinizden emin misiniz?',
    'profileDeleted': 'Profil başarıyla silindi',
    'cannotDeleteLastProfile':
        'Son profil silinemez. En az bir profil kalmalıdır.',
    'cancel': 'İptal',
    'delete': 'Sil',
    'done': 'Tamamlandı',
    'home': 'Ana Sayfa',
    'search': 'Ara',
    'downloads': 'İndirilenler',
    'profile': 'Profil',
    'featuredContent': 'Öne Çıkanlar',
    'trendingNow': 'Top 10',
    'popularMovies': 'Popüler Filmler',
    'tvSeries': 'Diziler',
    'newReleases': 'Yeni Çıkanlar',
    'play': 'Oynat',
    'myList': 'Listem',
    'forProfile': '{profileName} için',
    'continueWatching': '{profileName}, İzlemeye Devam Et',
    'series': 'Diziler',
    'movies': 'Filmler',
    'categories': 'Kategoriler',
    'newAndPopular': 'Yeni ve Popüler',
    'myNetflix': 'Benim Netflix\'im',
    'rememberMe': 'Beni hatırla',
    'needHelp': 'Yardım ister misiniz?',
    'createPasswordTitle': 'Üyeliğinizi başlatmak için parolanızı oluşturun',
    'createPasswordSubtitle':
        'Sadece birkaç adım daha kaldı.\nBiz de bürokrasiden hoşlanmayız.',
    'emailPlaceholder': 'E-posta',
    'addPasswordPlaceholder': 'Parola ekle',
    'nextButton': 'İleri',
    'moreInfo': 'Daha Fazla Bilgi',
    // Error Messages
    'errorGeneric': 'Bir hata oluştu. Lütfen tekrar deneyin.',
    'errorNetwork': 'Bağlantı hatası. İnternet bağlantınızı kontrol edin.',
    'errorUnknown': 'Beklenmeyen bir hata oluştu.',
    'errorInvalidCredentials': 'E-posta veya şifre hatalı.',
    'errorUserNotFound': 'Kullanıcı bulunamadı.',
    'errorEmailAlreadyExists': 'Bu e-posta adresi zaten kullanılıyor.',
    'errorWeakPassword': 'Şifreniz çok zayıf. Daha güçlü bir şifre seçin.',
    'errorAuthFailed': 'Giriş yapılamadı. Bilgilerinizi kontrol edin.',
    'errorSubscriptionFailed': 'Abonelik işlemi başarısız oldu.',
    'errorPaymentDeclined':
        'Ödeme reddedildi. Kart bilgilerinizi kontrol edin.',
    'errorInvalidPaymentMethod': 'Geçersiz ödeme yöntemi.',
    'errorProfileCreateFailed': 'Profil oluşturulamadı. Lütfen tekrar deneyin.',
    'errorProfileDeleteFailed': 'Profil silinemedi.',
    'errorProfileUpdateFailed': 'Profil güncellenemedi.',
    'errorContentLoadFailed': 'İçerik yüklenemedi.',
    'errorContentNotAvailable': 'İçerik şu anda mevcut değil.',
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
    'recaptchaInfo':
        'This page is protected by Google reCAPTCHA to ensure you are not a robot.',
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
    'subscriptionRequiredDetail':
        'You need to select a subscription plan to create profiles and access content.',
    'signOut': 'Sign Out',
    'watchOnDevices': 'Watch on your TV, computer, mobile phone and tablet',
    'leavePageTitle': 'Are you sure you want to leave?',
    'leavePageMessage':
        'If you leave without completing your subscription, your progress may be lost.',
    'stay': 'Stay',
    'leave': 'Leave',
    'paymentInfo': 'Payment Information',
    'paymentInfoSubtitle':
        'Enter your card details to complete your subscription',
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
    'manageProfiles': 'Manage Profiles',
    'manageProfilesSubtitle': 'Create or edit your profile',
    'addProfile': 'Add Profile',
    'noProfiles': 'No profiles yet',
    'noProfilesSubtitle': 'Start by creating your first profile',
    'profileName': 'Profile Name',
    'profileNamePlaceholder': 'Enter your profile name',
    'profileNameRequired': 'Profile name is required',
    'createProfile': 'Create Profile',
    'createProfileSubtitle': 'Create a new profile',
    'selectingAvatar': 'Avatar Selection',
    'selectingLanguage': 'Language Selection',
    'selectingMaturityLevel': 'Maturity Level',
    'profileCreated': 'Profile created successfully!',
    'profileCreateFailed': 'Failed to create profile',
    'maxProfilesReached': 'Maximum Profiles Reached',
    'maxProfilesReachedSubtitle': 'Upgrade your plan to add more profiles',
    'profileLimit': 'Profile Limit',
    'profilesUsed': 'Profiles Used',
    'whosWatching': 'Who\'s Watching?',
    'deleteProfile': 'Delete Profile',
    'confirmDeleteProfile': 'Delete Profile',
    'confirmDeleteProfileMessage':
        'Are you sure you want to delete this profile?',
    'profileDeleted': 'Profile deleted successfully',
    'cannotDeleteLastProfile':
        'Cannot delete the last profile. At least one profile must remain.',
    'cancel': 'Cancel',
    'delete': 'Delete',
    'done': 'Done',
    'home': 'Home',
    'search': 'Search',
    'downloads': 'Downloads',
    'profile': 'Profile',
    'featuredContent': 'Featured',
    'trendingNow': 'Top 10',
    'popularMovies': 'Popular Movies',
    'tvSeries': 'TV Series',
    'newReleases': 'New Releases',
    'play': 'Play',
    'myList': 'My List',
    'forProfile': 'For {profileName}',
    'continueWatching': '{profileName}, Continue Watching',
    'series': 'Series',
    'movies': 'Movies',
    'categories': 'Categories',
    'newAndPopular': 'New & Popular',
    'myNetflix': 'My Netflix',
    'rememberMe': 'Remember me',
    'needHelp': 'Need help?',
    'createPasswordTitle': 'Create your password to start your membership',
    'createPasswordSubtitle':
        'Just a few more steps.\nWe hate bureaucracy too.',
    'emailPlaceholder': 'Email',
    'addPasswordPlaceholder': 'Add password',
    'nextButton': 'Next',
    'moreInfo': 'More Info',
    // Error Messages
    'errorGeneric': 'An error occurred. Please try again.',
    'errorNetwork': 'Connection error. Check your internet connection.',
    'errorUnknown': 'An unexpected error occurred.',
    'errorInvalidCredentials': 'Invalid email or password.',
    'errorUserNotFound': 'User not found.',
    'errorEmailAlreadyExists': 'This email address is already in use.',
    'errorWeakPassword':
        'Your password is too weak. Choose a stronger password.',
    'errorAuthFailed': 'Login failed. Check your credentials.',
    'errorSubscriptionFailed': 'Subscription failed.',
    'errorPaymentDeclined': 'Payment declined. Check your card details.',
    'errorInvalidPaymentMethod': 'Invalid payment method.',
    'errorProfileCreateFailed': 'Failed to create profile. Please try again.',
    'errorProfileDeleteFailed': 'Failed to delete profile.',
    'errorProfileUpdateFailed': 'Failed to update profile.',
    'errorContentLoadFailed': 'Failed to load content.',
    'errorContentNotAvailable': 'Content is not available right now.',
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
