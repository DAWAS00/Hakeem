import 'package:intl/intl.dart';

import '../../domain/entities/signup_form_data.dart';

/// Maps [SignupFormData] to the `public.profiles` row update sent after OTP
/// verification (see supabase/migrations/0002_profiles_signup_fields.sql for
/// the columns this targets).
class SignupProfileUpdate {
  const SignupProfileUpdate(this._data);

  final SignupFormData _data;

  Map<String, dynamic> toJson() => {
        'full_name': _data.fullName,
        'national_id': _data.nationalId.isEmpty ? null : _data.nationalId,
        'gender': _data.gender.isEmpty ? null : _data.gender,
        'date_of_birth': _data.dateOfBirth != null
            ? DateFormat('yyyy-MM-dd').format(_data.dateOfBirth!)
            : null,
        'governorate': _data.governorate.isEmpty ? null : _data.governorate,
        'city': _data.city.isEmpty ? null : _data.city,
        'blood_type': _data.bloodType.isEmpty ? null : _data.bloodType,
        'chronic_diseases': _data.chronicDiseases,
        'allergies': _data.allergies.isEmpty ? null : _data.allergies,
        'height_cm': _data.height,
        'weight_kg': _data.weight,
        'current_medications':
            _data.currentMedications.isEmpty ? null : _data.currentMedications,
        'accept_terms': _data.acceptTerms,
        'enable_notifications': _data.enableNotifications,
      };
}
