import 'package:flutter/material.dart';
import '../../../../core/constants/hakim_icons.dart';

enum MascotState {
  idle,
  happy,
  curious,
  celebrating,
  listening,
  thinking,
  scanning,
  surprised,
  sleepy,
  sad;

  String get assetPath => switch (this) {
    MascotState.idle        => HakimIcons.mascotIdle,
    MascotState.happy       => HakimIcons.mascotHappy,
    MascotState.curious     => HakimIcons.mascotCurious,
    MascotState.celebrating => HakimIcons.mascotCelebrating,
    MascotState.listening   => HakimIcons.mascotListening,
    MascotState.thinking    => HakimIcons.mascotThinking,
    MascotState.scanning    => HakimIcons.mascotScanning,
    MascotState.surprised   => HakimIcons.mascotSurprised,
    MascotState.sleepy      => HakimIcons.mascotSleepy,
    MascotState.sad         => HakimIcons.mascotSad,
  };
}

class Vital {
  const Vital({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });

  final String label;
  final String value;
  final String icon;
  final Color iconColor;
  final Color iconBg;
}

class Appointment {
  const Appointment({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.hospital,
    required this.dateLabel,
    required this.timeLabel,
    required this.accentColor,
  });

  final String id;
  final String doctorName;
  final String specialty;
  final String hospital;
  final String dateLabel;
  final String timeLabel;
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
    this.route,
    this.onTap,
  });

  final String label;
  final String icon;
  final Color bgColor;
  final Color iconColor;
  final String? route;
  final VoidCallback? onTap;
}

enum ServiceBadge { none, isNew, popular }

enum ServiceLayout { grid, wide }

class ServiceCardModel {
  const ServiceCardModel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    this.badge = ServiceBadge.none,
    this.layout = ServiceLayout.grid,
    this.route,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final dynamic icon;
  final Color bgColor;
  final Color iconColor;
  final ServiceBadge badge;
  final ServiceLayout layout;
  final String? route;
  final VoidCallback? onTap;
}

class SpeedDialItem {
  const SpeedDialItem({
    required this.label,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    this.mascotState = MascotState.happy,
    this.onTap,
  });

  final String label;
  final dynamic icon;
  final Color bgColor;
  final Color iconColor;
  final MascotState mascotState;
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
