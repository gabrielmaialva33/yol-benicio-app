import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TimelineChart extends StatefulWidget {
  final String selectedPeriod;
  final Function(String) onPeriodChanged;

  const TimelineChart({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  State<TimelineChart> createState() => _TimelineChartState();
}

class _TimelineChartState extends State<TimelineChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                'Análise Temporal',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF582FFF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.selectedPeriod,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF582FFF),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 250,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
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
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toInt()}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            final months = [
                              'Jan',
                              'Fev',
                              'Mar',
                              'Abr',
                              'Mai',
                              'Jun'
                            ];
                            if (value.toInt() < months.length) {
                              return Text(
                                months[value.toInt()],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                ),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      // Linha principal - Casos resolvidos
                      LineChartBarData(
                        spots: _getAnimatedSpots([
                          const FlSpot(0, 45),
                          const FlSpot(1, 52),
                          const FlSpot(2, 48),
                          const FlSpot(3, 61),
                          const FlSpot(4, 58),
                          const FlSpot(5, 67),
                        ]),
                        isCurved: true,
                        color: const Color(0xFF582FFF),
                        barWidth: 3,
                        isStrokeCapRound: true,
                        belowBarData: BarAreaData(
                          show: true,
                          color: const Color(0xFF582FFF).withOpacity(0.1),
                        ),
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: const Color(0xFF582FFF),
                              strokeWidth: 2,
                              strokeColor: Colors.white,
                            );
                          },
                        ),
                      ),
                      // Linha secundária - Novos casos
                      LineChartBarData(
                        spots: _getAnimatedSpots([
                          const FlSpot(0, 30),
                          const FlSpot(1, 38),
                          const FlSpot(2, 35),
                          const FlSpot(3, 42),
                          const FlSpot(4, 45),
                          const FlSpot(5, 50),
                        ]),
                        isCurved: true,
                        color: const Color(0xFF22C55E),
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dashArray: [8, 4],
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 3,
                              color: const Color(0xFF22C55E),
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
                            final isMainLine = spot.barIndex == 0;
                            final label = isMainLine ? 'Resolvidos' : 'Novos';
                            return LineTooltipItem(
                              '$label\n${spot.y.toInt()} casos',
                              TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildLegend(),
          const SizedBox(height: 16),
          _buildInsights(),
        ],
      ),
    );
  }

  List<FlSpot> _getAnimatedSpots(List<FlSpot> targetSpots) {
    return targetSpots.map((spot) {
      return FlSpot(
        spot.x,
        spot.y * _animation.value,
      );
    }).toList();
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('Casos Resolvidos', const Color(0xFF582FFF)),
        const SizedBox(width: 24),
        _buildLegendItem('Novos Casos', const Color(0xFF22C55E)),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildInsights() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Insights do Período',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '• Taxa de resolução aumentou 15% em relação ao período anterior',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '• Junho foi o mês com melhor performance (67 casos resolvidos)',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '• Tendência de crescimento consistente nos últimos 3 meses',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}
