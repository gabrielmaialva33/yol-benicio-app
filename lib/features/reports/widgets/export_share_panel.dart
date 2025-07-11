import 'package:flutter/material.dart';

class ExportSharePanel extends StatefulWidget {
  const ExportSharePanel({Key? key}) : super(key: key);

  @override
  State<ExportSharePanel> createState() => _ExportSharePanelState();
}

class _ExportSharePanelState extends State<ExportSharePanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildExportOptions(),
                  const SizedBox(height: 20),
                  _buildShareOptions(),
                  const SizedBox(height: 20),
                  _buildQuickActions(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF582FFF), Color(0xFF8B5CF6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.cloud_download,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Exportar & Compartilhar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              Text(
                'Salve ou compartilhe seus relatórios',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExportOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Formatos de Exportação',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildExportButton(
                'PDF',
                Icons.picture_as_pdf,
                const Color(0xFFEF4444),
                () => _exportToPDF(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildExportButton(
                'Excel',
                Icons.table_chart,
                const Color(0xFF22C55E),
                () => _exportToExcel(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildExportButton(
                'PNG',
                Icons.image,
                const Color(0xFF3B82F6),
                () => _exportToPNG(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExportButton(
      String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Opções de Compartilhamento',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildShareButton(
                'E-mail',
                Icons.email,
                const Color(0xFF582FFF),
                () => _shareByEmail(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildShareButton(
                'WhatsApp',
                Icons.message,
                const Color(0xFF22C55E),
                () => _shareByWhatsApp(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildShareButton(
                'Link',
                Icons.link,
                const Color(0xFFF59E0B),
                () => _generateShareLink(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildShareButton(
      String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ações Rápidas',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _generateCompleteReport(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF582FFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon:
                    const Icon(Icons.assessment, color: Colors.white, size: 18),
                label: const Text(
                  'Relatório Completo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _scheduleReport(),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF582FFF)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.schedule,
                    color: Color(0xFF582FFF), size: 18),
                label: const Text(
                  'Agendar Envio',
                  style: TextStyle(
                    color: Color(0xFF582FFF),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _exportToPDF() {
    _showSuccessMessage('Exportando para PDF...');
  }

  void _exportToExcel() {
    _showSuccessMessage('Exportando para Excel...');
  }

  void _exportToPNG() {
    _showSuccessMessage('Exportando como imagem...');
  }

  void _shareByEmail() {
    _showSuccessMessage('Compartilhando por e-mail...');
  }

  void _shareByWhatsApp() {
    _showSuccessMessage('Compartilhando no WhatsApp...');
  }

  void _generateShareLink() {
    _showSuccessMessage('Link de compartilhamento copiado!');
  }

  void _generateCompleteReport() {
    _showSuccessMessage('Gerando relatório completo...');
  }

  void _scheduleReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agendar Relatório'),
        content: const Text(
            'Escolha a frequência para envio automático de relatórios.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessMessage('Relatório agendado com sucesso!');
            },
            child: const Text('Agendar'),
          ),
        ],
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF22C55E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
