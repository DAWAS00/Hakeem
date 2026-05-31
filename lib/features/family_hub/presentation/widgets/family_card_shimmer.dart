import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/constants/hakim_spacing.dart';

class FamilyCardShimmer extends StatelessWidget {
  const FamilyCardShimmer({super.key, this.height = 120});

  final double height;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: HakimSpacing.xl),
      child: Shimmer.fromColors(
        baseColor: c.bgCard,
        highlightColor: c.bgSurface,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: c.bgCard,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
