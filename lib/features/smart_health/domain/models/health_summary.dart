import 'lab_flag.dart';

class HealthSummary {
  const HealthSummary({
    required this.weekSummaryAr,
    required this.weekSummaryEn,
    required this.isConfirmed,
    required this.riskLevel,
    required this.labFlags,
    this.lastCheckInDate,
  });

  final String weekSummaryAr;
  final String weekSummaryEn;
  final bool isConfirmed;
  final String riskLevel; // e.g., 'low', 'medium', 'high'
  final List<LabFlag> labFlags;
  final DateTime? lastCheckInDate;
}
