import 'dart:math' as math;

import 'package:flutter/rendering.dart';

import '../../../../core/constants/hakim_colors.dart';

class SplashParticle {
  const SplashParticle({
    required this.angle,
    required this.speed,
    required this.isGreen,
  });

  final double angle;
  final double speed;
  final bool isGreen;
}

/// 12 mini + (cross-shaped) particles burst from [center] outward to
/// [maxRadius] as [progress] 0→1, then fade away.
/// Every 3rd particle uses sanad green; the rest use primary.
class ParticlePainter extends CustomPainter {
  const ParticlePainter({
    required this.progress,
    required this.particles,
    required this.center,
    required this.maxRadius,
  });

  final double progress;
  final List<SplashParticle> particles;
  final Offset center;
  final double maxRadius;

  static double _easeOut(double t) => 1 - math.pow(1 - t, 3).toDouble();

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;

    final ep = _easeOut(progress);

    // fast rise (0→0.9 over first 30%), slow fade (0.9→0 over last 70%)
    final opacity = progress < 0.3
        ? (progress / 0.3) * 0.9
        : 0.9 * (1.0 - (progress - 0.3) / 0.7);

    for (final p in particles) {
      final dist = ep * maxRadius * p.speed;
      final px = center.dx + math.cos(p.angle) * dist;
      final py = center.dy + math.sin(p.angle) * dist;

      final sz = (3.6 * (1.0 - progress * 0.45)).clamp(1.5, 4.0);

      final paint = Paint()
        ..color = (p.isGreen ? HakimColors.sanad : HakimColors.primary)
            .withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      // horizontal arm of mini +
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(px, py), width: sz * 2.8, height: sz * 0.9),
          const Radius.circular(1),
        ),
        paint,
      );
      // vertical arm of mini +
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(px, py), width: sz * 0.9, height: sz * 2.8),
          const Radius.circular(1),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter old) => old.progress != progress;
}
