import 'package:flutter/material.dart';
import 'package:hakeem/core/constants/hakim_colors.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, required this.initials, this.size = 64});

  final String initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: c.primary,
        shape: BoxShape.circle,
        border: Border.all(color: c.borderFocus, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: size * 0.35,
          fontWeight: FontWeight.w700,
          color: c.primaryText,
        ),
      ),
    );
  }
}
