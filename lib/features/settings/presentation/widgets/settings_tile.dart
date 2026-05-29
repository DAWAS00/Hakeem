import 'package:flutter/material.dart';
import 'package:hakeem/core/constants/hakim_colors.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.isDestructive = false,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: HakimSpacing.lg,
          vertical: HakimSpacing.md,
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: HakimSpacing.md),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: isDestructive ? c.error : c.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: TextStyle(fontSize: 13, color: c.textSecondary),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!
            else if (onTap != null)
              Icon(
                Icons.chevron_left_rounded,
                color: c.textHint,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

class SettingsDivider extends StatelessWidget {
  const SettingsDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    return Divider(
      height: 1,
      indent: HakimSpacing.lg,
      endIndent: HakimSpacing.lg,
      color: c.borderCard,
    );
  }
}
