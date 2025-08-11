import 'package:benicio/core/theme/theme_provider.dart';
import 'package:benicio/features/navigation/widgets/desktop_sidebar.dart';
import 'package:benicio/features/shared/widgets/quick_theme_toggle.dart';
import 'package:benicio/features/shared/widgets/notifications_badge.dart';
import 'package:benicio/features/shared/widgets/header_search_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DesktopLayout extends StatelessWidget {
  final int currentIndex;
  final List<String> pageTitles;
  final bool isSidebarCollapsed;
  final Function(int) onNavigationTap;
  final VoidCallback onToggleSidebar;
  final Widget page;

  const DesktopLayout({
    super.key,
    required this.currentIndex,
    required this.pageTitles,
    required this.isSidebarCollapsed,
    required this.onNavigationTap,
    required this.onToggleSidebar,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: themeProvider.themeData.appBarTheme.backgroundColor,
        foregroundColor: themeProvider.themeData.appBarTheme.foregroundColor,
        elevation: 0,
        title: Row(
          children: [
            Text(
              pageTitles[currentIndex],
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: themeProvider.themeData.textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: themeProvider.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Desktop',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: themeProvider.primaryColor,
                ),
              ),
            ),
          ],
        ),
        actions: [
          const NotificationsBadge(),
          const SizedBox(width: 8),
          const HeaderSearchButton(),
          const SizedBox(width: 8),
          const QuickThemeToggle(),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          DesktopSidebar(
            currentIndex: currentIndex,
            onNavigationTap: onNavigationTap,
            pageTitles: pageTitles,
            isCollapsed: isSidebarCollapsed,
            onToggle: onToggleSidebar,
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: themeProvider.themeData.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: page,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
