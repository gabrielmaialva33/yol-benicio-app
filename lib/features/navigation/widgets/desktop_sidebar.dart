import 'package:flutter/material.dart';

class DesktopSidebar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onNavigationTap;
  final List<String> pageTitles;
  final bool isCollapsed;
  final VoidCallback onToggle;

  const DesktopSidebar({
    super.key,
    required this.currentIndex,
    required this.onNavigationTap,
    required this.pageTitles,
    required this.isCollapsed,
    required this.onToggle,
  });

  @override
  State<DesktopSidebar> createState() => _DesktopSidebarState();
}

class _DesktopSidebarState extends State<DesktopSidebar> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredPageTitles = [];

  @override
  void initState() {
    super.initState();
    _filteredPageTitles = widget.pageTitles;
    _searchController.addListener(_filterPages);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterPages);
    _searchController.dispose();
    super.dispose();
  }

  void _filterPages() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPageTitles = widget.pageTitles
          .where((title) => title.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: widget.isCollapsed ? 80 : 240,
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA),
        border: Border(
          right: BorderSide(
            color: Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Logo header
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment:
            widget.isCollapsed ? Alignment.center : Alignment.centerLeft,
            child: widget.isCollapsed
                ? IconButton(
              icon: const Icon(Icons.menu),
              onPressed: widget.onToggle,
            )
                : Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF6B35), Color(0xFFFF8A65)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'B',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BENÍCIO',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      'ADVOGADOS',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF64748B),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: widget.onToggle,
                ),
              ],
            ),
          ),
          if (!widget.isCollapsed)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          // Navigation items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: _filteredPageTitles.length,
              itemBuilder: (context, index) {
                final title = _filteredPageTitles[index];
                final originalIndex = widget.pageTitles.indexOf(title);
                bool isActive = widget.currentIndex == originalIndex;
                return Container(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFF582FFF).withOpacity(0.1)
                        : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Tooltip(
                    message: widget.isCollapsed ? title : '',
                    child: ListTile(
                      leading: Icon(
                        _getIconForIndex(originalIndex),
                        color: isActive
                            ? const Color(0xFF582FFF)
                            : const Color(0xFF64748B),
                      ),
                      title: widget.isCollapsed
                          ? null
                          : Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: isActive
                              ? const Color(0xFF582FFF)
                              : const Color(0xFF64748B),
                        ),
                      ),
                      onTap: () => widget.onNavigationTap(originalIndex),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.dashboard_outlined;
      case 1:
        return Icons.folder_outlined;
      case 2:
        return Icons.search;
      case 3:
        return Icons.bar_chart_outlined;
      case 4:
        return Icons.history_outlined;
      case 5:
        return Icons.person_outline;
      default:
        return Icons.circle_outlined;
    }
  }
}
