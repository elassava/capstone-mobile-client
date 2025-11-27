import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/core/theme/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final EdgeInsets? contentPadding;
  final Widget? suffixIcon;

  final List<TextInputFormatter>? inputFormatters;
  final Color? fillColor;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final Color? borderColor;

  const CustomTextField({
    super.key,
    this.hintText,
    this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.contentPadding,
    this.suffixIcon,
    this.inputFormatters,
    this.fillColor,
    this.hintStyle,
    this.style,
    this.borderColor,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with SingleTickerProviderStateMixin {
  late FocusNode _internalFocusNode;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  bool _isUsingExternalFocusNode = false;

  @override
  void initState() {
    super.initState();

    // Use external focus node if provided, otherwise create internal one
    _internalFocusNode = widget.focusNode ?? FocusNode();
    _isUsingExternalFocusNode = widget.focusNode != null;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.01).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    // Listen to focus changes
    _internalFocusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    if (!_isUsingExternalFocusNode) {
      _internalFocusNode.dispose();
    } else {
      _internalFocusNode.removeListener(_handleFocusChange);
    }
    _animationController.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_internalFocusNode.hasFocus) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                if (_animationController.value > 0)
                  BoxShadow(
                    color: AppColors.netflixRed.withValues(
                      alpha: 0.3 * _glowAnimation.value,
                    ),
                    blurRadius: 12 * _glowAnimation.value,
                    spreadRadius: 0,
                  ),
              ],
            ),
            child: TextFormField(
              controller: widget.controller,
              validator: widget.validator,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              onChanged: widget.onChanged,
              onFieldSubmitted: widget.onSubmitted,
              focusNode: _internalFocusNode,
              inputFormatters: widget.inputFormatters,
              style:
                  widget.style ??
                  Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.netflixWhite,
                  ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle:
                    widget.hintStyle ??
                    Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.netflixLightGray.withValues(alpha: 0.7),
                    ),
                filled: true,
                fillColor: widget.fillColor ?? AppColors.netflixDarkGray,
                contentPadding:
                    widget.contentPadding ??
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(
                    color:
                        widget.borderColor ??
                        AppColors.netflixLightGray.withValues(alpha: 0.3),
                    width: 0.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(
                    color:
                        widget.borderColor ??
                        AppColors.netflixLightGray.withValues(alpha: 0.3),
                    width: 0.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(
                    color: AppColors.netflixRed,
                    width: 1.5,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: AppColors.netflixRed, width: 1),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(
                    color: AppColors.netflixRed,
                    width: 1.5,
                  ),
                ),
                errorStyle: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.netflixRed),
                suffixIcon: widget.suffixIcon,
              ),
            ),
          ),
        );
      },
    );
  }
}
