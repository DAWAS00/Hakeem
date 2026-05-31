import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/constants/hakim_spacing.dart';
import '../providers/smart_health_provider.dart';
import '../widgets/health_summary_ai_card.dart';
import '../widgets/symptom_checkin_card.dart';
import '../widgets/lab_result_tile.dart';
import '../widgets/doctor_notes_card.dart';
import '../widgets/smart_health_record_tile.dart';

class SmartHealthScreen extends ConsumerStatefulWidget {
  const SmartHealthScreen({super.key});

  @override
  ConsumerState<SmartHealthScreen> createState() => _SmartHealthScreenState();
}

class _SmartHealthScreenState extends ConsumerState<SmartHealthScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final c = HakimColorScheme.of(context);
    final state = ref.watch(smartHealthProvider);

    return Scaffold(
      backgroundColor: c.bgBase,
      appBar: AppBar(
        backgroundColor: c.bgBase,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'صحتي',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: c.textPrimary,
          ),
        ),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (data) => RefreshIndicator(
          onRefresh: () => ref.read(smartHealthProvider.notifier).refresh(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(HakimSpacing.xl),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Section A — AI Weekly Health Summary
                    HealthSummaryAiCard(summary: data.summary),
                    const SizedBox(height: HakimSpacing.xl),

                    // Section B — Symptom Check-In
                    SymptomCheckinCard(
                      lastCheckInDate: data.summary.lastCheckInDate,
                      onTap: () {
                        // TODO: Open DiaryCheckinSheet (Phase 6)
                      },
                    ),
                    const SizedBox(height: HakimSpacing.xl),

                    // Section C — Lab Results Header
                    _buildSectionHeader(context, 'نتائج المختبر الأخيرة', Icons.biotech_rounded),
                    const SizedBox(height: HakimSpacing.md),
                  ]),
                ),
              ),

              // Section C — Lab Result Tiles
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: HakimSpacing.xl),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final lab = data.summary.labFlags[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: HakimSpacing.md),
                        child: LabResultTile(lab: lab),
                      );
                    },
                    childCount: data.summary.labFlags.length,
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.all(HakimSpacing.xl),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Section D — Doctor Notes Header
                    const SizedBox(height: HakimSpacing.md),
                    _buildSectionHeader(context, 'ملاحظات الأطباء', Icons.history_edu_rounded),
                    const SizedBox(height: HakimSpacing.md),
                  ]),
                ),
              ),

              // Section D — Doctor Notes List
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: HakimSpacing.xl),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final note = data.notes[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: HakimSpacing.md),
                        child: DoctorNotesCard(
                          note: note,
                          onToggle: () => ref.read(smartHealthProvider.notifier).toggleNoteVisibility(note.id),
                        ),
                      );
                    },
                    childCount: data.notes.length,
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.all(HakimSpacing.xl),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Section E — Prescriptions & Imaging (Migrated)
                    const SizedBox(height: HakimSpacing.md),
                    _buildSectionHeader(context, 'وصفات وأشعة سابقة', Icons.folder_open_rounded),
                    const SizedBox(height: HakimSpacing.md),
                    
                    const SmartHealthRecordTile(
                      title: 'وصفة طبية - أموكسيسيلين',
                      date: '15 مايو 2024',
                      hospital: 'د. سامر عبيدات',
                      isAbnormal: false,
                      status: 'مكتملة',
                    ),
                    const SizedBox(height: HakimSpacing.md),
                    const SmartHealthRecordTile(
                      title: 'صورة أشعة للصدر (X-Ray)',
                      date: '10 مايو 2024',
                      hospital: 'مستشفى التخصصي',
                      isAbnormal: false,
                      status: 'متوفرة',
                    ),
                    const SizedBox(height: 100), // Bottom padding for PageView
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    final c = HakimColorScheme.of(context);
    return Row(
      children: [
        Icon(icon, color: c.primary, size: 20),
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
    );
  }
}
