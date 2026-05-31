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
        bloodType: json['bloodType'] as String,
        allergies: List<String>.from(json['allergies'] as List),
        chronicConditions: List<String>.from(json['chronicConditions'] as List),
        emergencyContactName: json['emergencyContactName'] as String,
        emergencyContactPhone: json['emergencyContactPhone'] as String,
      );

  Map<String, dynamic> toJson() => {
        'bloodType': bloodType,
        'allergies': allergies,
        'chronicConditions': chronicConditions,
        'emergencyContactName': emergencyContactName,
        'emergencyContactPhone': emergencyContactPhone,
      };
}
