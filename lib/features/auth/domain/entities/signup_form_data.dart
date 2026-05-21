class SignupFormData {
  const SignupFormData({
    // Step 1 – Identity
    this.fullName = '',
    this.dateOfBirth,
    this.gender = '',
    this.nationalId = '',
    // Step 2 – Contact
    this.phone = '',
    this.email = '',
    this.governorate = '',
    this.city = '',
    // Step 3 – Health
    this.bloodType = '',
    this.chronicDiseases = const [],
    this.allergies = '',
    this.height,
    this.weight,
    this.currentMedications = '',
    // Step 4 – Consent
    this.acceptTerms = false,
    this.enableNotifications = false,
    this.confirmAccuracy = false,
  });

  final String fullName;
  final DateTime? dateOfBirth;
  final String gender;
  final String nationalId;

  final String phone;
  final String email;
  final String governorate;
  final String city;

  final String bloodType;
  final List<String> chronicDiseases;
  final String allergies;
  final int? height;
  final int? weight;
  final String currentMedications;

  final bool acceptTerms;
  final bool enableNotifications;
  final bool confirmAccuracy;

  SignupFormData copyWith({
    String? fullName,
    DateTime? dateOfBirth,
    String? gender,
    String? nationalId,
    String? phone,
    String? email,
    String? governorate,
    String? city,
    String? bloodType,
    List<String>? chronicDiseases,
    String? allergies,
    int? height,
    int? weight,
    String? currentMedications,
    bool? acceptTerms,
    bool? enableNotifications,
    bool? confirmAccuracy,
  }) {
    return SignupFormData(
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      nationalId: nationalId ?? this.nationalId,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      governorate: governorate ?? this.governorate,
      city: city ?? this.city,
      bloodType: bloodType ?? this.bloodType,
      chronicDiseases: chronicDiseases ?? this.chronicDiseases,
      allergies: allergies ?? this.allergies,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      currentMedications: currentMedications ?? this.currentMedications,
      acceptTerms: acceptTerms ?? this.acceptTerms,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      confirmAccuracy: confirmAccuracy ?? this.confirmAccuracy,
    );
  }
}
