import 'package:flutter/material.dart';

import '../widgets/client_list_item.dart';
import '../widgets/dashboard_layout.dart';
import '../widgets/stat_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final clientTasks = [
      {
        "title": "Create FireStone Logo",
        "dueDate": "Due in 2 Days",
        "color": Colors.green
      },
      {
        "title": "Stakeholder Meeting",
        "dueDate": "Due in 3 Days",
        "color": Colors.green
      },
      {
        "title": "Scoping & Estimations",
        "dueDate": "Due in 5 Days",
        "color": Colors.yellow
      },
      {
        "title": "KPI App Showcase",
        "dueDate": "Due in 2 Days",
        "color": Colors.green
      },
    ];

    return DashboardLayout(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Suas pastas',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Encontre aqui todas as suas pastas',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              const Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Ativos',
                      value: '45',
                      subtitle: 'Visualizar pastas',
                      linkText: 'Visualizar pastas',
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: StatCard(
                      title: 'Clientes totais',
                      value: '98',
                      subtitle: '08 novos neste mês',
                      linkText: 'Visualizar pastas',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                '(98) Clientes encontrados',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: clientTasks.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final task = clientTasks[index];
                  return ClientListItem(
                    title: task['title'] as String,
                    dueDate: task['dueDate'] as String,
                    color: task['color'] as Color,
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
