import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../domain/models/home_models.dart';
import '../providers/home_provider.dart';
import '../widgets/home_header.dart';
import '../widgets/health_summary_card.dart';
import '../widgets/quick_actions_row.dart';
import '../widgets/home_section_header.dart';
import '../widgets/appointment_card.dart';
import '../widgets/services_grid.dart';
import '../widgets/medication_schedule_card.dart';
import '../widgets/hakim_bottom_nav.dart';
import '../widgets/speed_dial_overlay.dart';
import '../widgets/home_loading_view.dart';
import '../widgets/home_error_view.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  HomeTab _currentTab = HomeTab.home;

  List<SpeedDialItem> _buildSpeedDialItems(BuildContext context, AppLocalizations l10n) => [
    SpeedDialItem(
      label: l10n.bookAppointment,
      icon: HugeIcons.strokeRoundedCalendar03,
      bgColor: HakimColors.primary,
      iconColor: Colors.white,
      onTap: () => _navigate('/appointments/book'),
    ),
    SpeedDialItem(
      label: l10n.labResults,
      icon: HugeIcons.strokeRoundedMicroscope,
      bgColor: Theme.of(context).cardColor,
      iconColor: HakimColors.accent,
      onTap: () => _navigate('/results'),
    ),
    SpeedDialItem(
      label: l10n.myMedications,
      icon: HugeIcons.strokeRoundedMedicine01,
      bgColor: Theme.of(context).cardColor,
      iconColor: Colors.orange,
      onTap: () => _navigate('/medications'),
    ),
    SpeedDialItem(
      label: l10n.medicalRecord,
      icon: HugeIcons.strokeRoundedFolder01,
      bgColor: Theme.of(context).cardColor,
      iconColor: HakimColors.accent,
      onTap: () => _navigate('/medical-record'),
    ),
    SpeedDialItem(
      label: l10n.medicalAssistant,
      icon: HugeIcons.strokeRoundedAiChat01,
      bgColor: Theme.of(context).cardColor,
      iconColor: HakimColors.accent,
      onTap: () => _navigate('/assistant'),
    ),
    SpeedDialItem(
      label: l10n.nearestHospital,
      icon: HugeIcons.strokeRoundedHospital01,
      bgColor: Theme.of(context).cardColor,
      iconColor: HakimColors.sanad,
      onTap: () => _navigate('/nearby'),
    ),
    SpeedDialItem(
      label: l10n.emergency,
      icon: HugeIcons.strokeRoundedAmbulance,
      bgColor: HakimColors.error.withValues(alpha: 0.1),
      iconColor: HakimColors.error,
      onTap: () => _navigate('/emergency'),
    ),
    SpeedDialItem(
      label: l10n.billing,
      icon: HugeIcons.strokeRoundedInvoice01,
      bgColor: Theme.of(context).cardColor,
      iconColor: HakimColors.accent,
      onTap: () => _navigate('/billing'),
    ),
  ];

  void _navigate(String route) {
    debugPrint('Navigate to $route');
  }

  @override
  Widget build(BuildContext context) {
    final homeAsync = ref.watch(homeProvider);
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Stack(
            children: [
              homeAsync.when(
                loading: () => const HomeLoadingView(),
                error:   (e, _) => HomeErrorView(
                  errorMessage: l10n.errorLoadingData,
                  retryLabel: l10n.retry,
                  onRetry: () => ref.invalidate(homeProvider),
                ),
                data: (state) => RefreshIndicator(
                  onRefresh: () => ref.read(homeProvider.notifier).refresh(),
                  color: HakimColors.primary,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 100), // Space for nav bar
                    child: Column(
                      children: [
                        HomeHeader(
                          userName: state.userName,
                          unreadCount: state.unreadNotifications,
                          morningGreeting: l10n.goodMorning,
                          afternoonGreeting: l10n.goodAfternoon,
                          eveningGreeting: l10n.goodEvening,
                        ),
                        
                        HealthSummaryCard(
                          vitals: state.vitals,
                          status: state.healthStatus,
                          summaryLabel: l10n.healthSummary,
                        ),

                        const SizedBox(height: 8),
                        QuickActionsRow(actions: state.quickActions),

                        const SizedBox(height: 16),
                        HomeSectionHeader(
                          title: l10n.upcomingAppointments,
                          actionLabel: l10n.viewAll,
                          onActionTap: () => _navigate('/appointments'),
                        ),
                        ...state.appointments.map((a) => AppointmentCard(appointment: a)),

                        const SizedBox(height: 16),
                        HomeSectionHeader(title: l10n.services),
                        ServicesGrid(services: state.services),

                        const SizedBox(height: 16),
                        HomeSectionHeader(
                          title: l10n.medicationSchedule,
                          actionLabel: l10n.viewAll,
                          onActionTap: () => _navigate('/medications'),
                        ),
                        MedicationScheduleCard(
                          medications: state.medications,
                          onToggle: (id) => ref.read(homeProvider.notifier).toggleMedication(id),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SpeedDialOverlay(
                items: _buildSpeedDialItems(context, l10n),
              ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: HakimBottomNav(
                  currentTab: _currentTab,
                  onTabSelected: (tab) {
                    ref.read(speedDialProvider.notifier).close();
                    setState(() => _currentTab = tab);
                  },
                  homeLabel: l10n.home,
                  appointmentsLabel: l10n.appointments,
                  medicationsLabel: l10n.myMedications,
                  profileLabel: l10n.profile,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
