import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:benicio/core/theme/theme_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class GeneralHistoryPage extends StatefulWidget {
  const GeneralHistoryPage({super.key});

  @override
  State<GeneralHistoryPage> createState() => _GeneralHistoryPageState();
}

class _GeneralHistoryPageState extends State<GeneralHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  String _selectedFilter = 'Todos';
  bool _isLoading = false;

  final List<String> _filterOptions = [
    'Todos',
    'Faturamento',
    'Audiências',
    'Prazos',
    'Documentos',
    'Movimentações',
  ];

  final List<Map<String, dynamic>> _mockActivities = [
    {
      'type': 'billing',
      'title': 'Faturamento realizado com sucesso',
      'description':
          'Valor de R\$ 3.500,00 referente aos honorários do processo #2024-1234',
      'user': 'Dra. Ana Rodrigues',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'icon': FontAwesomeIcons.dollarSign,
      'color': const Color(0xFF10B981),
      'folder': 'Defesa Criminal - João Silva',
      'status': 'proceed',
    },
    {
      'type': 'document',
      'title': 'Acórdão Apelação #7979207',
      'description': 'Jud 2ª Instância (SP) - Recursal',
      'user': 'Dr. Carlos Mendes',
      'date': DateTime.now().subtract(const Duration(hours: 5)),
      'icon': FontAwesomeIcons.fileContract,
      'color': const Color(0xFF3B82F6),
      'folder': 'Cível - Maria Santos',
      'status': 'view',
    },
    {
      'type': 'bonus',
      'title': 'Bônus por improcedência #7966690',
      'description': 'Solicitado encerramento - Execução Definitiva',
      'user': 'Dr. Carlos Mendes',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'icon': FontAwesomeIcons.gift,
      'color': const Color(0xFFF59E0B),
      'folder': 'Trabalhista - Empresa XYZ',
      'status': 'view',
    },
    {
      'type': 'files',
      'title': '2 novos arquivos vinculados ao processo',
      'description': 'Petição inicial e documentos anexos',
      'user': 'Dra. Mariana Silva',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'icon': FontAwesomeIcons.paperclip,
      'color': const Color(0xFF6366F1),
      'folder': 'Tributário - ABC Ltda',
      'attachments': 2,
    },
    {
      'type': 'hearing',
      'title': 'Audiência de Conciliação agendada',
      'description': 'Data: 15/12/2024 às 14:00 - Fórum Central',
      'user': 'Dr. Pedro Oliveira',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'icon': FontAwesomeIcons.calendar,
      'color': const Color(0xFFEC4899),
      'folder': 'Família - Divórcio Consensual',
    },
    {
      'type': 'deadline',
      'title': 'Prazo processual próximo do vencimento',
      'description': 'Contestação deve ser protocolada até 20/12/2024',
      'user': 'Sistema',
      'date': DateTime.now().subtract(const Duration(days: 4)),
      'icon': FontAwesomeIcons.clock,
      'color': const Color(0xFFEF4444),
      'folder': 'Criminal - Defesa João Costa',
      'priority': 'high',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadActivities();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadActivities() async {
    setState(() => _isLoading = true);
    // Simular carregamento
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  List<Map<String, dynamic>> get _filteredActivities {
    if (_selectedFilter == 'Todos') return _mockActivities;

    final filterMap = {
      'Faturamento': 'billing',
      'Audiências': 'hearing',
      'Prazos': 'deadline',
      'Documentos': 'document',
      'Movimentações': 'movement',
    };

    final type = filterMap[_selectedFilter];
    return _mockActivities.where((a) => a['type'] == type).toList();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              backgroundColor: themeProvider.primaryColor,
              elevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Histórico',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Todas as atividades recentes',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: themeProvider.primaryGradient,
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -50,
                        top: -50,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                      Positioned(
                        left: -30,
                        bottom: -30,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.05),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: themeProvider.primaryColor,
                    indicatorWeight: 3,
                    labelColor: themeProvider.primaryColor,
                    unselectedLabelColor: const Color(0xFF64748B),
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    tabs: const [
                      Tab(text: 'Tudo'),
                      Tab(text: 'Hoje'),
                      Tab(text: 'Esta Semana'),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildActivityList(context, themeProvider),
            _buildActivityList(context, themeProvider, filterToday: true),
            _buildActivityList(context, themeProvider, filterWeek: true),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityList(BuildContext context, ThemeProvider themeProvider,
      {bool filterToday = false, bool filterWeek = false}) {
    List<Map<String, dynamic>> activities = _filteredActivities;

    if (filterToday) {
      final today = DateTime.now();
      activities = activities.where((a) {
        final date = a['date'] as DateTime;
        return date.year == today.year &&
            date.month == today.month &&
            date.day == today.day;
      }).toList();
    } else if (filterWeek) {
      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 7));
      activities = activities.where((a) {
        final date = a['date'] as DateTime;
        return date.isAfter(weekAgo);
      }).toList();
    }

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (activities.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.clipboardList,
              size: 64,
              color: themeProvider.themeData.textTheme.bodyMedium?.color
                  ?.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhuma atividade encontrada',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: themeProvider.themeData.textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'As atividades aparecerão aqui quando houver movimentações',
              style: TextStyle(
                fontSize: 14,
                color: themeProvider.themeData.textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadActivities,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filtros
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filterOptions.length,
                      itemBuilder: (context, index) {
                        final filter = _filterOptions[index];
                        final isSelected = _selectedFilter == filter;

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(filter),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedFilter = selected ? filter : 'Todos';
                              });
                            },
                            backgroundColor: isSelected
                                ? themeProvider.primaryColor
                                : const Color(0xFFF1F5F9),
                            selectedColor: themeProvider.primaryColor,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: isSelected
                                    ? themeProvider.primaryColor
                                    : Colors.transparent,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Título da seção
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Atividades Recentes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: themeProvider
                              .themeData.textTheme.titleMedium?.color,
                        ),
                      ),
                      Text(
                        '${activities.length} atividades',
                        style: TextStyle(
                          fontSize: 14,
                          color: themeProvider
                              .themeData.textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final activity = activities[index];
                  return _buildActivityCard(activity, themeProvider);
                },
                childCount: activities.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(
      Map<String, dynamic> activity, ThemeProvider themeProvider) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');
    final date = activity['date'] as DateTime;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeProvider.themeData.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: themeProvider.isDarkMode
              ? Colors.white.withOpacity(0.1)
              : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: themeProvider.isDarkMode
                ? Colors.black.withOpacity(0.2)
                : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (activity['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  activity['icon'] as IconData,
                  color: activity['color'] as Color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity['title'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: themeProvider
                            .themeData.textTheme.titleMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Adicionado por ',
                          style: TextStyle(
                            fontSize: 12,
                            color: themeProvider
                                .themeData.textTheme.bodySmall?.color,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: themeProvider.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            activity['user'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: themeProvider.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    dateFormat.format(date),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: themeProvider.themeData.textTheme.bodySmall?.color,
                    ),
                  ),
                  Text(
                    timeFormat.format(date),
                    style: TextStyle(
                      fontSize: 10,
                      color: themeProvider.themeData.textTheme.bodySmall?.color
                          ?.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),

          if (activity['description'] != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: themeProvider.isDarkMode
                    ? Colors.white.withOpacity(0.05)
                    : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                activity['description'],
                style: TextStyle(
                  fontSize: 14,
                  color: themeProvider.themeData.textTheme.bodyMedium?.color,
                ),
              ),
            ),
          ],

          const SizedBox(height: 12),

          // Pasta relacionada
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: themeProvider.isDarkMode
                  ? Colors.white.withOpacity(0.05)
                  : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  FontAwesomeIcons.folder,
                  size: 12,
                  color: themeProvider.themeData.textTheme.bodySmall?.color,
                ),
                const SizedBox(width: 6),
                Text(
                  activity['folder'],
                  style: TextStyle(
                    fontSize: 12,
                    color: themeProvider.themeData.textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),

          if (activity['attachments'] != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    FontAwesomeIcons.paperclip,
                    size: 12,
                    color: Color(0xFF6366F1),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${activity['attachments']} novos arquivos vinculados ao processo',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (activity['status'] != null || activity['priority'] != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                if (activity['priority'] == 'high')
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: const Color(0xFFEF4444).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.triangleExclamation,
                          size: 10,
                          color: Color(0xFFEF4444),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Alta Prioridade',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFEF4444),
                          ),
                        ),
                      ],
                    ),
                  ),
                const Spacer(),
                if (activity['status'] == 'proceed')
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Proceed',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  )
                else if (activity['status'] == 'view')
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: themeProvider.primaryColor,
                      side: BorderSide(color: themeProvider.primaryColor),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Visualizar',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
