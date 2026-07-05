import '../../../../core/data/json_field_x.dart';

class EmergencyCard {
  const EmergencyCard({
    required this.bloodType,
    required this.allergies,
    required this.chronicConditions,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
  });

  final String bloodType;
  final List<String> allergies;
  final List<String> chronicConditions;
  final String emergencyContactName;
  final String emergencyContactPhone;

  factory EmergencyCard.fromJson(Map<String, dynamic> json) => EmergencyCard(
        bloodType: json.requireString('bloodType'),
        allergies: json.requireList<String>('allergies'),
        chronicConditions: json.requireList<String>('chronicConditions'),
        emergencyContactName: json.requireString('emergencyContactName'),
        emergencyContactPhone: json.requireString('emergencyContactPhone'),
      );

  Map<String, dynamic> toJson() => {
        'bloodType': bloodType,
        'allergies': allergies,
        'chronicConditions': chronicConditions,
        'emergencyContactName': emergencyContactName,
        'emergencyContactPhone': emergencyContactPhone,
      };
}
