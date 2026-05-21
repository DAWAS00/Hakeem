import 'dart:math' as math;

import 'package:flutter/animation.dart';

/// Underdamped spring physics curve — produces natural overshoot and settle.
/// Tune [damping] (lower = bouncier) and [stiffness] (higher = faster).
class SpringCurve extends Curve {
  const SpringCurve({
    this.damping = 10.0,
    this.stiffness = 180.0,
  });

  final double damping;
  final double stiffness;

  @override
  double transformInternal(double t) {
    final beta = damping / 2;
    final omega = math.sqrt((stiffness - beta * beta).abs());
    return 1.0 -
        math.exp(-beta * t) *
            (math.cos(omega * t) + (beta / omega) * math.sin(omega * t));
  }
}
