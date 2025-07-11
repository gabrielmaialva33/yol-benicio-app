import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:benicio/core/theme/theme_provider.dart';

class BonusCard extends StatelessWidget {
  const BonusCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Solicitado encerramento',
              style: themeProvider.themeData.textTheme.bodyMedium,
            ),
            Row(
              children: [
                Chip(
                  label: Text('Execução Definitiva'),
                  backgroundColor:
                  themeProvider.themeData.scaffoldBackgroundColor,
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text('Interno'),
                  backgroundColor:
                  themeProvider.themeData.scaffoldBackgroundColor,
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Visualizar'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
