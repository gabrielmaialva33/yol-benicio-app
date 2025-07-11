import 'package:flutter/material.dart';

import '../widgets/dashboard_layout.dart';
import '../widgets/metric_card.dart';

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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(27),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Suas pastas',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: Color(0xFF161C24),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Encontre aqui todas as suas pastas',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFFA1A5B7),
              ),
            ),
            const SizedBox(height: 32),
            LayoutBuilder(
              builder: (context, constraints) {
                bool isDesktop = constraints.maxWidth > 900;

                if (isDesktop) {
                  return _buildDesktopLayout();
                } else {
                  return _buildMobileLayout();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: MetricCard(
                title: 'Ativas',
                value: _mockData.activeFolders.toString(),
                subtitle: '${_mockData.newThisMonth} novos neste mês',
                linkText: 'Visualizar pastas',
                titleColor: const Color(0xFF64748B),
                valueColor: const Color(0xFF1E293B),
                subtitleColor: const Color(0xFF3B82F6),
                backgroundColor: Colors.white,
                hasViewIcon: true,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: MetricCard(
                title: 'Encerradas',
                value: _mockData.closedFolders.toString(),
                subtitle: '${_mockData.newThisMonth} novos neste mês',
                linkText: 'Visualizar pastas',
                titleColor: const Color(0xFF64748B),
                valueColor: const Color(0xFF1E293B),
                subtitleColor: const Color(0xFF3B82F6),
                backgroundColor: Colors.white,
                hasViewIcon: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        MetricCard(
          title: 'Prazos de Pastas',
          subtitle: 'Entregues dentro do prazo x Não entregues',
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _mockData.totalFolders.toString(),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF22C55E),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Entregues',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${_mockData.deliveredFolders}',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFF59E0B),
                                ),
                              ),
                              TextSpan(
                                text: '/${_mockData.totalFolders}',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Atrasadas',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${_mockData.delayedFolders}',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFEF4444),
                                ),
                              ),
                              TextSpan(
                                text: '/${_mockData.totalFolders}',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        MetricCard(
          title: 'Atividade Pastas',
          subtitle: 'de 20/12/24 à 03/01/25',
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total de pastas',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _mockData.totalFolders.toString(),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Novas pastas',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _mockData.deliveredFolders.toString(),
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFF3B82F6),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: MetricCard(
            title: 'Entradas',
            value: _mockData.totalRevenue,
            subtitle: 'de 20/12/24 à 03/01/25',
            backgroundColor: Colors.white,
            titleColor: const Color(0xFF64748B),
            valueColor: const Color(0xFF1E293B),
            subtitleColor: const Color(0xFF64748B),
            hasViewIcon: true,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: [
            MetricCard(
              title: 'Ativas',
              value: _mockData.activeFolders.toString(),
              subtitle: '${_mockData.newThisMonth} novos neste mês',
              backgroundColor: Colors.white,
            ),
            MetricCard(
              title: 'Fechadas',
              value: _mockData.closedFolders.toString(),
              subtitle: '${_mockData.newThisMonth} novos neste mês',
              backgroundColor: Colors.white,
            ),
          ],
        ),
        const SizedBox(height: 24),
        MetricCard(
          title: 'Entradas',
          value: _mockData.totalRevenue,
          subtitle: 'de 20/12/24 à 03/01/25',
          backgroundColor: Colors.white,
        ),
        const SizedBox(height: 16),
        MetricCard(
          title: 'Atrasos',
          value: _mockData.delayedRevenue,
          subtitle: 'de 20/12/24 à 03/01/25',
          backgroundColor: Colors.white,
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
}
