import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum CustomButtonStyle {
  flat,
  outlined,
}

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final CustomButtonStyle style;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? borderRadius;
  final EdgeInsets? padding;

  const CustomButton({
    super.key,
    this.onPressed,
    required this.text,
    this.style = CustomButtonStyle.flat,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: _buildButton(context),
    );
  }

  Widget _buildButton(BuildContext context) {
    final defaultPadding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
    final defaultBorderRadius = 4.0; // Köşeleri çok az yuvarla
    final defaultfontSize = 16.0;

    switch (style) {
      case CustomButtonStyle.flat:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ??
                AppColors.netflixGray.withValues(alpha: 0.5),
            foregroundColor: foregroundColor ?? AppColors.netflixWhite,
            elevation: 0,
            padding: padding ?? defaultPadding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                borderRadius ?? defaultBorderRadius,
              ),
            ),
          ),
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontSize: defaultfontSize,
                  fontWeight: FontWeight.w600,
                ),
          ),
        );
      case CustomButtonStyle.outlined:
        return Container(
          decoration: BoxDecoration(
            // Glassmorphism: Artırılmış transparanlık
            color: AppColors.netflixBlack.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(
              borderRadius ?? defaultBorderRadius,
            ),
            // Solid border color
            border: Border.all(
              color: borderColor ?? AppColors.netflixWhite,
              width: borderWidth ?? 1,
            ),
          ),
          child: OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: foregroundColor ?? AppColors.netflixWhite,
              side: BorderSide.none, // Container'dan border gelecek
              padding: padding ?? defaultPadding,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  borderRadius ?? defaultBorderRadius,
                ),
              ),
            ),
            child: Text(
              text,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontSize: defaultfontSize,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        );
    }
  }
}

