import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/theme_provider_simplified.dart';
import '../../core/theme/app_themes_simplified.dart';
import '../shared/services/mock_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final MockService _mockService = MockService();

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String _selectedCategory = 'Todos';
  bool _isSearching = false;
  List<dynamic> _searchResults = [];

  final List<String> _categories = [
    'Todos',
    'Clientes',
    'Processos',
    'Documentos',
    'Contratos',
  ];

  final List<Map<String, dynamic>> _quickSearchItems = [
    {
      'title': 'Clientes',
      'subtitle': '98 totais',
      'icon': Icons.people_outline_rounded,
      'color': AppColors.blue600,
      'count': 98,
    },
    {
      'title': 'Pastas Ativas',
      'subtitle': '45 ativas',
      'icon': Icons.folder_open_rounded,
      'color': AppColors.green600,
      'count': 45,
    },
    {
      'title': 'Processos',
      'subtitle': '67 em andamento',
      'icon': Icons.gavel_rounded,
      'color': AppColors.amber500,
      'count': 67,
    },
    {
      'title': 'Relatórios',
      'subtitle': '12 pendentes',
      'icon': Icons.analytics_outlined,
      'color': AppColors.cyan500,
      'count': 12,
    },
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Simular busca
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isSearching = false;
          _searchResults = _mockService.searchItems(query, _selectedCategory);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
          body: FadeTransition(
            opacity: _fadeAnimation,
            child: CustomScrollView(
              slivers: [
                _buildSliverAppBar(themeProvider),
                SliverToBoxAdapter(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSearchField(themeProvider),
                          const SizedBox(height: 20),
                          _buildCategoryFilter(themeProvider),
                          const SizedBox(height: 24),
                          if (_searchController.text.isEmpty) ...[
                            _buildQuickSearchSection(themeProvider),
                            const SizedBox(height: 24),
                            _buildRecentSearches(themeProvider),
                          ] else if (_isSearching) ...[
                            _buildSearchingIndicator(themeProvider),
                          ] else ...[
                            _buildSearchResults(themeProvider),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSliverAppBar(ThemeProvider themeProvider) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: themeProvider.primaryColor,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: Text(
          'Buscar',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: themeProvider.primaryGradient,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            themeProvider.themeIcon,
            color: Colors.white,
          ),
          onPressed: () => themeProvider.toggleTheme(),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSearchField(ThemeProvider themeProvider) {
    return Container(
      decoration: BoxDecoration(
        color: themeProvider.themeData.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: themeProvider.isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _performSearch,
        style: GoogleFonts.inter(
          fontSize: 16,
          color: themeProvider.themeData.textTheme.bodyLarge?.color,
        ),
        decoration: InputDecoration(
          hintText: 'Buscar clientes, pastas, processos...',
          hintStyle: GoogleFonts.inter(
            fontSize: 16,
            color: themeProvider.themeData.textTheme.bodyMedium?.color,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: themeProvider.primaryColor,
            size: 24,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    color: themeProvider.themeData.textTheme.bodyMedium?.color,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    _performSearch('');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: themeProvider.themeData.cardColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(ThemeProvider themeProvider) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;

          return Container(
            margin:
                EdgeInsets.only(right: index < _categories.length - 1 ? 12 : 0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
                if (_searchController.text.isNotEmpty) {
                  _performSearch(_searchController.text);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  gradient: isSelected ? themeProvider.primaryGradient : null,
                  color: isSelected ? null : themeProvider.themeData.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : themeProvider.isDarkMode
                            ? Colors.white.withOpacity(0.1)
                            : Colors.black.withOpacity(0.1),
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: themeProvider.primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  category,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : themeProvider.themeData.textTheme.bodyLarge?.color,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickSearchSection(ThemeProvider themeProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Buscar por categoria',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: themeProvider.themeData.textTheme.titleLarge?.color,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: _quickSearchItems.length,
          itemBuilder: (context, index) {
            final item = _quickSearchItems[index];
            return _buildQuickSearchCard(item, themeProvider);
          },
        ),
      ],
    );
  }

  Widget _buildQuickSearchCard(
      Map<String, dynamic> item, ThemeProvider themeProvider) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = item['title'];
          _searchController.text = item['title'];
        });
        _performSearch(item['title']);
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: themeProvider.themeData.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: (item['color'] as Color).withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: themeProvider.isDarkMode
                  ? Colors.black.withOpacity(0.2)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 15,
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
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (item['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: item['color'] as Color,
                    size: 24,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (item['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${item['count']}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: item['color'] as Color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              item['title'],
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: themeProvider.themeData.textTheme.titleMedium?.color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item['subtitle'],
              style: GoogleFonts.inter(
                fontSize: 14,
                color: themeProvider.themeData.textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearches(ThemeProvider themeProvider) {
    final recentSearches = [
      'João Silva',
      'Processo 123456',
      'Contrato ABC Corp',
      'Pasta Família Silva',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Buscas recentes',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: themeProvider.themeData.textTheme.titleLarge?.color,
              ),
            ),
            TextButton(
              onPressed: () {
                // Limpar buscas recentes
              },
              child: Text(
                'Limpar',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: themeProvider.primaryColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...recentSearches.map((search) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                tileColor: themeProvider.themeData.cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: Icon(
                  Icons.history_rounded,
                  color: themeProvider.themeData.textTheme.bodyMedium?.color,
                  size: 20,
                ),
                title: Text(
                  search,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: themeProvider.themeData.textTheme.bodyLarge?.color,
                  ),
                ),
                trailing: Icon(
                  Icons.north_west_rounded,
                  color: themeProvider.themeData.textTheme.bodyMedium?.color,
                  size: 16,
                ),
                onTap: () {
                  _searchController.text = search;
                  _performSearch(search);
                },
              ),
            )),
      ],
    );
  }

  Widget _buildSearchingIndicator(ThemeProvider themeProvider) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(themeProvider.primaryColor),
          ),
          const SizedBox(height: 16),
          Text(
            'Buscando...',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: themeProvider.themeData.textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(ThemeProvider themeProvider) {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: themeProvider.themeData.textTheme.bodyMedium?.color,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum resultado encontrado',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: themeProvider.themeData.textTheme.titleMedium?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tente buscar com termos diferentes',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: themeProvider.themeData.textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_searchResults.length} resultado(s) encontrado(s)',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: themeProvider.themeData.textTheme.titleMedium?.color,
          ),
        ),
        const SizedBox(height: 16),
        ..._searchResults.map((result) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                tileColor: themeProvider.themeData.cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: themeProvider.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getResultIcon(result['type']),
                    color: themeProvider.primaryColor,
                    size: 20,
                  ),
                ),
                title: Text(
                  result['title'],
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: themeProvider.themeData.textTheme.titleMedium?.color,
                  ),
                ),
                subtitle: Text(
                  result['subtitle'],
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: themeProvider.themeData.textTheme.bodyMedium?.color,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: themeProvider.themeData.textTheme.bodyMedium?.color,
                ),
                onTap: () {
                  // Navegar para o resultado
                },
              ),
            )),
      ],
    );
  }

  IconData _getResultIcon(String type) {
    switch (type) {
      case 'client':
        return Icons.person_rounded;
      case 'folder':
        return Icons.folder_rounded;
      case 'process':
        return Icons.gavel_rounded;
      case 'document':
        return Icons.description_rounded;
      default:
        return Icons.search_rounded;
    }
  }
}
