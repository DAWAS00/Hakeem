import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/constants/hakim_colors.dart';
import '../../domain/models/home_models.dart';

abstract interface class HomeRepository {
  Future<HomeState> fetchHomeState();
  Future<HomeState> toggleMedication(HomeState current, String medicationId);
}

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl();

  @override
  Future<HomeState> fetchHomeState() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _mockState;
  }

  @override
  Future<HomeState> toggleMedication(
    HomeState current,
    String medicationId,
  ) async {
    final updated = current.medications.map((m) {
      if (m.id == medicationId) return m.copyWith(isTaken: !m.isTaken);
      return m;
    }).toList();
    return current.copyWith(medications: updated);
  }
}

final _mockState = HomeState(
  userName: 'محمد الخصاونة',
  healthStatus: 'جيد',
  unreadNotifications: 3,

  vitals: [
    const Vital(
      label: 'نبضات/د',
      value: '72',
      icon: HugeIcons.strokeRoundedActivity01,
      color: HakimColors.error,
    ),
    const Vital(
      label: 'ضغط الدم',
      value: '120/80',
      icon: HugeIcons.strokeRoundedSettings01,
      color: HakimColors.primary,
    ),
    const Vital(
      label: 'خطوة',
      value: '4,280',
      icon: HugeIcons.strokeRoundedUser,
      color: HakimColors.sanad,
    ),
  ],

  quickActions: [
    const QuickAction(
      label: 'حجز موعد',
      icon: HugeIcons.strokeRoundedCalendar03,
      bgColor: Color(0x203B82F6),
      iconColor: HakimColors.primary,
    ),
    const QuickAction(
      label: 'نتائجي',
      icon: HugeIcons.strokeRoundedMicroscope,
      bgColor: Color(0x2010B981),
      iconColor: HakimColors.sanad,
    ),
    const QuickAction(
      label: 'أدويتي',
      icon: HugeIcons.strokeRoundedMedicine01,
      bgColor: Color(0x20F59E0B),
      iconColor: Colors.orange,
    ),
    const QuickAction(
      label: 'طوارئ',
      icon: HugeIcons.strokeRoundedAmbulance,
      bgColor: Color(0x20EF4444),
      iconColor: HakimColors.error,
    ),
  ],

  appointments: const [
    Appointment(
      id: 'apt-1',
      doctorName: 'د. سارة العمري',
      specialty: 'طب عام',
      hospital: 'مستشفى الأردن',
      dateLabel: 'غد · 10:30 صباحاً',
      accentColor: HakimColors.primary,
    ),
    Appointment(
      id: 'apt-2',
      doctorName: 'د. خالد الزيود',
      specialty: 'قلب وأوعية',
      hospital: 'المركز الطبي',
      dateLabel: 'الأحد · 2:00 مساءً',
      accentColor: HakimColors.sanad,
    ),
  ],

  services: [
    const ServiceCardModel(
      title: 'المساعد الطبي',
      subtitle: 'اسأل عن أعراضك',
      icon: HugeIcons.strokeRoundedAiChat01,
      bgColor: Color(0x203B82F6),
      iconColor: HakimColors.primary,
    ),
    const ServiceCardModel(
      title: 'أقرب مستشفى',
      subtitle: 'ابحث بموقعك الحالي',
      icon: HugeIcons.strokeRoundedHospital01,
      bgColor: Color(0x2010B981),
      iconColor: HakimColors.sanad,
    ),
    const ServiceCardModel(
      title: 'الفواتير',
      subtitle: 'اطلع على مستحقاتك',
      icon: HugeIcons.strokeRoundedInvoice01,
      bgColor: Color(0x20F59E0B),
      iconColor: Colors.orange,
    ),
    const ServiceCardModel(
      title: 'سجل طبي',
      subtitle: 'زيارات سابقة',
      icon: HugeIcons.strokeRoundedFolder01,
      bgColor: Color(0x1F60A5FA),
      iconColor: HakimColors.accent,
    ),
  ],

  medications: const [
    Medication(
      id: 'med-1',
      name: 'Metformin 500mg',
      timeLabel: 'بعد الفطور · ٨:٠٠ ص',
      dotColor: HakimColors.sanad,
      isTaken: true,
    ),
    Medication(
      id: 'med-2',
      name: 'Lisinopril 10mg',
      timeLabel: 'الغداء · ١٢:٠٠ م',
      dotColor: Colors.orange,
    ),
    Medication(
      id: 'med-3',
      name: 'Atorvastatin 20mg',
      timeLabel: 'قبل النوم · ١٠:٠٠ م',
      dotColor: HakimColors.primary,
    ),
  ],
);
