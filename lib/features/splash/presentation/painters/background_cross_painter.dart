import 'package:flutter/rendering.dart';

/// Draws a large faded medical cross behind all content.
/// [rotation] animates from π/4 (45°) → 0 via spring curve.
/// [opacity] ramps from 0 → 0.07 as crossFadeAnim drives it.
class BackgroundCrossPainter extends CustomPainter {
  const BackgroundCrossPainter({
    required this.opacity,
    required this.rotation,
    required this.color,
  });

  final double opacity;
  final double rotation;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (opacity <= 0) return;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final arm = size.width * 0.46;
    final half = size.width * 0.09;

    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(rotation);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: arm * 2, height: half * 2),
        const Radius.circular(8),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: half * 2, height: arm * 2),
        const Radius.circular(8),
      ),
      paint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(BackgroundCrossPainter old) =>
      old.opacity != opacity || old.rotation != rotation || old.color != color;
}
