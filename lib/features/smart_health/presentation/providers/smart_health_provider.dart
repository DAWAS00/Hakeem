import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/smart_health_repository.dart';
import '../../data/repositories/mock_smart_health_repository.dart';
import '../../domain/models/health_summary.dart';
import '../../domain/models/doctor_note.dart';

class SmartHealthState {
  const SmartHealthState({
    required this.summary,
    required this.notes,
  });

  final HealthSummary summary;
  final List<DoctorNote> notes;

  SmartHealthState copyWith({
    HealthSummary? summary,
    List<DoctorNote>? notes,
  }) {
    return SmartHealthState(
      summary: summary ?? this.summary,
      notes: notes ?? this.notes,
    );
  }
}

final smartHealthRepositoryProvider = Provider<SmartHealthRepository>((ref) {
  return const MockSmartHealthRepository();
});

class SmartHealthNotifier extends AsyncNotifier<SmartHealthState> {
  @override
  Future<SmartHealthState> build() async {
    final repository = ref.watch(smartHealthRepositoryProvider);
    
    final results = await Future.wait([
      repository.fetchHealthSummary(),
      repository.fetchDoctorNotes(),
    ]);

    return SmartHealthState(
      summary: results[0] as HealthSummary,
      notes: results[1] as List<DoctorNote>,
    );
  }

  void toggleNoteVisibility(String noteId) {
    final current = state.asData?.value;
    if (current == null) return;

    final updatedNotes = current.notes.map((note) {
      if (note.id == noteId) {
        return note.copyWith(isSimplifiedVisible: !note.isSimplifiedVisible);
      }
      return note;
    }).toList();

    state = AsyncValue.data(current.copyWith(notes: updatedNotes));
  }
  
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }
}

final smartHealthProvider = AsyncNotifierProvider<SmartHealthNotifier, SmartHealthState>(
  SmartHealthNotifier.new,
);
