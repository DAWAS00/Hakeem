class NotificationPrefs {
  final bool appointments;
  final bool medications;
  final bool labResults;

  const NotificationPrefs({
    this.appointments = true,
    this.medications = true,
    this.labResults = true,
  });

  NotificationPrefs copyWith({
    bool? appointments,
    bool? medications,
    bool? labResults,
  }) => NotificationPrefs(
    appointments: appointments ?? this.appointments,
    medications: medications ?? this.medications,
    labResults: labResults ?? this.labResults,
  );
}

class EmergencyContact {
  final String id;
  final String name;
  final String relationship;
  final String phone;

  const EmergencyContact({
    required this.id,
    required this.name,
    required this.relationship,
    required this.phone,
  });

  EmergencyContact copyWith({
    String? name,
    String? relationship,
    String? phone,
  }) => EmergencyContact(
    id: id,
    name: name ?? this.name,
    relationship: relationship ?? this.relationship,
    phone: phone ?? this.phone,
  );
}

class UserProfile {
  final String fullName;
  final String phone;
  final String email;
  final String nationalId;

  const UserProfile({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.nationalId,
  });

  String get maskedNationalId {
    if (nationalId.length <= 4) return nationalId;
    return '${'*' * (nationalId.length - 4)}${nationalId.substring(nationalId.length - 4)}';
  }

  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) return '${parts.first[0]}${parts.last[0]}';
    if (parts.isNotEmpty && parts.first.isNotEmpty) return parts.first[0];
    return '؟';
  }
}

enum SettingsStatus { idle, loading, saving, error }

class SettingsState {
  final UserProfile profile;
  final NotificationPrefs notifications;
  final List<EmergencyContact> emergencyContacts;
  final SettingsStatus status;
  final String? errorMessage;

  const SettingsState({
    required this.profile,
    required this.notifications,
    required this.emergencyContacts,
    this.status = SettingsStatus.idle,
    this.errorMessage,
  });

  bool get isLoading => status == SettingsStatus.loading;
  bool get isSaving => status == SettingsStatus.saving;

  SettingsState copyWith({
    UserProfile? profile,
    NotificationPrefs? notifications,
    List<EmergencyContact>? emergencyContacts,
    SettingsStatus? status,
    String? errorMessage,
  }) => SettingsState(
    profile: profile ?? this.profile,
    notifications: notifications ?? this.notifications,
    emergencyContacts: emergencyContacts ?? this.emergencyContacts,
    status: status ?? this.status,
    errorMessage: errorMessage,
  );
}
