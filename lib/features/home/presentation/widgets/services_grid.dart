import 'package:flutter/material.dart';
import '../../../../core/constants/hakim_icons.dart';
import '../../../../shared/widgets/hakim_icon.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../domain/models/home_models.dart';

class ServicesGrid extends StatelessWidget {
  const ServicesGrid({super.key, required this.services});
  final List<ServiceCardModel> services;

  @override
  Widget build(BuildContext context) {
    final gridItems =
        services.where((s) => s.layout == ServiceLayout.grid).toList();
    final wideItems =
        services.where((s) => s.layout == ServiceLayout.wide).toList();

    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = (constraints.maxWidth - 8) / 2;
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: gridItems
                  .map((s) => SizedBox(
                        width: cardWidth,
                        child: _ServiceGridCard(service: s),
                      ))
                  .toList(),
            );
          },
        ),
        if (wideItems.isNotEmpty) const SizedBox(height: 8),
        ...wideItems.map(
          (s) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _ServiceWideCard(service: s),
          ),
        ),
      ],
    );
  }
}

class _ServiceGridCard extends StatelessWidget {
  const _ServiceGridCard({required this.service});
  final ServiceCardModel service;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? Colors.white : const Color(0xFF0F172A);

    return GestureDetector(
      onTap: service.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: c.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? c.border : c.borderCard,
            width: 0.5,
          ),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon — rightmost in RTL row
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: service.bgColor,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Center(
                    child: HakimIcon(
                      service.icon,
                      size: 20,
                      color: service.iconColor,
                    ),
                  ),
                ),
                // Badge — leftmost
                if (service.badge != ServiceBadge.none)
                  _BadgeChip(badge: service.badge)
                else
                  const SizedBox.shrink(),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              service.title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: primaryText,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              service.subtitle,
              style: TextStyle(
                fontSize: 10,
                color: c.textHint,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceWideCard extends StatelessWidget {
  const _ServiceWideCard({required this.service});
  final ServiceCardModel service;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? Colors.white : const Color(0xFF0F172A);

    return GestureDetector(
      onTap: service.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: c.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? c.border : c.borderCard,
            width: 0.5,
          ),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Icon container — rightmost in RTL
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: service.bgColor,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Center(
                child: HakimIcon(
                  service.icon,
                  size: 24,
                  color: service.iconColor,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Title + subtitle — aligned to start (right in RTL)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: primaryText,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    service.subtitle,
                    style: TextStyle(fontSize: 11, color: c.textHint),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Arrow — leftmost in RTL
            HakimIcon(
              HakimIcons.arrowLeft01,
              size: 18,
              color: isDark ? c.border : c.borderCard,
            ),
          ],
        ),
      ),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  const _BadgeChip({required this.badge});
  final ServiceBadge badge;

  @override
  Widget build(BuildContext context) {
    final isNew = badge == ServiceBadge.isNew;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isNew ? const Color(0xFF3B82F6) : const Color(0xFFEF4444),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isNew ? 'جديد' : 'شائع',

        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
