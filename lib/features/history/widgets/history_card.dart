import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:benicio/core/theme/theme_provider.dart';

class HistoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  final String user;
  final Widget? content;

  const HistoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.user,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.edit,
                    size: 16,
                    color: themeProvider.themeData.textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: themeProvider.themeData.textTheme.titleMedium,
                  ),
                ],
              ),
              Text(
                date,
                style: themeProvider.themeData.textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                'Adicionado por',
                style: themeProvider.themeData.textTheme.bodySmall,
              ),
              const SizedBox(width: 4),
              CircleAvatar(
                radius: 10,
                // backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=$user'),
              ),
              const SizedBox(width: 4),
              Text(
                user,
                style: themeProvider.themeData.textTheme.bodySmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          if (content != null) ...[
            const SizedBox(height: 16),
            content!,
          ],
        ],
      ),
    );
  }
}
