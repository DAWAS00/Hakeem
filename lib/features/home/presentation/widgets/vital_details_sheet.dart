import 'package:flutter/material.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/constants/hakim_spacing.dart';
import '../../../../shared/widgets/hakim_icon.dart';
import '../../domain/models/home_models.dart';

class VitalDetailsSheet extends StatelessWidget {
  const VitalDetailsSheet({super.key, required this.vital});
  final Vital vital;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: HakimSpacing.xl, vertical: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          
          // Header with Icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isDark ? vital.iconColor.withValues(alpha: 0.15) : vital.iconBg,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: HakimIcon(vital.icon, size: 32, color: vital.iconColor),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            vital.label,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            vital.value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: c.primary,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: vital.isGood 
                  ? (isDark ? Colors.green.withValues(alpha: 0.2) : const Color(0xFFF0FDF4))
                  : (isDark ? Colors.orange.withValues(alpha: 0.2) : const Color(0xFFFFF7ED)),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: vital.isGood ? Colors.green.withValues(alpha: 0.3) : Colors.orange.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  vital.isGood ? Icons.check_circle_outline : Icons.info_outline,
                  size: 16,
                  color: vital.isGood ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Text(
                  vital.isGood ? 'حالتك جيدة جداً' : 'تحتاج للاهتمام قليلاً',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: vital.isGood ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Information Sections
          _InfoSection(
            title: 'ماذا يعني هذا؟',
            content: vital.explanation,
            icon: Icons.lightbulb_outline,
          ),
          const SizedBox(height: 20),
          _InfoSection(
            title: 'المعدل الطبيعي',
            content: vital.normalRange,
            icon: Icons.analytics_outlined,
          ),
          
          const SizedBox(height: 32),
          
          // Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: c.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
              ),
              child: const Text(
                'فهمت ذلك',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({
    required this.title,
    required this.content,
    required this.icon,
  });

  final String title;
  final String content;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: c.textPrimary,
              ),
            ),
            const SizedBox(width: 8),
            Icon(icon, size: 18, color: c.primary),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          content,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 13,
            color: c.textHint,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
