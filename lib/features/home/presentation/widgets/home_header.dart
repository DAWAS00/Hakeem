import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/constants/hakim_spacing.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.userName,
    required this.unreadCount,
    this.onNotificationTap,
    this.onAvatarTap,
    required this.morningGreeting,
    required this.afternoonGreeting,
    required this.eveningGreeting,
  });

  final String userName;
  final int unreadCount;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onAvatarTap;
  final String morningGreeting;
  final String afternoonGreeting;
  final String eveningGreeting;

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return morningGreeting;
    if (hour < 17) return afternoonGreeting;
    return eveningGreeting;
  }

  String get _initials {
    final parts = userName.trim().split(' ');
    return parts.isNotEmpty ? parts.first[0] : 'م';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: HakimSpacing.xl, vertical: 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: onAvatarTap,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: HakimColors.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: HakimColors.accent.withValues(alpha: 0.4),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  _initials,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: HakimSpacing.md),

          GestureDetector(
            onTap: onNotificationTap,
            child: Stack(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: const Center(
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedNotification03,
                      size: 20,
                      color: HakimColors.accent,
                    ),
                  ),
                ),
                if (unreadCount > 0)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: HakimColors.error,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const Spacer(),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _greeting,
                style: const TextStyle(
                  fontSize: 12,
                  color: HakimColors.textHint,
                ),
              ),
              Text(
                userName,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).textTheme.titleLarge?.color ?? HakimColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
