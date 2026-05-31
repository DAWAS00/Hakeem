import 'emergency_card.dart';
import 'family_member.dart';
import 'genetic_risk_flag.dart';

class FamilyHubData {
  const FamilyHubData({
    required this.emergencyCard,
    required this.members,
    required this.geneticFlags,
  });

  final EmergencyCard emergencyCard;
  final List<FamilyMember> members;
  final List<GeneticRiskFlag> geneticFlags;
}
