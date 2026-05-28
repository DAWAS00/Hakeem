import 'package:flutter/material.dart';
import '../../../../core/constants/hakim_icons.dart';
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

  vitals: const [
    Vital(
      label: 'نبضات/د',
      value: '72',
      icon: HakimIcons.favoriteBorderRounded,
      iconColor: Color(0xFFEF4444),
      iconBg: Color(0xFFFEF2F2),
    ),
    Vital(
      label: 'ضغط الدم',
      value: '120/80',
      icon: HakimIcons.monitorHeartOutlined,
      iconColor: Color(0xFF3B82F6),
      iconBg: Color(0xFFEFF6FF),
    ),
    Vital(
      label: 'خطوة',
      value: '4,280',
      icon: HakimIcons.activity01,
      iconColor: Color(0xFF10B981),
      iconBg: Color(0xFFF0FDF4),
    ),
  ],

  quickActions: const [
    QuickAction(
      label: 'حجز موعد',
      icon: HakimIcons.calendar03,
      bgColor: Color(0xFFEFF6FF),
      iconColor: Color(0xFF3B82F6),
      route: '/appointments/book',
    ),
    QuickAction(
      label: 'نتائجي',
      icon: HakimIcons.microscope,
      bgColor: Color(0xFFF0FDF4),
      iconColor: Color(0xFF059669),
      route: '/results',
    ),
    QuickAction(
      label: 'أدويتي',
      icon: HakimIcons.medicine01,
      bgColor: Color(0xFFF3E8FF),
      iconColor: Color(0xFF9333EA),
      route: '/medications',
    ),
    QuickAction(
      label: 'طوارئ',
      icon: HakimIcons.ambulance,
      bgColor: Color(0xFFFFF7ED),
      iconColor: Color(0xFFEA580C),
      route: '/emergency',
    ),
  ],

  appointments: const [
    Appointment(
      id: 'apt-1',
      doctorName: 'د. سارة العمري',
      specialty: 'طب عام',
      hospital: 'مستشفى الأردن',
      dateLabel: 'غد',
      timeLabel: '10:30 صباحاً',
      accentColor: Color(0xFF3B82F6),
    ),
    Appointment(
      id: 'apt-2',
      doctorName: 'د. خالد الزيود',
      specialty: 'قلب وأوعية',
      hospital: 'المركز الطبي',
      dateLabel: 'الأحد',
      timeLabel: '2:00 مساءً',
      accentColor: Color(0xFF10B981),
    ),
  ],

  services: [
    const ServiceCardModel(
      title: 'المساعد الطبي',
      subtitle: 'اسأل عن أعراضك',
      icon: HakimIcons.aiChat01,
      bgColor: Color(0xFFEDE9FE),
      iconColor: Color(0xFF7C3AED),
      badge: ServiceBadge.isNew,
      layout: ServiceLayout.grid,
      route: '/assistant',
    ),
    const ServiceCardModel(
      title: 'تحاليل مخبرية',
      subtitle: 'طلب وتتبع التحاليل',
      icon: HakimIcons.microscope,
      bgColor: Color(0xFFFFE4E6),
      iconColor: Color(0xFFE11D48),
      layout: ServiceLayout.grid,
      route: '/results',
    ),
    const ServiceCardModel(
      title: 'أدويتي',
      subtitle: 'جدول الوصفات والأدوية',
      icon: HakimIcons.medicine01,
      bgColor: Color(0xFFFEF3C7),
      iconColor: Color(0xFFD97706),
      badge: ServiceBadge.popular,
      layout: ServiceLayout.grid,
      route: '/medications',
    ),
    const ServiceCardModel(
      title: 'سجل طبي',
      subtitle: 'زياراتك السابقة',
      icon: HakimIcons.folder01,
      bgColor: Color(0xFFE0E7FF),
      iconColor: Color(0xFF4F46E5),
      layout: ServiceLayout.grid,
      route: '/medical-record',
    ),
    const ServiceCardModel(
      title: 'أقرب مستشفى إليك',
      subtitle: 'ابحث بناءً على موقعك الحالي',
      icon: HakimIcons.hospital01,
      bgColor: Color(0xFFE0F2FE),
      iconColor: Color(0xFF0284C7),
      layout: ServiceLayout.wide,
      route: '/nearby',
    ),
    const ServiceCardModel(
      title: 'الفواتير والمدفوعات',
      subtitle: 'اطّلع على مستحقاتك وسجل الدفع',
      icon: HakimIcons.invoice01,
      bgColor: Color(0xFFFFF7ED),
      iconColor: Color(0xFFEA580C),
      layout: ServiceLayout.wide,
      route: '/billing',
    ),
  ],

  medications: const [
    Medication(
      id: 'med-1',
      name: 'Metformin 500mg',
      timeLabel: 'بعد الفطور · ٨:٠٠ ص',
      dotColor: Color(0xFF10B981),
      isTaken: true,
    ),
    Medication(
      id: 'med-2',
      name: 'Lisinopril 10mg',
      timeLabel: 'الغداء · ١٢:٠٠ م',
      dotColor: Color(0xFFF59E0B),
    ),
    Medication(
      id: 'med-3',
      name: 'Atorvastatin 20mg',
      timeLabel: 'قبل النوم · ١٠:٠٠ م',
      dotColor: Color(0xFF3B82F6),
    ),
  ],
);
