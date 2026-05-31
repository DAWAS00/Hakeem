import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/constants/hakim_spacing.dart';
import '../../domain/models/emergency_card.dart';

class EmergencyCardHome extends StatelessWidget {
  const EmergencyCardHome({super.key, required this.card});

  final EmergencyCard card;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: HakimSpacing.xl),
      child: GestureDetector(
        onTap: () => _showFullSheet(context),
        child: Container(
          decoration: BoxDecoration(
            color: c.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: c.borderCard),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header strip
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: HakimSpacing.lg,
                  vertical: HakimSpacing.md,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF013F73),
                      const Color(0xFF0A6FB0),
                    ],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.shield_rounded, color: Colors.white, size: 18),
                    const SizedBox(width: HakimSpacing.sm),
                    Text(
                      'بطاقة الطوارئ',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    // Blood type badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.red.shade700,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        card.bloodType,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Body
              Padding(
                padding: const EdgeInsets.all(HakimSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Allergies
                    Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, size: 14, color: c.error),
                        const SizedBox(width: 4),
                        Text(
                          'حساسية: ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: c.error,
                          ),
                        ),
                        Expanded(
                          child: Wrap(
                            spacing: 4,
                            children: card.allergies
                                .map((a) => _AllergyChip(label: a))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: HakimSpacing.sm),

                    // Emergency contact
                    Row(
                      children: [
                        Icon(Icons.phone_rounded, size: 14, color: c.textHint),
                        const SizedBox(width: 4),
                        Text(
                          '${card.emergencyContactName} — ${card.emergencyContactPhone}',
                          style: TextStyle(fontSize: 12, color: c.textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: HakimSpacing.sm),

                    // View more hint
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'عرض البطاقة كاملة',
                          style: TextStyle(
                            fontSize: 11,
                            color: c.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(Icons.chevron_left_rounded, size: 14, color: c.primary),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.1, end: 0, duration: 400.ms, curve: Curves.easeOut);
  }

  void _showFullSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EmergencyFullSheet(card: card),
    );
  }
}

class _AllergyChip extends StatelessWidget {
  const _AllergyChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: c.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: c.error.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: c.error,
        ),
      ),
    );
  }
}

// ── Full sheet ────────────────────────────────────────────────────────────────

class _EmergencyFullSheet extends StatelessWidget {
  const _EmergencyFullSheet({required this.card});
  final EmergencyCard card;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: c.bgBase,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(
        HakimSpacing.xl,
        HakimSpacing.lg,
        HakimSpacing.xl,
        HakimSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: c.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: HakimSpacing.xl),

          // Title + blood type
          Row(
            children: [
              Icon(Icons.shield_rounded, color: c.primary, size: 22),
              const SizedBox(width: HakimSpacing.sm),
              Text(
                'بطاقة الطوارئ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.red.shade700,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  card.bloodType,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: HakimSpacing.xl),

          _SheetRow(
            icon: Icons.warning_amber_rounded,
            iconColor: c.error,
            label: 'حساسية',
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              children: card.allergies.map((a) => _AllergyChip(label: a)).toList(),
            ),
          ),
          const SizedBox(height: HakimSpacing.lg),

          _SheetRow(
            icon: Icons.medical_services_rounded,
            iconColor: c.primary,
            label: 'أمراض مزمنة',
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              children: card.chronicConditions
                  .map((cc) => _ConditionChip(label: cc))
                  .toList(),
            ),
          ),
          const SizedBox(height: HakimSpacing.lg),

          _SheetRow(
            icon: Icons.phone_rounded,
            iconColor: c.textSecondary,
            label: 'جهة الطوارئ',
            child: Text(
              '${card.emergencyContactName}\n${card.emergencyContactPhone}',
              style: TextStyle(
                fontSize: 14,
                color: c.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: HakimSpacing.xl),

          // QR placeholder
          Container(
            width: double.infinity,
            height: 140,
            decoration: BoxDecoration(
              color: c.bgCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: c.borderCard),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_rounded, size: 32, color: c.textHint),
                const SizedBox(height: 8),
                Text(
                  'رمز QR المشفّر',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: c.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'قريباً — يتطلب التفعيل من الطاقم الطبي',
                  style: TextStyle(fontSize: 11, color: c.textHint),
                ),
              ],
            ),
          ),
          const SizedBox(height: HakimSpacing.xl),
        ],
      ),
    );
  }
}

class _SheetRow extends StatelessWidget {
  const _SheetRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.child,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(width: HakimSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: c.textHint,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              child,
            ],
          ),
        ),
      ],
    );
  }
}

class _ConditionChip extends StatelessWidget {
  const _ConditionChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: c.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: c.primary.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, color: c.primary, fontWeight: FontWeight.w500),
      ),
    );
  }
}
