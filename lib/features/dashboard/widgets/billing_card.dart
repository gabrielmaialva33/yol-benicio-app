import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/billing_data.dart';

class BillingCard extends StatelessWidget {
  final BillingData billingData;

  const BillingCard({super.key, required this.billingData});

  @override
  Widget build(BuildContext context) {
    final percentageColor = billingData.percentage > 0
        ? const Color(0xFF22C55E)
        : const Color(0xFFEF4444);
    final percentageIcon =
        billingData.percentage > 0 ? Icons.arrow_upward : Icons.arrow_downward;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F8F3),
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
                'Faturamento',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF004B50),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(percentageIcon, color: percentageColor, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${billingData.percentage.toStringAsFixed(2)}%',
                        style: TextStyle(
                          color: percentageColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Último mês',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF004B50),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            billingData.value,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF004B50),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 80,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: billingData.chartData,
                    isCurved: true,
                    color: const Color(0xFF004B50),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
