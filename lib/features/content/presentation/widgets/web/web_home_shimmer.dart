import 'package:flutter/material.dart';
import 'package:mobile/core/utils/web_responsive.dart';
import 'package:mobile/core/widgets/shimmer_loading_card.dart';

class WebHomeShimmer extends StatelessWidget {
  const WebHomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final scaler = context.responsive;
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Section Shimmer
          ShimmerLoadingCard(
            width: double.infinity,
            height: screenHeight * WebDimensions.heroHeightPercent,
            borderRadius: 0,
          ),

          scaler.verticalSpace(20),

          // Rows Shimmer
          _buildShimmerRow(context),
          _buildShimmerRow(context),
          _buildShimmerRow(context),
        ],
      ),
    );
  }

  Widget _buildShimmerRow(BuildContext context) {
    final scaler = context.responsive;
    
    return Padding(
      padding: scaler.paddingOnly(bottom: WebDimensions.rowSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Shimmer
          Padding(
            padding: scaler.paddingSymmetric(
              horizontal: WebDimensions.rowPadding,
              vertical: 10,
            ),
            child: ShimmerLoadingCard(
              width: scaler.w(200),
              height: scaler.h(24),
            ),
          ),

          // Cards Row
          SizedBox(
            height: scaler.h(WebDimensions.cardHeight),
            child: ListView.builder(
              padding: scaler.paddingSymmetric(horizontal: WebDimensions.rowPadding),
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (context, index) {
                return Padding(
                  padding: scaler.paddingOnly(right: WebDimensions.cardSpacing),
                  child: ShimmerLoadingCard(
                    width: scaler.w(230),
                    height: scaler.h(WebDimensions.cardHeight),
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
