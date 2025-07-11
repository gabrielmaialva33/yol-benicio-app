import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/theme_provider.dart';
import '../auth/services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final theme = themeProvider.themeData;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: FadeTransition(
            opacity: _fadeAnimation,
            child: CustomScrollView(
              slivers: [
                _buildSliverAppBar(context, themeProvider),
                SliverToBoxAdapter(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildProfileHeader(themeProvider),
                          const SizedBox(height: 32),
                          _buildQuickActions(themeProvider),
                          const SizedBox(height: 24),
                          _buildMenuSection(themeProvider),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSliverAppBar(BuildContext context, ThemeProvider themeProvider) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: themeProvider.primaryColor,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: Text(
          'Perfil',
          style: TextStyle(color: Colors.white),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: themeProvider.primaryGradient,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined, color: Colors.white),
          onPressed: () => _showProfileEdit(context),
        ),
        IconButton(
          icon: Icon(
            themeProvider.isDarkMode
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined,
            color: Colors.white,
          ),
          onPressed: () => themeProvider.toggleTheme(),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildProfileHeader(ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: themeProvider.themeData.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: themeProvider.isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Hero(
            tag: 'profile_avatar',
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: themeProvider.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: themeProvider.primaryColor.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person_rounded,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Dr. João Silva',
            style: TextStyle(
              color: themeProvider.themeData.textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Advogado Sênior • OAB/SP 123.456',
            style: TextStyle(
              color: themeProvider.themeData.textTheme.bodyMedium?.color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'joao.silva@yol.com.br',
            style: TextStyle(
              color: themeProvider.themeData.textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: themeProvider.successGradient.scale(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: themeProvider.successColor.withOpacity(0.3),
              ),
            ),
            child: Text(
              '🏆 Membro Premium',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: themeProvider.successColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(ThemeProvider themeProvider) {
    final actions = [
      {
        'icon': Icons.analytics_outlined,
        'title': 'Estatísticas',
        'color': themeProvider.primaryColor,
        'onTap': () => _showStatistics(context),
      },
      {
        'icon': Icons.calendar_today_outlined,
        'title': 'Agenda',
        'color': themeProvider.errorColor,
        'onTap': () => _showCalendar(context),
      },
      {
        'icon': Icons.star_outline,
        'title': 'Avaliações',
        'color': themeProvider.warningColor,
        'onTap': () => _showReviews(context),
      },
      {
        'icon': Icons.palette_outlined,
        'title': 'Temas',
        'color': themeProvider.accentColor,
        'onTap': () => _showThemeSelector(context),
      },
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: actions.map((action) {
        return _buildQuickActionCard(
          icon: action['icon'] as IconData,
          title: action['title'] as String,
          color: action['color'] as Color,
          onTap: action['onTap'] as VoidCallback,
          themeProvider: themeProvider,
        );
      }).toList(),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
    required ThemeProvider themeProvider,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: themeProvider.themeData.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: themeProvider.isDarkMode
                  ? Colors.black.withOpacity(0.2)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: themeProvider.themeData.textTheme.bodyMedium?.color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(ThemeProvider themeProvider) {
    final menuItems = [
      {
        'icon': Icons.person_outline_rounded,
        'title': 'Dados Pessoais',
        'subtitle': 'Gerencie suas informações',
        'onTap': () => _showProfileEdit(context),
      },
      {
        'icon': Icons.security_rounded,
        'title': 'Segurança',
        'subtitle': 'Senha e autenticação',
        'onTap': () => _showSecurityOptions(context),
      },
      {
        'icon': Icons.notifications_outlined,
        'title': 'Notificações',
        'subtitle': 'Configure alertas',
        'onTap': () => _showNotificationSettings(context),
      },
      {
        'icon': Icons.language_rounded,
        'title': 'Idioma',
        'subtitle': 'Português (Brasil)',
        'onTap': () => _showLanguageOptions(context),
      },
      {
        'icon': Icons.help_outline_rounded,
        'title': 'Ajuda e Suporte',
        'subtitle': 'Central de ajuda',
        'onTap': () => _showSupport(context),
      },
      {
        'icon': Icons.info_outline_rounded,
        'title': 'Sobre',
        'subtitle': 'Versão 1.0.0',
        'onTap': () => _showAbout(context),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            'Configurações',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: themeProvider.themeData.textTheme.titleMedium?.color,
            ),
          ),
        ),
        ...menuItems.map((item) =>
            _buildMenuItem(
              icon: item['icon'] as IconData,
              title: item['title'] as String,
              subtitle: item['subtitle'] as String,
              onTap: item['onTap'] as VoidCallback,
              themeProvider: themeProvider,
            )),
        const SizedBox(height: 24),
        _buildLogoutButton(themeProvider),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required ThemeProvider themeProvider,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
            color: themeProvider.isDarkMode
                ? Colors.black.withOpacity(0.2)
                : Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: themeProvider.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: themeProvider.primaryColor,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: themeProvider.themeData.textTheme.titleMedium?.color,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: themeProvider.themeData.textTheme.bodySmall?.color,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: themeProvider.themeData.textTheme.bodySmall?.color,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLogoutButton(ThemeProvider themeProvider) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: themeProvider.errorColor.withOpacity(0.3),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: themeProvider.errorColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.logout_rounded,
            color: themeProvider.errorColor,
            size: 24,
          ),
        ),
        title: Text(
          'Sair da Conta',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: themeProvider.errorColor,
          ),
        ),
        subtitle: Text(
          'Fazer logout do aplicativo',
          style: TextStyle(
            fontSize: 14,
            color: themeProvider.themeData.textTheme.bodySmall?.color,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: themeProvider.errorColor,
        ),
        onTap: () => _showLogoutDialog(context),
      ),
    );
  }

  // Métodos de ação simplificados
  void _showProfileEdit(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Editar Perfil - Em desenvolvimento'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showStatistics(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Estatísticas - Em desenvolvimento'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showCalendar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Agenda - Em desenvolvimento'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showReviews(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Avaliações - Em desenvolvimento'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showThemeSelector(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: themeProvider.themeData.cardColor,
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Escolha o tema',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: themeProvider.themeData.textTheme.titleLarge?.color,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildThemeOption(
                        context: context,
                        themeProvider: themeProvider,
                        isLight: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildThemeOption(
                        context: context,
                        themeProvider: themeProvider,
                        isLight: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required ThemeProvider themeProvider,
    required bool isLight,
  }) {
    final isSelected =
    isLight ? !themeProvider.isDarkMode : themeProvider.isDarkMode;

    return GestureDetector(
      onTap: () {
        themeProvider
            .setTheme(isLight ? AppThemeMode.light : AppThemeMode.dark);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? themeProvider.primaryColor.withOpacity(0.1)
              : themeProvider.themeData.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? themeProvider.primaryColor
                : themeProvider.isDarkMode
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              isLight ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: isSelected
                  ? themeProvider.primaryColor
                  : themeProvider.themeData.textTheme.bodyMedium?.color,
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              isLight ? 'Claro' : 'Escuro',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? themeProvider.primaryColor
                    : themeProvider.themeData.textTheme.bodyMedium?.color,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(height: 8),
              Icon(
                Icons.check_rounded,
                color: themeProvider.primaryColor,
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showSecurityOptions(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Segurança - Em desenvolvimento'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notificações - Em desenvolvimento'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showLanguageOptions(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Idiomas - Em desenvolvimento'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSupport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Suporte - Em desenvolvimento'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'YOL Advocacia',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.gavel_rounded),
      children: const [
        Text('Sistema de gestão para escritórios de advocacia.'),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('Confirmar Logout'),
            content: const Text('Tem certeza que deseja sair da sua conta?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final authService = AuthService();
                  await authService.logout();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
                child: const Text('Sair', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}
