import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/hakim_icons.dart';
import '../../../../core/constants/hakim_spacing.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/models/home_models.dart' show MascotState, SpeedDialItem;
import '../providers/home_provider.dart';
import '../widgets/appointment_card.dart';
import '../widgets/health_summary_card.dart';
import '../widgets/home_error_view.dart';
import '../widgets/home_header.dart';
import '../widgets/home_loading_view.dart';
import '../widgets/home_section_header.dart';
import '../widgets/medication_schedule_card.dart';
import '../widgets/quick_actions_row.dart';
import '../widgets/services_grid.dart';
import '../widgets/speed_dial_overlay.dart';

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

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final ScrollController _scroll;
  Timer? _scrollStopTimer;
  double _lastOffset = 0;

  @override
  void initState() {
    super.initState();
    _scroll = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.dispose();
    _scrollStopTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (ref.read(speedDialProvider)) return;

    final delta = _scroll.offset - _lastOffset;
    _lastOffset = _scroll.offset;

    if (delta.abs() < 1) return;

    final next = delta > 0 ? MascotState.scanning : MascotState.curious;
    if (ref.read(mascotStateProvider) != next) {
      ref.read(mascotStateProvider.notifier).set(next);
    }

    _scrollStopTimer?.cancel();
    _scrollStopTimer = Timer(const Duration(milliseconds: 700), () {
      if (mounted && !ref.read(speedDialProvider)) {
        ref.read(mascotStateProvider.notifier).set(MascotState.idle);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final homeAsync = ref.watch(homeProvider);

    return Scaffold(
      body: homeAsync.when(
        loading: () => const HomeLoadingView(),
        error: (e, _) => HomeErrorView(
          onRetry: () => ref.read(homeProvider.notifier).refresh(),
          errorMessage: l10n.errorLoadingData,
          retryLabel: l10n.retry,
        ),
        data: (state) => Stack(
          children: [
            CustomScrollView(
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

                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: HakimSpacing.xl,
                          ),
                          child: QuickActionsRow(actions: state.quickActions),
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

                        HomeSectionHeader(title: l10n.medicationSchedule),
                        MedicationScheduleCard(
                          medications: state.medications,
                          onToggle: (id) =>
                              ref.read(homeProvider.notifier).toggleMedication(id),
                        ),

                        const SizedBox(height: 200),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SpeedDialOverlay(
              items: [
                SpeedDialItem(
                  label: l10n.bookAppointment,
                  icon: HakimIcons.calendar03,
                  bgColor: const Color(0xFFEFF6FF),
                  iconColor: const Color(0xFF3B82F6),
                  mascotState: MascotState.listening,
                ),
                SpeedDialItem(
                  label: l10n.medicalAssistant,
                  icon: HakimIcons.aiChat01,
                  bgColor: const Color(0xFFEDE9FE),
                  iconColor: const Color(0xFF7C3AED),
                  mascotState: MascotState.thinking,
                ),
                SpeedDialItem(
                  label: l10n.emergency,
                  icon: HakimIcons.ambulance,
                  bgColor: const Color(0xFFFFF1F2),
                  iconColor: const Color(0xFF3B82F6),
                  mascotState: MascotState.surprised,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
