import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../domain/models/nav_item.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static final List<NavItem> _items = [
    const NavItem(
      label: 'Dashboard',
      icon: HugeIcons.strokeRoundedUser, // Placeholder
      routePath: '/dashboard',
    ),
    const NavItem(
      label: 'Schedule',
      icon: HugeIcons.strokeRoundedCalendar03,
      routePath: '/appointments',
    ),
    const NavItem(
      label: 'Home',
      icon: HugeIcons.strokeRoundedHome01,
      routePath: '/home',
    ),
    const NavItem(
      label: 'Medical',
      icon: HugeIcons.strokeRoundedMedicine01,
      routePath: '/records',
    ),
    const NavItem(
      label: 'Settings',
      icon: HugeIcons.strokeRoundedSettings01,
      routePath: '/settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = HakimColorScheme.of(context).bgCard;
    final primaryColor = HakimColorScheme.of(context).primary;
    final unselectedColor = HakimColorScheme.of(context).textSecondary;

    return Container(
      height: 80,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (index) {
          final isSelected = currentIndex == index;
          final item = _items[index];

          return GestureDetector(
            onTap: () => onTap(index),
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 60,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Circular Background for selected item
                      if (isSelected)
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                        )
                            .animate()
                            .scale(
                              duration: 300.ms,
                              curve: Curves.easeOutBack,
                              begin: const Offset(0.5, 0.5),
                              end: const Offset(1, 1),
                            )
                            .fadeIn(),
                      
                      // Icon with elevation/offset animation
                      HugeIcon(
                        icon: item.icon,
                        color: isSelected ? primaryColor : unselectedColor,
                        size: 28,
                      )
                          .animate(target: isSelected ? 1 : 0)
                          .moveY(
                            begin: 0,
                            end: -8,
                            duration: 300.ms,
                            curve: Curves.easeOutBack,
                          )
                          .scale(
                            begin: const Offset(1, 1),
                            end: const Offset(1.1, 1.1),
                            duration: 300.ms,
                          ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? primaryColor : unselectedColor,
                    ),
                  ).animate(target: isSelected ? 1 : 0).fadeIn(duration: 200.ms),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
