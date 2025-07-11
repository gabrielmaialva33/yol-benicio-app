import 'package:flutter/material.dart';

class FolderStats {
  final int active;
  final int newThisMonth;

  FolderStats({required this.active, required this.newThisMonth});
}

class AreaDivision {
  final String name;
  final int value;
  final Color color;

  AreaDivision({required this.name, required this.value, required this.color});
}

class FolderActivity {
  final String label;
  final int value;
  final Color color;
  final double percentage;

  FolderActivity({
    required this.label,
    required this.value,
    required this.color,
    required this.percentage,
  });
}
