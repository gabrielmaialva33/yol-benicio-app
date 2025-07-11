import 'package:fl_chart/fl_chart.dart';

class BillingData {
  final String value;
  final double percentage;
  final List<FlSpot> chartData;

  BillingData({
    required this.value,
    required this.percentage,
    required this.chartData,
  });
}
