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
}
