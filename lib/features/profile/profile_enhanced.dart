import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../auth/services/auth_service.dart';
import '../shared/services/mock_service.dart';
import '../../core/theme/app_theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  final MockService _mockService = MockService();
  late AnimationController _profileAnimationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  bool _isNotificationsEnabled = true;
  bool _isDarkModeEnabled = false;
  bool _isEmailNotificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _profileAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _profileAnimationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _profileAnimationController,
      curve: AppTheme.smoothCurve,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: AppTheme.bounceCurve,
    ));

    _profileAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _cardAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _profileAnimationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lawyers = _mockService.getLawyers();
    final currentLawyer = lawyers.first; // Simular usuário logado

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: CustomScrollView(
            slivers: [
              _buildSliverAppBar(currentLawyer),
              SliverPadding(
                padding: const EdgeInsets.all(AppTheme.spacingL),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildStatsCards(currentLawyer),
                    const SizedBox(height: AppTheme.spacingL),
                    _buildSettingsSection(),
                    const SizedBox(height: AppTheme.spacingL),
                    _buildAccountSection(),
                    const SizedBox(height: AppTheme.spacingL),
                    _buildSupportSection(),
                    const SizedBox(height: AppTheme.spacingXL),
                    _buildLogoutButton(),
                    const SizedBox(height: AppTheme.spacingXL),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(LawyerProfile lawyer) {
    return SliverAppBar(
      expandedHeight: 280,
      floating: false,
      pinned: true,
      backgroundColor: AppTheme.cardBackground,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.primaryGradient,
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Hero(
                    tag: 'profile_avatar',
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 4,
                        ),
                        gradient: const LinearGradient(
                          colors: [
                            AppTheme.secondaryColor,
                            Color(0xFFFF8A65),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  lawyer.name,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  lawyer.oab,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    lawyer.specialization,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCards(LawyerProfile lawyer) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Casos Ativos',
            lawyer.activeCases.toString(),
            Icons.folder_open_rounded,
            AppTheme.infoColor,
          ),
        ),
        const SizedBox(width: AppTheme.spacingM),
        Expanded(
          child: _buildStatCard(
            'Taxa de Sucesso',
            '${lawyer.successRate.toStringAsFixed(1)}%',
            Icons.trending_up_rounded,
            AppTheme.successColor,
          ),
        ),
        const SizedBox(width: AppTheme.spacingM),
        Expanded(
          child: _buildStatCard(
            'Total de Casos',
            lawyer.totalCases.toString(),
            Icons.analytics_rounded,
            AppTheme.warningColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return AnimatedContainer(
      duration: AppTheme.animationMedium,
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(
          color: AppTheme.borderLight,
          width: 1,
        ),
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
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return _buildSection(
      'Configurações',
      Icons.settings_rounded,
      [
        _buildSwitchTile(
          'Notificações Push',
          'Receber notificações de novos casos e prazos',
          Icons.notifications_rounded,
          _isNotificationsEnabled,
          (value) => setState(() => _isNotificationsEnabled = value),
        ),
        _buildSwitchTile(
          'Notificações por Email',
          'Receber resumos diários por email',
          Icons.email_rounded,
          _isEmailNotificationsEnabled,
          (value) => setState(() => _isEmailNotificationsEnabled = value),
        ),
        _buildSwitchTile(
          'Modo Escuro',
          'Alterar aparência do aplicativo',
          Icons.dark_mode_rounded,
          _isDarkModeEnabled,
          (value) => setState(() => _isDarkModeEnabled = value),
        ),
      ],
    );
  }

  Widget _buildAccountSection() {
    return _buildSection(
      'Conta',
      Icons.account_circle_rounded,
      [
        _buildProfileTile(
          'Editar Perfil',
          'Alterar informações pessoais',
          Icons.edit_rounded,
          () => _showEditProfileDialog(),
        ),
        _buildProfileTile(
          'Alterar Senha',
          'Atualizar senha de acesso',
          Icons.lock_rounded,
          () => _showChangePasswordDialog(),
        ),
        _buildProfileTile(
          'Privacidade',
          'Gerenciar dados e privacidade',
          Icons.privacy_tip_rounded,
          () => _showPrivacyDialog(),
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return _buildSection(
      'Suporte',
      Icons.help_rounded,
      [
        _buildProfileTile(
          'Central de Ajuda',
          'FAQ e documentação',
          Icons.help_center_rounded,
          () {},
        ),
        _buildProfileTile(
          'Contatar Suporte',
          'Falar com nossa equipe',
          Icons.support_agent_rounded,
          () {},
        ),
        _buildProfileTile(
          'Sobre o App',
          'Versão e informações',
          Icons.info_rounded,
          () {},
        ),
      ],
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(
          color: AppTheme.borderLight,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.borderLight),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: AppTheme.primaryColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppTheme.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(
          fontSize: 14,
          color: AppTheme.textSecondary,
        ),
      ),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildProfileTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: AppTheme.primaryColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppTheme.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(
          fontSize: 14,
          color: AppTheme.textSecondary,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: AppTheme.textSecondary,
      ),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.errorColor.withOpacity(0.1),
            AppTheme.errorColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: AppTheme.errorColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          onTap: _handleLogout,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.logout_rounded,
                  color: AppTheme.errorColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Sair da Conta',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.errorColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Perfil'),
        content: const Text('Funcionalidade em desenvolvimento'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alterar Senha'),
        content: const Text('Funcionalidade em desenvolvimento'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacidade'),
        content: const Text('Configurações de privacidade em desenvolvimento'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _handleLogout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Saída'),
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
            child: Text(
              'Sair',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }
}
