import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yolapp/features/dashboard/models/folder_data.dart';
import 'package:yolapp/features/dashboard/models/task.dart';
import '../widgets/dashboard_layout.dart';
import '../widgets/stat_card.dart';
import '../widgets/client_list_item.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Mock data based on the analyzed files
  final FolderStats _folderStats = FolderStats(active: 45, newThisMonth: 8);
  final List<Task> _tasks = [
    Task(
        id: '1',
        title: 'Create FireStone Logo',
        category: 'Design',
        completed: false,
        color: Colors.green,
        dueDate: DateTime.now().add(const Duration(days: 2))),
    Task(
        id: '2',
        title: 'Stakeholder Meeting',
        category: 'Meeting',
        completed: false,
        color: Colors.green,
        dueDate: DateTime.now().add(const Duration(days: 3))),
    Task(
        id: '3',
        title: 'Scoping & Estimations',
        category: 'Planning',
        completed: false,
        color: Colors.yellow,
        dueDate: DateTime.now().add(const Duration(days: 5))),
    Task(
        id: '4',
        title: 'KPI App Showcase',
        category: 'Demo',
        completed: false,
        color: Colors.green,
        dueDate: DateTime.now().add(const Duration(days: 2))),
  ];

  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference < 0) {
      return 'Atrasado';
    } else if (difference == 0) {
      return 'Vence hoje';
    } else if (difference == 1) {
      return 'Vence amanhã';
    } else {
      return 'Vence em $difference dias';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Suas pastas',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Encontre aqui todas as suas pastas',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Ativos',
                      value: _folderStats.active.toString(),
                      subtitle: 'Visualizar pastas',
                      linkText: 'Visualizar pastas',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatCard(
                      title: 'Clientes totais',
                      value: '98', // Assuming this is a separate metric for now
                      subtitle: '${_folderStats.newThisMonth} novos neste mês',
                      linkText: 'Visualizar pastas',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                '(${_tasks.length}) Tarefas encontradas',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _tasks.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  return ClientListItem(
                    title: task.title,
                    dueDate: _formatDueDate(task.dueDate),
                    color: task.color,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
