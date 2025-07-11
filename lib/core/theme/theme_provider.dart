import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { light, dark }

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'app_theme_mode';
  
  AppThemeMode _currentTheme = AppThemeMode.light;
  AppThemeMode get currentTheme => _currentTheme;
  
  bool get isDarkMode => _currentTheme == AppThemeMode.dark;
  
  // Cores do tema usando as cores fornecidas pelo usuário
  static const Color primaryLight = Color(0xFF0284c7);    // Azul principal
  static const Color primaryDark = Color(0xFF00b8d9);     // Azul claro
  static const Color accent = Color(0xFF22c55e);          // Verde
  static const Color warning = Color(0xFFffab00);         // Amarelo
  static const Color error = Color(0xFFff5630);           // Vermelho
  static const Color success = Color(0xFF00a76f);         // Verde escuro
  
  // Backgrounds
  static const Color backgroundLight = Color(0xFFf1f5f9); // Cinza claro
  static const Color backgroundDark = Color(0xFF1e293b);  // Cinza escuro
  static const Color cardLight = Color(0xFFffffff);       // Branco
  static const Color cardDark = Color(0xFF212b36);        // Cinza escuro
  
  // Textos
  static const Color textPrimaryLight = Color(0xFF1e293b);
  static const Color textPrimaryDark = Color(0xFFffffff);
  static const Color textSecondaryLight = Color(0xFF64748b);
  static const Color textSecondaryDark = Color(0xFF919eab);

  Color get primaryColor => isDarkMode ? primaryDark : primaryLight;
  Color get accentColor => accent;
  Color get warningColor => warning;
  Color get errorColor => error;
  Color get successColor => success;
  
  LinearGradient get primaryGradient => LinearGradient(
    colors: isDarkMode 
      ? [primaryDark, Color(0xFF115e59)]
      : [primaryLight, Color(0xFF004b50)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  LinearGradient get successGradient => LinearGradient(
    colors: [successColor, Color(0xFF008980)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  ThemeData get themeData {
    final base = isDarkMode ? ThemeData.dark() : ThemeData.light();
    
    return base.copyWith(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: isDarkMode ? backgroundDark : backgroundLight,
      cardColor: isDarkMode ? cardDark : cardLight,
      
      appBarTheme: AppBarTheme(
        backgroundColor: isDarkMode ? cardDark : cardLight,
        foregroundColor: isDarkMode ? textPrimaryDark : textPrimaryLight,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: isDarkMode ? textPrimaryDark : textPrimaryLight,
          fontFamily: 'SF Pro Display', // Fonte do sistema
        ),
      ),
      
      textTheme: base.textTheme.copyWith(
        titleLarge: TextStyle(
          color: isDarkMode ? textPrimaryDark : textPrimaryLight,
          fontWeight: FontWeight.w700,
          fontFamily: 'SF Pro Display',
        ),
        titleMedium: TextStyle(
          color: isDarkMode ? textPrimaryDark : textPrimaryLight,
          fontWeight: FontWeight.w600,
          fontFamily: 'SF Pro Display',
        ),
        bodyLarge: TextStyle(
          color: isDarkMode ? textPrimaryDark : textPrimaryLight,
          fontFamily: 'SF Pro Text',
        ),
        bodyMedium: TextStyle(
          color: isDarkMode ? textSecondaryDark : textSecondaryLight,
          fontFamily: 'SF Pro Text',
        ),
        bodySmall: TextStyle(
          color: isDarkMode ? textSecondaryDark : textSecondaryLight,
          fontFamily: 'SF Pro Text',
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'SF Pro Text',
          ),
        ),
      ),
      
      cardTheme: CardTheme(
        color: isDarkMode ? cardDark : cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isDarkMode 
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
          ),
        ),
      ),
      
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDarkMode ? cardDark : cardLight,
        selectedItemColor: primaryColor,
        unselectedItemColor: isDarkMode ? textSecondaryDark : textSecondaryLight,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDarkMode 
          ? Colors.white.withOpacity(0.05)
          : Colors.black.withOpacity(0.02),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkMode 
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDarkMode 
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
      ),
      
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        primary: primaryColor,
        secondary: accentColor,
        error: errorColor,
        surface: isDarkMode ? cardDark : cardLight,
        background: isDarkMode ? backgroundDark : backgroundLight,
      ),
    );
  }

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? 0;
    _currentTheme = AppThemeMode.values[themeIndex];
    notifyListeners();
  }

  Future<void> setTheme(AppThemeMode theme) async {
    if (_currentTheme != theme) {
      _currentTheme = theme;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, theme.index);
      
      notifyListeners();
    }
  }

  Future<void> toggleTheme() async {
    final newTheme = isDarkMode ? AppThemeMode.light : AppThemeMode.dark;
    await setTheme(newTheme);
  }
}
