import 'package:benicio/features/folders/models/folder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:benicio/core/theme/theme_provider.dart';

class FolderCard extends StatelessWidget {
  final Folder folder;
  final VoidCallback onTap;

  const FolderCard({
    Key? key,
    required this.folder,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
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
                Text(
                  '#${folder.client.id} - ${folder.client.name}',
                  style: themeProvider.themeData.textTheme.titleMedium,
                ),
                Icon(
                  folder.isFavorite ? Icons.star : Icons.star_border,
                  color: folder.isFavorite
                      ? themeProvider.warningColor
                      : themeProvider.themeData.textTheme.bodySmall?.color,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              folder.title,
              style: themeProvider.themeData.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Responsável',
                      style: themeProvider.themeData.textTheme.bodySmall,
                    ),
                    Text(
                      folder.responsibleLawyer.fullName,
                      style: themeProvider.themeData.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Status',
                      style: themeProvider.themeData.textTheme.bodySmall,
                    ),
                    Text(
                      folder.status.toString().split('.').last,
                      style: themeProvider.themeData.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
