import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/hakim_spacing.dart';

class HomeLoadingView extends StatelessWidget {
  const HomeLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 14),
        child: Column(
          children: [
            // Header Shimmer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: HakimSpacing.xl),
              child: Row(
                children: [
                  const CircleAvatar(radius: 20),
                  const SizedBox(width: HakimSpacing.md),
                  const CircleAvatar(radius: 20),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(width: 60, height: 10, color: Colors.white),
                      const SizedBox(height: 6),
                      Container(width: 100, height: 16, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: HakimSpacing.xl),
            
            // Card Shimmer
            Container(
              margin: const EdgeInsets.symmetric(horizontal: HakimSpacing.xl),
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: HakimSpacing.xl),

            // Quick Actions Shimmer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: HakimSpacing.xl),
              child: Row(
                children: List.generate(4, (i) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                )),
              ),
            ),
            const SizedBox(height: HakimSpacing.xl),

            // Section Header Shimmer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: HakimSpacing.xl),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(width: 60, height: 12, color: Colors.white),
                  Container(width: 80, height: 12, color: Colors.white),
                ],
              ),
            ),
            const SizedBox(height: HakimSpacing.md),

            // Appointment Card Shimmer
            Container(
              margin: const EdgeInsets.symmetric(horizontal: HakimSpacing.xl),
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
