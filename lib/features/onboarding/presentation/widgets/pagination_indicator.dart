import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';

class PaginationIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalPages;

  const PaginationIndicator({
    super.key,
    required this.currentIndex,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == currentIndex
                ? AppColors.netflixWhite
                : AppColors.netflixLightGray.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}

