import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/constants/hakim_spacing.dart';

class SuggestionChipsRow extends StatelessWidget {
  const SuggestionChipsRow({super.key, required this.onChipTap});

  final Function(String) onChipTap;

  static const List<Map<String, dynamic>> _suggestions = [
    {'text': 'متى موعدي القادم؟', 'icon': Icons.calendar_today_rounded},
    {'text': 'متى آخذ دوائي؟', 'icon': Icons.medication_rounded},
    {'text': 'ماذا تعني نتيجة السكر؟', 'icon': Icons.biotech_rounded},
    {'text': 'كيف حالي هذا الأسبوع؟', 'icon': Icons.favorite_rounded},
    {'text': 'احجز موعداً', 'icon': Icons.add_circle_outline_rounded, 'isSpecial': true},
  ];

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: HakimSpacing.xl),
      child: Row(
        children: List.generate(_suggestions.length, (i) {
          final s = _suggestions[i];
          final isSpecial = s['isSpecial'] == true;

          return Padding(
            padding: const EdgeInsets.only(left: HakimSpacing.sm),
            child: ActionChip(
              onPressed: () => onChipTap(s['text'] as String),
              avatar: Icon(
                s['icon'] as IconData,
                size: 15,
                color: isSpecial ? Colors.white : c.primary,
              ),
              label: Text(
                s['text'] as String,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSpecial ? Colors.white : c.textPrimary,
                ),
              ),
              backgroundColor: isSpecial ? c.primary : c.bgCard,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSpecial ? c.primary : c.borderCard,
                ),
              ),
              elevation: 0,
              pressElevation: 2,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            )
                .animate(delay: Duration(milliseconds: 60 * i))
                .fadeIn(duration: 300.ms)
                .slideX(begin: 0.3, end: 0, duration: 300.ms, curve: Curves.easeOut),
          );
        }),
      ),
    );
  }
}
