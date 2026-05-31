import 'package:flutter/material.dart';

/// A custom [ScrollPhysics] designed to handle nested horizontal scrolling.
///
/// When the scroll position reaches the boundaries (min or max extent),
/// this physics rejects the overscroll, allowing parent scrollable widgets
/// (like a [PageView]) to pick up the remaining gesture delta.
class NestedScrollPhysics extends ScrollPhysics {
  const NestedScrollPhysics({super.parent});

  @override
  NestedScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return NestedScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    // value is the proposed new position. pixels is current position.
    
    // If the proposed value is less than the current pixels and we are already
    // at or beyond the minimum scroll extent, return the difference (overscroll).
    if (value < position.pixels && position.pixels <= position.minScrollExtent) {
      return value - position.pixels;
    }
    
    // If the proposed value is greater than current pixels and we are already
    // at or beyond the maximum scroll extent, return the difference (overscroll).
    if (position.maxScrollExtent <= position.pixels && position.pixels < value) {
      return value - position.pixels;
    }
    
    // If we are moving towards the boundary and would cross it, 
    // return only the portion that crosses the boundary.
    if (value < position.minScrollExtent && position.minScrollExtent < position.pixels) {
      return value - position.minScrollExtent;
    }
    
    if (position.pixels < position.maxScrollExtent && position.maxScrollExtent < value) {
      return value - position.maxScrollExtent;
    }

    // Otherwise, the movement is within boundaries, return 0.0 (no overscroll rejected).
    return 0.0;
  }
}
