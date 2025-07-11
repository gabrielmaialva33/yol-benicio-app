import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:benicio/core/theme/theme_provider.dart';

class JudgmentCard extends StatelessWidget {
  const JudgmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    
    if (isSmallScreen) {
      // Mobile layout - stack vertically
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jud 2º instância (SP)',
            style: themeProvider.themeData.textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                label: const Text('Recursal'),
                backgroundColor:
                    themeProvider.themeData.scaffoldBackgroundColor,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              Chip(
                label: const Text('Interno'),
                backgroundColor:
                    themeProvider.themeData.scaffoldBackgroundColor,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              SizedBox(
                height: 32,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Text('Visualizar', style: TextStyle(fontSize: 14)),
                ),
              ),
            ],
          ),
        ],
      );
    }
    
    // Desktop/Tablet layout
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            'Jud 2º instância (SP)',
            style: themeProvider.themeData.textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Flexible(
          flex: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Chip(
                  label: const Text('Recursal', style: TextStyle(fontSize: 12)),
                  backgroundColor:
                      themeProvider.themeData.scaffoldBackgroundColor,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Chip(
                  label: const Text('Interno', style: TextStyle(fontSize: 12)),
                  backgroundColor:
                      themeProvider.themeData.scaffoldBackgroundColor,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: SizedBox(
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: const Text('Visualizar', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
