import 'package:flutter/material.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/enums/login_method.dart';

class TabSwitcher extends StatelessWidget {
  const TabSwitcher({
    super.key,
    required this.active,
    required this.onSwitch,
  });

  final LoginMethod active;
  final ValueChanged<LoginMethod> onSwitch;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final c = HakimColorScheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 42,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: c.bgBase,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.border, width: 0.5),
      ),
      child: Row(
        children: [
          _TabItem(
            label: l10n.phone,
            isActive: active == LoginMethod.phone,
            isDark: isDark,
            onTap: () => onSwitch(LoginMethod.phone),
          ),
          _TabItem(
            label: l10n.nationalId,
            isActive: active == LoginMethod.nationalId,
            isDark: isDark,
            onTap: () => onSwitch(LoginMethod.nationalId),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive
                ? (isDark ? c.info : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isActive && !isDark
                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 4)]
                : [],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isActive
                  ? (isDark ? Colors.white : c.info)
                  : c.textHint,
            ),
          ),
        ),
      ),
    );
  }
}
