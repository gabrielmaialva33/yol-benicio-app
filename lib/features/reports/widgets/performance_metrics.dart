import 'package:flutter/material.dart';

class PerformanceMetrics extends StatefulWidget {
  final Function(String) onMetricTap;

  const PerformanceMetrics({
    Key? key,
    required this.onMetricTap,
  }) : super(key: key);

  @override
  State<PerformanceMetrics> createState() => _PerformanceMetricsState();
}

class _PerformanceMetricsState extends State<PerformanceMetrics>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  final List<MetricData> metrics = [
    MetricData(
      title: 'Produtividade',
      value: 94.5,
      unit: '%',
      trend: 'up',
      color: const Color(0xFF22C55E),
      icon: Icons.trending_up,
    ),
    MetricData(
      title: 'Eficiência',
      value: 87.2,
      unit: '%',
      trend: 'up',
      color: const Color(0xFF3B82F6),
      icon: Icons.speed,
    ),
    MetricData(
      title: 'Qualidade',
      value: 96.8,
      unit: '%',
      trend: 'stable',
      color: const Color(0xFF8B5CF6),
      icon: Icons.star,
    ),
    MetricData(
      title: 'Satisfação',
      value: 92.1,
      unit: '%',
      trend: 'up',
      color: const Color(0xFFF59E0B),
      icon: Icons.sentiment_very_satisfied,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      metrics.length,
          (index) =>
          AnimationController(
            duration: Duration(milliseconds: 800 + (index * 200)),
            vsync: this,
          ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticOut),
      );
    }).toList();

    // Start animations with staggered delay
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) {
          _controllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
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
          const Text(
            'Métricas de Performance',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Indicadores chave de desempenho do escritório',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: metrics.length,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _animations[index],
                builder: (context, child) {
                  return Transform.scale(
                    scale: _animations[index].value,
                    child: _buildMetricCard(metrics[index], index),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 24),
          _buildPerformanceSummary(),
        ],
      ),
    );
  }

  Widget _buildMetricCard(MetricData metric, int index) {
    return GestureDetector(
      onTap: () => widget.onMetricTap(metric.title),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: metric.color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: metric.color.withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  metric.icon,
                  color: metric.color,
                  size: 24,
                ),
                _buildTrendIndicator(metric.trend, metric.color),
              ],
            ),
            const Spacer(),
            Text(
              metric.title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AnimatedBuilder(
                  animation: _animations[index],
                  builder: (context, child) {
                    final animatedValue =
                        metric.value * _animations[index].value;
                    return Text(
                      animatedValue.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: metric.color,
                      ),
                    );
                  },
                ),
                Text(
                  metric.unit,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: metric.color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendIndicator(String trend, Color color) {
    IconData iconData;
    switch (trend) {
      case 'up':
        iconData = Icons.arrow_upward;
        break;
      case 'down':
        iconData = Icons.arrow_downward;
        break;
      default:
        iconData = Icons.remove;
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(
        iconData,
        size: 12,
        color: color,
      ),
    );
  }

  Widget _buildPerformanceSummary() {
    final avgPerformance =
        metrics.map((m) => m.value).reduce((a, b) => a + b) / metrics.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF582FFF).withOpacity(0.1),
            const Color(0xFF22C55E).withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.assessment,
              color: Color(0xFF582FFF),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Performance Geral',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${avgPerformance.toStringAsFixed(1)}% - Excelente',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF22C55E),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Todas as métricas estão acima da meta estabelecida',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MetricData {
  final String title;
  final double value;
  final String unit;
  final String trend;
  final Color color;
  final IconData icon;

  MetricData({
    required this.title,
    required this.value,
    required this.unit,
    required this.trend,
    required this.color,
    required this.icon,
  });
}
