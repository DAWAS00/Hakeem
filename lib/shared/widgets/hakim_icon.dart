import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HakimIcon extends StatelessWidget {
  const HakimIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
  });

  final String icon;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon,
      width: size,
      height: size,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}
