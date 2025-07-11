import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_themes_simplified.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'app_theme_mode';
  
  AppThemeMode _currentTheme = AppThemeMode.light;
  
  AppThemeMode get currentTheme => _currentTheme;
  bool get isDarkMode => _currentTheme == AppThemeMode.dark;
  
  ThemeData get themeData {
    return _currentTheme == AppThemeMode.light 
        ? AppThemes.lightTheme 
        : AppThemes.darkTheme;
  }
  
  String get themeName => isDarkMode ? 'Escuro' : 'Claro';
  
  IconData get themeIcon => isDarkMode 
      ? Icons.dark_mode_rounded 
      : Icons.light_mode_rounded;
  
  Color get primaryColor => isDarkMode 
      ? AppColors.cyan400 
      : AppColors.blue600;
      
  LinearGradient get primaryGradient => isDarkMode 
      ? AppThemes.primaryGradientDark 
      : AppThemes.primaryGradientLight;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themeKey) ?? false;
    
    _currentTheme = isDark ? AppThemeMode.dark : AppThemeMode.light;
    notifyListeners();
  }

  Future<void> setTheme(AppThemeMode theme) async {
    if (_currentTheme != theme) {
      _currentTheme = theme;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, theme == AppThemeMode.dark);
      
      notifyListeners();
    }
  }

  Future<void> toggleTheme() async {
    final newTheme = isDarkMode ? AppThemeMode.light : AppThemeMode.dark;
    await setTheme(newTheme);
  }
  
  // Cores de status com base no tema
  Color get successColor => AppColors.green600;
  Color get warningColor => AppColors.amber500;
  Color get errorColor => AppColors.red500;
  Color get infoColor => primaryColor;
  
  // Gradientes de status
  LinearGradient get successGradient => AppThemes.successGradient;
  LinearGradient get warningGradient => AppThemes.warningGradient;
  LinearGradient get errorGradient => AppThemes.errorGradient;
}
