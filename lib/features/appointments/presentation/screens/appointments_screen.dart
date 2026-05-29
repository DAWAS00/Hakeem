import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hakeem/core/constants/hakim_colors.dart';
import 'package:hakeem/core/constants/hakim_spacing.dart';
import 'package:hakeem/core/l10n/app_localizations.dart';
import 'package:hakeem/features/home/presentation/providers/home_provider.dart';
import 'package:hakeem/features/home/presentation/widgets/appointment_card.dart';

class AppointmentsScreen extends ConsumerStatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  ConsumerState<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends ConsumerState<AppointmentsScreen>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showTriageModal(BuildContext context) {
    final c = HakimColorScheme.of(context);
    int step = 0;
    final questions = [
      'ما هو العرض الرئيسي الذي تشعر به؟',
      'منذ متى بدأت هذه الأعراض؟',
      'هل تعاني من أي أمراض مزمنة؟',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: c.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: HakimSpacing.xl,
            right: HakimSpacing.xl,
            top: HakimSpacing.xl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: c.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: HakimSpacing.xl),
              Text(
                'التقييم الذكي قبل الحجز',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                ),
              ),
              const SizedBox(height: HakimSpacing.md),
              Text(
                'الخطوة ${step + 1} من 3',
                style: TextStyle(fontSize: 14, color: c.primary),
              ),
              const SizedBox(height: HakimSpacing.xl),
              Text(
                questions[step],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: c.textPrimary,
                ),
              ),
              const SizedBox(height: HakimSpacing.xl),
              TextField(
                decoration: InputDecoration(
                  hintText: 'اكتب إجابتك هنا...',
                  filled: true,
                  fillColor: c.bgInput,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: HakimSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (step < 2) {
                      setModalState(() => step++);
                    } else {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تم التحليل. ننصحك بحجز موعد مع طبيب قلب.'),
                        ),
                      );
                    }
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(step < 2 ? 'التالي' : 'إكمال التقييم'),
                ),
              ),
              const SizedBox(height: HakimSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final c = HakimColorScheme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final homeState = ref.watch(homeProvider);

    return Scaffold(
      backgroundColor: c.bgBase,
      appBar: AppBar(
        backgroundColor: c.bgBase,
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.appointments,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: c.textPrimary,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: c.primary,
          unselectedLabelColor: c.textHint,
          indicatorColor: c.primary,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'القادمة'),
            Tab(text: 'السابقة'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          homeState.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text(e.toString())),
            data: (state) => ListView(
              padding: const EdgeInsets.all(HakimSpacing.xl),
              children: [
                ...state.appointments.map((a) => AppointmentCard(appointment: a)),
              ],
            ),
          ),
          const Center(child: Text('لا توجد مواعيد سابقة')),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTriageModal(context),
        backgroundColor: c.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('حجز موعد جديد', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
