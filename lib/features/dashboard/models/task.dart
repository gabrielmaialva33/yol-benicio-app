import 'package:flutter/material.dart';

class Task {
  final String id;
  final String title;
  final String category;
  final bool completed;
  final Color color;
  final DateTime dueDate;

  Task({
    required this.id,
    required this.title,
    required this.category,
    required this.completed,
    required this.color,
    required this.dueDate,
  });

  Task copyWith({
    String? id,
    String? title,
    String? category,
    bool? completed,
    Color? color,
    DateTime? dueDate,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      completed: completed ?? this.completed,
      color: color ?? this.color,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}
