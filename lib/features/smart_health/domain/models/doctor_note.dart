class DoctorNote {
  const DoctorNote({
    required this.id,
    required this.rawNote,
    required this.simplifiedNoteAr,
    required this.doctorName,
    required this.date,
    this.isSimplifiedVisible = true,
  });

  final String id;
  final String rawNote;
  final String simplifiedNoteAr;
  final String doctorName;
  final DateTime date;
  final bool isSimplifiedVisible;

  DoctorNote copyWith({bool? isSimplifiedVisible}) => DoctorNote(
        id: id,
        rawNote: rawNote,
        simplifiedNoteAr: simplifiedNoteAr,
        doctorName: doctorName,
        date: date,
        isSimplifiedVisible: isSimplifiedVisible ?? this.isSimplifiedVisible,
      );
}
