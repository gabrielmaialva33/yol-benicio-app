import 'package:flutter/material.dart';

import '../dashboard/pages/dashboard_page.dart';
import '../history/history_page.dart';
import '../navigation/bottom_navigation.dart';
import '../profile/profile_page.dart';
import '../reports/reports_page.dart';
import '../search/search_page.dart';
import '../folders/pages/folder_consultation_page.dart';
import 'widgets/desktop_sidebar.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({Key? key}) : super(key: key);

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  bool _isSidebarCollapsed = false;

  final List<Widget> _pages = [
    const DashboardPage(),
    const FolderConsultationPage(),
    const SearchPage(),
    const ReportsPage(),
    const HistoryPage(),
    const ProfilePage(),
  ];

  final List<String> _pageTitles = [
    'Dashboard',
    'Pastas',
    'Buscar',
    'Relatórios',
    'Histórico',
    'Perfil',
  ];

  void _onNavigationTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Only animate PageController if it's attached to a PageView (mobile layout)
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 900;

        if (isDesktop) {
          // Layout desktop sem bottom navigation
          return Scaffold(
            body: Row(
              children: [
                DesktopSidebar(
                  currentIndex: _currentIndex,
                  onNavigationTap: _onNavigationTap,
                  pageTitles: _pageTitles,
                  isCollapsed: _isSidebarCollapsed,
                  onToggle: () {
                    setState(() {
                      _isSidebarCollapsed = !_isSidebarCollapsed;
                    });
                  },
                ),
                // Main content
                Expanded(
                  child: _pages[_currentIndex],
                ),
              ],
            ),
          );
        } else {
          // Layout mobile com bottom navigation
          return Scaffold(
            body: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: _pages,
            ),
            bottomNavigationBar: BenicioBottomNavigation(
              currentIndex: _currentIndex,
              onTap: _onNavigationTap,
            ),
          );
        }
      },
    );
  }
}
