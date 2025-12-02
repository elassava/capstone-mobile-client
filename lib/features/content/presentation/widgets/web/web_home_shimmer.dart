import 'package:flutter/material.dart';
import 'package:mobile/core/widgets/shimmer_loading_card.dart';

class WebHomeShimmer extends StatelessWidget {
  const WebHomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Section Shimmer
          ShimmerLoadingCard(
            width: double.infinity,
            height: size.height * 0.85,
            borderRadius: 0,
          ),

          const SizedBox(height: 20),

          // Rows Shimmer
          _buildShimmerRow(context),
          _buildShimmerRow(context),
          _buildShimmerRow(context),
        ],
      ),
    );
  }

  Widget _buildShimmerRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Shimmer
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 10.0),
            child: ShimmerLoadingCard(width: 200, height: 24),
          ),

          // Cards Row
          SizedBox(
            height: 130,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              scrollDirection: Axis.horizontal,
              itemCount: 6, // Show a few placeholder cards
              itemBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: ShimmerLoadingCard(
                    width: 230, // Approx 16:9 width for 130 height
                    height: 130,
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
