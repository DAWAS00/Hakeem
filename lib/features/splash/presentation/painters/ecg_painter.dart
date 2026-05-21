import 'dart:math' as math;

import 'package:flutter/rendering.dart';

/// Draws a medically-accurate P-QRS-T waveform that reveals itself
/// left-to-right as [progress] 0→1. A bright dot rides the tip of
/// the line as it draws for a "live signal" feel.
class EcgPainter extends CustomPainter {
  const EcgPainter({
    required this.progress,
    required this.color,
    required this.opacity,
  });

  final double progress;
  final Color color;
  final double opacity;

  static const double _kH = 24.0;
  static const List<Offset> _waypoints = [
    Offset(0, 0),
    Offset(40, 0),
    Offset(52, -4),   // P wave
    Offset(58, -7),
    Offset(64, -4),
    Offset(70, 0),
    Offset(82, 0),    // PR segment
    Offset(88, 4),    // Q dip
    Offset(92, -18),  // R spike
    Offset(96, 5),    // S dip
    Offset(102, 0),
    Offset(114, 0),   // ST segment
    Offset(122, -5),  // T wave
    Offset(130, -9),
    Offset(138, -5),
    Offset(146, 0),
    Offset(220, 0),   // baseline end
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final totalWidth = size.width;
    final baseline = _kH / 2 + 2;
    final scaleX = totalWidth / _waypoints.last.dx;

    final path = Path();
    for (var i = 0; i < _waypoints.length; i++) {
      final x = _waypoints[i].dx * scaleX;
      final y = baseline + _waypoints[i].dy;
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }

    final revealX = totalWidth * progress;
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, revealX, size.height));
    canvas.drawPath(
      path,
      Paint()
        ..color = color.withValues(alpha: opacity)
        ..strokeWidth = 1.4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.restore();

    // leading glow dot
    if (progress > 0.02 && progress < 0.99) {
      final tipX = revealX.clamp(0.0, totalWidth);
      double tipY = baseline;
      for (var i = 1; i < _waypoints.length; i++) {
        final x0 = _waypoints[i - 1].dx * scaleX;
        final x1 = _waypoints[i].dx * scaleX;
        if (tipX >= x0 && tipX <= x1) {
          final t = (tipX - x0) / (x1 - x0);
          tipY = baseline +
              (_waypoints[i - 1].dy +
                  (_waypoints[i].dy - _waypoints[i - 1].dy) * t);
          break;
        }
      }
      canvas.drawCircle(
        Offset(tipX, tipY),
        2.5,
        Paint()
          ..color = color.withValues(alpha: math.min(1.0, opacity * 2.5))
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(EcgPainter old) =>
      old.progress != progress || old.color != color;
}
