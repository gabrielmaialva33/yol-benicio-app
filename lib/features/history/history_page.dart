import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:benicio/core/theme/theme_provider.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: themeProvider.themeData.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Histórico',
          style: themeProvider.themeData.textTheme.titleLarge,
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Atividades Recentes',
              style: themeProvider.themeData.textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildHistoryItem(
                    context,
                    'Create FireStone Logo',
                    'Due in 2 Days',
                    const Color(0xFF2FAC68),
                    '10:30 AM',
                  ),
                  _buildHistoryItem(
                    context,
                    'Stakeholder Meeting',
                    'Due in 3 Days',
                    const Color(0xFF008980),
                    '09:15 AM',
                  ),
                  _buildHistoryItem(
                    context,
                    'Scoping & Estimations',
                    'Due in 5 Days',
                    const Color(0xFFF6C000),
                    'Yesterday',
                  ),
                  _buildHistoryItem(
                    context,
                    'KPI App Showcase',
                    'Due in 2 Days',
                    const Color(0xFF008980),
                    '2 days ago',
                  ),
                  _buildHistoryItem(
                    context,
                    'Client Review Session',
                    'Completed',
                    const Color(0xFF582FFF),
                    '3 days ago',
                  ),
                  _buildHistoryItem(
                    context,
                    'Design System Update',
                    'Completed',
                    const Color(0xFF2FAC68),
                    '1 week ago',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, String title, String subtitle,
      Color color, String time) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.themeData.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: themeProvider.isDarkMode
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: themeProvider.themeData.textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: themeProvider.themeData.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: themeProvider.themeData.textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: themeProvider.isDarkMode
                      ? Colors.white.withOpacity(0.05)
                      : Colors.black.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: themeProvider.themeData.textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
