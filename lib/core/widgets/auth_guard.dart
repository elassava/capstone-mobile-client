import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter/foundation.dart';

class AuthGuard extends ConsumerWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    // Check if user is authenticated
    // We check both authResponse and token presence
    final isAuthenticated =
        authState.authResponse != null &&
        authState.authResponse!.token.isNotEmpty;

    if (!isAuthenticated) {
      // If not authenticated, redirect to login
      // Using a microtask to avoid build-phase navigation errors
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (kIsWeb) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/login', (route) => false);
        } else {
          // For mobile, we might want to go to splash or login
          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        }
      });

      // Return a loading indicator or empty container while redirecting
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return child;
  }
}
