import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_drawing/path_drawing.dart';
import '../../../core/constants/hakim_colors.dart';

/// An animated version of the Hakeem Heritage Logo.
///
/// Traces the stethoscope line and pops the diaphragm based on [progress].
class AnimatedHakeemHeritageLogo extends StatelessWidget {
  /// Animation progress from 0.0 to 1.0.
  final Animation<double> progress;
  
  /// Total width of the logo. Height is calculated automatically (width * 0.5).
  final double width;
  
  /// Whether the logo is displayed on a dark background.
  final bool onDark;

  const AnimatedHakeemHeritageLogo({
    super.key,
    required this.progress,
    this.width = 280,
    this.onDark = false,
  });

  static const String _stethD =
      'M208 32 C 208 41 222 41 222 49 M238 32 C 238 41 222 41 222 49 '
      'M222 49 C 203 17 104 12 64 41 C 50 51 52 74 60 86';

  @override
  Widget build(BuildContext context) {
    final double height = width * 150 / 300;
    final c = HakimColorScheme.of(context);

    // Sub-animations based on the single progress animation.
    final t = progress.value;
    final wordOpacity = const Interval(0.0, 0.35, curve: Curves.easeOut).transform(t);
    final drawProgress = const Interval(0.15, 0.75, curve: Curves.easeInOutCubic).transform(t);
    final discScale = const Interval(0.70, 1.0, curve: Curves.elasticOut).transform(t);

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 1. The word "حكيم" fades + rises
          Opacity(
            opacity: wordOpacity,
            child: Transform.translate(
              offset: Offset(0, (height * 0.1) * (1 - wordOpacity)),
              child: Padding(
                padding: EdgeInsets.only(top: height * 0.07),
                child: Center(
                  child: Text(
                    'حكيم',
                    textDirection: TextDirection.rtl,
                    style: GoogleFonts.cairo(
                      fontWeight: FontWeight.w800,
                      fontSize: width * 80 / 300,
                      height: 1.0,
                      color: onDark ? Colors.white : c.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // 2. Stethoscope traces on, diaphragm pops
          Positioned.fill(
            child: CustomPaint(
              painter: _StethPainter(
                d: _stethD,
                drawT: drawProgress,
                discT: discScale.clamp(0.0, 1.0),
                color: onDark ? const Color(0xFF74D8F2) : c.primary,
                diaphragmColor: onDark ? Colors.white : c.sanad,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StethPainter extends CustomPainter {
  final String d;
  final double drawT; // 0..1 how much of the line is drawn
  final double discT; // 0..1 diaphragm pop
  final Color color;
  final Color diaphragmColor;

  _StethPainter({
    required this.d,
    required this.drawT,
    required this.discT,
    required this.color,
    required this.diaphragmColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Map the 300 x 150 viewBox onto the widget size.
    final sx = size.width / 300, sy = size.height / 150;
    canvas.save();
    canvas.scale(sx, sy);

    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Draw the line progressively using PathMetrics.
    final full = parseSvgPathData(d);
    final drawn = ui.Path();
    for (final m in full.computeMetrics()) {
      drawn.addPath(m.extractPath(0, m.length * drawT), Offset.zero);
    }
    canvas.drawPath(drawn, stroke);

    // Diaphragm + ear tips appear once the line is essentially done.
    if (discT > 0) {
      final s = discT; // elastic scale
      void dot(double x, double y, double r, Color col, {bool fill = true}) {
        canvas.drawCircle(Offset(x, y), r * s, Paint()
          ..color = col
          ..style = fill ? PaintingStyle.fill : PaintingStyle.stroke
          ..strokeWidth = 6
          ..strokeCap = StrokeCap.round);
      }
      
      // Ear tips
      dot(208, 31, 4.7, color);
      dot(238, 31, 4.7, color);
      
      // Diaphragm
      dot(62, 95, 12.5, color, fill: false); // ring
      dot(62, 95, 3.1, diaphragmColor);      // center
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_StethPainter old) =>
      old.drawT != drawT || old.discT != discT || old.color != color;
}
