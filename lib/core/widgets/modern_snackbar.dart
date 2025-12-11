import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';

enum SnackbarType { success, error, info }

/// Modern snackbar widget with iOS 26 Liquid Glass effect
class ModernSnackbar extends StatefulWidget {
  final String message;
  final SnackbarType type;
  final bool isDarkBackground;

  const ModernSnackbar({
    super.key, 
    required this.message, 
    required this.type,
    this.isDarkBackground = true,
  });

  @override
  State<ModernSnackbar> createState() => _ModernSnackbarState();
}

class _ModernSnackbarState extends State<ModernSnackbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _iconScaleAnimation;
  late Animation<double> _iconRotationAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _iconScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.0),
        weight: 50,
      ),
    ]).animate(_animationController);

    _iconRotationAnimation = Tween<double>(
      begin: 0.0,
      end: widget.type == SnackbarType.error ? 0.1 : 0.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.3, curve: Curves.elasticIn),
      ),
    );

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // iOS 26 Liquid Glass colors
  Color _getAccentColor() {
    switch (widget.type) {
      case SnackbarType.success:
        return const Color(0xFF34D399); // Mint green
      case SnackbarType.error:
        return const Color(0xFFFF6B6B); // Coral red
      case SnackbarType.info:
        return const Color(0xFF60A5FA); // Sky blue
    }
  }

  Color _getSecondaryAccent() {
    switch (widget.type) {
      case SnackbarType.success:
        return const Color(0xFF10B981);
      case SnackbarType.error:
        return const Color(0xFFEF4444);
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
    final accentColor = _getAccentColor();
    final secondaryAccent = _getSecondaryAccent();
    final isDark = widget.isDarkBackground;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          constraints: const BoxConstraints(maxWidth: 500, minHeight: 64),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              // Outer glow - color tinted
              BoxShadow(
                color: accentColor.withValues(alpha: isDark ? 0.25 : 0.15),
                blurRadius: 32,
                spreadRadius: -4,
                offset: const Offset(0, 8),
              ),
              // Soft ambient shadow
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                blurRadius: 24,
                spreadRadius: -8,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Ultra blur layer - iOS 26 style
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

                // Base glass layer
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDark
                          ? [
                              Colors.white.withValues(alpha: 0.12),
                              Colors.white.withValues(alpha: 0.06),
                              Colors.white.withValues(alpha: 0.03),
                            ]
                          : [
                              Colors.white.withValues(alpha: 0.85),
                              Colors.white.withValues(alpha: 0.75),
                              Colors.white.withValues(alpha: 0.65),
                            ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),

                // Spectral/chromatic border effect
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: SweepGradient(
                        center: Alignment.center,
                        startAngle: 0,
                        endAngle: math.pi * 2,
                        colors: [
                          accentColor.withValues(alpha: 0.4),
                          const Color(0xFFE879F9).withValues(alpha: 0.3), // Purple
                          const Color(0xFF60A5FA).withValues(alpha: 0.3), // Blue
                          const Color(0xFF34D399).withValues(alpha: 0.3), // Green
                          accentColor.withValues(alpha: 0.4),
                        ],
                      ),
                    ),
                  ),
                ),

                // Inner glass fill
                Positioned.fill(
                  child: Container(
                    margin: const EdgeInsets.all(1.5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.5),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: isDark
                            ? [
                                const Color(0xFF1A1A2E).withValues(alpha: 0.85),
                                const Color(0xFF16213E).withValues(alpha: 0.75),
                              ]
                            : [
                                Colors.white.withValues(alpha: 0.92),
                                const Color(0xFFF8FAFC).withValues(alpha: 0.88),
                              ],
                      ),
                    ),
                  ),
                ),

                // Top highlight reflection
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 32,
                  child: Container(
                    margin: const EdgeInsets.all(1.5),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(18.5),
                        topRight: Radius.circular(18.5),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: isDark ? 0.15 : 0.5),
                          Colors.white.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),

                // Shimmer effect
                Positioned.fill(
                  child: Container(
                    margin: const EdgeInsets.all(1.5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.5),
                      gradient: LinearGradient(
                        begin: Alignment(-1.0 + _shimmerAnimation.value, -0.3),
                        end: Alignment(-0.5 + _shimmerAnimation.value, 0.3),
                        colors: [
                          Colors.white.withValues(alpha: 0.0),
                          Colors.white.withValues(alpha: isDark ? 0.08 : 0.2),
                          Colors.white.withValues(alpha: 0.0),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),

                // Accent glow on left
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: 80,
                  child: Container(
                    margin: const EdgeInsets.all(1.5),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(18.5),
                        bottomLeft: Radius.circular(18.5),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          accentColor.withValues(alpha: isDark ? 0.2 : 0.12),
                          accentColor.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      // Animated icon with glow
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              accentColor.withValues(alpha: 0.25),
                              secondaryAccent.withValues(alpha: 0.15),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withValues(alpha: 0.3),
                              blurRadius: 12,
                              spreadRadius: -2,
                            ),
                          ],
                        ),
                        child: Transform.scale(
                          scale: _iconScaleAnimation.value,
                          child: Transform.rotate(
                            angle: _iconRotationAnimation.value,
                            child: Icon(
                              _getIcon(),
                              color: accentColor,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Message text
                      Expanded(
                        child: Text(
                          widget.message,
                          style: TextStyle(
                            color: isDark 
                                ? Colors.white.withValues(alpha: 0.95)
                                : const Color(0xFF1E293B),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.1,
                            height: 1.4,
                          ),
                        ),
                      ),

                      // Close indicator dots
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(3, (index) {
                          return Container(
                            width: 4,
                            height: 4,
                            margin: EdgeInsets.only(left: index == 0 ? 0 : 3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (isDark ? Colors.white : const Color(0xFF64748B))
                                  .withValues(alpha: 0.4 - (index * 0.1)),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
