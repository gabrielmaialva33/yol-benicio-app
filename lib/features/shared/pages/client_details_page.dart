import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme_provider.dart';
import '../models/client.dart';
import '../../folders/models/folder.dart';
import '../../folders/widgets/folder_card.dart';
import '../services/mock_service.dart';

class ClientDetailsPage extends StatefulWidget {
  final Client client;

  const ClientDetailsPage({
    super.key,
    required this.client,
  });

  @override
  State<ClientDetailsPage> createState() => _ClientDetailsPageState();
}

class _ClientDetailsPageState extends State<ClientDetailsPage>
    with TickerProviderStateMixin {
  final MockService _mockService = MockService();
  late TabController _tabController;
  List<Folder> _clientFolders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadClientFolders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadClientFolders() {
    setState(() {
      _isLoading = true;
    });

    // Simular carregamento das pastas do cliente
    Future.delayed(const Duration(milliseconds: 500), () {
      final List<Folder> allFolders = _mockService.getFolders(50);
      setState(() {
        // Filtrar pastas que pertencem a este cliente
        _clientFolders = allFolders
            .where((folder) => folder.client.id == widget.client.id)
            .toList();
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 900;

          return CustomScrollView(
            slivers: [
              _buildSliverAppBar(themeProvider, isDesktop),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(isDesktop ? 32.0 : 16.0),
                  child: Column(
                    children: [
                      _buildClientHeader(themeProvider, isDesktop),
                      SizedBox(height: isDesktop ? 32 : 24),
                      _buildTabBar(themeProvider),
                      SizedBox(height: isDesktop ? 24 : 16),
                      _buildTabContent(themeProvider, isDesktop),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(ThemeProvider themeProvider, bool isDesktop) {
    return SliverAppBar(
      expandedHeight: isDesktop ? 200 : 150,
      floating: false,
      pinned: true,
      backgroundColor: themeProvider.themeData.cardColor,
      foregroundColor: themeProvider.themeData.textTheme.titleLarge?.color,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.client.name,
          style: TextStyle(
            fontSize: isDesktop ? 24 : 18,
            fontWeight: FontWeight.w700,
            color: themeProvider.themeData.textTheme.titleLarge?.color,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                themeProvider.primaryColor.withOpacity(0.1),
                themeProvider.accentColor.withOpacity(0.05),
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Editar Cliente - Em desenvolvimento'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showClientOptions(context, themeProvider),
        ),
      ],
    );
  }

  Widget _buildClientHeader(ThemeProvider themeProvider, bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 32 : 24),
      decoration: BoxDecoration(
        color: themeProvider.themeData.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: themeProvider.isDarkMode
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isDesktop
          ? _buildDesktopClientInfo(themeProvider)
          : _buildMobileClientInfo(themeProvider),
    );
  }

  Widget _buildDesktopClientInfo(ThemeProvider themeProvider) {
    return Row(
      children: [
        // Avatar e informações principais
        Expanded(
          flex: 2,
          child: Row(
            children: [
              _buildClientAvatar(themeProvider, 80),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.client.formattedDocument,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: themeProvider
                            .themeData.textTheme.titleMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildStatusChip(themeProvider),
                    const SizedBox(height: 16),
                    Text(
                      widget.client.displayContact,
                      style: TextStyle(
                        fontSize: 14,
                        color:
                        themeProvider.themeData.textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Métricas
        Expanded(
          flex: 3,
          child: _buildMetricsGrid(themeProvider, true),
        ),
      ],
    );
  }

  Widget _buildMobileClientInfo(ThemeProvider themeProvider) {
    return Column(
      children: [
        Row(
          children: [
            _buildClientAvatar(themeProvider, 64),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.client.formattedDocument,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color:
                      themeProvider.themeData.textTheme.titleMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildStatusChip(themeProvider),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          widget.client.displayContact,
          style: TextStyle(
            fontSize: 14,
            color: themeProvider.themeData.textTheme.bodyMedium?.color,
          ),
        ),
        const SizedBox(height: 24),
        _buildMetricsGrid(themeProvider, false),
      ],
    );
  }

  Widget _buildClientAvatar(ThemeProvider themeProvider, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: themeProvider.primaryColor.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: themeProvider.primaryColor.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Icon(
        widget.client.isCorporate
            ? Icons.business_rounded
            : Icons.person_rounded,
        size: size * 0.4,
        color: themeProvider.primaryColor,
      ),
    );
  }

  Widget _buildStatusChip(ThemeProvider themeProvider) {
    Color statusColor;
    String statusText;

    switch (widget.client.status) {
      case ClientStatus.active:
        statusColor = themeProvider.successColor;
        statusText = 'Ativo';
        break;
      case ClientStatus.vip:
        statusColor = themeProvider.warningColor;
        statusText = 'VIP';
        break;
      case ClientStatus.inactive:
        statusColor = Colors.grey;
        statusText = 'Inativo';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: statusColor,
        ),
      ),
    );
  }

  Widget _buildMetricsGrid(ThemeProvider themeProvider, bool isDesktop) {
    final metrics = [
      {
        'title': 'Processos Ativos',
        'value': '${widget.client.activeFolders}',
        'icon': Icons.folder_open,
        'color': themeProvider.primaryColor,
      },
      {
        'title': 'Total Faturado',
        'value': 'R\$ ${widget.client.totalBilled.toStringAsFixed(2)}',
        'icon': Icons.attach_money,
        'color': themeProvider.successColor,
      },
      {
        'title': 'Cliente Desde',
        'value': widget.client.clientSince?.year.toString() ?? 'N/A',
        'icon': Icons.calendar_today,
        'color': themeProvider.accentColor,
      },
      {
        'title': 'Total Processos',
        'value': '${widget.client.totalFolders}',
        'icon': Icons.folder,
        'color': themeProvider.warningColor,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isDesktop ? 4 : 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: isDesktop ? 1.2 : 1.5,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) {
        final metric = metrics[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: themeProvider.themeData.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: themeProvider.isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.05),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                metric['icon'] as IconData,
                color: metric['color'] as Color,
                size: 24,
              ),
              const SizedBox(height: 8),
              Flexible(
                child: Text(
                  metric['value'] as String,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: themeProvider.themeData.textTheme.titleLarge?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  metric['title'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: themeProvider.themeData.textTheme.bodySmall?.color,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabBar(ThemeProvider themeProvider) {
    return Container(
      decoration: BoxDecoration(
        color: themeProvider.themeData.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: themeProvider.isDarkMode
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: themeProvider.primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor:
        themeProvider.themeData.textTheme.bodyMedium?.color,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Processos'),
          Tab(text: 'Documentos'),
          Tab(text: 'Histórico'),
        ],
      ),
    );
  }

  Widget _buildTabContent(ThemeProvider themeProvider, bool isDesktop) {
    return SizedBox(
      height: 600,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildProcessesTab(themeProvider, isDesktop),
          _buildDocumentsTab(themeProvider),
          _buildHistoryTab(themeProvider),
        ],
      ),
    );
  }

  Widget _buildProcessesTab(ThemeProvider themeProvider, bool isDesktop) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_clientFolders.isEmpty) {
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
              'Nenhum processo encontrado',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: themeProvider.themeData.textTheme.titleMedium?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Este cliente ainda não possui processos vinculados.',
              style: TextStyle(
                color: themeProvider.themeData.textTheme.bodyMedium?.color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return isDesktop
        ? _buildDesktopFolderGrid(themeProvider)
        : _buildMobileFolderList(themeProvider);
  }

  Widget _buildDesktopFolderGrid(ThemeProvider themeProvider) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: _clientFolders.length,
      itemBuilder: (context, index) {
        final folder = _clientFolders[index];
        return FolderCard(
          folder: folder,
          onTap: () => _navigateToFolderDetails(folder),
        );
      },
    );
  }

  Widget _buildMobileFolderList(ThemeProvider themeProvider) {
    return ListView.builder(
      itemCount: _clientFolders.length,
      itemBuilder: (context, index) {
        final folder = _clientFolders[index];
        return FolderCard(
          folder: folder,
          onTap: () => _navigateToFolderDetails(folder),
        );
      },
    );
  }

  Widget _buildDocumentsTab(ThemeProvider themeProvider) {
    return Center(
      child: Text(
        'Documentos - Em desenvolvimento',
        style: TextStyle(
          color: themeProvider.themeData.textTheme.bodyMedium?.color,
        ),
      ),
    );
  }

  Widget _buildHistoryTab(ThemeProvider themeProvider) {
    return Center(
      child: Text(
        'Histórico - Em desenvolvimento',
        style: TextStyle(
          color: themeProvider.themeData.textTheme.bodyMedium?.color,
        ),
      ),
    );
  }

  void _navigateToFolderDetails(Folder folder) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navegando para ${folder.title}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showClientOptions(BuildContext context, ThemeProvider themeProvider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: themeProvider.themeData.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) =>
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Editar Cliente'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Editar Cliente - Em desenvolvimento'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.add),
                  title: const Text('Novo Processo'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Novo Processo - Em desenvolvimento'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Compartilhar'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Compartilhar - Em desenvolvimento'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
    );
  }
}
