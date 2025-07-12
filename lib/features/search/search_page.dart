import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/theme_provider.dart';
import '../shared/services/mock_data_service.dart';
import '../folders/models/folder.dart';
import '../shared/models/client.dart';
import '../dashboard/models/task.dart';
import '../history/history_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  final _mockService = MockDataService();
  late TabController _tabController;
  
  List<dynamic> _searchResults = [];
  List<Folder> _folderResults = [];
  List<Client> _clientResults = [];
  List<Task> _taskResults = [];
  bool _isSearching = false;
  final String _searchType = 'all'; // all, folders, clients, tasks
  
  // Search history
  final List<String> _searchHistory = [];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_searchController.text.isNotEmpty) {
        _performSearch(_searchController.text);
      }
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }
  
  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _folderResults = [];
        _clientResults = [];
        _taskResults = [];
      });
      return;
    }
    
    setState(() => _isSearching = true);
    
    // Add to search history
    if (!_searchHistory.contains(query)) {
      _searchHistory.insert(0, query);
      if (_searchHistory.length > 10) {
        _searchHistory.removeLast();
      }
    }
    
    // Simulate search delay
    Future.delayed(const Duration(milliseconds: 300), () {
      final results = _mockService.search(query);
      
      setState(() {
        _searchResults = results;
        _folderResults = results.whereType<Folder>().toList();
        _clientResults = results.whereType<Client>().toList();
        _taskResults = results.whereType<Task>().toList();
        _isSearching = false;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Search header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: themeProvider.themeData.cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Busca Avançada',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: themeProvider.themeData.textTheme.titleLarge?.color,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Search field
                TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Buscar processos, clientes, tarefas...',
                    prefixIcon: const Icon(Icons.search, size: 24),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _performSearch('');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: themeProvider.isDarkMode
                        ? Colors.white.withOpacity(0.05)
                        : Colors.grey.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: _performSearch,
                ),
                
                // Search suggestions
                if (_searchHistory.isNotEmpty && _searchController.text.isEmpty) ...[
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text(
                          'Recentes: ',
                          style: TextStyle(
                            color: themeProvider.themeData.textTheme.bodySmall?.color,
                            fontSize: 14,
                          ),
                        ),
                        ..._searchHistory.take(5).map((query) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: ActionChip(
                              label: Text(query),
                              onPressed: () {
                                _searchController.text = query;
                                _performSearch(query);
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Tabs
          if (_searchController.text.isNotEmpty) ...[
            Container(
              color: themeProvider.themeData.cardColor,
              child: TabBar(
                controller: _tabController,
                labelColor: themeProvider.primaryColor,
                unselectedLabelColor: themeProvider.themeData.textTheme.bodyMedium?.color,
                indicatorColor: themeProvider.primaryColor,
                tabs: [
                  Tab(
                    text: 'Todos (${_searchResults.length})',
                  ),
                  Tab(
                    text: 'Processos (${_folderResults.length})',
                  ),
                  Tab(
                    text: 'Clientes (${_clientResults.length})',
                  ),
                  Tab(
                    text: 'Tarefas (${_taskResults.length})',
                  ),
                ],
              ),
            ),
          ],
          
          // Results
          Expanded(
            child: _buildSearchResults(themeProvider),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSearchResults(ThemeProvider themeProvider) {
    if (_searchController.text.isEmpty) {
      return _buildEmptyState(themeProvider);
    }
    
    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_searchResults.isEmpty) {
      return _buildNoResultsState(themeProvider);
    }
    
    return TabBarView(
      controller: _tabController,
      children: [
        // All results
        _buildAllResults(themeProvider),
        
        // Folder results
        _buildFolderResults(themeProvider),
        
        // Client results
        _buildClientResults(themeProvider),
        
        // Task results
        _buildTaskResults(themeProvider),
      ],
    );
  }
  
  Widget _buildEmptyState(ThemeProvider themeProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 80,
            color: themeProvider.themeData.textTheme.bodyMedium?.color?.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          Text(
            'Comece a digitar para buscar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: themeProvider.themeData.textTheme.titleMedium?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Busque por processos, clientes, tarefas e mais',
            style: TextStyle(
              color: themeProvider.themeData.textTheme.bodyMedium?.color,
            ),
          ),
          
          // Quick search suggestions
          const SizedBox(height: 40),
          Text(
            'Sugestões de busca:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: themeProvider.themeData.textTheme.bodyMedium?.color,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildSuggestionChip('Processos ativos', themeProvider),
              _buildSuggestionChip('Clientes VIP', themeProvider),
              _buildSuggestionChip('Tarefas urgentes', themeProvider),
              _buildSuggestionChip('Audiências hoje', themeProvider),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildSuggestionChip(String label, ThemeProvider themeProvider) {
    return ActionChip(
      label: Text(label),
      backgroundColor: themeProvider.primaryColor.withOpacity(0.1),
      onPressed: () {
        _searchController.text = label;
        _performSearch(label);
      },
    );
  }
  
  Widget _buildNoResultsState(ThemeProvider themeProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: themeProvider.themeData.textTheme.bodyMedium?.color?.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          Text(
            'Nenhum resultado encontrado',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: themeProvider.themeData.textTheme.titleMedium?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tente buscar com outros termos',
            style: TextStyle(
              color: themeProvider.themeData.textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAllResults(ThemeProvider themeProvider) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (_folderResults.isNotEmpty) ...[
          _buildSectionHeader('Processos', Icons.folder_outlined, themeProvider),
          ..._folderResults.take(3).map((folder) => _buildFolderItem(folder, themeProvider)),
          if (_folderResults.length > 3)
            TextButton(
              onPressed: () => _tabController.animateTo(1),
              child: Text('Ver todos os ${_folderResults.length} processos'),
            ),
          const SizedBox(height: 24),
        ],
        
        if (_clientResults.isNotEmpty) ...[
          _buildSectionHeader('Clientes', Icons.person_outline, themeProvider),
          ..._clientResults.take(3).map((client) => _buildClientItem(client, themeProvider)),
          if (_clientResults.length > 3)
            TextButton(
              onPressed: () => _tabController.animateTo(2),
              child: Text('Ver todos os ${_clientResults.length} clientes'),
            ),
          const SizedBox(height: 24),
        ],
        
        if (_taskResults.isNotEmpty) ...[
          _buildSectionHeader('Tarefas', Icons.task_alt, themeProvider),
          ..._taskResults.take(3).map((task) => _buildTaskItem(task, themeProvider)),
          if (_taskResults.length > 3)
            TextButton(
              onPressed: () => _tabController.animateTo(3),
              child: Text('Ver todas as ${_taskResults.length} tarefas'),
            ),
        ],
      ],
    );
  }
  
  Widget _buildSectionHeader(String title, IconData icon, ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: themeProvider.primaryColor),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: themeProvider.themeData.textTheme.titleMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFolderResults(ThemeProvider themeProvider) {
    if (_folderResults.isEmpty) {
      return _buildNoResultsState(themeProvider);
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _folderResults.length,
      itemBuilder: (context, index) {
        return _buildFolderItem(_folderResults[index], themeProvider);
      },
    );
  }
  
  Widget _buildClientResults(ThemeProvider themeProvider) {
    if (_clientResults.isEmpty) {
      return _buildNoResultsState(themeProvider);
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _clientResults.length,
      itemBuilder: (context, index) {
        return _buildClientItem(_clientResults[index], themeProvider);
      },
    );
  }
  
  Widget _buildTaskResults(ThemeProvider themeProvider) {
    if (_taskResults.isEmpty) {
      return _buildNoResultsState(themeProvider);
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _taskResults.length,
      itemBuilder: (context, index) {
        return _buildTaskItem(_taskResults[index], themeProvider);
      },
    );
  }
  
  Widget _buildFolderItem(Folder folder, ThemeProvider themeProvider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getStatusColor(folder.status).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.folder,
            color: _getStatusColor(folder.status),
          ),
        ),
        title: Text(
          folder.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${folder.code} • ${folder.client.name}'),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getStatusColor(folder.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    folder.status.displayName,
                    style: TextStyle(
                      fontSize: 11,
                      color: _getStatusColor(folder.status),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  folder.area.displayName,
                  style: TextStyle(
                    fontSize: 12,
                    color: themeProvider.themeData.textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 16),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HistoryPage(folder: folder),
              ),
            );
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HistoryPage(folder: folder),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildClientItem(Client client, ThemeProvider themeProvider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: client.type == ClientType.corporate
              ? Colors.blue.withOpacity(0.1)
              : Colors.green.withOpacity(0.1),
          child: Text(
            client.type == ClientType.corporate ? 'PJ' : 'PF',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: client.type == ClientType.corporate ? Colors.blue : Colors.green,
            ),
          ),
        ),
        title: Text(
          client.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(client.formattedDocument),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.folder_outlined,
                  size: 14,
                  color: themeProvider.themeData.textTheme.bodySmall?.color,
                ),
                const SizedBox(width: 4),
                Text(
                  '${client.activeFolders} processos ativos',
                  style: TextStyle(
                    fontSize: 12,
                    color: themeProvider.themeData.textTheme.bodySmall?.color,
                  ),
                ),
                if (client.status == ClientStatus.vip) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'VIP',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.amber,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 16),
          onPressed: () {
            // TODO: Navigate to client details
          },
        ),
      ),
    );
  }
  
  Widget _buildTaskItem(Task task, ThemeProvider themeProvider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: task.priority.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.task_alt,
            color: task.priority.color,
          ),
        ),
        title: Text(
          task.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.assignedTo.name),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: task.status.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    task.status.displayName,
                    style: TextStyle(
                      fontSize: 11,
                      color: task.status.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.schedule,
                  size: 14,
                  color: task.isOverdue ? Colors.red : themeProvider.themeData.textTheme.bodySmall?.color,
                ),
                const SizedBox(width: 4),
                Text(
                  task.dueDateDisplay,
                  style: TextStyle(
                    fontSize: 12,
                    color: task.isOverdue ? Colors.red : themeProvider.themeData.textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Checkbox(
          value: task.isCompleted,
          onChanged: (value) {
            _mockService.updateTask(task.id, {
              'status': value! ? TaskStatus.completed : TaskStatus.pending,
            });
            _performSearch(_searchController.text);
          },
        ),
      ),
    );
  }
  
  Color _getStatusColor(FolderStatus status) {
    switch (status) {
      case FolderStatus.active:
        return const Color(0xFF3B82F6);
      case FolderStatus.completed:
        return const Color(0xFF10B981);
      case FolderStatus.pending:
        return const Color(0xFFF59E0B);
      case FolderStatus.cancelled:
        return const Color(0xFFEF4444);
      case FolderStatus.archived:
        return const Color(0xFF6B7280);
      case FolderStatus.suspended:
        return const Color(0xFF8B5CF6);
    }
  }
}
