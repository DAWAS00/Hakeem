import 'package:flutter/material.dart';
import 'package:hakeem/core/constants/hakim_colors.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';
import '../../domain/models/settings_models.dart';

class EmergencyContactCard extends StatelessWidget {
  const EmergencyContactCard({
    super.key,
    required this.contact,
    required this.onDelete,
  });

  final EmergencyContact contact;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: HakimSpacing.lg,
        vertical: HakimSpacing.xs,
      ),
      padding: const EdgeInsets.all(HakimSpacing.md),
      decoration: BoxDecoration(
        color: c.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.borderCard),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: c.errorBg,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person_outline_rounded, color: c.error, size: 20),
          ),
          const SizedBox(width: HakimSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: c.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${contact.relationship} · ${contact.phone}',
                  style: TextStyle(fontSize: 12, color: c.textSecondary),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: Icon(Icons.delete_outline_rounded, color: c.error, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: c.errorBg,
              padding: const EdgeInsets.all(6),
              minimumSize: const Size(32, 32),
            ),
          ),
        ],
      ),
    );
  }
}
