import 'package:flutter/material.dart';

/// Custom page transition for Netflix-themed animations
class SlideFadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final bool reverse;

  SlideFadePageRoute({
    required this.child,
    this.reverse = false,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: reverse ? Curves.easeIn : Curves.easeOutCubic,
              reverseCurve: Curves.easeIn,
            );

            // Slide transition
            final slideTween = reverse
                ? Tween<Offset>(
                    begin: const Offset(0.0, 0.1),
                    end: Offset.zero,
                  )
                : Tween<Offset>(
                    begin: const Offset(0.0, 0.15),
                    end: Offset.zero,
                  );

            // Fade transition
            final fadeTween = Tween<double>(begin: 0.0, end: 1.0);

            return SlideTransition(
              position: slideTween.animate(curvedAnimation),
              child: FadeTransition(
                opacity: fadeTween.animate(curvedAnimation),
                child: child,
              ),
            );
          },
        );
}

/// Horizontal slide page transition (for side navigation)
class SlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final bool slideFromRight;

  SlidePageRoute({
    required this.child,
    this.slideFromRight = true,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: const Duration(milliseconds: 350),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeIn,
            );

            final slideTween = slideFromRight
                ? Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  )
                : Tween<Offset>(
                    begin: const Offset(-1.0, 0.0),
                    end: Offset.zero,
                  );

            final fadeTween = Tween<double>(begin: 0.0, end: 1.0);

            return SlideTransition(
              position: slideTween.animate(curvedAnimation),
              child: FadeTransition(
                opacity: fadeTween.animate(curvedAnimation),
                child: child,
              ),
            );
          },
        );
}

/// Fade-only page transition (for subtle transitions)
class FadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  FadePageRoute({
    required this.child,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 250),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            );

            final fadeTween = Tween<double>(begin: 0.0, end: 1.0);

            return FadeTransition(
              opacity: fadeTween.animate(curvedAnimation),
              child: child,
            );
          },
        );
}

