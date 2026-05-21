import 'package:flutter/material.dart';

class Vital {
  const Vital({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final dynamic icon;
  final Color color;
}

class Appointment {
  const Appointment({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.hospital,
    required this.dateLabel,
    required this.accentColor,
  });

  final String id;
  final String doctorName;
  final String specialty;
  final String hospital;
  final String dateLabel;
  final Color accentColor;
}

class Medication {
  const Medication({
    required this.id,
    required this.name,
    required this.timeLabel,
    required this.dotColor,
    this.isTaken = false,
  });

  final String id;
  final String name;
  final String timeLabel;
  final Color dotColor;
  final bool isTaken;

  Medication copyWith({bool? isTaken}) => Medication(
        id: id,
        name: name,
        timeLabel: timeLabel,
        dotColor: dotColor,
        isTaken: isTaken ?? this.isTaken,
      );
}

class QuickAction {
  const QuickAction({
    required this.label,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    this.onTap,
  });

  final String label;
  final dynamic icon;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback? onTap;
}

class ServiceCardModel {
  const ServiceCardModel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final dynamic icon;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback? onTap;
}

class SpeedDialItem {
  const SpeedDialItem({
    required this.label,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    this.onTap,
  });

  final String label;
  final dynamic icon;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback? onTap;
}

class HomeState {
  const HomeState({
    required this.userName,
    required this.healthStatus,
    required this.vitals,
    required this.quickActions,
    required this.appointments,
    required this.services,
    required this.medications,
    required this.unreadNotifications,
  });

  final String userName;
  final String healthStatus;
  final List<Vital> vitals;
  final List<QuickAction> quickActions;
  final List<Appointment> appointments;
  final List<ServiceCardModel> services;
  final List<Medication> medications;
  final int unreadNotifications;

  HomeState copyWith({List<Medication>? medications}) => HomeState(
        userName: userName,
        healthStatus: healthStatus,
        vitals: vitals,
        quickActions: quickActions,
        appointments: appointments,
        services: services,
        medications: medications ?? this.medications,
        unreadNotifications: unreadNotifications,
      );
}
