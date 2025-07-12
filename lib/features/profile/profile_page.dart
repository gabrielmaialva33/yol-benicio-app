import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/theme_provider.dart';
import '../auth/services/auth_service.dart';
import '../shared/services/mock_data_service.dart';
import '../shared/models/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _mockService = MockDataService();
  late User _currentUser;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isEditing = false;
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    // Get mock user data (in real app, this would come from auth service)
    final users = _mockService.getUsers();
    _currentUser = users.first;

    _nameController.text = _currentUser.name;
    _emailController.text = _currentUser.email;
    _phoneController.text = _currentUser.phone ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // Save changes (in real app, this would update the backend)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perfil atualizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  void _logout() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.logout();

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    _darkModeEnabled = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    themeProvider.primaryColor,
                    themeProvider.primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: _currentUser.photoUrl != null
                              ? ClipOval(
                            child: Image.network(
                              _currentUser.photoUrl!,
                              width: 96,
                              height: 96,
                              fit: BoxFit.cover,
                            ),
                          )
                              : Text(
                            _currentUser.initials,
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w600,
                              color: themeProvider.primaryColor,
                            ),
                          ),
                        ),
                        if (_isEditing)
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              size: 20,
                              color: themeProvider.primaryColor,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _currentUser.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _currentUser.role,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _currentUser.department,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Profile Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Stats
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Processos',
                          '42',
                          Icons.folder_outlined,
                          themeProvider,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          'Tarefas',
                          '18',
                          Icons.task_alt,
                          themeProvider,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          'Clientes',
                          '25',
                          Icons.people_outline,
                          themeProvider,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Personal Information
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Informações Pessoais',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: themeProvider.themeData.textTheme.titleLarge
                              ?.color,
                        ),
                      ),
                      IconButton(
                        onPressed: _toggleEdit,
                        icon: Icon(_isEditing ? Icons.check : Icons.edit),
                        color: themeProvider.primaryColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    'Nome Completo',
                    _nameController,
                    Icons.person_outline,
                    enabled: _isEditing,
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    'E-mail',
                    _emailController,
                    Icons.email_outlined,
                    enabled: _isEditing,
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    'Telefone',
                    _phoneController,
                    Icons.phone_outlined,
                    enabled: _isEditing,
                  ),
                  const SizedBox(height: 32),

                  // Settings
                  Text(
                    'Configurações',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: themeProvider.themeData.textTheme.titleLarge
                          ?.color,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildSettingItem(
                    'Notificações',
                    'Receber notificações de prazos e tarefas',
                    Icons.notifications_outlined,
                    Switch(
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                      activeColor: themeProvider.primaryColor,
                    ),
                    themeProvider,
                  ),
                  const Divider(height: 32),

                  _buildSettingItem(
                    'Modo Escuro',
                    'Alternar entre tema claro e escuro',
                    Icons.dark_mode_outlined,
                    Switch(
                      value: _darkModeEnabled,
                      onChanged: (value) {
                        themeProvider.toggleTheme();
                      },
                      activeColor: themeProvider.primaryColor,
                    ),
                    themeProvider,
                  ),
                  const Divider(height: 32),

                  _buildSettingItem(
                    'Alterar Senha',
                    'Atualizar sua senha de acesso',
                    Icons.lock_outline,
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: themeProvider.themeData.textTheme.bodyMedium
                          ?.color,
                    ),
                    themeProvider,
                    onTap: () {
                      // TODO: Navigate to change password
                    },
                  ),
                  const SizedBox(height: 32),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout),
                      label: const Text('Sair'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon,
      ThemeProvider themeProvider) {
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
        children: [
          Icon(icon, color: themeProvider.primaryColor),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: themeProvider.themeData.textTheme.titleLarge?.color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: themeProvider.themeData.textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label,
      TextEditingController controller,
      IconData icon, {
        bool enabled = true,
      }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: !enabled,
        fillColor: enabled ? null : Colors.grey.withOpacity(0.1),
      ),
    );
  }

  Widget _buildSettingItem(String title,
      String subtitle,
      IconData icon,
      Widget trailing,
      ThemeProvider themeProvider, {
        VoidCallback? onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: themeProvider.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: themeProvider.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: themeProvider.themeData.textTheme.titleMedium
                          ?.color,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: themeProvider.themeData.textTheme.bodyMedium
                          ?.color,
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
