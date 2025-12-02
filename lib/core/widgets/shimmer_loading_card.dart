import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingCard extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoadingCard({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[900]!,
      highlightColor: Colors.grey[800]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
