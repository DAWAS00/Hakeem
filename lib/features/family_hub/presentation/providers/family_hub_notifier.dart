import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/family_hub_providers.dart';
import '../../domain/models/family_hub_data.dart';

class FamilyHubNotifier extends Notifier<AsyncValue<FamilyHubData>> {
  @override
  AsyncValue<FamilyHubData> build() {
    _load();
    return const AsyncValue.loading();
  }

  Future<void> _load() async {
    state = const AsyncValue.loading();
    try {
      final data = await ref.read(familyHubRepositoryProvider).getFamilyHubData();
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() => _load();
}

final familyHubProvider =
    NotifierProvider<FamilyHubNotifier, AsyncValue<FamilyHubData>>(
  FamilyHubNotifier.new,
);
