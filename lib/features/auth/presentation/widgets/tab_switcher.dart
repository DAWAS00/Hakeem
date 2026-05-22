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

    return Container(
      height: 42,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF0E1A26)
            : HakimColorScheme.of(context).primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _TabItem(
            label: l10n.phone,
            isActive: active == LoginMethod.phone,
            onTap: () => onSwitch(LoginMethod.phone),
          ),
          _TabItem(
            label: l10n.nationalId,
            isActive: active == LoginMethod.nationalId,
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
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: isActive ? HakimColorScheme.of(context).primary : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive
                  ? (Theme.of(context).brightness == Brightness.dark
                      ? HakimColorScheme.of(context).primaryText
                      : Colors.white)
                  : HakimColorScheme.of(context).textHint,
            ),
          ),
        ),
      ),
    );
  }
}
