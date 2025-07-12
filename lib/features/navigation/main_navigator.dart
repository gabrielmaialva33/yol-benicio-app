import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/theme_provider.dart';
import '../shared/widgets/quick_theme_toggle.dart';
import '../dashboard/pages/dashboard_page.dart';
import '../navigation/bottom_navigation.dart';
import '../profile/profile_page.dart';
import '../reports/reports_page.dart';
import '../search/search_page.dart';
import '../folders/pages/folder_consultation_page.dart';
import '../history/pages/general_history_page.dart';
import 'widgets/desktop_sidebar.dart';
import '../auth/services/auth_service.dart';

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
    const GeneralHistoryPage(),
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
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            bool isDesktop = constraints.maxWidth > 900;
            bool isTablet =
                constraints.maxWidth > 600 && constraints.maxWidth <= 900;

            if (isDesktop) {
              // Layout desktop com sidebar
              return Scaffold(
                backgroundColor:
                    themeProvider.themeData.scaffoldBackgroundColor,
                appBar: AppBar(
                  backgroundColor:
                      themeProvider.themeData.appBarTheme.backgroundColor,
                  foregroundColor:
                      themeProvider.themeData.appBarTheme.foregroundColor,
                  elevation: 0,
                  title: Row(
                    children: [
                      Text(
                        _pageTitles[_currentIndex],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: themeProvider
                              .themeData.textTheme.titleLarge?.color,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
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
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      onPressed: () {
                        // TODO: Mostrar notificações
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          _currentIndex = 2; // Ir para página de busca
                        });
                      },
                    ),
                    const QuickThemeToggle(),
                    const SizedBox(width: 16),
                  ],
                ),
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
                          child: _pages[_currentIndex],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              // Layout mobile/tablet com bottom navigation
              return Scaffold(
                backgroundColor:
                    themeProvider.themeData.scaffoldBackgroundColor,
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
                              _pageTitles[_currentIndex],
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: themeProvider
                                    .themeData.textTheme.titleLarge?.color,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color:
                                    themeProvider.primaryColor.withOpacity(0.1),
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
                          _pageTitles[_currentIndex],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: themeProvider
                                .themeData.textTheme.titleLarge?.color,
                          ),
                        ),
                        actions: [
                          if (_currentIndex == 4) // Profile page
                            IconButton(
                              icon: const Icon(Icons.logout),
                              onPressed: _handleLogout,
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
      },
    );
  }
}
