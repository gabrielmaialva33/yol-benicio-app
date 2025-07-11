import 'package:flutter/material.dart';
import '../../shared/models/user.dart';
import '../../folders/models/folder.dart';

enum TaskStatus {
  pending,
  inProgress,
  completed,
  cancelled,
  overdue,
}

enum TaskPriority {
  low,
  medium,
  high,
  urgent,
}

extension TaskStatusExtension on TaskStatus {
  String get displayName {
    switch (this) {
      case TaskStatus.pending:
        return 'Pendente';
      case TaskStatus.inProgress:
        return 'Em Andamento';
      case TaskStatus.completed:
        return 'Concluída';
      case TaskStatus.cancelled:
        return 'Cancelada';
      case TaskStatus.overdue:
        return 'Atrasada';
    }
  }
  
  Color get color {
    switch (this) {
      case TaskStatus.pending:
        return const Color(0xFFF59E0B);
      case TaskStatus.inProgress:
        return const Color(0xFF3B82F6);
      case TaskStatus.completed:
        return const Color(0xFF10B981);
      case TaskStatus.cancelled:
        return const Color(0xFF6B7280);
      case TaskStatus.overdue:
        return const Color(0xFFEF4444);
    }
  }
}

extension TaskPriorityExtension on TaskPriority {
  String get displayName {
    switch (this) {
      case TaskPriority.low:
        return 'Baixa';
      case TaskPriority.medium:
        return 'Média';
      case TaskPriority.high:
        return 'Alta';
      case TaskPriority.urgent:
        return 'Urgente';
    }
  }
  
  Color get color {
    switch (this) {
      case TaskPriority.low:
        return const Color(0xFF10B981);
      case TaskPriority.medium:
        return const Color(0xFF3B82F6);
      case TaskPriority.high:
        return const Color(0xFFF59E0B);
      case TaskPriority.urgent:
        return const Color(0xFFEF4444);
    }
  }
}

class Task {
  final int id;
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskPriority priority;
  final TaskStatus status;
  final User assignedTo;
  final Folder? folder;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? completedAt;
  final List<String>? tags;
  final String? notes;
  final List<User>? watchers;
  final String? category;
  final bool completed;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
    required this.assignedTo,
    this.folder,
    this.createdAt,
    this.updatedAt,
    this.completedAt,
    this.tags,
    this.notes,
    this.watchers,
    this.category,
    bool? completed,
  }) : completed = completed ?? (status == TaskStatus.completed);

  // Helper methods
  bool get isOverdue => 
    status != TaskStatus.completed && 
    status != TaskStatus.cancelled && 
    DateTime.now().isAfter(dueDate);
    
  int get daysUntilDue => dueDate.difference(DateTime.now()).inDays;
  
  bool get isDueSoon => daysUntilDue <= 3 && daysUntilDue >= 0;
  
  bool get isCompleted => status == TaskStatus.completed;
  
  String get dueDateDisplay {
    final days = daysUntilDue;
    if (days < 0) return 'Atrasado ${-days} dia(s)';
    if (days == 0) return 'Vence hoje';
    if (days == 1) return 'Vence amanhã';
    return 'Vence em $days dias';
  }

  Color get color => priority.color;

  Task copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    TaskStatus? status,
    User? assignedTo,
    Folder? folder,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
    List<String>? tags,
    String? notes,
    List<User>? watchers,
    String? category,
    bool? completed,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      assignedTo: assignedTo ?? this.assignedTo,
      folder: folder ?? this.folder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      watchers: watchers ?? this.watchers,
      category: category ?? this.category,
      completed: completed ?? this.completed,
    );
  }
}
