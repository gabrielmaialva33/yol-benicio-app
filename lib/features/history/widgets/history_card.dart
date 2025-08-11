import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:benicio/core/theme/theme_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HistoryCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String date;
  final String user;
  final Widget? content;
  final int delay;

  const HistoryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.user,
    this.content,
    this.delay = 0,
  });

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard>
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
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    // Delay the animation based on the delay parameter
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: themeProvider.themeData.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: themeProvider.isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : const Color(0xFFE2E8F0),
            ),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: themeProvider.isDarkMode
                          ? Colors.white.withOpacity(0.05)
                          : const Color(0xFFF1F5F9),
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          FontAwesomeIcons.pencil,
                          size: 16,
                          color: themeProvider
                              .themeData.textTheme.bodySmall?.color,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: themeProvider
                                      .themeData.textTheme.titleMedium?.color,
                                ),
                              ),
                              if (widget.subtitle.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  widget.subtitle,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: themeProvider
                                        .themeData.textTheme.bodySmall?.color,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.pencil,
                            size: 14,
                            color: Color(0xFF94A3B8),
                          ),
                          onPressed: () {
                            // TODO: Implementar edição
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          'Adicionado por',
                          style: TextStyle(
                            fontSize: 12,
                            color: themeProvider
                                .themeData.textTheme.bodySmall?.color,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                themeProvider.primaryColor,
                                themeProvider.primaryColor.withOpacity(0.7),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              widget.user
                                  .split(' ')
                                  .map((n) => n[0])
                                  .take(2)
                                  .join(),
                              style: const TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color:
                                  themeProvider.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              widget.user,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: themeProvider.primaryColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Content
              if (widget.content != null)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: widget.content!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
