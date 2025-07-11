import 'package:flutter/material.dart';
import '../dashboard/pages/dashboard_page.dart';
import '../navigation/bottom_navigation.dart';
import '../search/search_page.dart';
import '../reports/reports_page.dart';
import '../history/history_page.dart';
import '../profile/profile_page.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({Key? key}) : super(key: key);

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    const DashboardPage(),
    const SearchPage(),
    const ReportsPage(),
    const HistoryPage(),
    const ProfilePage(),
  ];

  final List<String> _pageTitles = [
    'Dashboard',
    'Buscar',
    'Relatórios',
    'Histórico',
    'Perfil',
  ];

  void _onNavigationTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
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
                // Sidebar navigation para desktop
                Container(
                  width: 240,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8F9FA),
                    border: Border(
                      right: BorderSide(
                        color: Color(0xFFE2E8F0),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Logo header Benício
                      Container(
                        height: 80,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xFFE2E8F0),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [Color(0xFFFF6B35), Color(0xFFFF8A65)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'B',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'BENÍCIO',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1E293B),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Text(
                                  'ADVOGADOS',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF64748B),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Navigation items
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          itemCount: _pageTitles.length,
                          itemBuilder: (context, index) {
                            bool isActive = _currentIndex == index;
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                              decoration: BoxDecoration(
                                color: isActive ? const Color(0xFF582FFF).withOpacity(0.1) : null,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListTile(
                                title: Text(
                                  _pageTitles[index],
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                                    color: isActive ? const Color(0xFF582FFF) : const Color(0xFF64748B),
                                  ),
                                ),
                                onTap: () => _onNavigationTap(index),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
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
            bottomNavigationBar: YolBottomNavigation(
              currentIndex: _currentIndex,
              onTap: _onNavigationTap,
            ),
          );
        }
      },
    );
  }
}