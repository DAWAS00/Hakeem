import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/hakim_icons.dart';
import '../../../../shared/widgets/hakim_icon.dart';
import '../../../../core/constants/hakim_colors.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';
import '../providers/family_provider.dart';

class HomeHeader extends ConsumerWidget {
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

  void _showProfilePicker(BuildContext context, WidgetRef ref) {
    final c = HakimColorScheme.of(context);
    final profiles = ref.read(availableProfilesProvider);
    final current = ref.read(familyProfileProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: c.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(HakimSpacing.lg),
              child: Text(
                'تبديل الملف الشخصي',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                ),
              ),
            ),
            ...profiles.map((profile) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: profile.isMe ? c.primary : c.bgInput,
                    child: Text(
                      profile.initials,
                      style: TextStyle(
                        color: profile.isMe ? c.primaryText : c.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    profile.name,
                    style: TextStyle(
                      color: c.textPrimary,
                      fontWeight: current.id == profile.id
                          ? FontWeight.w700
                          : FontWeight.w400,
                    ),
                  ),
                  subtitle: Text(profile.relationship),
                  trailing: current.id == profile.id
                      ? Icon(Icons.check_circle, color: c.primary)
                      : null,
                  onTap: () {
                    ref.read(familyProfileProvider.notifier).selectProfile(profile);
                    Navigator.pop(context);
                  },
                )),
            const SizedBox(height: HakimSpacing.lg),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = HakimColorScheme.of(context);
    final currentProfile = ref.watch(familyProfileProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: HakimSpacing.xl, vertical: 14),
      child: Row(
        children: [
          // Avatar
          GestureDetector(
            onTap: onAvatarTap ?? () => _showProfilePicker(context, ref),
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
                  currentProfile.initials,
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

          // Greeting + name
          GestureDetector(
            onTap: () => _showProfilePicker(context, ref),
            behavior: HitTestBehavior.opaque,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _greeting,
                  style: TextStyle(
                    fontSize: 12,
                    color: c.textHint,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currentProfile.isMe ? userName : currentProfile.name,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: c.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: c.textHint,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Spacer(),

          // Notification bell
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

