import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/area_division_data.dart';

class AreaDivisionCard extends StatefulWidget {
  final List<AreaDivisionData> areaDivisionData;

  const AreaDivisionCard({super.key, required this.areaDivisionData});

  @override
  State<AreaDivisionCard> createState() => _AreaDivisionCardState();
}

class _AreaDivisionCardState extends State<AreaDivisionCard>
    with TickerProviderStateMixin {
  int touchedIndex = -1;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Text(
                  'Divisão por Áreas Jurídicas',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Interativo',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF22C55E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 250,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
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
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    sections: _getAnimatedSections(),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: touchedIndex >= 0 ? 8 : 2,
                    centerSpaceRadius: touchedIndex >= 0 ? 60 : 50,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          _buildInteractiveLegend(),
          if (touchedIndex >= 0) ...[
            const SizedBox(height: 16),
            _buildSelectedAreaDetails(),
          ],
        ],
      ),
    );
  }

  List<PieChartSectionData> _getAnimatedSections() {
    return widget.areaDivisionData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final isTouched = index == touchedIndex;
      final radius = isTouched ? 120.0 : 100.0;
      final animatedValue = data.value * _animation.value;

      return PieChartSectionData(
        color: data.color,
        value: animatedValue,
        title: isTouched
            ? '${data.name}\n${animatedValue.toInt()}%'
            : '${animatedValue.toInt()}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: isTouched ? 16 : 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: const [
            Shadow(
              offset: Offset(1, 1),
              blurRadius: 2,
              color: Colors.black26,
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildInteractiveLegend() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
        spacing: 16,
        runSpacing: 12,
        children: widget.areaDivisionData.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;
          final isSelected = index == touchedIndex;

          return GestureDetector(
            onTap: () {
              setState(() {
                touchedIndex = touchedIndex == index ? -1 : index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? data.color.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? data.color : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: isSelected ? 16 : 12,
                    height: isSelected ? 16 : 12,
                    decoration: BoxDecoration(
                      color: data.color,
                      borderRadius: BorderRadius.circular(isSelected ? 8 : 2),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: data.color.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    data.name,
                    style: TextStyle(
                      fontSize: isSelected ? 14 : 12,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? data.color : const Color(0xFF64748B),
                    ),
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 4),
                    Text(
                      '(${data.value.toInt()}%)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: data.color,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSelectedAreaDetails() {
    if (touchedIndex < 0 || touchedIndex >= widget.areaDivisionData.length) {
      return const SizedBox.shrink();
    }

    final selectedData = widget.areaDivisionData[touchedIndex];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            selectedData.color.withOpacity(0.1),
            selectedData.color.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selectedData.color.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: selectedData.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${selectedData.name} - Detalhes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: selectedData.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildDetailRow('Participação', '${selectedData.value.toInt()}%'),
          _buildDetailRow(
              'Casos ativos', '${(selectedData.value * 24.2).toInt()}'),
          _buildDetailRow('Taxa de sucesso',
              '${(85 + (selectedData.value * 0.3)).toStringAsFixed(1)}%'),
          _buildDetailRow('Faturamento',
              'R\$ ${(selectedData.value * 85000).toStringAsFixed(0)}'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}
