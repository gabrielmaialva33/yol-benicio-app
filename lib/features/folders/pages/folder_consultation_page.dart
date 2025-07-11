import 'package:benicio/features/folders/widgets/folder_card.dart';
import 'package:benicio/features/history/history_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../features/shared/services/mock_service.dart';
import '../models/folder.dart';

class FolderConsultationPage extends StatefulWidget {
  const FolderConsultationPage({super.key});

  @override
  State<FolderConsultationPage> createState() => _FolderConsultationPageState();
}

class _FolderConsultationPageState extends State<FolderConsultationPage>
    with TickerProviderStateMixin {
  final MockService _mockService = MockService();
  final TextEditingController _searchController = TextEditingController();

  late List<Folder> _allFolders;
  List<Folder> _filteredFolders = [];
  String _selectedFilter = 'Todos';
  String _selectedClient = 'Todos';
  bool _groupByClient = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> _filterOptions = [
    'Todos',
    'Ativos',
    'Concluídos',
    'Pendentes',
    'Arquivados',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _allFolders = _mockService.getFolders(20);
    _filteredFolders = _allFolders;
    _animationController.forward();

    _searchController.addListener(_filterFolders);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterFolders() {
    setState(() {
      _filteredFolders = _allFolders.where((folder) {
        final matchesSearch = _searchController.text.isEmpty ||
            folder.title
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            folder.client.name
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());

        final matchesStatus = _selectedFilter == 'Todos' ||
            (_selectedFilter == 'Ativos' &&
                folder.status == FolderStatus.active) ||
            (_selectedFilter == 'Concluídos' &&
                folder.status == FolderStatus.completed) ||
            (_selectedFilter == 'Pendentes' &&
                folder.status == FolderStatus.pending) ||
            (_selectedFilter == 'Arquivados' &&
                folder.status == FolderStatus.archived);

        final matchesClient =
            _selectedClient == 'Todos' || folder.client.name == _selectedClient;

        return matchesSearch && matchesStatus && matchesClient;
      }).toList();
    });
  }

  List<String> _getUniqueClients() {
    final clients =
        _allFolders.map((folder) => folder.client.name).toSet().toList();
    clients.sort();
    return ['Todos', ...clients];
  }

  Map<String, List<Folder>> _groupFoldersByClient() {
    final grouped = <String, List<Folder>>{};
    for (final folder in _filteredFolders) {
      final clientName = folder.client.name;
      if (!grouped.containsKey(clientName)) {
        grouped[clientName] = [];
      }
      grouped[clientName]!.add(folder);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 900;
          bool isTablet =
              constraints.maxWidth > 600 && constraints.maxWidth <= 900;

          return Column(
            children: [
              _buildFiltersSection(themeProvider, isDesktop, isTablet),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: _groupByClient
                      ? _buildGroupedFoldersList(themeProvider, isDesktop)
                      : _buildFoldersList(themeProvider, isDesktop),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        _showCreateProcessDialog(context);
      },
      icon: const Icon(Icons.add),
      label: const Text('Nova Pasta'),
      backgroundColor: const Color(0xFF3B82F6),
      foregroundColor: Colors.white,
    );
  }

  void _showCreateProcessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Criar Nova Pasta'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Título do Processo',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Cliente',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implementar criação de pasta
            },
            child: const Text('Criar'),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection(
      ThemeProvider themeProvider, bool isDesktop, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : (isTablet ? 20 : 16)),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: themeProvider.themeData.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header com estatísticas rápidas
          if (isDesktop || isTablet) ...[
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gestão de Processos',
                        style: TextStyle(
                          fontSize: isDesktop ? 24 : 20,
                          fontWeight: FontWeight.w700,
                          color: themeProvider
                              .themeData.textTheme.titleLarge?.color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Acompanhe todos os processos e clientes',
                        style: TextStyle(
                          fontSize: isDesktop ? 16 : 14,
                          color: themeProvider
                              .themeData.textTheme.bodyMedium?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildQuickStats(themeProvider, isDesktop),
              ],
            ),
            const SizedBox(height: 20),
          ],

          // Barra de pesquisa
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar por processo, cliente ou número...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _filterFolders();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: themeProvider.isDarkMode
                  ? Colors.white.withOpacity(0.05)
                  : Colors.black.withOpacity(0.03),
            ),
          ),

          SizedBox(height: isDesktop ? 16 : 12),

          // Filtros
          if (isDesktop)
            _buildDesktopFilters(themeProvider)
          else if (isTablet)
            _buildTabletFilters(themeProvider)
          else
            _buildMobileFilters(themeProvider),
        ],
      ),
    );
  }

  Widget _buildQuickStats(ThemeProvider themeProvider, bool isDesktop) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildStatChip('${_filteredFolders.length} resultados',
            themeProvider.primaryColor),
        const SizedBox(width: 12),
        _buildStatChip('${_getUniqueClients().length - 1} clientes',
            themeProvider.successColor),
        if (isDesktop) ...[
          const SizedBox(width: 12),
          _buildStatChip(
              '${_filteredFolders.where((f) => f.status == FolderStatus.active).length} ativos',
              themeProvider.warningColor),
        ],
      ],
    );
  }

  Widget _buildStatChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildTabletFilters(ThemeProvider themeProvider) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildFilterDropdown(
                'Status',
                _selectedFilter,
                _filterOptions,
                (value) => setState(() {
                  _selectedFilter = value!;
                  _filterFolders();
                }),
                themeProvider,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFilterDropdown(
                'Cliente',
                _selectedClient,
                _getUniqueClients(),
                (value) => setState(() {
                  _selectedClient = value!;
                  _filterFolders();
                }),
                themeProvider,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Switch(
                  value: _groupByClient,
                  onChanged: (value) => setState(() => _groupByClient = value),
                  activeColor: themeProvider.primaryColor,
                ),
                const SizedBox(width: 8),
                const Text('Agrupar por cliente'),
              ],
            ),
            _buildQuickStats(themeProvider, false),
          ],
        ),
      ],
    );
  }

  // ...existing code...

  Widget _buildDesktopFilters(ThemeProvider themeProvider) {
    return Row(
      children: [
        // Filtro por status
        Expanded(
          child: _buildFilterDropdown(
            'Status',
            _selectedFilter,
            _filterOptions,
            (value) => setState(() {
              _selectedFilter = value!;
              _filterFolders();
            }),
            themeProvider,
          ),
        ),
        const SizedBox(width: 16),

        // Filtro por cliente
        Expanded(
          child: _buildFilterDropdown(
            'Cliente',
            _selectedClient,
            _getUniqueClients(),
            (value) => setState(() {
              _selectedClient = value!;
              _filterFolders();
            }),
            themeProvider,
          ),
        ),
        const SizedBox(width: 16),

        // Switch para agrupar por cliente
        Row(
          children: [
            Switch(
              value: _groupByClient,
              onChanged: (value) => setState(() => _groupByClient = value),
              activeColor: themeProvider.primaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              'Agrupar por cliente',
              style: TextStyle(
                fontSize: 14,
                color: themeProvider.themeData.textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),

        const SizedBox(width: 16),

        // Contador de resultados
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: themeProvider.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${_filteredFolders.length} resultado(s)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: themeProvider.primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileFilters(ThemeProvider themeProvider) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildFilterDropdown(
                'Status',
                _selectedFilter,
                _filterOptions,
                (value) => setState(() {
                  _selectedFilter = value!;
                  _filterFolders();
                }),
                themeProvider,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFilterDropdown(
                'Cliente',
                _selectedClient,
                _getUniqueClients(),
                (value) => setState(() {
                  _selectedClient = value!;
                  _filterFolders();
                }),
                themeProvider,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Switch(
                  value: _groupByClient,
                  onChanged: (value) => setState(() => _groupByClient = value),
                  activeColor: themeProvider.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Agrupar por cliente',
                  style: TextStyle(
                    fontSize: 14,
                    color: themeProvider.themeData.textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: themeProvider.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${_filteredFolders.length} resultado(s)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: themeProvider.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterDropdown(
    String label,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
    ThemeProvider themeProvider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: themeProvider.themeData.textTheme.bodySmall?.color,
          ),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: value,
          items: options
              .map((option) => DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  ))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: themeProvider.isDarkMode
                ? Colors.white.withOpacity(0.05)
                : Colors.black.withOpacity(0.03),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildFoldersList(ThemeProvider themeProvider, bool isDesktop) {
    if (_filteredFolders.isEmpty) {
      return _buildEmptyState(themeProvider);
    }

    return isDesktop
        ? _buildDesktopFoldersGrid(themeProvider)
        : _buildMobileFoldersList(themeProvider);
  }

  Widget _buildDesktopFoldersGrid(ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemCount: _filteredFolders.length,
        itemBuilder: (context, index) {
          final folder = _filteredFolders[index];
          return FolderCard(
            folder: folder,
            onTap: () => _navigateToFolderDetails(folder),
          );
        },
      ),
    );
  }

  Widget _buildMobileFoldersList(ThemeProvider themeProvider) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredFolders.length,
      itemBuilder: (context, index) {
        final folder = _filteredFolders[index];
        return FolderCard(
          folder: folder,
          onTap: () => _navigateToFolderDetails(folder),
        );
      },
    );
  }

  Widget _buildGroupedFoldersList(ThemeProvider themeProvider, bool isDesktop) {
    final groupedFolders = _groupFoldersByClient();

    if (groupedFolders.isEmpty) {
      return _buildEmptyState(themeProvider);
    }

    return ListView.builder(
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
      itemCount: groupedFolders.keys.length,
      itemBuilder: (context, index) {
        final clientName = groupedFolders.keys.elementAt(index);
        final clientFolders = groupedFolders[clientName]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho do cliente
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: themeProvider.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: themeProvider.primaryColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      clientName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: themeProvider.primaryColor,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: themeProvider.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${clientFolders.length} processo(s)',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Lista de pastas do cliente
            ...clientFolders.map((folder) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: FolderCard(
                    folder: folder,
                    showClientNavigation: false,
                    onTap: () => _navigateToFolderDetails(folder),
                  ),
                )),

            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(ThemeProvider themeProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_off_outlined,
            size: 64,
            color: themeProvider.themeData.textTheme.bodyMedium?.color,
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhuma pasta encontrada',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: themeProvider.themeData.textTheme.titleMedium?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tente ajustar os filtros ou criar uma nova pasta.',
            style: TextStyle(
              color: themeProvider.themeData.textTheme.bodyMedium?.color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _navigateToFolderDetails(Folder folder) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryPage(folder: folder),
      ),
    );
  }
}
