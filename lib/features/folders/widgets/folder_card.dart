import 'package:benicio/features/folders/models/folder.dart';
import 'package:benicio/features/shared/pages/client_details_page.dart';
import 'package:benicio/features/shared/models/client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:benicio/core/theme/theme_provider.dart';

class FolderCard extends StatelessWidget {
  final Folder folder;
  final VoidCallback onTap;
  final bool showClientNavigation;
  final bool isCompactMode;

  const FolderCard({
    super.key,
    required this.folder,
    required this.onTap,
    this.showClientNavigation = true,
    this.isCompactMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth > 1200;
        final bool isTablet =
            constraints.maxWidth > 768 && constraints.maxWidth <= 1200;
        final bool isMobile = constraints.maxWidth <= 768;

        if (isCompactMode || isMobile) {
          return _buildCompactCard(themeProvider, context);
        } else if (isTablet) {
          return _buildTabletCard(themeProvider, context);
        } else {
          return _buildDesktopCard(themeProvider, context);
        }
      },
    );
  }

  Widget _buildCompactCard(ThemeProvider themeProvider, BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: _buildCardDecoration(themeProvider),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildClientSection(themeProvider, context,
                      isCompact: true),
                ),
                _buildStatusBadges(themeProvider, isCompact: true),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              folder.title,
              style: themeProvider.themeData.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildCompactInfo(themeProvider),
                ),
                if (folder.contractValue != null)
                  _buildValueChip(themeProvider),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAreaChip(themeProvider, isCompact: true),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (folder.documentsCount > 0)
                      _buildDocumentsBadge(themeProvider, isCompact: true),
                    if (folder.dueDate != null) ...[
                      const SizedBox(width: 8),
                      _buildDueDateChip(themeProvider, isCompact: true),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletCard(ThemeProvider themeProvider, BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: _buildCardDecoration(themeProvider),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildClientSection(themeProvider, context),
                ),
                _buildStatusBadges(themeProvider),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              folder.title,
              style: themeProvider.themeData.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (folder.description != null) ...[
              const SizedBox(height: 6),
              Text(
                folder.description!,
                style: themeProvider.themeData.textTheme.bodySmall?.copyWith(
                  color: themeProvider.themeData.textTheme.bodySmall?.color
                      ?.withOpacity(0.7),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildProcessInfo(themeProvider),
                ),
                Expanded(
                  flex: 1,
                  child: _buildValueInfo(themeProvider),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAreaChip(themeProvider),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (folder.documentsCount > 0)
                      _buildDocumentsBadge(themeProvider),
                    if (folder.dueDate != null) ...[
                      const SizedBox(width: 12),
                      _buildDueDateChip(themeProvider),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopCard(ThemeProvider themeProvider, BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: _buildCardDecoration(themeProvider),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildClientSection(themeProvider, context,
                      isDesktop: true),
                ),
                _buildStatusBadges(themeProvider, isDesktop: true),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              folder.title,
              style: themeProvider.themeData.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (folder.description != null) ...[
              const SizedBox(height: 8),
              Text(
                folder.description!,
                style: themeProvider.themeData.textTheme.bodySmall?.copyWith(
                  color: themeProvider.themeData.textTheme.bodySmall?.color
                      ?.withOpacity(0.7),
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildProcessInfo(themeProvider, isDesktop: true),
                ),
                Expanded(
                  flex: 1,
                  child: _buildValueInfo(themeProvider, isDesktop: true),
                ),
                Expanded(
                  flex: 1,
                  child: _buildAdditionalInfo(themeProvider, isDesktop: true),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildAreaChip(themeProvider, isDesktop: true),
                    if (folder.processNumber != null) ...[
                      const SizedBox(width: 12),
                      _buildProcessNumberChip(themeProvider),
                    ],
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (folder.documentsCount > 0)
                      _buildDocumentsBadge(themeProvider, isDesktop: true),
                    if (folder.dueDate != null) ...[
                      const SizedBox(width: 12),
                      _buildDueDateChip(themeProvider, isDesktop: true),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildCardDecoration(ThemeProvider themeProvider) {
    return BoxDecoration(
      color: themeProvider.themeData.cardColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: themeProvider.themeData.dividerColor.withOpacity(0.5),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: themeProvider.themeData.shadowColor.withOpacity(0.03),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildClientSection(ThemeProvider themeProvider, BuildContext context,
      {bool isCompact = false, bool isDesktop = false}) {
    return GestureDetector(
      onTap:
      showClientNavigation ? () => _navigateToClientDetails(context) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: showClientNavigation
              ? themeProvider.primaryColor.withOpacity(0.1)
              : themeProvider.themeData.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: showClientNavigation
              ? Border.all(color: themeProvider.primaryColor.withOpacity(0.3))
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: folder.client.type == ClientType.corporate
                  ? themeProvider.successColor.withOpacity(0.2)
                  : themeProvider.primaryColor.withOpacity(0.2),
              child: Text(
                folder.client.type == ClientType.corporate ? 'PJ' : 'PF',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: folder.client.type == ClientType.corporate
                      ? themeProvider.successColor
                      : themeProvider.primaryColor,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '#${folder.client.id} - ${folder.client.name}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: showClientNavigation
                          ? themeProvider.primaryColor
                          : themeProvider
                          .themeData.textTheme.titleMedium?.color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (folder.client.hasMultipleFolders) ...[
                    const SizedBox(height: 2),
                    Text(
                      '${folder.client.totalFolders} processos ativos',
                      style: TextStyle(
                        fontSize: 10,
                        color: themeProvider.warningColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (showClientNavigation) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: themeProvider.primaryColor,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadges(ThemeProvider themeProvider,
      {bool isCompact = false, bool isDesktop = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (folder.priority == FolderPriority.urgent ||
            folder.priority == FolderPriority.high)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: folder.priority == FolderPriority.urgent
                  ? themeProvider.errorColor.withOpacity(0.1)
                  : themeProvider.warningColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              folder.priority == FolderPriority.urgent ? 'URGENTE' : 'ALTA',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: folder.priority == FolderPriority.urgent
                    ? themeProvider.errorColor
                    : themeProvider.warningColor,
              ),
            ),
          ),
        Icon(
          folder.isFavorite ? Icons.star : Icons.star_border,
          size: 18,
          color: folder.isFavorite
              ? themeProvider.warningColor
              : themeProvider.themeData.textTheme.bodySmall?.color
              ?.withOpacity(0.5),
        ),
      ],
    );
  }

  Widget _buildCompactInfo(ThemeProvider themeProvider) {
    return Row(
      children: [
        Icon(Icons.person_outline,
            size: 12,
            color: themeProvider.themeData.textTheme.bodySmall?.color),
        const SizedBox(width: 4),
        Text(
          folder.responsibleLawyer.shortName,
          style: TextStyle(
              fontSize: 11,
              color: themeProvider.themeData.textTheme.bodySmall?.color),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(width: 8),
        Icon(Icons.calendar_today_outlined,
            size: 12,
            color: themeProvider.themeData.textTheme.bodySmall?.color),
        const SizedBox(width: 4),
        Text(
          _formatDate(folder.createdAt),
          style: TextStyle(
              fontSize: 11,
              color: themeProvider.themeData.textTheme.bodySmall?.color),
        ),
      ],
    );
  }

  Widget _buildValueChip(ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: themeProvider.successColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'R\$ ${_formatValue(folder.contractValue!)}',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: themeProvider.successColor,
        ),
      ),
    );
  }

  Widget _buildProcessInfo(ThemeProvider themeProvider,
      {bool isDesktop = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.person_outline,
              size: 14,
              color: themeProvider.themeData.textTheme.bodySmall?.color,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                folder.responsibleLawyer.fullName,
                style: TextStyle(
                  fontSize: 12,
                  color: themeProvider.themeData.textTheme.bodyMedium?.color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 14,
              color: themeProvider.themeData.textTheme.bodySmall?.color,
            ),
            const SizedBox(width: 4),
            Text(
              'Criado ${_formatDate(folder.createdAt)}',
              style: TextStyle(
                fontSize: 12,
                color: themeProvider.themeData.textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildValueInfo(ThemeProvider themeProvider,
      {bool isDesktop = false}) {
    if (folder.contractValue == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment:
      isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(
          'Valor do Contrato',
          style: TextStyle(
            fontSize: 11,
            color: themeProvider.themeData.textTheme.bodySmall?.color,
          ),
        ),
        Text(
          'R\$ ${_formatValue(folder.contractValue!)}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: themeProvider.successColor,
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo(ThemeProvider themeProvider,
      {bool isDesktop = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Última Atualização',
          style: TextStyle(
            fontSize: 11,
            color: themeProvider.themeData.textTheme.bodySmall?.color,
          ),
        ),
        Text(
          _formatDate(folder.updatedAt ?? folder.createdAt),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: themeProvider.themeData.textTheme.bodyMedium?.color,
          ),
        ),
      ],
    );
  }

  Widget _buildProcessNumberChip(ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: themeProvider.themeData.dividerColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Proc. ${folder.processNumber}',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: themeProvider.themeData.textTheme.bodySmall?.color,
        ),
      ),
    );
  }

  Widget _buildAreaChip(ThemeProvider themeProvider,
      {bool isCompact = false, bool isDesktop = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getAreaColor(folder.area).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getAreaColor(folder.area).withOpacity(0.3),
        ),
      ),
      child: Text(
        folder.area.displayName,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _getAreaColor(folder.area),
        ),
      ),
    );
  }

  Widget _buildDocumentsBadge(ThemeProvider themeProvider,
      {bool isCompact = false, bool isDesktop = false}) {
    return Row(
      children: [
        Icon(Icons.attach_file,
            size: 12,
            color: themeProvider.themeData.textTheme.bodySmall?.color),
        const SizedBox(width: 4),
        Text(
          '${folder.documentsCount}',
          style: TextStyle(
              fontSize: 11,
              color: themeProvider.themeData.textTheme.bodySmall?.color),
        ),
      ],
    );
  }

  Widget _buildDueDateChip(ThemeProvider themeProvider,
      {bool isCompact = false, bool isDesktop = false}) {
    final now = DateTime.now();
    final daysUntilDue = folder.dueDate!.difference(now).inDays;

    Color color;
    String text;

    if (daysUntilDue < 0) {
      color = themeProvider.errorColor;
      text = '${-daysUntilDue}d atrasado';
    } else if (daysUntilDue == 0) {
      color = themeProvider.warningColor;
      text = 'Vence hoje';
    } else if (daysUntilDue <= 7) {
      color = themeProvider.warningColor;
      text = '${daysUntilDue}d restantes';
    } else {
      color = themeProvider.successColor;
      text = '${daysUntilDue}d restantes';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Color _getAreaColor(FolderArea area) {
    switch (area) {
      case FolderArea.civilLitigation:
        return const Color(0xFF3B82F6);
      case FolderArea.labor:
        return const Color(0xFF10B981);
      case FolderArea.tax:
        return const Color(0xFFF59E0B);
      case FolderArea.criminal:
        return const Color(0xFFEF4444);
      case FolderArea.family:
        return const Color(0xFF8B5CF6);
      case FolderArea.corporate:
        return const Color(0xFF06B6D4);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now
        .difference(date)
        .inDays;

    if (difference == 0) return 'hoje';
    if (difference == 1) return 'ontem';
    if (difference < 7) return 'há $difference dias';
    if (difference < 30) return 'há ${(difference / 7).round()} semanas';
    if (difference < 365) return 'há ${(difference / 30).round()} meses';
    return 'há ${(difference / 365).round()} anos';
  }

  String _formatValue(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toStringAsFixed(0);
  }

  void _navigateToClientDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClientDetailsPage(client: folder.client),
      ),
    );
  }
}
