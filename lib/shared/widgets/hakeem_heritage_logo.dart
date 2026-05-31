import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/hakim_colors.dart';

class HakeemHeritageLogo extends StatelessWidget {
  final double width;
  final bool onDark;
  
  const HakeemHeritageLogo({
    super.key, 
    this.width = 260, 
    this.onDark = false,
  });

  @override
  Widget build(BuildContext context) {
    // The source artwork uses a 300 x 150 viewBox.
    final double height = width * 150 / 300;
    final steth = onDark
        ? 'assets/hakeem/heritage/heritage_stethoscope_white.svg'
        : 'assets/hakeem/heritage/heritage_stethoscope.svg';

    final c = HakimColorScheme.of(context);

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // الكلمة (the word) — sits behind the stethoscope, matching the artwork
          Padding(
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
          // the stethoscope drape (its coordinates already wrap the word)
          Positioned.fill(
            child: SvgPicture.asset(
              steth, 
              fit: BoxFit.contain,
              // Ensure we don't have issues if the SVG doesn't exist yet in the cache
            ),
          ),
        ],
      ),
    );
  }
}
