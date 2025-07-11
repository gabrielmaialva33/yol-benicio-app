import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';
import 'task_item.dart';

class TasksCard extends StatefulWidget {
  const TasksCard({super.key});

  @override
  State<TasksCard> createState() => _TasksCardState();
}

class _TasksCardState extends State<TasksCard> {
  late List<Task> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = _getMockTasks();
  }

  void _toggleTask(Task task) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task.copyWith(completed: !task.completed);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Suas tarefas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              // Placeholder for DateRangePicker
              TextButton.icon(
                onPressed: () {
                  // TODO: Implement DateRangePicker
                },
                icon: const Icon(Icons.calendar_today, size: 16),
                label: Text(
                  DateFormat('d MMM', 'pt_BR').format(DateTime.now()),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_tasks.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  'Nenhuma tarefa para hoje!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return TaskItem(
                  task: task,
                  onToggle: _toggleTask,
                );
              },
            ),
        ],
      ),
    );
  }

  List<Task> _getMockTasks() {
    return [
      Task(
        id: '1',
        title: 'Reunião com o cliente sobre o caso XPTO',
        category: 'Processo 12345-67.2023',
        completed: false,
        color: const Color(0xFF3B82F6),
        dueDate: DateTime.now(),
      ),
      Task(
        id: '2',
        title: 'Elaborar petição inicial',
        category: 'Processo 98765-43.2023',
        completed: false,
        color: const Color(0xFFF59E0B),
        dueDate: DateTime.now().add(const Duration(days: 1)),
      ),
      Task(
        id: '3',
        title: 'Protocolar recurso de apelação',
        category: 'Processo 55555-55.2022',
        completed: true,
        color: const Color(0xFF10B981),
        dueDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Task(
        id: '4',
        title: 'Analisar documentos do novo cliente',
        category: 'Cliente Joana Silva',
        completed: false,
        color: const Color(0xFFEF4444),
        dueDate: DateTime.now().add(const Duration(days: 3)),
      ),
    ];
  }
}
