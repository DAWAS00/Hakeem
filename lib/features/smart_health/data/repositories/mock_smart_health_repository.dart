import '../../domain/models/health_summary.dart';
import '../../domain/models/lab_flag.dart';
import '../../domain/models/doctor_note.dart';
import 'smart_health_repository.dart';

class MockSmartHealthRepository implements SmartHealthRepository {
  const MockSmartHealthRepository();

  @override
  Future<HealthSummary> fetchHealthSummary() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return HealthSummary(
      weekSummaryAr: 'نتائجك هذا الأسبوع جيدة بشكل عام — فقط قراءة السكر تحتاج متابعة',
      weekSummaryEn: 'Your results this week are generally good — only the sugar reading needs follow-up.',
      isConfirmed: false,
      riskLevel: 'medium',
      lastCheckInDate: DateTime.now().subtract(const Duration(days: 3)),
      labFlags: [
        const LabFlag(
          name: 'السكر الصائم',
          value: '126',
          unit: 'mg/dL',
          status: LabStatus.abnormal,
          trend: 1,
          referenceRange: '70 - 99',
          explanationAr: 'قراءة السكر مرتفعة قليلاً عن الطبيعي.',
        ),
        const LabFlag(
          name: 'الهيموجلوبين',
          value: '14.2',
          unit: 'g/dL',
          status: LabStatus.normal,
          trend: 0,
          referenceRange: '13.5 - 17.5',
          explanationAr: 'نسبة الهيموجلوبين طبيعية جداً.',
        ),
        const LabFlag(
          name: 'الكوليسترول',
          value: '240',
          unit: 'mg/dL',
          status: LabStatus.critical,
          trend: 1,
          referenceRange: '< 200',
          explanationAr: 'مستوى الكوليسترول مرتفع ويحتاج لتدخل.',
        ),
      ],
    );
  }

  @override
  Future<List<DoctorNote>> fetchDoctorNotes() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      DoctorNote(
        id: '1',
        rawNote: 'Patient shows mild hyperglycemia. Advised to reduce sugar intake and monitor glucose daily.',
        simplifiedNoteAr: 'لديك ارتفاع طفيف في السكر. ننصح بتقليل السكريات ومتابعة القياس يومياً.',
        doctorName: 'د. أحمد علي',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }
}
