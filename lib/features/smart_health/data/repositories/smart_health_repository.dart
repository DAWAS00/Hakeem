import '../../domain/models/health_summary.dart';
import '../../domain/models/doctor_note.dart';

abstract class SmartHealthRepository {
  Future<HealthSummary> fetchHealthSummary();
  Future<List<DoctorNote>> fetchDoctorNotes();
}
