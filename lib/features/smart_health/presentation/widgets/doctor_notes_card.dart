import 'package:flutter/material.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/constants/hakim_spacing.dart';
import '../../../smart_health/domain/models/doctor_note.dart';

class DoctorNotesCard extends StatelessWidget {
  const DoctorNotesCard({
    super.key,
    required this.note,
    required this.onToggle,
  });

  final DoctorNote note;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: HakimRadius.bxl,
        side: BorderSide(color: c.borderCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(HakimSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.description_outlined, color: c.primary, size: 20),
                        const SizedBox(width: HakimSpacing.sm),
                        Text(
                          'ملاحظات الطبيب',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: c.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    _buildToggleChip(context),
                  ],
                ),
                const SizedBox(height: HakimSpacing.md),
                Text(
                  note.isSimplifiedVisible ? note.simplifiedNoteAr : note.rawNote,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: c.textSecondary,
                  ),
                ),
                const SizedBox(height: HakimSpacing.md),
                Row(
                  children: [
                    Text(
                      '${note.doctorName} • ',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: c.textHint),
                    ),
                    Text(
                      'منذ يومين', // Placeholder for formatted date
                      style: TextStyle(fontSize: 12, color: c.textHint),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleChip(BuildContext context) {
    final c = HakimColorScheme.of(context);
    return InkWell(
      onTap: onToggle,
      borderRadius: HakimRadius.bpill,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: HakimSpacing.md, vertical: 4),
        decoration: BoxDecoration(
          color: c.bgSurface,
          borderRadius: HakimRadius.bpill,
          border: Border.all(color: c.borderCard),
          ),

        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              note.isSimplifiedVisible ? Icons.auto_awesome_rounded : Icons.code_rounded,
              size: 14,
              color: c.primary,
            ),
            const SizedBox(width: 6),
            Text(
              note.isSimplifiedVisible ? 'شرح مبسّط' : 'النص الأصلي',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: c.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
