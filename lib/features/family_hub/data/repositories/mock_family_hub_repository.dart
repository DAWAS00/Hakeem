import '../../domain/models/emergency_card.dart';
import '../../domain/models/family_hub_data.dart';
import '../../domain/models/family_member.dart';
import '../../domain/models/genetic_risk_flag.dart';
import 'family_hub_repository.dart';

class MockFamilyHubRepository implements FamilyHubRepository {
  const MockFamilyHubRepository();

  @override
  Future<FamilyHubData> getFamilyHubData() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return FamilyHubData(
      emergencyCard: const EmergencyCard(
        bloodType: 'A+',
        allergies: ['البنسلين', 'الأسبرين'],
        chronicConditions: ['داء السكري من النوع 2', 'ارتفاع ضغط الدم'],
        emergencyContactName: 'محمد أحمد',
        emergencyContactPhone: '0791234567',
      ),
      members: [
        FamilyMember(
          id: 'mom',
          name: 'أم أحمد',
          relation: 'الأم',
          initials: 'أم',
          medicationCompliancePercent: 85,
          labFlags: ['سكر مرتفع — HbA1c 8.2%'],
          aiSummaryAr: 'الحالة مستقرة. يُنصح بمتابعة مستوى السكر.',
          nextAppointmentDate: DateTime.now().add(const Duration(days: 5)),
        ),
        FamilyMember(
          id: 'son',
          name: 'عمر أحمد',
          relation: 'الابن',
          initials: 'عم',
          medicationCompliancePercent: 100,
          labFlags: [],
          aiSummaryAr: 'جميع النتائج طبيعية. استمر على نفس النظام.',
          nextAppointmentDate: DateTime.now().add(const Duration(days: 21)),
        ),
      ],
      geneticFlags: [
        const GeneticRiskFlag(
          condition: 'داء السكري من النوع 2',
          riskLevel: RiskLevel.high,
          affectedRelativesCount: 2,
          explanationAr:
              'وجود والدَين مصابَين بالسكري يرفع احتمالية الإصابة به بشكل ملحوظ.',
          recommendationAr:
              'فحص دوري للسكر كل 6 أشهر، نظام غذائي صحي، ونشاط بدني منتظم.',
        ),
        const GeneticRiskFlag(
          condition: 'ارتفاع ضغط الدم',
          riskLevel: RiskLevel.moderate,
          affectedRelativesCount: 1,
          explanationAr: 'تاريخ عائلي لارتفاع الضغط يزيد من عوامل الخطر.',
          recommendationAr: 'قياس الضغط بانتظام وتقليل الملح في الغذاء.',
        ),
      ],
    );
  }
}
