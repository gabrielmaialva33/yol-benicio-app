import 'package:benicio/features/history/widgets/billed_card.dart';
import 'package:benicio/features/history/widgets/bonus_card.dart';
import 'package:benicio/features/history/widgets/history_card.dart';
import 'package:benicio/features/history/widgets/judgment_card.dart';
import 'package:benicio/features/history/widgets/new_files_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:benicio/core/theme/theme_provider.dart';
import 'package:benicio/features/folders/models/folder.dart';

class HistoryPage extends StatelessWidget {
  final Folder folder;

  const HistoryPage({super.key, required this.folder});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: themeProvider.themeData.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Histórico - ${folder.title}',
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
                children: const [
                  HistoryCard(
                    title: 'Faturamento realizado com sucesso',
                    subtitle: '',
                    date: '29/11/2024',
                    user: 'Dra. Ana Rodrigues',
                    content: BilledCard(),
                  ),
                  HistoryCard(
                    title: 'Acórdão Apelção #7979207',
                    subtitle: '',
                    date: '29/11/2024',
                    user: 'Dr. Carlos Mendes',
                    content: JudgmentCard(),
                  ),
                  HistoryCard(
                    title: 'Bônus por improcedência #7966690',
                    subtitle: '',
                    date: '29/11/2024',
                    user: 'Dr. Carlos Mendes',
                    content: BonusCard(),
                  ),
                  HistoryCard(
                    title: '2 novos arquivos vinculados ao processo',
                    subtitle: '',
                    date: '29/11/2024',
                    user: 'Dra. Mariana Silva',
                    content: NewFilesCard(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
