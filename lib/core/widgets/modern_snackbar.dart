import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';

enum SnackbarType { success, error, info }

/// Modern snackbar widget with glassmorphism and floating effects
class ModernSnackbar extends StatefulWidget {
  final String message;
  final SnackbarType type;

  const ModernSnackbar({super.key, required this.message, required this.type});

  @override
  State<ModernSnackbar> createState() => _ModernSnackbarState();
}

class _ModernSnackbarState extends State<ModernSnackbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _iconAnimationController;
  late Animation<double> _iconScaleAnimation;
  late Animation<double> _iconRotationAnimation;

  @override
  void initState() {
    super.initState();
    _iconAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _iconScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.2,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.2,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_iconAnimationController);

    _iconRotationAnimation =
        Tween<double>(
          begin: 0.0,
          end: widget.type == SnackbarType.error ? 0.1 : 0.0,
        ).animate(
          CurvedAnimation(
            parent: _iconAnimationController,
            curve: Curves.elasticIn,
          ),
        );

    _iconAnimationController.forward();
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    super.dispose();
  }

  Color _getBackgroundGradientStart() {
    switch (widget.type) {
      case SnackbarType.success:
        return const Color(0xFF10B981).withValues(alpha: 0.3);
      case SnackbarType.error:
        return AppColors.netflixRed.withValues(alpha: 0.3);
      case SnackbarType.info:
        return const Color(0xFF3B82F6).withValues(alpha: 0.3);
    }
  }

  Color _getBackgroundGradientEnd() {
    switch (widget.type) {
      case SnackbarType.success:
        return const Color(0xFF059669).withValues(alpha: 0.2);
      case SnackbarType.error:
        return const Color(0xFF991B1B).withValues(alpha: 0.2);
      case SnackbarType.info:
        return const Color(0xFF1E40AF).withValues(alpha: 0.2);
    }
  }

  Color _getIconColor() {
    switch (widget.type) {
      case SnackbarType.success:
        return const Color(0xFF10B981);
      case SnackbarType.error:
        return AppColors.netflixRed;
      case SnackbarType.info:
        return const Color(0xFF3B82F6);
    }
  }

  IconData _getIcon() {
    switch (widget.type) {
      case SnackbarType.success:
        return Icons.check_circle_rounded;
      case SnackbarType.error:
        return Icons.error_rounded;
      case SnackbarType.info:
        return Icons.info_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500, minHeight: 60),
      child: Stack(
        children: [
          // Gradient background layer
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _getBackgroundGradientStart(),
                  _getBackgroundGradientEnd(),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
          ),

          // Glassmorphism layer
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                constraints: const BoxConstraints(minHeight: 60),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: _getIconColor().withValues(alpha: 0.1),
                      blurRadius: 30,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // Animated Icon (Simplified - no background container)
                    AnimatedBuilder(
                      animation: _iconAnimationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _iconScaleAnimation.value,
                          child: Transform.rotate(
                            angle: _iconRotationAnimation.value,
                            child: Icon(
                              _getIcon(),
                              color: _getIconColor(),
                              size: 28,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),

                    // Message
                    Expanded(
                      child: Text(
                        widget.message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
