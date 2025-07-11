import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/hearing.dart';

class HearingsCard extends StatefulWidget {
  const HearingsCard({super.key});

  @override
  State<HearingsCard> createState() => _HearingsCardState();
}

class _HearingsCardState extends State<HearingsCard> {
  late List<Hearing> _hearings;

  @override
  void initState() {
    super.initState();
    _hearings = _getMockHearings();
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
            children: [
              const Expanded(
                child: Text(
                  'Audiências e Prazos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
              // Placeholder for DateRangePicker
              TextButton.icon(
                onPressed: () {
                  // TODO: Implement DateRangePicker
                },
                icon: const Icon(Icons.calendar_today, size: 16),
                label: Text(
                  DateFormat('d MMM', 'pt_BR').format(DateTime.now()),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_hearings.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  'Nenhuma audiência para hoje!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _hearings.length,
              itemBuilder: (context, index) {
                final hearing = _hearings[index];
                return _buildHearingItem(hearing);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildHearingItem(Hearing hearing) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${hearing.percentage.toInt()}%',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hearing.label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: ${hearing.total}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    Text(
                      'Cumpridos: ${hearing.completed}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: hearing.percentage / 100,
                  backgroundColor: Colors.grey[200],
                  color: hearing.color,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Hearing> _getMockHearings() {
    return [
      Hearing(
        label: 'Audiências',
        percentage: 75,
        total: 120,
        completed: 90,
        color: const Color(0xFF3B82F6),
        date: DateTime.now(),
      ),
      Hearing(
        label: 'Prazos',
        percentage: 40,
        total: 50,
        completed: 20,
        color: const Color(0xFFF59E0B),
        date: DateTime.now(),
      ),
      Hearing(
        label: 'Recursos',
        percentage: 90,
        total: 10,
        completed: 9,
        color: const Color(0xFF10B981),
        date: DateTime.now(),
      ),
    ];
  }
}
