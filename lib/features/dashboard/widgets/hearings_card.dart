import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../shared/services/mock_data_service.dart';
import '../models/hearing.dart';

class HearingsCard extends StatefulWidget {
  const HearingsCard({super.key});

  @override
  State<HearingsCard> createState() => _HearingsCardState();
}

class _HearingsCardState extends State<HearingsCard> {
  final _mockService = MockDataService();
  late List<Hearing> _hearings;
  late Map<String, dynamic> _hearingStats;

  @override
  void initState() {
    super.initState();
    _loadHearings();
  }

  void _loadHearings() {
    // Get upcoming hearings
    _hearings = _mockService.getHearings(
      fromDate: DateTime.now(),
      toDate: DateTime.now().add(const Duration(days: 30)),
    );
    
    // Calculate statistics
    final totalHearings = _hearings.length;
    final completedHearings = _hearings.where((h) => h.status == HearingStatus.completed).length;
    final todayHearings = _hearings.where((h) => h.isToday).length;
    final thisWeekHearings = _hearings.where((h) => h.isThisWeek).length;
    
    _hearingStats = {
      'total': totalHearings,
      'completed': completedHearings,
      'today': todayHearings,
      'thisWeek': thisWeekHearings,
      'completionRate': totalHearings > 0 ? (completedHearings / totalHearings * 100) : 0,
    };
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
              TextButton.icon(
                onPressed: () {
                  // TODO: Show all hearings
                },
                icon: const Icon(Icons.calendar_today, size: 16),
                label: const Text('Ver todas'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Statistics
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Hoje',
                  _hearingStats['today'].toString(),
                  const Color(0xFF3B82F6),
                  Icons.today,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Esta Semana',
                  _hearingStats['thisWeek'].toString(),
                  const Color(0xFFF59E0B),
                  Icons.date_range,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Taxa Conclusão',
                  '${_hearingStats['completionRate'].toStringAsFixed(0)}%',
                  const Color(0xFF10B981),
                  Icons.check_circle_outline,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Upcoming hearings list
          const Text(
            'Próximas Audiências',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 16),
          
          if (_hearings.where((h) => h.status != HearingStatus.completed).isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  'Nenhuma audiência pendente!',
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
              itemCount: _hearings.where((h) => h.status != HearingStatus.completed).take(3).length,
              itemBuilder: (context, index) {
                final upcomingHearings = _hearings
                    .where((h) => h.status != HearingStatus.completed)
                    .toList();
                final hearing = upcomingHearings[index];
                return _buildHearingItem(hearing);
              },
            ),
        ],
      ),
    );
  }
  
  Widget _buildStatCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
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

  Widget _buildHearingItem(Hearing hearing) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: hearing.status.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              hearing.isVirtual ? Icons.video_call : Icons.gavel,
              color: hearing.status.color,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hearing.type,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${hearing.folder.code} - ${hearing.folder.client.name}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 14,
                      color: hearing.isToday ? const Color(0xFFEF4444) : const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      hearing.fullDisplay,
                      style: TextStyle(
                        fontSize: 12,
                        color: hearing.isToday ? const Color(0xFFEF4444) : const Color(0xFF6B7280),
                        fontWeight: hearing.isToday ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        hearing.location,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: hearing.status.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              hearing.status.displayName,
              style: TextStyle(
                fontSize: 11,
                color: hearing.status.color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
