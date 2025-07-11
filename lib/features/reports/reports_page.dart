import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../shared/services/mock_service.dart';
import 'widgets/area_division_card.dart';
import 'widgets/interactive_stats_card.dart';
import 'widgets/timeline_chart.dart';
import 'widgets/performance_metrics.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage>
    with TickerProviderStateMixin {
  final MockService mockService = MockService();
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  String selectedPeriod = 'Este mês';
  String selectedChart = 'pie';
  bool showDetails = false;
  int touchedIndex = -1;
  
  final List<String> periods = [
    'Esta semana',
    'Este mês', 
    'Últimos 3 meses',
    'Este ano'
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));
    
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Relatórios Interativos',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list, color: Color(0xFF1E293B)),
            onSelected: (value) {
              setState(() {
                selectedPeriod = value;
                _slideController.reset();
                _slideController.forward();
              });
            },
            itemBuilder: (context) => periods.map((period) {
              return PopupMenuItem(
                value: period,
                child: Text(period),
              );
            }).toList(),
          ),
          IconButton(
            icon: Icon(
              showDetails ? Icons.visibility_off : Icons.visibility,
              color: const Color(0xFF1E293B),
            ),
            onPressed: () {
              setState(() {
                showDetails = !showDetails;
              });
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPeriodSelector(),
              const SizedBox(height: 24),
              _buildQuickStats(),
              const SizedBox(height: 24),
              AreaDivisionCard(
                areaDivisionData: mockService.getAreaDivisionData(),
              ),
              const SizedBox(height: 24),
              _buildInteractiveCharts(),
              const SizedBox(height: 24),
              _buildPerformanceMetrics(),
              const SizedBox(height: 24),
              _buildTimelineAnalysis(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: periods.map((period) {
          final isSelected = selectedPeriod == period;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedPeriod = period;
                  _slideController.reset();
                  _slideController.forward();
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected 
                    ? const Color(0xFF582FFF) 
                    : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  period,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected 
                      ? Colors.white 
                      : const Color(0xFF64748B),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQuickStats() {
    return SlideTransition(
      position: _slideAnimation,
      child: Row(
        children: [
          Expanded(
            child: InteractiveStatsCard(
              title: 'Total de Casos',
              value: '2,420',
              subtitle: '+12% vs mês anterior',
              icon: Icons.folder_outlined,
              color: const Color(0xFF582FFF),
              onTap: () => _showStatsDetails('casos'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: InteractiveStatsCard(
              title: 'Taxa de Sucesso',
              value: '94.2%',
              subtitle: '+2.1% vs mês anterior',
              icon: Icons.trending_up,
              color: const Color(0xFF22C55E),
              onTap: () => _showStatsDetails('sucesso'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: InteractiveStatsCard(
              title: 'Faturamento',
              value: 'R\$ 2.5M',
              subtitle: '+8.5% vs mês anterior',
              icon: Icons.attach_money,
              color: const Color(0xFFF59E0B),
              onTap: () => _showStatsDetails('faturamento'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveCharts() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
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
                'Distribuição por Áreas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              Row(
                children: [
                  _buildChartTypeButton('pie', Icons.pie_chart),
                  const SizedBox(width: 8),
                  _buildChartTypeButton('bar', Icons.bar_chart),
                  const SizedBox(width: 8),
                  _buildChartTypeButton('line', Icons.show_chart),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 300,
            child: selectedChart == 'pie' 
              ? _buildInteractivePieChart()
              : selectedChart == 'bar'
                ? _buildInteractiveBarChart()
                : _buildInteractiveLineChart(),
          ),
          if (showDetails) ...[
            const SizedBox(height: 16),
            _buildChartLegend(),
          ],
        ],
      ),
    );
  }

  Widget _buildChartTypeButton(String type, IconData icon) {
    final isSelected = selectedChart == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedChart = type;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected 
            ? const Color(0xFF582FFF).withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected 
              ? const Color(0xFF582FFF)
              : Colors.transparent,
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isSelected 
            ? const Color(0xFF582FFF)
            : const Color(0xFF64748B),
        ),
      ),
    );
  }

  Widget _buildInteractivePieChart() {
    final data = mockService.getAreaDivisionData();
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        ),
        sections: data.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;
          final isTouched = index == touchedIndex;
          final radius = isTouched ? 110.0 : 100.0;
          
          return PieChartSectionData(
            color: data.color,
            value: data.value,
            title: isTouched ? '${data.name}\n${data.value.toInt()}%' : '${data.value.toInt()}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: isTouched ? 16 : 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
        borderData: FlBorderData(show: false),
        sectionsSpace: 2,
        centerSpaceRadius: 50,
      ),
    );
  }

  Widget _buildInteractiveBarChart() {
    final data = mockService.getAreaDivisionData();
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 35,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${data[group.x.toInt()].name}\n${rod.toY.round()}%',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() < data.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      data[value.toInt()].name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: data.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: data.value,
                color: data.color,
                width: 40,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInteractiveLineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 30),
              FlSpot(1, 25),
              FlSpot(2, 20),
              FlSpot(3, 15),
              FlSpot(4, 10),
            ],
            isCurved: true,
            color: const Color(0xFF582FFF),
            barWidth: 4,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF582FFF).withOpacity(0.1),
            ),
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 6,
                  color: const Color(0xFF582FFF),
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final areas = ['Trabalhista', 'Penal', 'Cível', 'Contencioso', 'Tributário'];
                return LineTooltipItem(
                  '${areas[spot.x.toInt()]}\n${spot.y.toInt()}%',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildChartLegend() {
    final data = mockService.getAreaDivisionData();
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: data.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: item.color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${item.name} (${item.value.toInt()}%)',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildPerformanceMetrics() {
    return PerformanceMetrics(
      onMetricTap: (metric) => _showMetricDetails(metric),
    );
  }

  Widget _buildTimelineAnalysis() {
    return TimelineChart(
      selectedPeriod: selectedPeriod,
      onPeriodChanged: (period) {
        setState(() {
          selectedPeriod = period;
        });
      },
    );
  }

  void _showStatsDetails(String type) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Detalhes de ${type.substring(0, 1).toUpperCase()}${type.substring(1)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Análise detalhada dos dados de $type para o período selecionado: $selectedPeriod',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF582FFF),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Fechar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMetricDetails(String metric) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Análise de $metric'),
        content: Text('Detalhes específicos sobre a métrica de $metric'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}
