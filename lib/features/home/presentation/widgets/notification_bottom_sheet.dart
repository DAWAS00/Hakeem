import 'package:flutter/material.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/constants/hakim_spacing.dart';
import '../../../../core/constants/hakim_icons.dart';
import '../../../../shared/widgets/hakim_icon.dart';

class NotificationBottomSheet extends StatelessWidget {
  const NotificationBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          // Drag Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: HakimSpacing.xl),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'تحديد الكل كمقروء',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: c.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Text(
                  'التنبيهات',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: HakimSpacing.xl),
              itemCount: _mockNotifications.length,
              itemBuilder: (context, i) {
                final note = _mockNotifications[i];
                return _NotificationTile(notification: note);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification});
  final _MockNote notification;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: notification.isUnread 
            ? (isDark ? c.primary.withValues(alpha: 0.1) : const Color(0xFFEFF6FF))
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: notification.isUnread ? c.primary.withValues(alpha: 0.2) : Theme.of(context).dividerColor,
          width: 0.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.more_vert, size: 18, color: Colors.grey),
          const Spacer(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (notification.isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: c.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    Text(
                      notification.title,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification.body,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 12,
                    color: c.textHint,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  notification.time,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 10,
                    color: c.textHint.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: notification.iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: HakimIcon(
                notification.icon,
                size: 20,
                color: notification.iconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MockNote {
  final String title;
  final String body;
  final String time;
  final String icon;
  final Color iconColor;
  final Color iconBg;
  final bool isUnread;

  const _MockNote({
    required this.title,
    required this.body,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    this.isUnread = false,
  });
}

final _mockNotifications = [
  const _MockNote(
    title: 'تذكير بموعد دواء',
    body: 'حان الآن موعد تناول دواء Metformin 500mg. يرجى تناوله بعد الطعام.',
    time: 'منذ ١٠ دقائق',
    icon: HakimIcons.medicine01,
    iconColor: Color(0xFFD97706),
    iconBg: Color(0xFFFEF3C7),
    isUnread: true,
  ),
  const _MockNote(
    title: 'نتائج التحاليل جاهزة',
    body: 'تم رفع نتائج تحاليل الدم الشاملة في سجلك الطبي. يمكنك الاطلاع عليها الآن.',
    time: 'منذ ساعتين',
    icon: HakimIcons.microscope,
    iconColor: Color(0xFFE11D48),
    iconBg: Color(0xFFFFE4E6),
    isUnread: true,
  ),
  const _MockNote(
    title: 'تأكيد حجز موعد',
    body: 'تم تأكيد موعدك مع د. سارة العمري غداً الساعة ١٠:٣٠ صباحاً في مستشفى الأردن.',
    time: 'أمس',
    icon: HakimIcons.calendar03,
    iconColor: Color(0xFF3B82F6),
    iconBg: Color(0xFFEFF6FF),
  ),
  const _MockNote(
    title: 'تحديث أهدافك الصحية',
    body: 'رائع! لقد حققت ٨٠٪ من هدف المشي اليومي. استمر في النشاط!',
    time: 'قبل يومين',
    icon: HakimIcons.activity01,
    iconColor: Color(0xFF10B981),
    iconBg: Color(0xFFF0FDF4),
  ),
];
