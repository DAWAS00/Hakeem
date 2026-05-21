import 'package:intl/intl.dart';
import '../../domain/entities/signup_form_data.dart';

class SignupRequestModel {
  const SignupRequestModel(this._data);

  final SignupFormData _data;

  Map<String, dynamic> toJson() => {
        'full_name': _data.fullName,
        'date_of_birth': _data.dateOfBirth != null
            ? DateFormat('yyyy-MM-dd').format(_data.dateOfBirth!)
            : null,
        'gender': _data.gender,
        'national_id': _data.nationalId,
        'phone': _data.phone,
        'email': _data.email.isEmpty ? null : _data.email,
        'governorate': _data.governorate,
        'city': _data.city,
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
