import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/constants/hakim_spacing.dart';

enum HomeTab { home, appointments, medications, profile }

class HakimBottomNav extends StatelessWidget {
  const HakimBottomNav({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
    required this.homeLabel,
    required this.appointmentsLabel,
    required this.medicationsLabel,
    required this.profileLabel,
  });

  final HomeTab currentTab;
  final ValueChanged<HomeTab> onTabSelected;
  final String homeLabel;
  final String appointmentsLabel;
  final String medicationsLabel;
  final String profileLabel;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 70 + MediaQuery.of(context).padding.bottom,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: HugeIcons.strokeRoundedUser,
            activeIcon: HugeIcons.strokeRoundedUser,
            label: profileLabel,
            isActive: currentTab == HomeTab.profile,
            onTap: () => onTabSelected(HomeTab.profile),
          ),
          _NavItem(
            icon: HugeIcons.strokeRoundedMedicine01,
            activeIcon: HugeIcons.strokeRoundedMedicine01,
            label: medicationsLabel,
            isActive: currentTab == HomeTab.medications,
            onTap: () => onTabSelected(HomeTab.medications),
          ),
          const SizedBox(width: HakimSpacing.xxxl + 10), // Space for FAB
          _NavItem(
            icon: HugeIcons.strokeRoundedCalendar03,
            activeIcon: HugeIcons.strokeRoundedCalendar03,
            label: appointmentsLabel,
            isActive: currentTab == HomeTab.appointments,
            onTap: () => onTabSelected(HomeTab.appointments),
          ),
          _NavItem(
            icon: HugeIcons.strokeRoundedHome01,
            activeIcon: HugeIcons.strokeRoundedHome01,
            label: homeLabel,
            isActive: currentTab == HomeTab.home,
            onTap: () => onTabSelected(HomeTab.home),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final dynamic icon;
  final dynamic activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HugeIcon(
            icon: isActive ? activeIcon : icon,
            color: isActive ? HakimColors.primary : HakimColors.textHint,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: isActive ? HakimColors.primary : HakimColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}
