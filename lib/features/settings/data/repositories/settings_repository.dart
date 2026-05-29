import '../../domain/models/settings_models.dart';

abstract interface class SettingsRepository {
  Future<SettingsState> fetchSettings();
  Future<void> saveNotificationPrefs(NotificationPrefs prefs);
  Future<void> addEmergencyContact(EmergencyContact contact);
  Future<void> deleteEmergencyContact(String id);
}

class MockSettingsRepository implements SettingsRepository {
  @override
  Future<SettingsState> fetchSettings() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return SettingsState(
      profile: const UserProfile(
        fullName: 'أحمد محمد الخصاونة',
        phone: '0791234567',
        email: 'ahmed.khassawneh@example.com',
        nationalId: '9876543210',
      ),
      notifications: const NotificationPrefs(),
      emergencyContacts: [
        EmergencyContact(
          id: '1',
          name: 'محمد الخصاونة',
          relationship: 'الأب',
          phone: '0799876543',
        ),
        EmergencyContact(
          id: '2',
          name: 'سارة الخصاونة',
          relationship: 'الأخت',
          phone: '0781234567',
        ),
      ],
    );
  }

  @override
  Future<void> saveNotificationPrefs(NotificationPrefs prefs) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<void> addEmergencyContact(EmergencyContact contact) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<void> deleteEmergencyContact(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
