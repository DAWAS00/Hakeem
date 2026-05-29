import 'package:flutter/material.dart';
import '../../../../core/constants/hakim_colors.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';
import '../../../../core/constants/hakim_icons.dart';
import '../../../../shared/widgets/hakim_icon.dart';
import '../../domain/models/home_models.dart';

class MedicationScheduleCard extends StatelessWidget {
  const MedicationScheduleCard({
    super.key,
    required this.medications,
    required this.onToggle,
  });

  final List<Medication> medications;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: HakimSpacing.xl),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: HakimSpacing.lg,
        vertical: HakimSpacing.sm,
      ),
      child: Column(
        children: medications
            .map((m) => _MedRow(
                  medication: m,
                  onToggle: () => onToggle(m.id),
                  isLast: medications.last.id == m.id,
                ))
            .toList(),
      ),
    );
  }
}

class _MedRow extends StatelessWidget {
  const _MedRow({
    required this.medication,
    required this.onToggle,
    required this.isLast,
  });

  final Medication medication;
  final VoidCallback onToggle;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: HakimSpacing.md),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
      ),
      child: Row(
        children: [
          // Color dot — rightmost in RTL
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: medication.dotColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: medication.dotColor.withValues(alpha: 0.4),
                  blurRadius: 6,
                ),
              ],
            ),
          ),

          const SizedBox(width: HakimSpacing.md),

          // Name + time — center, aligned to start (right in RTL)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medication.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: medication.isTaken
                        ? HakimColorScheme.of(context).textHint
                        : HakimColorScheme.of(context).textPrimary,
                    decoration: medication.isTaken ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  medication.timeLabel,
                  style: TextStyle(
                    fontSize: 11,
                    color: HakimColorScheme.of(context).textHint,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: HakimSpacing.md),

          // Checkbox — leftmost in RTL
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: medication.isTaken
                    ? HakimColorScheme.of(context).sanad
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: medication.isTaken
                      ? HakimColorScheme.of(context).sanad
                      : HakimColorScheme.of(context).border,
                  width: 2,
                ),
              ),
              child: medication.isTaken
                  ? const HakimIcon(HakimIcons.checkRounded, size: 16, color: Colors.white)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

