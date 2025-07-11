import 'package:flutter/material.dart';
import '../../folders/models/folder.dart';

enum HearingType {
  conciliation,
  instruction,
  judgment,
  unified,
  session,
}

enum HearingStatus {
  scheduled,
  confirmed,
  postponed,
  cancelled,
  completed,
}

extension HearingTypeExtension on HearingType {
  String get displayName {
    switch (this) {
      case HearingType.conciliation:
        return 'Audiência de Conciliação';
      case HearingType.instruction:
        return 'Audiência de Instrução';
      case HearingType.judgment:
        return 'Audiência de Julgamento';
      case HearingType.unified:
        return 'Audiência Una';
      case HearingType.session:
        return 'Sessão de Julgamento';
    }
  }
}

extension HearingStatusExtension on HearingStatus {
  String get displayName {
    switch (this) {
      case HearingStatus.scheduled:
        return 'Agendada';
      case HearingStatus.confirmed:
        return 'Confirmada';
      case HearingStatus.postponed:
        return 'Adiada';
      case HearingStatus.cancelled:
        return 'Cancelada';
      case HearingStatus.completed:
        return 'Realizada';
    }
  }
  
  Color get color {
    switch (this) {
      case HearingStatus.scheduled:
        return const Color(0xFF3B82F6);
      case HearingStatus.confirmed:
        return const Color(0xFF10B981);
      case HearingStatus.postponed:
        return const Color(0xFFF59E0B);
      case HearingStatus.cancelled:
        return const Color(0xFFEF4444);
      case HearingStatus.completed:
        return const Color(0xFF6B7280);
    }
  }
}

class Hearing {
  final int id;
  final String type;
  final DateTime dateTime;
  final String location;
  final Folder folder;
  final String? judge;
  final String? notes;
  final HearingStatus status;
  final List<String>? participants;
  final String? result;
  final String? roomNumber;
  final bool isVirtual;
  final String? meetingLink;
  final Duration? estimatedDuration;
  
  // Legacy fields for compatibility
  final String? label;
  final double? percentage;
  final int? total;
  final int? completed;
  final Color? color;
  DateTime get date => dateTime;

  Hearing({
    required this.id,
    required this.type,
    required this.dateTime,
    required this.location,
    required this.folder,
    this.judge,
    this.notes,
    this.status = HearingStatus.scheduled,
    this.participants,
    this.result,
    this.roomNumber,
    this.isVirtual = false,
    this.meetingLink,
    this.estimatedDuration,
    // Legacy parameters
    this.label,
    this.percentage,
    this.total,
    this.completed,
    this.color,
  });

  // Helper methods
  bool get isPast => DateTime.now().isAfter(dateTime);
  
  bool get isToday {
    final now = DateTime.now();
    return dateTime.year == now.year &&
           dateTime.month == now.month &&
           dateTime.day == now.day;
  }
  
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return dateTime.year == tomorrow.year &&
           dateTime.month == tomorrow.month &&
           dateTime.day == tomorrow.day;
  }
  
  bool get isThisWeek {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 7));
    return dateTime.isAfter(weekStart) && dateTime.isBefore(weekEnd);
  }
  
  String get timeDisplay {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
  
  String get dateDisplay {
    if (isToday) return 'Hoje';
    if (isTomorrow) return 'Amanhã';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
  
  String get fullDisplay => '$dateDisplay às $timeDisplay';
}
