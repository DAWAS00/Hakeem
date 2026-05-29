import 'package:flutter/material.dart';
import '../../../../core/constants/hakim_icons.dart';
import '../../../../shared/widgets/hakim_icon.dart';
import '../../../../core/constants/hakim_colors.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';

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
    final c = HakimColorScheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: HakimSpacing.xl, vertical: 14),
      child: Row(
        children: [
          // Avatar — rightmost in RTL
          GestureDetector(
            onTap: onAvatarTap,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: c.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: c.accent.withValues(alpha: 0.4),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  _initials,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: c.primaryText,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: HakimSpacing.md),

          // Greeting + name — next to avatar on the right
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _greeting,
                style: TextStyle(
                  fontSize: 12,
                  color: c.textHint,
                ),
              ),
              Text(
                userName,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                ),
              ),
            ],
          ),

          const Spacer(),

          // Notification bell — leftmost in RTL
          GestureDetector(
            onTap: onNotificationTap,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: c.bgCard,
                    shape: BoxShape.circle,
                    border: Border.all(color: c.borderCard),
                  ),
                  child: Center(
                    child: HakimIcon(
                      HakimIcons.notification03,
                      size: 20,
                      color: c.accent,
                    ),
                  ),
                ),
                if (unreadCount > 0)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: c.error,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: c.bgBase,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

