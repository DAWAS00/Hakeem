import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/constants/hakim_spacing.dart';
import '../../../../shared/widgets/ai_disclaimer_banner.dart';
import '../../domain/models/family_member.dart';

class FamilyMemberHomeCard extends StatelessWidget {
  const FamilyMemberHomeCard({super.key, required this.members});

  final List<FamilyMember> members;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 148,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: HakimSpacing.xl),
        itemCount: members.length,
        itemBuilder: (context, i) => Padding(
          padding: const EdgeInsets.only(left: HakimSpacing.md),
          child: _MemberCard(member: members[i])
              .animate(delay: Duration(milliseconds: 80 * i))
              .fadeIn(duration: 350.ms)
              .slideX(begin: 0.2, end: 0, duration: 350.ms, curve: Curves.easeOut),
        ),
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  const _MemberCard({required this.member});
  final FamilyMember member;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    final complianceColor = member.medicationCompliancePercent >= 80
        ? const Color(0xFF22C55E)
        : member.medicationCompliancePercent >= 50
            ? const Color(0xFFF59E0B)
            : c.error;
    final complianceLabel = member.medicationCompliancePercent >= 80
        ? 'ممتاز'
        : member.medicationCompliancePercent >= 50
            ? 'متوسط'
            : 'منخفض';

    return GestureDetector(
      onTap: () => _showDetailSheet(context),
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(HakimSpacing.md),
        decoration: BoxDecoration(
          color: c.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: c.borderCard),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [c.primary, c.accent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      member.initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: HakimSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: c.textPrimary,
                        ),
                      ),
                      Text(
                        member.relation,
                        style: TextStyle(fontSize: 11, color: c.textHint),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: HakimSpacing.md),

            // Compliance badge — color + icon + text (CLN-001)
            Row(
              children: [
                Icon(Icons.medication_rounded, size: 13, color: complianceColor),
                const SizedBox(width: 3),
                Text(
                  'الالتزام: $complianceLabel',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: complianceColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Compliance bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: member.medicationCompliancePercent / 100,
                backgroundColor: complianceColor.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation(complianceColor),
                minHeight: 5,
              ),
            ),
            const SizedBox(height: HakimSpacing.sm),

            // Lab flag indicator
            if (member.labFlags.isNotEmpty)
              Row(
                children: [
                  Icon(Icons.warning_amber_rounded, size: 12, color: c.error),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      '${member.labFlags.length} تنبيه مخبري',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11, color: c.error),
                    ),
                  ),
                ],
              )
            else
              Row(
                children: [
                  Icon(Icons.check_circle_rounded, size: 12, color: const Color(0xFF22C55E)),
                  const SizedBox(width: 3),
                  Text(
                    'نتائج طبيعية',
                    style: TextStyle(fontSize: 11, color: c.textHint),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _showDetailSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _MemberDetailSheet(member: member),
    );
  }
}

class _MemberDetailSheet extends StatelessWidget {
  const _MemberDetailSheet({required this.member});
  final FamilyMember member;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: c.bgBase,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        HakimSpacing.xl,
        HakimSpacing.lg,
        HakimSpacing.xl,
        MediaQuery.of(context).viewInsets.bottom + HakimSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: c.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: HakimSpacing.xl),

          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [c.primary, c.accent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    member.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: HakimSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: c.textPrimary,
                    ),
                  ),
                  Text(member.relation, style: TextStyle(fontSize: 13, color: c.textHint)),
                ],
              ),
            ],
          ),
          const SizedBox(height: HakimSpacing.xl),

          if (member.nextAppointmentDate != null) ...[
            _DetailRow(
              icon: Icons.calendar_today_rounded,
              iconColor: c.primary,
              label: 'الموعد القادم',
              value: _formatDate(member.nextAppointmentDate!),
            ),
            const SizedBox(height: HakimSpacing.md),
          ],

          if (member.labFlags.isNotEmpty) ...[
            Text(
              'تنبيهات مخبرية',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: c.textPrimary),
            ),
            const SizedBox(height: HakimSpacing.sm),
            ...member.labFlags.map((flag) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, size: 14, color: c.error),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(flag, style: TextStyle(fontSize: 13, color: c.textPrimary)),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: HakimSpacing.md),
          ],

          Text(
            'ملخص حكيم AI',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: c.textPrimary),
          ),
          const SizedBox(height: HakimSpacing.sm),
          Container(
            padding: const EdgeInsets.all(HakimSpacing.md),
            decoration: BoxDecoration(
              color: c.bgCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: c.borderCard),
            ),
            child: Text(
              member.aiSummaryAr,
              style: TextStyle(fontSize: 14, color: c.textPrimary, height: 1.5),
            ),
          ),
          const SizedBox(height: HakimSpacing.sm),
          const AiDisclaimerBanner(),
          const SizedBox(height: HakimSpacing.lg),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) {
    final diff = d.difference(DateTime.now()).inDays;
    if (diff == 0) return 'اليوم';
    if (diff == 1) return 'غداً';
    return 'بعد $diff يوم';
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final c = HakimColorScheme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: HakimSpacing.sm),
        Text('$label: ', style: TextStyle(fontSize: 13, color: c.textHint)),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: c.textPrimary)),
      ],
    );
  }
}
