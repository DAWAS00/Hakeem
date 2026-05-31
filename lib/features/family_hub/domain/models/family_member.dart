class FamilyMember {
  const FamilyMember({
    required this.id,
    required this.name,
    required this.relation,
    required this.initials,
    required this.medicationCompliancePercent,
    required this.labFlags,
    required this.aiSummaryAr,
    this.nextAppointmentDate,
  });

  final String id;
  final String name;
  final String relation;
  final String initials;
  final double medicationCompliancePercent;
  final List<String> labFlags;
  final String aiSummaryAr;
  final DateTime? nextAppointmentDate;
}
