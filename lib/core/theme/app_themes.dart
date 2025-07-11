import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Sistema de temas avançado com 4 variações diferentes
class AppThemes {
  // ========== DESIGN TOKENS ==========

  // Cores principais
  static const Color slate900 = Color(0xFF1e293b);
  static const Color sky600 = Color(0xFF0284c7);
  static const Color cyan500 = Color(0xFF00b8d9);
  static const Color red500 = Color(0xFFff5630);
  static const Color emerald600 = Color(0xFF00a76f);
  static const Color amber500 = Color(0xFFffab00);
  static const Color white = Color(0xFFffffff);
  static const Color gray800 = Color(0xFF212b36);
  static const Color slate100 = Color(0xFFf1f5f9);
  static const Color slate50 = Color(0xFFf8fafc);
  static const Color slate500 = Color(0xFF64748b);
  static const Color teal800 = Color(0xFF115e59);
  static const Color green500 = Color(0xFF22c55e);
  static const Color gray600 = Color(0xFF637381);
  static const Color teal900 = Color(0xFF004b50);
  static const Color gray400 = Color(0xFF919eab);

  // Cores complementares
  static const Color slate300 = Color(0xFFcbd5e1);
  static const Color cyan400 = Color(0xFF1cd6f4);
  static const Color gray500 = Color(0xFFa1a5b7);
  static const Color green50 = Color(0xFFe8fff3);
  static const Color green600 = Color(0xFF2fac68);
  static const Color slate600 = Color(0xFF475569);
  static const Color gray900 = Color(0xFF1f2a37);
  static const Color gray700 = Color(0xFF5e6278);
  static const Color teal100 = Color(0xFFbae3e0);
  static const Color teal700 = Color(0xFF008980);
  static const Color gray650 = Color(0xFF7e8299);
  static const Color gray100 = Color(0xFFe1e3ea);
  static const Color red400 = Color(0xFFec6553);
  static const Color gray50 = Color(0xFFf1f1f2);

