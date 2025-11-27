import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/core/utils/responsive_helper.dart';
import 'package:mobile/features/content/domain/entities/content.dart';

class ContentHorizontalList extends StatelessWidget {
  final String title;
  final List<Content> contents;
  final VoidCallback? onSeeAll;
  final Function(Content)? onContentTap;

  const ContentHorizontalList({
    super.key,
    required this.title,
    required this.contents,
    this.onSeeAll,
    this.onContentTap,
  });

  @override
  Widget build(BuildContext context) {
    if (contents.isEmpty) {
      return const SizedBox.shrink();
    }

    final horizontalPadding = ResponsiveHelper.getResponsiveHorizontalPadding(context);
    final spacing = ResponsiveHelper.getResponsiveSpacing(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Row
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: AppTheme.bold,
                    ),
              ),
              if (onSeeAll != null)
                TextButton(
                  onPressed: onSeeAll,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Tümünü Gör',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.netflixLightGray,
                        ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: spacing),
        // Horizontal Scrollable List
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            itemCount: contents.length,
            itemBuilder: (context, index) {
              final content = contents[index];
              return _ContentCard(
                content: content,
                onTap: () => onContentTap?.call(content),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ContentCard extends StatelessWidget {
  final Content content;
  final VoidCallback? onTap;

  const _ContentCard({
    required this.content,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: content.posterUrl != null && content.posterUrl!.isNotEmpty
              ? Image.network(
                  content.posterUrl!,
                  width: 120,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholder();
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _buildPlaceholder();
                  },
                )
              : _buildPlaceholder(),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 120,
      height: 180,
      color: AppColors.netflixDarkGray,
      child: Center(
        child: Icon(
          content.isMovie ? Icons.movie : Icons.tv,
          color: AppColors.netflixLightGray,
          size: 40,
        ),
      ),
    );
  }
}



