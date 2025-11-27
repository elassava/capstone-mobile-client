import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/di/service_locator.dart';
import 'package:mobile/core/localization/app_localizations.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:mobile/features/auth/presentation/pages/web/web_login_page.dart';
import 'package:mobile/features/auth/presentation/pages/web/web_register_page.dart';
import 'package:mobile/features/splash/presentation/pages/splash_page.dart';
import 'package:mobile/features/subscription/presentation/pages/subscription_plan_page.dart';
import 'package:mobile/features/subscription/presentation/pages/web/web_payment_page.dart';
import 'package:mobile/features/subscription/domain/entities/subscription_plan.dart';
import 'package:mobile/features/profile/presentation/pages/web/web_profile_selection_page.dart';
import 'package:mobile/features/profile/presentation/pages/profile_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Use PathUrlStrategy to remove the hash (#) from the URL
  usePathUrlStrategy();

  // Initialize dependency injection
  await setupServiceLocator();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Netflix Clone',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('tr', ''), Locale('en', '')],
      locale: const Locale('tr', ''),
      initialRoute: '/',
      routes: {
        '/': (context) => kIsWeb ? const WebLoginPage() : const SplashPage(),
        '/login': (context) => const WebLoginPage(),
        '/register': (context) => const WebRegisterPage(),
        '/plans': (context) => const SubscriptionPlanPage(),
        '/payment': (context) {
          final plan = ModalRoute.of(context)!.settings.arguments;
          return WebPaymentPage(selectedPlan: plan as SubscriptionPlan);
        },
        '/profiles': (context) =>
            kIsWeb ? const WebProfileSelectionPage() : const ProfileListPage(),
      },
    );
  }
}
