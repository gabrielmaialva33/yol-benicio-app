import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:benicio/core/theme/theme_provider.dart';

class GeneralHistoryPage extends StatelessWidget {
  const GeneralHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: themeProvider.themeData.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Histórico Geral',
          style: themeProvider.themeData.textTheme.titleLarge,
        ),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text('Página de Histórico Geral'),
      ),
    );
  }
}
