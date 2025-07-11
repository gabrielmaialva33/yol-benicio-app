import 'package:flutter/material.dart';
import 'package:yolapp/features/dashboard/models/folder_data.dart';
import 'package:yolapp/features/dashboard/models/task.dart';
import '../widgets/dashboard_layout.dart';
import '../widgets/stat_card.dart';
import '../widgets/metric_card.dart';
import '../widgets/task_item.dart';
import '../../common/widgets/yol_logo.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Mock data baseado no projeto yol-project
  final FolderStats _folderStats = FolderStats(active: 45, newThisMonth: 8);
  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Create FireStone Logo',
      category: 'Design',
      completed: false,
      color: const Color(0xFF10B981),
      dueDate: DateTime.now().add(const Duration(days: 2)),
    ),
    Task(
      id: '2',
      title: 'Stakeholder Meeting',
      category: 'Meeting',
      completed: false,
      color: const Color(0xFF3B82F6),
      dueDate: DateTime.now().add(const Duration(days: 3)),
    ),
    Task(
      id: '3',
      title: 'Scoping & Estimations',
      category: 'Planning',
      completed: false,
      color: const Color(0xFFF59E0B),
      dueDate: DateTime.now().add(const Duration(days: 5)),
    ),
    Task(
      id: '4',
      title: 'KPI App Showcase',
      category: 'Demo',
      completed: true,
      color: const Color(0xFF10B981),
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  void _toggleTask(Task task) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = _tasks[index].copyWith(completed: !task.completed);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Visão Geral',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Suas tarefas principais estão nessa sessão.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 32),

              // Grid principal com cards
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 1024;
                  
                  if (isWide) {
                    return Column(
                      children: [
                        // Primeira linha - 3 cards
                        Row(
                          children: [
                            Expanded(
                              child: StatCard(
                                title: 'Pastas ativas',
                                value: _folderStats.active.toString(),
                                subtitle: '${_folderStats.newThisMonth} novos neste mês',
                                linkText: 'Visualizar pastas',
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: StatCard(
                                title: 'Clientes totais',
                                value: '98',
                                subtitle: 'Diversos segmentos',
                                linkText: 'Ver clientes',
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: StatCard(
                                title: 'Atividade recente',
                                value: '520',
                                subtitle: 'Ações nos últimos 30 dias',
                                linkText: 'Ver atividades',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Segunda linha - 2 cards grandes
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: _buildTasksCard(),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: MetricCard(
                                title: 'Prazos de Pastas',
                                subtitle: 'Status de entrega',
                                metrics: [
                                  MetricItem(
                                    label: 'No prazo',
                                    value: '140',
                                    valueColor: const Color(0xFF10B981),
                                  ),
                                  MetricItem(
                                    label: 'Atrasadas',
                                    value: '47',
                                    valueColor: const Color(0xFFEF4444),
                                  ),
                                ],
                                linkText: 'Ver relatório completo',
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    // Layout para telas menores
                    return Column(
                      children: [
                        // Cards de métricas
                        StatCard(
                          title: 'Pastas ativas',
                          value: _folderStats.active.toString(),
                          subtitle: '${_folderStats.newThisMonth} novos neste mês',
                          linkText: 'Visualizar pastas',
                        ),
                        const SizedBox(height: 16),
                        StatCard(
                          title: 'Clientes totais',
                          value: '98',
                          subtitle: 'Diversos segmentos',
                          linkText: 'Ver clientes',
                        ),
                        const SizedBox(height: 24),
                        
                        // Card de tarefas
                        _buildTasksCard(),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTasksCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Suas tarefas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_tasks.length} tarefas',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._tasks.map(
            (task) => TaskItem(
              task: task,
              onToggle: _toggleTask,
            ),
          ),
        ],
      ),
    );
  }
}