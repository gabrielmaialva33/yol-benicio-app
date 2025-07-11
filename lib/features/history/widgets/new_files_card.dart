import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:benicio/core/theme/theme_provider.dart';

class NewFilesCard extends StatelessWidget {
  const NewFilesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.attach_file,
              size: 16,
              color: themeProvider.themeData.textTheme.bodySmall?.color,
            ),
            const SizedBox(width: 8),
            Text(
              '2 novos arquivos vinculados ao processo',
              style: themeProvider.themeData.textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}
