import 'package:flutter/material.dart';

class ConnectivityStatus extends StatefulWidget {
  const ConnectivityStatus({super.key});

  @override
  State<ConnectivityStatus> createState() => _ConnectivityStatusState();
}

class _ConnectivityStatusState extends State<ConnectivityStatus>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showConnectionDetails(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _isOnline 
            ? const Color(0xFF10B981).withOpacity(0.1)
            : const Color(0xFFEF4444).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isOnline 
              ? const Color(0xFF10B981).withOpacity(0.3)
              : const Color(0xFFEF4444).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _isOnline ? _pulseAnimation.value : 1.0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _isOnline 
                        ? const Color(0xFF10B981)
                        : const Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 6),
            Text(
              _isOnline ? 'Online' : 'Offline',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _isOnline 
                  ? const Color(0xFF10B981)
                  : const Color(0xFFEF4444),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConnectionDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              _isOnline ? Icons.wifi : Icons.wifi_off,
              color: _isOnline 
                ? const Color(0xFF10B981)
                : const Color(0xFFEF4444),
            ),
            const SizedBox(width: 8),
            Text(
              _isOnline ? 'Conectado' : 'Desconectado',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusItem(
              'Status da Conexão', 
              _isOnline ? 'Conectado à internet' : 'Sem conexão',
              _isOnline ? Icons.check_circle : Icons.error,
              _isOnline ? const Color(0xFF10B981) : const Color(0xFFEF4444),
            ),
            const SizedBox(height: 12),
            _buildStatusItem(
              'Servidor API', 
              _isOnline ? 'Operacional' : 'Indisponível',
              _isOnline ? Icons.cloud_done : Icons.cloud_off,
              _isOnline ? const Color(0xFF10B981) : const Color(0xFFEF4444),
            ),
            const SizedBox(height: 12),
            _buildStatusItem(
              'Sincronização', 
              _isOnline ? 'Ativa' : 'Pausada',
              _isOnline ? Icons.sync : Icons.sync_disabled,
              _isOnline ? const Color(0xFF10B981) : const Color(0xFFEF4444),
            ),
            if (!_isOnline) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFF59E0B),
                    width: 1,
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Color(0xFFF59E0B),
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Dados serão sincronizados quando a conexão for restabelecida.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF92400E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (!_isOnline)
            TextButton(
              onPressed: () {
                setState(() => _isOnline = true);
                Navigator.pop(context);
              },
              child: const Text('Tentar Reconectar'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String title, String status, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF374151),
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
