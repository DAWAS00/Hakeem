import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hakeem/core/constants/hakim_colors.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';
import 'package:hakeem/core/l10n/app_localizations.dart';

class RecordsScreen extends ConsumerStatefulWidget {
  const RecordsScreen({super.key});

  @override
  ConsumerState<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends ConsumerState<RecordsScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  void _showSecureShare(BuildContext context, String recordTitle) {
    final c = HakimColorScheme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: c.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'مشاركة آمنة',
          style: TextStyle(color: c.textPrimary, fontWeight: FontWeight.w700),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'سيتم إنشاء رابط مؤقت ومحمي برمز PIN لمشاركة $recordTitle.',
              style: TextStyle(color: c.textSecondary),
            ),
            const SizedBox(height: HakimSpacing.xl),
            Container(
              padding: const EdgeInsets.all(HakimSpacing.md),
              decoration: BoxDecoration(
                color: c.bgInput,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'PIN: 5821',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: c.primary,
                      letterSpacing: 4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: c.textHint)),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            style: FilledButton.styleFrom(backgroundColor: c.primary),
            child: const Text('نسخ الرابط'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final c = HakimColorScheme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: c.bgBase,
      appBar: AppBar(
        backgroundColor: c.bgBase,
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.medicalRecord,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: c.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(HakimSpacing.xl),
        children: [
          _buildCategoryHeader(context, 'النتائج المخبرية', Icons.biotech_rounded),
          _buildRecordTile(
            context,
            title: 'فحص دم شامل (CBC)',
            date: '24 مايو 2024',
            hospital: 'مستشفى الملك عبد الله المؤسس',
            isAbnormal: true,
            status: 'قراءة مرتفعة',
          ),
          _buildRecordTile(
            context,
            title: 'فحص السكر الصيامي',
            date: '20 مايو 2024',
            hospital: 'مركز صحي إربد الشامل',
            isAbnormal: false,
            status: 'طبيعي',
          ),
          const SizedBox(height: HakimSpacing.xl),
          
          _buildCategoryHeader(context, 'الوصفات الطبية', Icons.medication_rounded),
          _buildRecordTile(
            context,
            title: 'وصفة طبية - أموكسيسيلين',
            date: '15 مايو 2024',
            hospital: 'د. سامر عبيدات',
            isAbnormal: false,
            status: 'مكتملة',
          ),
          const SizedBox(height: HakimSpacing.xl),
          
          _buildCategoryHeader(context, 'الأشعة والتصوير', Icons.settings_remote_rounded),
          _buildRecordTile(
            context,
            title: 'صورة أشعة للصدر (X-Ray)',
            date: '10 مايو 2024',
            hospital: 'مستشفى التخصصي',
            isAbnormal: false,
            status: 'متوفرة',
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(BuildContext context, String title, IconData icon) {
    final c = HakimColorScheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: HakimSpacing.md),
      child: Row(
        children: [
          // Icon — rightmost in RTL
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: c.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: c.primary, size: 18),
          ),
          const SizedBox(width: HakimSpacing.sm),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordTile(
    BuildContext context, {
    required String title,
    required String date,
    required String hospital,
    required bool isAbnormal,
    required String status,
  }) {
    final c = HakimColorScheme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: HakimSpacing.md),
      padding: const EdgeInsets.all(HakimSpacing.lg),
      decoration: BoxDecoration(
        color: c.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.borderCard),
      ),
      child: Row(
        children: [
          // Content — rightmost in RTL
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: c.textPrimary,
                        ),
                      ),
                    ),
                    if (isAbnormal) ...[
                      const SizedBox(width: HakimSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: c.errorBg,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'غير طبيعي',
                          style: TextStyle(
                            color: c.error,
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '$hospital • $date',
                  style: TextStyle(fontSize: 12, color: c.textHint),
                ),
                const SizedBox(height: HakimSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isAbnormal
                        ? c.error.withValues(alpha: 0.1)
                        : c.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isAbnormal ? c.error : c.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Actions — leftmost in RTL
          IconButton(
            onPressed: () => _showSecureShare(context, title),
            icon: Icon(Icons.share_outlined, color: c.primary, size: 20),
          ),
          Icon(Icons.chevron_left_rounded, color: c.textHint),
        ],
      ),
    );
  }
}
