import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/constants/hakim_spacing.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../providers/home_provider.dart';
import '../widgets/appointment_card.dart';
import '../widgets/health_summary_card.dart';
import '../widgets/home_error_view.dart';
import '../widgets/home_header.dart';
import '../widgets/home_loading_view.dart';
import '../widgets/home_section_header.dart';
import '../widgets/medication_schedule_card.dart';
import '../widgets/services_grid.dart';
import '../widgets/notification_bottom_sheet.dart';
import '../../../family_hub/presentation/providers/family_hub_notifier.dart';
import '../../../family_hub/presentation/widgets/emergency_card_home.dart';
import '../../../family_hub/presentation/widgets/family_member_home_card.dart';
import '../../../family_hub/presentation/widgets/genetic_risk_strip.dart';
import '../../../family_hub/presentation/widgets/family_card_shimmer.dart';

/// The main landing screen for authenticated users.
/// 
/// Displays a personalized greeting, quick actions, health summary,
/// medication schedule, and upcoming appointments.
/// 
/// Features:
/// - Dynamic mascot (Hakim) that responds to user status.
/// - Sticky section headers on scroll.
/// - Speed dial for quick access to core features.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with AutomaticKeepAliveClientMixin {
  late final ScrollController _scroll;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scroll = ScrollController();
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final l10n = AppLocalizations.of(context)!;
    final homeAsync = ref.watch(homeProvider);

    return Scaffold(
      backgroundColor: HakimColorScheme.of(context).bgBase,
      body: homeAsync.when(
        loading: () => const HomeLoadingView(),
        error: (e, _) => HomeErrorView(
          onRetry: () => ref.read(homeProvider.notifier).refresh(),
          errorMessage: l10n.errorLoadingData,
          retryLabel: l10n.retry,
        ),
        data: (state) => CustomScrollView(
          controller: _scroll,
          slivers: [
            SliverToBoxAdapter(
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    HomeHeader(
                      userName: state.userName,
                      unreadCount: state.unreadNotifications,
                      morningGreeting: l10n.goodMorning,
                      afternoonGreeting: l10n.goodAfternoon,
                      eveningGreeting: l10n.goodEvening,
                      onNotificationTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const NotificationBottomSheet(),
                        );
                      },
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: HakimSpacing.xl,
                      ),
                      child: HealthSummaryCard(
                        vitals: state.vitals,
                        status: state.healthStatus,
                        summaryLabel: l10n.healthSummary,
                      ),
                    ),

                    const SizedBox(height: HakimSpacing.lg),

                    HomeSectionHeader(title: l10n.medicationSchedule),
                    MedicationScheduleCard(
                      medications: state.medications,
                      onToggle: (id) =>
                          ref.read(homeProvider.notifier).toggleMedication(id),
                    ),

                    const SizedBox(height: HakimSpacing.lg),

                    HomeSectionHeader(
                      title: l10n.upcomingAppointments,
                      actionLabel: l10n.viewAll,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: HakimSpacing.xl,
                      ),
                      child: Column(
                        children: state.appointments
                            .map((a) => AppointmentCard(appointment: a))
                            .toList(),
                      ),
                    ),

                    const SizedBox(height: HakimSpacing.lg),

                    HomeSectionHeader(title: l10n.services),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: HakimSpacing.xl,
                      ),
                      child: ServicesGrid(services: state.services),
                    ),

                    const SizedBox(height: HakimSpacing.lg),

                    // ── Family Hub Feature Cards ──────────────────────────
                    const _FamilyHubSection(),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Family Hub section — watches its own provider independently ──────────────

class _FamilyHubSection extends ConsumerWidget {
  const _FamilyHubSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final familyAsync = ref.watch(familyHubProvider);

    return familyAsync.when(
      loading: () => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FamilyCardShimmer(height: 110),
          SizedBox(height: HakimSpacing.lg),
          FamilyCardShimmer(height: 148),
          SizedBox(height: HakimSpacing.lg),
          FamilyCardShimmer(height: 60),
        ],
      ),
      // Fail silently — home still works without family data
      error: (e, s) => const SizedBox.shrink(),
      data: (data) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeSectionHeader(title: 'بطاقة الطوارئ'),
          EmergencyCardHome(card: data.emergencyCard),

          const SizedBox(height: HakimSpacing.lg),

          HomeSectionHeader(
            title: 'صحة العائلة',
            actionLabel: 'إضافة فرد',
          ),
          FamilyMemberHomeCard(members: data.members),

          if (data.geneticFlags.isNotEmpty) ...[
            const SizedBox(height: HakimSpacing.lg),
            HomeSectionHeader(title: 'تنبيهات وراثية'),
            GeneticRiskStrip(flags: data.geneticFlags),
          ],
        ],
      ),
    );
  }
}
