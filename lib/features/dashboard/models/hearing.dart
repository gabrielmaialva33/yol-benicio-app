import 'package:flutter/material.dart';

class Hearing {
  final String label;
  final double percentage;
  final int total;
  final int completed;
  final Color color;
  final DateTime date;

  Hearing({
    required this.label,
    required this.percentage,
    required this.total,
    required this.completed,
    required this.color,
    required this.date,
  });
}
