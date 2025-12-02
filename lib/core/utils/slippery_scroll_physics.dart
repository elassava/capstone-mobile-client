import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class SlipperyScrollPhysics extends BouncingScrollPhysics {
  const SlipperyScrollPhysics({super.parent});

  @override
  SlipperyScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SlipperyScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double get minFlingVelocity => 30.0; // Lower threshold to allow slower flings

  @override
  double get dragStartDistanceMotionThreshold => 3.5; // Default

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    final Tolerance tolerance = toleranceFor(position);
    if (velocity.abs() >= tolerance.velocity || position.outOfRange) {
      return BouncingScrollSimulation(
        spring: spring,
        position: position.pixels,
        velocity:
            velocity *
            1.5, // Significantly amplify velocity for "slippery" feel
        leadingExtent: position.minScrollExtent,
        trailingExtent: position.maxScrollExtent,
        tolerance: tolerance,
      );
    }
    return null;
  }
}
