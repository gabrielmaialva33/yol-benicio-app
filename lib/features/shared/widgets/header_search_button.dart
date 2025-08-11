import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeaderSearchButton extends StatelessWidget {
  final VoidCallback? onTap;

  const HeaderSearchButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
        _showSearchOverlay(context);
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/search_icon.svg',
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(
              Color(0xFF64748B),
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }

  void _showSearchOverlay(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Search',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SearchOverlay();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: child,
        );
      },
    );
  }
}

class SearchOverlay extends StatefulWidget {
  const SearchOverlay({super.key});

  @override
  State<SearchOverlay> createState() => _SearchOverlayState();
}

class _SearchOverlayState extends State<SearchOverlay> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Simular busca
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _searchResults = _performSearch(query);
          _isSearching = false;
        });
      }
    });
  }

  List<Map<String, dynamic>> _performSearch(String query) {
    // Dados mockados para demonstração
    final allData = [
      {
        'type': 'process',
        'title': 'Processo Silva vs. Estado',
        'subtitle': 'ABC-2024-001 • Maria Silva',
        'icon': Icons.folder,
        'color': const Color(0xFF3B82F6),
      },
      {
        'type': 'client',
        'title': 'João Santos Silva',
        'subtitle': 'Pessoa Física • Cliente ativo',
        'icon': Icons.person,
        'color': const Color(0xFF10B981),
      },
      {
        'type': 'hearing',
        'title': 'Audiência Preliminar',
        'subtitle': '15/07/2025 às 14:00 • Fórum Central',
        'icon': Icons.gavel,
        'color': const Color(0xFFF59E0B),
      },
      {
        'type': 'task',
        'title': 'Revisar contrato de locação',
        'subtitle': 'Vence em 3 dias • Prioridade alta',
        'icon': Icons.task,
        'color': const Color(0xFFEF4444),
      },
      {
        'type': 'process',
        'title': 'Ação Trabalhista - Ana Costa',
        'subtitle': 'DEF-2024-002 • Ana Costa',
        'icon': Icons.folder,
        'color': const Color(0xFF3B82F6),
      },
      {
        'type': 'client',
        'title': 'Empresa XYZ Ltda',
        'subtitle': 'Pessoa Jurídica • Cliente ativo',
        'icon': Icons.business,
        'color': const Color(0xFF10B981),
      },
    ];

    return allData
        .where((item) =>
            (item['title'] as String).toLowerCase().contains(query.toLowerCase()) ||
            (item['subtitle'] as String).toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            // Header de busca
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.search,
                    color: Color(0xFF64748B),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      decoration: const InputDecoration(
                        hintText: 'Buscar processos, clientes, audiências...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 16,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                      },
                      child: const Icon(
                        Icons.clear,
                        color: Color(0xFF64748B),
                        size: 20,
                      ),
                    ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                        color: Color(0xFF3B82F6),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Resultados da busca
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: _buildSearchContent(),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchContent() {
    if (_searchController.text.isEmpty) {
      return _buildSearchSuggestions();
    }

    if (_isSearching) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_searchResults.isEmpty) {
      return _buildEmptyResults();
    }

    return _buildSearchResults();
  }

  Widget _buildSearchSuggestions() {
    final suggestions = [
      {
        'title': 'Processos pendentes',
        'icon': Icons.folder_outlined,
        'color': const Color(0xFF3B82F6),
      },
      {
        'title': 'Clientes ativos',
        'icon': Icons.people_outlined,
        'color': const Color(0xFF10B981),
      },
      {
        'title': 'Audiências hoje',
        'icon': Icons.today_outlined,
        'color': const Color(0xFFF59E0B),
      },
      {
        'title': 'Tarefas em atraso',
        'icon': Icons.schedule_outlined,
        'color': const Color(0xFFEF4444),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Buscar por',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];
              return ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: (suggestion['color']! as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    suggestion['icon'] as IconData,
                    color: suggestion['color'] as Color,
                    size: 20,
                  ),
                ),
                title: Text(
                  suggestion['title'] as String,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
                  ),
                ),
                trailing: const Icon(
                  Icons.north_west,
                  size: 16,
                  color: Color(0xFF9CA3AF),
                ),
                onTap: () {
                  _searchController.text = suggestion['title'] as String;
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyResults() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Color(0xFF9CA3AF),
            ),
            SizedBox(height: 16),
            Text(
              'Nenhum resultado encontrado',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tente buscar por outros termos',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        return ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (result['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              result['icon'] as IconData,
              color: result['color'] as Color,
              size: 20,
            ),
          ),
          title: Text(
            result['title'] as String,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          subtitle: Text(
            result['subtitle'] as String,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Color(0xFF9CA3AF),
          ),
          onTap: () {
            Navigator.pop(context);
            // Navegar para o resultado
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Navegando para: ${result['title'] as String}'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        );
      },
    );
  }
}
