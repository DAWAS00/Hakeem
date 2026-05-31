import 'package:flutter/material.dart';

enum LabStatus {
  normal,
  abnormal,
  critical;

  Color get color => switch (this) {
    LabStatus.normal   => Colors.green, // Will be resolved via HakimColorScheme in UI
    LabStatus.abnormal => Colors.amber,
    LabStatus.critical => Colors.red,
  };
}

class LabFlag {
  const LabFlag({
    required this.name,
    required this.value,
    required this.unit,
    required this.status,
    required this.trend,
    this.referenceRange = '',
    this.explanationAr = '',
  });

  final String name;
  final String value;
  final String unit;
  final LabStatus status;
  final int trend; // -1: down, 0: stable, 1: up
  final String referenceRange;
  final String explanationAr;
}
