import 'package:flutter/material.dart';

import '../models/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final Function(Task)? onToggle;

  const TaskItem({
    super.key,
    required this.task,
    this.onTap,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          // Checkbox
          GestureDetector(
            onTap: () => onToggle?.call(task),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: task.completed ? task.color : Colors.transparent,
                border: Border.all(
                  color: task.color,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: task.completed
                  ? const Icon(
                Icons.check,
                size: 14,
                color: Colors.white,
              )
                  : null,
            ),
          ),
          const SizedBox(width: 12),

          // Task content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: task.completed
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF111827),
                    decoration:
                    task.completed ? TextDecoration.lineThrough : null,
                  ),
                ),
                if (task.category != null && task.category!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    task.category!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ] else
                  if (task.folder != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${task.folder!.code} - ${task.folder!.client.name}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
              ],
            ),
          ),

          // Due date
          Text(
            _formatDueDate(task.dueDate),
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final difference = date
        .difference(now)
        .inDays;

    if (difference < 0) {
      return 'Atrasado';
    } else if (difference == 0) {
      return 'Hoje';
    } else if (difference == 1) {
      return 'Amanhã';
    } else {
      return 'Em $difference dias';
    }
  }
}
