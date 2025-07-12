import 'package:benicio/features/history/widgets/billed_card.dart';
import 'package:benicio/features/history/widgets/bonus_card.dart';
import 'package:benicio/features/history/widgets/history_card.dart';
import 'package:benicio/features/history/widgets/judgment_card.dart';
import 'package:benicio/features/history/widgets/new_files_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:benicio/core/theme/theme_provider.dart';
import 'package:benicio/features/folders/models/folder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HistoryPage extends StatefulWidget {
  final Folder folder;

  const HistoryPage({super.key, required this.folder});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getAreaColor() {
    switch (widget.folder.area) {
      case FolderArea.criminal:
        return const Color(0xFFEF4444);
      case FolderArea.civilLitigation:
        return const Color(0xFF3B82F6);
      case FolderArea.labor:
        return const Color(0xFFF59E0B);
      case FolderArea.tax:
        return const Color(0xFF10B981);
      case FolderArea.family:
        return const Color(0xFFEC4899);
      case FolderArea.corporate:
        return const Color(0xFF6366F1);
      default:
        return const Color(0xFF64748B);
    }
  }

  String _getAreaName() {
    return widget.folder.area.displayName;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final areaColor = _getAreaColor();

    return Scaffold(
      backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // Header com gradiente
          SliverAppBar(
            expandedHeight: 240,
            floating: false,
            pinned: true,
            backgroundColor: areaColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {
                  // TODO: Mostrar opções
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(
                  left: 20, bottom: 16, right: 20),
              title: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 60),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12,
                              vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _getAreaName(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Flexible(
                        child: Text(
                          'Histórico - ${widget.folder.title}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      areaColor,
                      areaColor.withOpacity(0.8),
                    ],
                  ),
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
          ),

          // Informações do processo
          SliverToBoxAdapter(
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                margin: const EdgeInsets.all(20),
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
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: areaColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            FontAwesomeIcons.folderOpen,
                            color: areaColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Processo #${widget.folder.processNumber ??
                                    widget.folder.code}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: themeProvider.themeData.textTheme
                                      .bodySmall?.color,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.folder.client.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: themeProvider.themeData.textTheme
                                      .titleMedium?.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getStatusColor(widget.folder.status)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _getStatusColor(widget.folder.status)
                                  .withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            widget.folder.status.displayName,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _getStatusColor(widget.folder.status),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _buildInfoChip(
                          icon: FontAwesomeIcons.user,
                          label: widget.folder.responsibleLawyer.fullName,
                          color: themeProvider.primaryColor,
                        ),
                        const SizedBox(width: 12),
                        _buildInfoChip(
                          icon: FontAwesomeIcons.fileAlt,
                          label: '${widget.folder.documentsCount} docs',
                          color: const Color(0xFF6366F1),
                        ),
                        const SizedBox(width: 12),
                        if (widget.folder.contractValue != null)
                          _buildInfoChip(
                            icon: FontAwesomeIcons.dollarSign,
                            label: 'R\$ ${widget.folder.contractValue!
                                .toStringAsFixed(2)}',
                            color: const Color(0xFF10B981),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Título da seção
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Atividades Recentes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: themeProvider.themeData.textTheme.titleMedium
                          ?.color,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      // TODO: Filtrar atividades
                    },
                    icon: const Icon(FontAwesomeIcons.filter, size: 14),
                    label: const Text('Filtrar'),
                    style: TextButton.styleFrom(
                      foregroundColor: themeProvider.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),

          // Lista de atividades
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                HistoryCard(
                  title: 'Faturamento realizado com sucesso',
                  subtitle: '',
                  date: '29/11/2024',
                  user: 'Dra. Ana Rodrigues',
                  content: const BilledCard(),
                  delay: 0,
                ),
                HistoryCard(
                  title: 'Acórdão Apelação #7979207',
                  subtitle: '',
                  date: '29/11/2024',
                  user: 'Dr. Carlos Mendes',
                  content: const JudgmentCard(),
                  delay: 100,
                ),
                HistoryCard(
                  title: 'Bônus por improcedência #7966690',
                  subtitle: '',
                  date: '29/11/2024',
                  user: 'Dr. Carlos Mendes',
                  content: const BonusCard(),
                  delay: 200,
                ),
                HistoryCard(
                  title: '2 novos arquivos vinculados ao processo',
                  subtitle: '',
                  date: '29/11/2024',
                  user: 'Dra. Mariana Silva',
                  content: const NewFilesCard(),
                  delay: 300,
                ),
                HistoryCard(
                  title: 'Audiência de conciliação agendada',
                  subtitle: 'Fórum Central - Sala 12',
                  date: '28/11/2024',
                  user: 'Dr. Pedro Oliveira',
                  content: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEC4899).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.calendar,
                          color: Color(0xFFEC4899),
                          size: 20,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Data: 15/12/2024 às 14:00',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Local: Fórum Central - Sala 12',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  delay: 400,
                ),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Adicionar nova atividade
        },
        backgroundColor: areaColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
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
        return const Color(0xFF64748B);
      case FolderStatus.suspended:
        return const Color(0xFF8B5CF6);
    }
  }
}