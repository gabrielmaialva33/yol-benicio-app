import 'package:benicio/features/auth/services/auth_service.dart';
import 'package:benicio/features/dashboard/pages/dashboard_page.dart';
import 'package:benicio/features/folders/pages/folder_consultation_page.dart';
import 'package:benicio/features/navigation/widgets/desktop_layout.dart';
import 'package:benicio/features/navigation/widgets/mobile_layout.dart';
import 'package:benicio/features/profile/profile_page.dart';
import 'package:benicio/features/reports/reports_page.dart';
import 'package:benicio/features/search/search_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

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
    const ProfilePage(),
  ];

  final List<String> _pageTitles = [
    'Dashboard',
    'Pastas',
    'Buscar',
    'Relatórios',
    'Perfil',
  ];

  void _onNavigationTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Logout'),
        content: const Text('Tem certeza que deseja sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final authService = context.read<AuthService>();
              await authService.logout();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            child: const Text('Sair', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
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
        bool isTablet =
            constraints.maxWidth > 600 && constraints.maxWidth <= 900;

        if (isDesktop) {
          return DesktopLayout(
            currentIndex: _currentIndex,
            pageTitles: _pageTitles,
            isSidebarCollapsed: _isSidebarCollapsed,
            onNavigationTap: _onNavigationTap,
            onToggleSidebar: () {
              setState(() {
                _isSidebarCollapsed = !_isSidebarCollapsed;
              });
            },
            page: _pages[_currentIndex],
          );
        } else {
          return MobileLayout(
            currentIndex: _currentIndex,
            pageTitles: _pageTitles,
            pages: _pages,
            pageController: _pageController,
            onNavigationTap: _onNavigationTap,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            onLogout: _handleLogout,
            isTablet: isTablet,
          );
        }
      },
    );
  }
}