  // ========== TEMA 1: OCEANO CLARO ==========
  static ThemeData oceanLightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: sky600,
      onPrimary: white,
      secondary: cyan500,
      onSecondary: white,
      tertiary: teal700,
      onTertiary: white,
      surface: white,
      onSurface: slate900,
      background: slate50,
      onBackground: slate900,
      error: red500,
      onError: white,
      surfaceVariant: slate100,
      onSurfaceVariant: slate500,
      outline: slate300,
      shadow: slate900,
    ),
    scaffoldBackgroundColor: slate50,
    appBarTheme: AppBarTheme(
      backgroundColor: white,
      foregroundColor: slate900,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: slate900,
      ),
    ),
    cardTheme: CardTheme(
      color: white,
      elevation: 2,
      shadowColor: slate900.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: slate300.withOpacity(0.5)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: sky600,
        foregroundColor: white,
        elevation: 2,
        shadowColor: sky600.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textTheme: GoogleFonts.interTextTheme().copyWith(
      displayLarge:
          GoogleFonts.inter(color: slate900, fontWeight: FontWeight.w700),
      displayMedium:
          GoogleFonts.inter(color: slate900, fontWeight: FontWeight.w600),
      bodyLarge:
          GoogleFonts.inter(color: slate900, fontWeight: FontWeight.w500),
      bodyMedium:
          GoogleFonts.inter(color: slate500, fontWeight: FontWeight.w400),
    ),
  );

  // ========== TEMA 2: FLORESTA CLARO ==========
  static ThemeData forestLightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: emerald600,
      onPrimary: white,
      secondary: green500,
      onSecondary: white,
      tertiary: teal800,
      onTertiary: white,
      surface: white,
      onSurface: gray800,
      background: green50,
      onBackground: gray800,
      error: red500,
      onError: white,
      surfaceVariant: teal100,
      onSurfaceVariant: teal800,
      outline: green600,
      shadow: gray800,
    ),
    scaffoldBackgroundColor: green50,
    appBarTheme: AppBarTheme(
      backgroundColor: white,
      foregroundColor: gray800,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: gray800,
      ),
    ),
    cardTheme: CardTheme(
      color: white,
      elevation: 2,
      shadowColor: emerald600.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: teal100.withOpacity(0.7)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: emerald600,
        foregroundColor: white,
        elevation: 2,
        shadowColor: emerald600.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textTheme: GoogleFonts.interTextTheme().copyWith(
      displayLarge:
          GoogleFonts.inter(color: gray800, fontWeight: FontWeight.w700),
      displayMedium:
          GoogleFonts.inter(color: gray800, fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.inter(color: gray800, fontWeight: FontWeight.w500),
      bodyMedium:
          GoogleFonts.inter(color: gray600, fontWeight: FontWeight.w400),
    ),
  );

  // ========== TEMA 3: NOITE OCEÂNICA ==========
  static ThemeData oceanDarkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: cyan400,
      onPrimary: slate900,
      secondary: sky600,
      onSecondary: white,
      tertiary: teal100,
      onTertiary: teal900,
      surface: gray900,
      onSurface: slate100,
      background: slate900,
      onBackground: slate100,
      error: red400,
      onError: white,
      surfaceVariant: gray800,
      onSurfaceVariant: slate300,
      outline: slate600,
      shadow: Colors.black,
    ),
    scaffoldBackgroundColor: slate900,
    appBarTheme: AppBarTheme(
      backgroundColor: gray900,
      foregroundColor: slate100,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: slate100,
      ),
    ),
    cardTheme: CardTheme(
      color: gray900,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: slate600.withOpacity(0.3)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: cyan400,
        foregroundColor: slate900,
        elevation: 3,
        shadowColor: cyan400.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textTheme: GoogleFonts.interTextTheme().copyWith(
      displayLarge:
          GoogleFonts.inter(color: slate100, fontWeight: FontWeight.w700),
      displayMedium:
          GoogleFonts.inter(color: slate100, fontWeight: FontWeight.w600),
      bodyLarge:
          GoogleFonts.inter(color: slate100, fontWeight: FontWeight.w500),
      bodyMedium:
          GoogleFonts.inter(color: slate300, fontWeight: FontWeight.w400),
    ),
  );

  // ========== TEMA 4: FLORESTA NOTURNA ==========
  static ThemeData forestDarkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: green600,
      onPrimary: white,
      secondary: teal700,
      onSecondary: white,
      tertiary: emerald600,
      onTertiary: white,
      surface: teal900,
      onSurface: teal100,
      background: gray900,
      onBackground: gray100,
      error: red400,
      onError: white,
      surfaceVariant: teal800,
      onSurfaceVariant: teal100,
      outline: gray700,
      shadow: Colors.black,
    ),
    scaffoldBackgroundColor: gray900,
    appBarTheme: AppBarTheme(
      backgroundColor: teal900,
      foregroundColor: teal100,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: teal100,
      ),
    ),
    cardTheme: CardTheme(
      color: teal900,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: gray700.withOpacity(0.4)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: green600,
        foregroundColor: white,
        elevation: 3,
        shadowColor: green600.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textTheme: GoogleFonts.interTextTheme().copyWith(
      displayLarge:
          GoogleFonts.inter(color: teal100, fontWeight: FontWeight.w700),
      displayMedium:
          GoogleFonts.inter(color: teal100, fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.inter(color: gray100, fontWeight: FontWeight.w500),
      bodyMedium:
          GoogleFonts.inter(color: gray400, fontWeight: FontWeight.w400),
    ),
  );

  // ========== CLASSES DE TEMA PERSONALIZADAS ==========

  static const List<AppThemeVariant> availableThemes = [
    AppThemeVariant.oceanLight,
    AppThemeVariant.forestLight,
    AppThemeVariant.oceanDark,
    AppThemeVariant.forestDark,
  ];

  static ThemeData getTheme(AppThemeVariant variant) {
    switch (variant) {
      case AppThemeVariant.oceanLight:
        return oceanLightTheme;
      case AppThemeVariant.forestLight:
        return forestLightTheme;
      case AppThemeVariant.oceanDark:
        return oceanDarkTheme;
      case AppThemeVariant.forestDark:
        return forestDarkTheme;
    }
  }

  static String getThemeName(AppThemeVariant variant) {
    switch (variant) {
      case AppThemeVariant.oceanLight:
        return 'Oceano Claro';
      case AppThemeVariant.forestLight:
        return 'Floresta Clara';
      case AppThemeVariant.oceanDark:
        return 'Noite Oceânica';
      case AppThemeVariant.forestDark:
        return 'Floresta Noturna';
    }
  }

  static IconData getThemeIcon(AppThemeVariant variant) {
    switch (variant) {
      case AppThemeVariant.oceanLight:
        return Icons.wb_sunny_rounded;
      case AppThemeVariant.forestLight:
        return Icons.nature_rounded;
      case AppThemeVariant.oceanDark:
        return Icons.nightlight_rounded;
      case AppThemeVariant.forestDark:
        return Icons.forest_rounded;
    }
  }

  static Color getThemePreviewColor(AppThemeVariant variant) {
    switch (variant) {
      case AppThemeVariant.oceanLight:
        return sky600;
      case AppThemeVariant.forestLight:
        return emerald600;
      case AppThemeVariant.oceanDark:
        return cyan400;
      case AppThemeVariant.forestDark:
        return green600;
    }
  }

  // ========== GRADIENTES PERSONALIZADOS ==========

  static const LinearGradient oceanGradient = LinearGradient(
    colors: [sky600, cyan500],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient forestGradient = LinearGradient(
    colors: [emerald600, green500],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient oceanDarkGradient = LinearGradient(
    colors: [cyan400, sky600],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient forestDarkGradient = LinearGradient(
    colors: [green600, teal700],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient getGradient(AppThemeVariant variant) {
    switch (variant) {
      case AppThemeVariant.oceanLight:
        return oceanGradient;
      case AppThemeVariant.forestLight:
        return forestGradient;
      case AppThemeVariant.oceanDark:
        return oceanDarkGradient;
      case AppThemeVariant.forestDark:
        return forestDarkGradient;
    }
  }

  // ========== CONSTANTES DE DESIGN ==========

  // Espaçamentos
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Raios de borda
  static const double radiusXS = 4.0;
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusXXL = 32.0;

  // Durações de animação
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Curvas de animação
  static const Curve smoothCurve = Curves.easeInOutCubic;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve springCurve = Curves.fastOutSlowIn;

  // Sombras personalizadas
  static List<BoxShadow> get lightShadow => [
        BoxShadow(
          color: slate900.withOpacity(0.08),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get mediumShadow => [
        BoxShadow(
          color: slate900.withOpacity(0.12),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get strongShadow => [
        BoxShadow(
          color: slate900.withOpacity(0.16),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];
}

enum AppThemeVariant {
  oceanLight,
  forestLight,
  oceanDark,
  forestDark,
}
