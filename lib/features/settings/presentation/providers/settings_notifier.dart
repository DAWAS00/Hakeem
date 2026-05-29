import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/settings_providers.dart';
import '../../domain/models/settings_models.dart';

class SettingsNotifier extends AsyncNotifier<SettingsState> {
  @override
  Future<SettingsState> build() async {
    return ref.read(settingsRepositoryProvider).fetchSettings();
  }

  Future<void> toggleAppointmentNotif(bool value) async {
    final current = state.asData?.value;
    if (current == null) return;
    final updated = current.copyWith(
      notifications: current.notifications.copyWith(appointments: value),
    );
    state = AsyncData(updated);
    await ref.read(settingsRepositoryProvider).saveNotificationPrefs(updated.notifications);
  }

  Future<void> toggleMedicationNotif(bool value) async {
    final current = state.asData?.value;
    if (current == null) return;
    final updated = current.copyWith(
      notifications: current.notifications.copyWith(medications: value),
    );
    state = AsyncData(updated);
    await ref.read(settingsRepositoryProvider).saveNotificationPrefs(updated.notifications);
  }

  Future<void> toggleLabResultsNotif(bool value) async {
    final current = state.asData?.value;
    if (current == null) return;
    final updated = current.copyWith(
      notifications: current.notifications.copyWith(labResults: value),
    );
    state = AsyncData(updated);
    await ref.read(settingsRepositoryProvider).saveNotificationPrefs(updated.notifications);
  }

  Future<void> addContact(EmergencyContact contact) async {
    final current = state.asData?.value;
    if (current == null) return;
    final updated = current.copyWith(
      emergencyContacts: [...current.emergencyContacts, contact],
    );
    state = AsyncData(updated);
    await ref.read(settingsRepositoryProvider).addEmergencyContact(contact);
  }

  Future<void> deleteContact(String id) async {
    final current = state.asData?.value;
    if (current == null) return;
    final updated = current.copyWith(
      emergencyContacts: current.emergencyContacts.where((c) => c.id != id).toList(),
    );
    state = AsyncData(updated);
    await ref.read(settingsRepositoryProvider).deleteEmergencyContact(id);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(settingsRepositoryProvider).fetchSettings(),
    );
  }
}

final settingsNotifierProvider =
    AsyncNotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);
