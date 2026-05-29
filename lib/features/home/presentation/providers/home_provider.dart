import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/home_repository.dart';
import '../../domain/models/home_models.dart';
import 'family_provider.dart';

class MascotStateNotifier extends Notifier<MascotState> {
  @override
  MascotState build() => MascotState.idle;

  void set(MascotState s) => state = s;
}

final mascotStateProvider = NotifierProvider<MascotStateNotifier, MascotState>(
  MascotStateNotifier.new,
);

final homeRepositoryProvider = Provider<HomeRepository>(
  (_) => const HomeRepositoryImpl(),
);

class SpeedDialNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void open()  => state = true;
  void close() => state = false;
  void toggle() => state = !state;
}

final speedDialProvider = NotifierProvider<SpeedDialNotifier, bool>(
  SpeedDialNotifier.new,
);

class HomeNotifier extends AsyncNotifier<HomeState> {
  @override
  Future<HomeState> build() async {
    // Watch the selected profile to trigger a re-fetch when it changes
    ref.watch(familyProfileProvider);
    
    return ref.read(homeRepositoryProvider).fetchHomeState();
  }

  Future<void> toggleMedication(String medicationId) async {
    final current = state.asData?.value;
    if (current == null) return;

    state = AsyncValue.data(
      await ref
          .read(homeRepositoryProvider)
          .toggleMedication(current, medicationId),
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(homeRepositoryProvider).fetchHomeState(),
    );
  }
}

final homeProvider = AsyncNotifierProvider<HomeNotifier, HomeState>(
  HomeNotifier.new,
);
