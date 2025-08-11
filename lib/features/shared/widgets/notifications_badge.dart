import 'package:flutter/material.dart';

class NotificationsBadge extends StatefulWidget {
  final VoidCallback? onTap;
  final bool showBadge;
  final int notificationCount;

  const NotificationsBadge({
    super.key,
    this.onTap,
    this.showBadge = true,
    this.notificationCount = 3,
  });

  @override
  State<NotificationsBadge> createState() => _NotificationsBadgeState();
}

class _NotificationsBadgeState extends State<NotificationsBadge>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.showBadge) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap?.call();
        _showNotificationsPanel();
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
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.notifications_outlined,
              size: 22,
              color: const Color(0xFF64748B),
            ),
            if (widget.showBadge)
              Positioned(
                top: 8,
                right: 8,
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFEF4444).withOpacity(0.3),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            widget.notificationCount > 9
                                ? '9+'
                                : widget.notificationCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showNotificationsPanel() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const NotificationsPanel(),
    );
  }
}

class NotificationsPanel extends StatelessWidget {
  const NotificationsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Notificações',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Marcar todas como lidas
                  },
                  child: const Text('Marcar todas como lidas'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Lista de notificações
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _getNotifications().length,
              itemBuilder: (context, index) {
                final notification = _getNotifications()[index];
                return _buildNotificationItem(notification);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: notification['isRead'] ? Colors.white : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: notification['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            notification['icon'],
            color: notification['color'],
            size: 24,
          ),
        ),
        title: Text(
          notification['title'],
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification['message'],
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              notification['time'],
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF9CA3AF),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: !notification['isRead']
            ? Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF3B82F6),
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: () {
          // Marcar como lida e navegar se necessário
        },
      ),
    );
  }

  List<Map<String, dynamic>> _getNotifications() {
    return [
      {
        'title': 'Prazo próximo',
        'message': 'Processo Silva vs. Estado - Prazo vence em 2 dias',
        'time': 'Há 15 min',
        'icon': Icons.schedule,
        'color': const Color(0xFFEF4444),
        'isRead': false,
      },
      {
        'title': 'Nova audiência marcada',
        'message': 'Audiência para 15/07/2025 às 14:00 - Caso João Santos',
        'time': 'Há 1 hora',
        'icon': Icons.gavel,
        'color': const Color(0xFF3B82F6),
        'isRead': false,
      },
      {
        'title': 'Cliente adicionado',
        'message': 'Maria Oliveira foi adicionada ao sistema',
        'time': 'Há 2 horas',
        'icon': Icons.person_add,
        'color': const Color(0xFF10B981),
        'isRead': false,
      },
      {
        'title': 'Documento anexado',
        'message': 'Novo documento no processo ABC-2024-001',
        'time': 'Ontem',
        'icon': Icons.attach_file,
        'color': const Color(0xFFF59E0B),
        'isRead': true,
      },
      {
        'title': 'Tarefa concluída',
        'message': 'Revisão de contrato foi marcada como concluída',
        'time': 'Ontem',
        'icon': Icons.check_circle,
        'color': const Color(0xFF10B981),
        'isRead': true,
      },
    ];
  }
}
