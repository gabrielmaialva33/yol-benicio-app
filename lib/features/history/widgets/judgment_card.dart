import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:benicio/core/theme/theme_provider.dart';

class JudgmentCard extends StatelessWidget {
  const JudgmentCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Jud 2º instância (SP)',
              style: themeProvider.themeData.textTheme.bodyMedium,
            ),
            Row(
              children: [
                Chip(
                  label: Text('Recursal'),
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
