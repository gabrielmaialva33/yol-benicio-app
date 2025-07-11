import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode {
  light,
  dark,
}

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'selected_theme';
  
  AppThemeMode _currentTheme = AppThemeMode.light;
  AppThemeMode get currentTheme => _currentTheme;
  
  bool get isDarkMode => _currentTheme == AppThemeMode.dark;
  
  // Cores principais do design system
  static const Color _primaryBlue = Color(0xFF0284C7);
  static const Color _primaryTeal = Color(0xFF00B8D9);
  static const Color _successGreen = Color(0xFF00A76F);
  static const Color _warningOrange = Color(0xFFFFAB00);
  static const Color _errorRed = Color(0xFFFF5630);
  
  // Cores do tema claro
  static const Color _lightBackground = Color(0xFFF1F5F9);
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _lightCard = Color(0xFFFFFFFF);
  static const Color _lightTextPrimary = Color(0xFF1E293B);
  static const Color _lightTextSecondary = Color(0xFF64748B);
  static const Color _lightBorder = Color(0xFFCBD5E1);
  
  // Cores do tema escuro
  static const Color _darkBackground = Color(0xFF1F2A37);
  static const Color _darkSurface = Color(0xFF212B36);
  static const Color _darkCard = Color(0xFF212B36);
  static const Color _darkTextPrimary = Color(0xFFFFFFFF);
  static const Color _darkTextSecondary = Color(0xFF919EAB);
  static const Color _darkBorder = Color(0xFF475569);

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? 0;
    
    _currentTheme = themeIndex == 0 ? AppThemeMode.light : AppThemeMode.dark;
    notifyListeners();
  }

  Future<void> setTheme(AppThemeMode theme) async {
    if (_currentTheme != theme) {
      _currentTheme = theme;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, theme == AppThemeMode.light ? 0 : 1);
      
      notifyListeners();
    }
  }

  Future<void> toggleTheme() async {
    final newTheme = _currentTheme == AppThemeMode.light 
        ? AppThemeMode.dark 
        : AppThemeMode.light;
    await setTheme(newTheme);
  }

  // Getters para cores principais
  Color get primaryColor => _primaryBlue;
  Color get accentColor => _primaryTeal;
  Color get successColor => _successGreen;
  Color get warningColor => _warningOrange;
  Color get errorColor => _errorRed;

  // Theme Data
  ThemeData get themeData {
    return isDarkMode ? _darkTheme : _lightTheme;
  }

  ThemeData get _lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: _primaryBlue,
      scaffoldBackgroundColor: _lightBackground,
      cardColor: _lightCard,
      colorScheme: const ColorScheme.light(
        primary: _primaryBlue,
        secondary: _primaryTeal,
        surface: _lightSurface,
        background: _lightBackground,
        error: _errorRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: _lightTextPrimary,
        onBackground: _lightTextPrimary,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightSurface,
        foregroundColor: _lightTextPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardTheme(
        color: _lightCard,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: _lightTextPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: _lightTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: _lightTextPrimary,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: _lightTextSecondary,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: _lightTextSecondary,
          fontSize: 12,
        ),
      ),
      dividerColor: _lightBorder,
      iconTheme: const IconThemeData(
        color: _lightTextSecondary,
      ),
    );
  }

  ThemeData get _darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: _primaryBlue,
      scaffoldBackgroundColor: _darkBackground,
      cardColor: _darkCard,
      colorScheme: const ColorScheme.dark(
        primary: _primaryBlue,
        secondary: _primaryTeal,
        surface: _darkSurface,
        background: _darkBackground,
        error: _errorRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: _darkTextPrimary,
        onBackground: _darkTextPrimary,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkSurface,
        foregroundColor: _darkTextPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardTheme(
        color: _darkCard,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: _darkTextPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: _darkTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: _darkTextPrimary,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: _darkTextSecondary,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: _darkTextSecondary,
          fontSize: 12,
        ),
      ),
      dividerColor: _darkBorder,
      iconTheme: const IconThemeData(
        color: _darkTextSecondary,
      ),
    );
  }

  // Gradientes para elementos especiais
  LinearGradient get primaryGradient {
    return LinearGradient(
      colors: [_primaryBlue, _primaryTeal],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  LinearGradient get successGradient {
    return LinearGradient(
      colors: [_successGreen, const Color(0xFF22C55E)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  LinearGradient get warningGradient {
    return LinearGradient(
      colors: [_warningOrange, const Color(0xFFF59E0B)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  LinearGradient get errorGradient {
    return LinearGradient(
      colors: [_errorRed, const Color(0xFFEF4444)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
