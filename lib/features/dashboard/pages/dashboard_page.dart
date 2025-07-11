import 'package:flutter/material.dart';

import '../widgets/dashboard_layout.dart';
import '../widgets/metric_card.dart';
import 'package:fl_chart/fl_chart.dart';

import '../models/billing_data.dart';
import '../widgets/tasks_card.dart';
import '../widgets/hearings_card.dart';
import '../widgets/billing_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final MockData _mockData = MockData();

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 900;
          bool isTablet =
              constraints.maxWidth > 600 && constraints.maxWidth <= 900;

          return SingleChildScrollView(
            padding: EdgeInsets.all(isDesktop ? 32 : (isTablet ? 24 : 16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(isDesktop, isTablet),
                SizedBox(height: isDesktop ? 32 : 24),
                if (isDesktop)
                  _buildDesktopLayout()
                else
                  if (isTablet)
                    _buildTabletLayout()
                  else
                    _buildMobileLayout(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(bool isDesktop, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dashboard - Processos',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: isDesktop ? 30 : (isTablet ? 26 : 22),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF161C24),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Acompanhe suas pastas e clientes em tempo real',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: isDesktop ? 18 : (isTablet ? 16 : 14),
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFA1A5B7),
                    ),
                  ),
                ],
              ),
            ),
            if (isDesktop || isTablet) ...[
              const SizedBox(width: 16),
              _buildQuickActions(),
            ],
          ],
        ),
        if (!isDesktop && !isTablet) ...[
          const SizedBox(height: 16),
          _buildQuickActions(),
        ],
      ],
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionButton(
          icon: Icons.add_circle_outline,
          label: 'Nova Pasta',
          color: const Color(0xFF3B82F6),
          onTap: () {
            // TODO: Implementar criação de nova pasta
          },
        ),
        const SizedBox(width: 12),
        _buildActionButton(
          icon: Icons.person_add_outlined,
          label: 'Novo Cliente',
          color: const Color(0xFF10B981),
          onTap: () {
            // TODO: Implementar criação de novo cliente
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Column(
      children: [
        // Métricas principais em grid responsivo
        _buildMetricsGrid(isDesktop: true),
        const SizedBox(height: 32),

        // Segunda linha com cards mais complexos
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  const TasksCard(),
                  const SizedBox(height: 24),
                  const HearingsCard(),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  BillingCard(billingData: _mockData.billingData),
                  const SizedBox(height: 24),
                  _buildRecentClientsCard(),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Seção adicional com prazos
        Row(
          children: [
            Expanded(
              child: _buildDeadlinesCard(),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildProcessStatsCard(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Column(
      children: [
        // Métricas em grid 2x2
        _buildMetricsGrid(isDesktop: false),
        const SizedBox(height: 24),

        // Cards principais em coluna única
        const TasksCard(),
        const SizedBox(height: 20),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: const HearingsCard(),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: BillingCard(billingData: _mockData.billingData),
            ),
          ],
        ),
        const SizedBox(height: 20),

        _buildRecentClientsCard(),
        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(child: _buildDeadlinesCard()),
            const SizedBox(width: 16),
            Expanded(child: _buildProcessStatsCard()),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Métricas principais em grid 2x2
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.9,
          children: [
            MetricCard(
              title: 'Processos Ativos',
              value: _mockData.activeFolders.toString(),
              subtitle: '+${_mockData.newThisMonth}',
              backgroundColor: Colors.white,
              valueColor: const Color(0xFF3B82F6),
            ),
            MetricCard(
              title: 'Concluídos',
              value: _mockData.closedFolders.toString(),
              subtitle: 'Finalizados',
              backgroundColor: Colors.white,
              valueColor: const Color(0xFF10B981),
            ),
            MetricCard(
              title: 'Clientes',
              value: '89',
              subtitle: '+12 novos',
              backgroundColor: Colors.white,
              valueColor: const Color(0xFFF59E0B),
            ),
            MetricCard(
              title: 'Receita',
              value: _formatCurrency(_mockData.totalRevenue),
              subtitle: 'Este mês',
              backgroundColor: Colors.white,
              valueColor: const Color(0xFF059669),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Seção de ações rápidas
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ações Rápidas',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildMobileQuickAction(
                      Icons.add_circle_outline,
                      'Nova\nPasta',
                      const Color(0xFF3B82F6),
                          () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMobileQuickAction(
                      Icons.person_add_outlined,
                      'Novo\nCliente',
                      const Color(0xFF10B981),
                          () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMobileQuickAction(
                      Icons.calendar_today_outlined,
                      'Agenda',
                      const Color(0xFFF59E0B),
                          () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Tasks Card
        const TasksCard(),
        const SizedBox(height: 20),

        // Prazos próximos (versão mobile)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
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
                    'Prazos Próximos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Ver todos os prazos
                    },
                    child: const Text('Ver todos'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildMobileDeadlineItem(
                      '${_mockData.delayedFolders}',
                      'Atrasados',
                      const Color(0xFFEF4444),
                    ),
                  ),
                  Expanded(
                    child: _buildMobileDeadlineItem(
                      '12',
                      'Hoje',
                      const Color(0xFFF59E0B),
                    ),
                  ),
                  Expanded(
                    child: _buildMobileDeadlineItem(
                      '8',
                      'Amanhã',
                      const Color(0xFF3B82F6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Hearings Card
        const HearingsCard(),
        const SizedBox(height: 20),

        // Billing Card
        BillingCard(billingData: _mockData.billingData),
      ],
    );
  }

  Widget _buildMobileQuickAction(IconData icon, String label, Color color,
      VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileDeadlineItem(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(String value) {
    // Remove "R$" e espaços para pegar apenas o número
    final cleanValue = value.replaceAll(RegExp(r'[^\d,.]'), '');
    if (cleanValue.contains(',')) {
      final parts = cleanValue.split(',');
      if (parts[0].length > 6) {
        return 'R\$ ${parts[0].substring(0, parts[0].length - 3)}K';
      }
    }
    return value;
  }

  Widget _buildMetricsGrid({required bool isDesktop}) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isDesktop ? 4 : 2,
      crossAxisSpacing: isDesktop ? 24 : 16,
      mainAxisSpacing: isDesktop ? 24 : 16,
      childAspectRatio: isDesktop ? 1.1 : 1.0,
      children: [
        MetricCard(
          title: 'Processos Ativos',
          value: _mockData.activeFolders.toString(),
          subtitle: '${_mockData.newThisMonth} novos este mês',
          titleColor: const Color(0xFF64748B),
          valueColor: const Color(0xFF3B82F6),
          subtitleColor: const Color(0xFF10B981),
          backgroundColor: Colors.white,
          hasViewIcon: true,
        ),
        MetricCard(
          title: 'Processos Concluídos',
          value: _mockData.closedFolders.toString(),
          subtitle: 'Finalizados',
          titleColor: const Color(0xFF64748B),
          valueColor: const Color(0xFF10B981),
          subtitleColor: const Color(0xFF6B7280),
          backgroundColor: Colors.white,
          hasViewIcon: true,
        ),
        MetricCard(
          title: 'Clientes Ativos',
          value: '89',
          subtitle: '12 novos este mês',
          titleColor: const Color(0xFF64748B),
          valueColor: const Color(0xFFF59E0B),
          subtitleColor: const Color(0xFF10B981),
          backgroundColor: Colors.white,
          hasViewIcon: true,
        ),
        MetricCard(
          title: 'Receita Total',
          value: _mockData.totalRevenue,
          subtitle: 'Este mês',
          titleColor: const Color(0xFF64748B),
          valueColor: const Color(0xFF059669),
          subtitleColor: const Color(0xFF6B7280),
          backgroundColor: Colors.white,
          hasViewIcon: true,
        ),
      ],
    );
  }

  Widget _buildRecentClientsCard() {
    return MetricCard(
      title: 'Clientes Recentes',
      subtitle: 'Últimos adicionados ao sistema',
      value: '',
      backgroundColor: Colors.white,
      hasViewIcon: true,
      customContent: Column(
        children: [
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final clients = [
                'Maria Silva',
                'João Santos',
                'Empresa XYZ Ltda',
                'Ana Costa'
              ];
              final dates = ['Hoje', 'Ontem', '2 dias', '3 dias'];
              final types = ['PF', 'PF', 'PJ', 'PF'];

              return ListTile(
                dense: true,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                leading: CircleAvatar(
                  radius: 16,
                  backgroundColor: types[index] == 'PF'
                      ? const Color(0xFF3B82F6).withOpacity(0.1)
                      : const Color(0xFF10B981).withOpacity(0.1),
                  child: Text(
                    types[index],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: types[index] == 'PF'
                          ? const Color(0xFF3B82F6)
                          : const Color(0xFF10B981),
                    ),
                  ),
                ),
                title: Text(
                  clients[index],
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  'Adicionado há ${dates[index]}',
                  style:
                  const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                onTap: () {
                  // TODO: Navegar para detalhes do cliente
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDeadlinesCard() {
    return MetricCard(
      title: 'Prazos Próximos',
      subtitle: 'Vencimento nos próximos 7 dias',
      value: '',
      backgroundColor: Colors.white,
      hasViewIcon: true,
      customContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDeadlineItem(
                  '${_mockData.delayedFolders}',
                  'Atrasados',
                  const Color(0xFFEF4444),
                ),
              ),
              Expanded(
                child: _buildDeadlineItem(
                  '12',
                  'Hoje',
                  const Color(0xFFF59E0B),
                ),
              ),
              Expanded(
                child: _buildDeadlineItem(
                  '8',
                  'Amanhã',
                  const Color(0xFF3B82F6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeadlineItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildProcessStatsCard() {
    return MetricCard(
      title: 'Estatísticas de Processos',
      subtitle: 'Últimos 30 dias',
      value: '',
      backgroundColor: Colors.white,
      hasViewIcon: true,
      customContent: Column(
        children: [
          const SizedBox(height: 16),
          _buildStatRow('Total de Processos', _mockData.totalFolders.toString(),
              const Color(0xFF1E293B)),
          const SizedBox(height: 12),
          _buildStatRow('Entregues no Prazo', '${_mockData.deliveredFolders}',
              const Color(0xFF10B981)),
          const SizedBox(height: 12),
          _buildStatRow('Com Atraso', '${_mockData.delayedFolders}',
              const Color(0xFFEF4444)),
          const SizedBox(height: 12),
          _buildStatRow(
              'Taxa de Sucesso',
              '${(((_mockData.deliveredFolders / _mockData.totalFolders) * 100)
                  .round())}%',
              const Color(0xFF3B82F6)),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class MockData {
  final int activeFolders = 2420;
  final int closedFolders = 2420;
  final int newThisMonth = 98;
  final int totalFolders = 520;
  final int deliveredFolders = 140;
  final int delayedFolders = 47;
  final String totalRevenue = 'R\$1.084.000,00';
  final String delayedRevenue = 'R\$584.000,00';

  final BillingData billingData = BillingData(
    value: 'R\$ 2.5M',
    percentage: 15.3,
    chartData: [
      const FlSpot(0, 1),
      const FlSpot(1, 1.5),
      const FlSpot(2, 1.4),
      const FlSpot(3, 3.4),
      const FlSpot(4, 2),
      const FlSpot(5, 2.2),
      const FlSpot(6, 1.8),
    ],
  );
}
