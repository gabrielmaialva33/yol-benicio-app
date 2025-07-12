import 'package:benicio/core/theme/theme_provider.dart';
import 'package:benicio/features/navigation/bottom_navigation.dart';
import 'package:benicio/features/shared/widgets/quick_theme_toggle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MobileLayout extends StatelessWidget {
  final int currentIndex;
  final List<String> pageTitles;
  final List<Widget> pages;
  final PageController pageController;
  final Function(int) onNavigationTap;
  final Function(int) onPageChanged;
  final VoidCallback onLogout;
  final bool isTablet;

  const MobileLayout({
    super.key,
    required this.currentIndex,
    required this.pageTitles,
    required this.pages,
    required this.pageController,
    required this.onNavigationTap,
    required this.onPageChanged,
    required this.onLogout,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
      appBar: isTablet
          ? AppBar(
              backgroundColor:
                  themeProvider.themeData.appBarTheme.backgroundColor,
              foregroundColor:
                  themeProvider.themeData.appBarTheme.foregroundColor,
              elevation: 0,
              title: Row(
                children: [
                  Text(
                    pageTitles[currentIndex],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color:
                          themeProvider.themeData.textTheme.titleLarge?.color,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: themeProvider.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Tablet',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: themeProvider.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {},
                ),
                const QuickThemeToggle(),
                const SizedBox(width: 8),
              ],
            )
          : AppBar(
              backgroundColor:
                  themeProvider.themeData.appBarTheme.backgroundColor,
              foregroundColor:
                  themeProvider.themeData.appBarTheme.foregroundColor,
              elevation: 0,
              title: Text(
                pageTitles[currentIndex],
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: themeProvider.themeData.textTheme.titleLarge?.color,
                ),
              ),
              actions: [
                if (currentIndex == 4) // Profile page
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: onLogout,
                  ),
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {},
                ),
                const QuickThemeToggle(),
                const SizedBox(width: 8),
              ],
            ),
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: pages,
      ),
      bottomNavigationBar: BenicioBottomNavigation(
        currentIndex: currentIndex,
        onTap: onNavigationTap,
      ),
    );
  }
}
