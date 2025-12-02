import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/web_responsive.dart';
import 'package:mobile/features/content/domain/entities/content.dart';
import 'package:mobile/features/content/presentation/widgets/web/web_content_card.dart';

class Top10ListRow extends StatelessWidget {
  final String title;
  final List<Content> contents;

  const Top10ListRow({super.key, required this.title, required this.contents});

  @override
  Widget build(BuildContext context) {
    final scaler = context.responsive;
    final rowHeight = scaler.h(WebDimensions.top10RowHeight);
    final itemWidth = rowHeight * 0.9; // Slightly less than square for better layout
    final posterOffset = itemWidth * 0.35;

    return Padding(
      padding: scaler.paddingOnly(bottom: WebDimensions.rowSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: scaler.paddingSymmetric(
              horizontal: WebDimensions.rowPadding,
              vertical: 10,
            ),
            child: Text(
              title,
              style: TextStyle(
                color: AppColors.sectionTitle,
                fontSize: scaler.sp(WebDimensions.rowTitleSize),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: rowHeight,
            child: ListView.builder(
              padding: scaler.paddingSymmetric(horizontal: WebDimensions.rowPadding),
              scrollDirection: Axis.horizontal,
              itemCount: contents.length,
              cacheExtent: scaler.w(500),
              addAutomaticKeepAlives: false,
              addRepaintBoundaries: true,
              itemBuilder: (context, index) {
                final content = contents[index];
                return Padding(
                  padding: scaler.paddingOnly(right: 20),
                  child: RepaintBoundary(
                    child: SizedBox(
                      width: itemWidth,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          // Big Number (Behind)
                          Positioned(
                            left: 0,
                            bottom: 0,
                            height: rowHeight,
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Stack(
                                children: [
                                  Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      height: 1.0,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = scaler.s(1)
                                        ..color = AppColors.top10Border,
                                    ),
                                  ),
                                  Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      height: 1.0,
                                      color: AppColors.netflixBlack,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Poster (Front)
                          Padding(
                            padding: EdgeInsets.only(left: posterOffset),
                            child: WebContentCard(
                              key: ValueKey('top10_${content.id}'),
                              content: content,
                              isTop10: true,
                              top10Index: index + 1,
                              aspectRatio: 2 / 3,
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
