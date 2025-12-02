import 'package:flutter/material.dart';
import 'package:mobile/core/utils/web_responsive.dart';
import 'package:mobile/features/content/domain/entities/content.dart';
import 'package:mobile/features/content/presentation/widgets/web/web_content_card.dart';

class ContentListRow extends StatelessWidget {
  final String title;
  final List<Content> contents;

  const ContentListRow({
    super.key,
    required this.title,
    required this.contents,
  });

  @override
  Widget build(BuildContext context) {
    final scaler = context.responsive;
    
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
                color: const Color(0xFFE5E5E5),
                fontSize: scaler.sp(WebDimensions.rowTitleSize),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: scaler.h(WebDimensions.cardHeight),
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
                  padding: scaler.paddingOnly(right: WebDimensions.cardSpacing),
                  child: WebContentCard(
                    key: ValueKey('content_${content.id}'),
                    content: content,
                    aspectRatio: 16 / 9,
                    onTap: () {},
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
