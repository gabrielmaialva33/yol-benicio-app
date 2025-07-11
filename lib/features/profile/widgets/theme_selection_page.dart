import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/theme/app_themes.dart';

class ThemeSelectionPage extends StatefulWidget {
  const ThemeSelectionPage({super.key});

  @override
  State<ThemeSelectionPage> createState() => _ThemeSelectionPageState();
}

class _ThemeSelectionPageState extends State<ThemeSelectionPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
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

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              'Escolher Tema',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor:
                themeProvider.themeData.appBarTheme.backgroundColor,
            foregroundColor:
                themeProvider.themeData.appBarTheme.foregroundColor,
            elevation: 0,
          ),
          body: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personalize a aparência do app',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color:
                          themeProvider.themeData.textTheme.bodyMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: AppThemes.availableThemes.length,
                      itemBuilder: (context, index) {
                        final theme = AppThemes.availableThemes[index];
                        final isSelected = themeProvider.currentTheme == theme;

                        return _buildThemeCard(
                          theme: theme,
                          isSelected: isSelected,
                          onTap: () => themeProvider.setTheme(theme),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildQuickToggleRow(themeProvider),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeCard({
    required AppThemeVariant theme,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final themeData = AppThemes.getTheme(theme);
    final themeName = AppThemes.getThemeName(theme);
    final themeIcon = AppThemes.getThemeIcon(theme);
    final themeColor = AppThemes.getThemePreviewColor(theme);
    final gradient = AppThemes.getGradient(theme);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? themeColor : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? themeColor.withOpacity(0.3)
                  : Colors.black.withOpacity(0.1),
              blurRadius: isSelected ? 15 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(17),
          child: Container(
            decoration: BoxDecoration(
              color: themeData.scaffoldBackgroundColor,
            ),
            child: Column(
              children: [
                // Header com gradiente
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: gradient,
                  ),
                  child: Stack(
                    children: [
                      if (isSelected)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check_rounded,
                              size: 16,
                              color: themeColor,
                            ),
                          ),
                        ),
                      Center(
                        child: Icon(
                          themeIcon,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                // Conteúdo
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              themeName,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: themeData.textTheme.titleMedium?.color,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            // Preview das cores
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildColorDot(themeData.primaryColor),
                                const SizedBox(width: 4),
                                _buildColorDot(themeData.cardColor),
                                const SizedBox(width: 4),
                                _buildColorDot(
                                    themeData.scaffoldBackgroundColor),
                              ],
                            ),
                          ],
                        ),
                        // Indicador de tema escuro/claro
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: themeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            theme.name.contains('Dark') ? 'Escuro' : 'Claro',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: themeColor,
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildColorDot(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black.withOpacity(0.1),
          width: 0.5,
        ),
      ),
    );
  }

  Widget _buildQuickToggleRow(ThemeProvider themeProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.themeData.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickToggleButton(
              icon: themeProvider.isDarkMode
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
              title:
                  'Alternar ${themeProvider.isDarkMode ? 'Claro' : 'Escuro'}',
              onTap: () => themeProvider.toggleDarkMode(),
              themeProvider: themeProvider,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildQuickToggleButton(
              icon: themeProvider.isOceanTheme
                  ? Icons.forest_rounded
                  : Icons.water_rounded,
              title:
                  'Trocar ${themeProvider.isOceanTheme ? 'Floresta' : 'Oceano'}',
              onTap: () => themeProvider.switchThemeFamily(),
              themeProvider: themeProvider,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickToggleButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required ThemeProvider themeProvider,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              themeProvider.themeColor.withOpacity(0.1),
              themeProvider.themeColor.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: themeProvider.themeColor.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: themeProvider.themeColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: themeProvider.themeData.textTheme.bodyMedium?.color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
