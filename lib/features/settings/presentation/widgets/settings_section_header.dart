import 'package:flutter/material.dart';
import 'package:hakeem/core/constants/hakim_colors.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';

class SettingsSectionHeader extends StatelessWidget {
  const SettingsSectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        HakimSpacing.lg,
        HakimSpacing.xl,
        HakimSpacing.lg,
        HakimSpacing.sm,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: c.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
