import 'package:flutter/material.dart';

import '../../shared/services/mock_data_service.dart';
import '../models/task.dart';
import 'task_item.dart';

class TasksCard extends StatefulWidget {
  const TasksCard({super.key});

  @override
  State<TasksCard> createState() => _TasksCardState();
}

class _TasksCardState extends State<TasksCard> {
  final _mockService = MockDataService();
  late List<Task> _tasks;
  late Map<String, int> _taskStats;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }
  
  void _loadTasks() {
    _tasks = _mockService.getTasks(status: null);
    
    // Calculate statistics
    _taskStats = {
      'total': _tasks.length,
      'pending': _tasks.where((t) => t.status == TaskStatus.pending).length,
      'inProgress': _tasks.where((t) => t.status == TaskStatus.inProgress).length,
      'completed': _tasks.where((t) => t.status == TaskStatus.completed).length,
      'overdue': _tasks.where((t) => t.isOverdue).length,
    };
  }

  void _toggleTask(Task task) {
    _mockService.updateTask(task.id, {
      'status': task.isCompleted ? TaskStatus.pending : TaskStatus.completed,
    });
    setState(() {
      _loadTasks();
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Suas tarefas',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_taskStats['completed']} concluídas',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF10B981),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (_taskStats['overdue']! > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_taskStats['overdue']} atrasadas',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFFEF4444),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: View all tasks
                },
                child: const Text('Ver todas'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_tasks.where((t) => !t.isCompleted).isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  'Nenhuma tarefa pendente!',
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
              itemCount: _tasks.where((t) => !t.isCompleted).take(5).length,
              itemBuilder: (context, index) {
                final pendingTasks = _tasks.where((t) => !t.isCompleted).take(5).toList();
                final task = pendingTasks[index];
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

}
