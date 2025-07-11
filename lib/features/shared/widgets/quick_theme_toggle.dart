import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/theme_provider.dart';

class QuickThemeToggle extends StatelessWidget {
  const QuickThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return GestureDetector(
          onTap: () => themeProvider.toggleTheme(),
          onLongPress: () => _showThemeSelector(context, themeProvider),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: themeProvider.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: themeProvider.primaryColor.withOpacity(0.2),
              ),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                themeProvider.isDarkMode
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
                key: ValueKey(themeProvider.isDarkMode),
                color: themeProvider.primaryColor,
                size: 20,
              ),
            ),
          ),
        );
      },
    );
  }

  void _showThemeSelector(BuildContext context, ThemeProvider themeProvider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: themeProvider.themeData.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Escolha um tema',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: themeProvider.themeData.textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildThemeOption(
                    context: context,
                    themeProvider: themeProvider,
                    theme: AppThemeMode.light,
                    title: 'Claro',
                    icon: Icons.light_mode_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildThemeOption(
                    context: context,
                    themeProvider: themeProvider,
                    theme: AppThemeMode.dark,
                    title: 'Escuro',
                    icon: Icons.dark_mode_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required ThemeProvider themeProvider,
    required AppThemeMode theme,
    required String title,
    required IconData icon,
  }) {
    final isSelected = themeProvider.currentTheme == theme;
    
    return GestureDetector(
      onTap: () {
        themeProvider.setTheme(theme);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              themeProvider.primaryColor.withOpacity(0.1),
              themeProvider.primaryColor.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
              ? themeProvider.primaryColor
              : themeProvider.primaryColor.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: themeProvider.primaryColor,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: themeProvider.themeData.textTheme.bodyMedium?.color,
              ),
              textAlign: TextAlign.center,
            ),
            if (isSelected) ...[
              const SizedBox(height: 4),
              Icon(
                Icons.check_rounded,
                color: themeProvider.primaryColor,
                size: 16,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
