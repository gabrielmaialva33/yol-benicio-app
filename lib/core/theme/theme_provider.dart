import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_themes.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'selected_theme';

  AppThemeVariant _currentTheme = AppThemeVariant.oceanLight;
  AppThemeVariant get currentTheme => _currentTheme;

  ThemeData get themeData => AppThemes.getTheme(_currentTheme);

  String get themeName => AppThemes.getThemeName(_currentTheme);

  IconData get themeIcon => AppThemes.getThemeIcon(_currentTheme);

  Color get themeColor => AppThemes.getThemePreviewColor(_currentTheme);

  LinearGradient get themeGradient => AppThemes.getGradient(_currentTheme);

  bool get isDarkMode {
    return _currentTheme == AppThemeVariant.oceanDark ||
        _currentTheme == AppThemeVariant.forestDark;
  }

  bool get isOceanTheme {
    return _currentTheme == AppThemeVariant.oceanLight ||
        _currentTheme == AppThemeVariant.oceanDark;
  }

  bool get isForestTheme {
    return _currentTheme == AppThemeVariant.forestLight ||
        _currentTheme == AppThemeVariant.forestDark;
  }

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? 0;

    if (themeIndex >= 0 && themeIndex < AppThemes.availableThemes.length) {
      _currentTheme = AppThemes.availableThemes[themeIndex];
      notifyListeners();
    }
  }

  Future<void> setTheme(AppThemeVariant theme) async {
    if (_currentTheme != theme) {
      _currentTheme = theme;

      final prefs = await SharedPreferences.getInstance();
      final themeIndex = AppThemes.availableThemes.indexOf(theme);
      await prefs.setInt(_themeKey, themeIndex);

      notifyListeners();
    }
  }

  Future<void> toggleDarkMode() async {
    AppThemeVariant newTheme;

    switch (_currentTheme) {
      case AppThemeVariant.oceanLight:
        newTheme = AppThemeVariant.oceanDark;
        break;
      case AppThemeVariant.oceanDark:
        newTheme = AppThemeVariant.oceanLight;
        break;
      case AppThemeVariant.forestLight:
        newTheme = AppThemeVariant.forestDark;
        break;
      case AppThemeVariant.forestDark:
        newTheme = AppThemeVariant.forestLight;
        break;
    }

    await setTheme(newTheme);
  }

  Future<void> switchThemeFamily() async {
    AppThemeVariant newTheme;

    switch (_currentTheme) {
      case AppThemeVariant.oceanLight:
        newTheme = AppThemeVariant.forestLight;
        break;
      case AppThemeVariant.oceanDark:
        newTheme = AppThemeVariant.forestDark;
        break;
      case AppThemeVariant.forestLight:
        newTheme = AppThemeVariant.oceanLight;
        break;
      case AppThemeVariant.forestDark:
        newTheme = AppThemeVariant.oceanDark;
        break;
    }

    await setTheme(newTheme);
  }

  List<AppThemeVariant> get availableThemes => AppThemes.availableThemes;

  Color getThemePreviewColor(AppThemeVariant theme) {
    return AppThemes.getThemePreviewColor(theme);
  }

  String getThemeName(AppThemeVariant theme) {
    return AppThemes.getThemeName(theme);
  }

  IconData getThemeIcon(AppThemeVariant theme) {
    return AppThemes.getThemeIcon(theme);
  }
}
