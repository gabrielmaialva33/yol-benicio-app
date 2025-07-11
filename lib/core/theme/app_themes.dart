import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Design Tokens - Cores fornecidas pelo usuário
class AppColors {
  // Cores principais
  static const Color slate900 = Color(0xFF1e293b);
  static const Color blue600 = Color(0xFF0284c7);
  static const Color cyan500 = Color(0xFF00b8d9);
  static const Color red500 = Color(0xFFff5630);
  static const Color green600 = Color(0xFF00a76f);
  static const Color amber500 = Color(0xFFffab00);
  static const Color white = Color(0xFFffffff);
  static const Color gray900 = Color(0xFF212b36);
  static const Color slate100 = Color(0xFFf1f5f9);
  static const Color slate300 = Color(0xFFcbd5e1);
  static const Color slate400 = Color(0xFF94a3b8);
  static const Color slate500 = Color(0xFF64748b);
  static const Color teal800 = Color(0xFF115e59);
  static const Color green500 = Color(0xFF22c55e);
  static const Color gray600 = Color(0xFF637381);
  static const Color teal900 = Color(0xFF004b50);
  static const Color gray400 = Color(0xFF919eab);
  
  // Cores adicionais
  static const Color cyan400 = Color(0xFF1cd6f4);
  static const Color gray700 = Color(0xFFa1a5b7);
  static const Color green50 = Color(0xFFe8fff3);
  static const Color green600Alt = Color(0xFF2fac68);
  static const Color slate600 = Color(0xFF475569);
  static const Color gray800 = Color(0xFF1f2a37);
  static const Color gray800Alt = Color(0xFF5e6278);
  static const Color teal100 = Color(0xFFbae3e0);
  static const Color teal600 = Color(0xFF008980);
  static const Color gray700Alt = Color(0xFF7e8299);
  static const Color gray200 = Color(0xFFe1e3ea);
  static const Color red600 = Color(0xFFec6553);
  static const Color gray100 = Color(0xFFf1f1f2);
}

enum AppThemeMode { light, dark }

class AppThemes {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // Esquema de cores principal
    colorScheme: ColorScheme.light(
      primary: AppColors.blue600,
      secondary: AppColors.cyan500,
      surface: AppColors.white,
      background: AppColors.slate100,
      error: AppColors.red500,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onSurface: AppColors.slate900,
      onBackground: AppColors.slate900,
      onError: AppColors.white,
    ),
    
    // Cores de fundo
    scaffoldBackgroundColor: AppColors.slate100,
    cardColor: AppColors.white,
    
    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.slate900,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.slate900,
      ),
      iconTheme: const IconThemeData(color: AppColors.slate900),
    ),
    
    // Navegação inferior
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.blue600,
      unselectedItemColor: AppColors.slate500,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400),
    ),
    
    // Cards
    cardTheme: CardTheme(
      color: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: Colors.black.withOpacity(0.1),
    ),
    
    // Botões
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blue600,
        foregroundColor: AppColors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.blue600,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),
    
    // Campos de texto
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColors.white,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.slate300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.slate300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.blue600, width: 2),
      ),
      labelStyle: GoogleFonts.inter(color: AppColors.slate500),
      hintStyle: GoogleFonts.inter(color: AppColors.slate400),
    ),
    
    // Tipografia
    textTheme: GoogleFonts.interTextTheme().copyWith(
      displayLarge: GoogleFonts.inter(color: AppColors.slate900, fontWeight: FontWeight.w700),
      displayMedium: GoogleFonts.inter(color: AppColors.slate900, fontWeight: FontWeight.w700),
      displaySmall: GoogleFonts.inter(color: AppColors.slate900, fontWeight: FontWeight.w600),
      headlineLarge: GoogleFonts.inter(color: AppColors.slate900, fontWeight: FontWeight.w700),
      headlineMedium: GoogleFonts.inter(color: AppColors.slate900, fontWeight: FontWeight.w600),
      headlineSmall: GoogleFonts.inter(color: AppColors.slate900, fontWeight: FontWeight.w600),
      titleLarge: GoogleFonts.inter(color: AppColors.slate900, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.inter(color: AppColors.slate900, fontWeight: FontWeight.w600),
      titleSmall: GoogleFonts.inter(color: AppColors.slate900, fontWeight: FontWeight.w500),
      bodyLarge: GoogleFonts.inter(color: AppColors.slate900, fontWeight: FontWeight.w400),
      bodyMedium: GoogleFonts.inter(color: AppColors.slate500, fontWeight: FontWeight.w400),
      bodySmall: GoogleFonts.inter(color: AppColors.slate400, fontWeight: FontWeight.w400),
      labelLarge: GoogleFonts.inter(color: AppColors.slate900, fontWeight: FontWeight.w600),
      labelMedium: GoogleFonts.inter(color: AppColors.slate500, fontWeight: FontWeight.w500),
      labelSmall: GoogleFonts.inter(color: AppColors.slate400, fontWeight: FontWeight.w500),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    // Esquema de cores principal
    colorScheme: ColorScheme.dark(
      primary: AppColors.cyan400,
      secondary: AppColors.blue600,
      surface: AppColors.gray800,
      background: AppColors.slate900,
      error: AppColors.red500,
      onPrimary: AppColors.slate900,
      onSecondary: AppColors.white,
      onSurface: AppColors.white,
      onBackground: AppColors.white,
      onError: AppColors.white,
    ),
    
    // Cores de fundo
    scaffoldBackgroundColor: AppColors.slate900,
    cardColor: AppColors.gray800,
    
    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.gray800,
      foregroundColor: AppColors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      ),
      iconTheme: const IconThemeData(color: AppColors.white),
    ),
    
    // Navegação inferior
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.gray800,
      selectedItemColor: AppColors.cyan400,
      unselectedItemColor: AppColors.gray400,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400),
    ),
    
    // Cards
    cardTheme: CardTheme(
      color: AppColors.gray800,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: Colors.black.withOpacity(0.3),
    ),
    
    // Botões
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.cyan400,
        foregroundColor: AppColors.slate900,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.cyan400,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),
    
    // Campos de texto
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColors.gray800,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.gray600),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.gray600),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.cyan400, width: 2),
      ),
      labelStyle: GoogleFonts.inter(color: AppColors.gray400),
      hintStyle: GoogleFonts.inter(color: AppColors.gray600),
    ),
    
    // Tipografia
    textTheme: GoogleFonts.interTextTheme().copyWith(
      displayLarge: GoogleFonts.inter(color: AppColors.white, fontWeight: FontWeight.w700),
      displayMedium: GoogleFonts.inter(color: AppColors.white, fontWeight: FontWeight.w700),
      displaySmall: GoogleFonts.inter(color: AppColors.white, fontWeight: FontWeight.w600),
      headlineLarge: GoogleFonts.inter(color: AppColors.white, fontWeight: FontWeight.w700),
      headlineMedium: GoogleFonts.inter(color: AppColors.white, fontWeight: FontWeight.w600),
      headlineSmall: GoogleFonts.inter(color: AppColors.white, fontWeight: FontWeight.w600),
      titleLarge: GoogleFonts.inter(color: AppColors.white, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.inter(color: AppColors.white, fontWeight: FontWeight.w600),
      titleSmall: GoogleFonts.inter(color: AppColors.white, fontWeight: FontWeight.w500),
      bodyLarge: GoogleFonts.inter(color: AppColors.white, fontWeight: FontWeight.w400),
      bodyMedium: GoogleFonts.inter(color: AppColors.gray400, fontWeight: FontWeight.w400),
      bodySmall: GoogleFonts.inter(color: AppColors.gray600, fontWeight: FontWeight.w400),
      labelLarge: GoogleFonts.inter(color: AppColors.white, fontWeight: FontWeight.w600),
      labelMedium: GoogleFonts.inter(color: AppColors.gray400, fontWeight: FontWeight.w500),
      labelSmall: GoogleFonts.inter(color: AppColors.gray600, fontWeight: FontWeight.w500),
    ),
  );

  // Gradientes personalizados
  static LinearGradient primaryGradientLight = LinearGradient(
    colors: [AppColors.blue600, AppColors.cyan500],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient primaryGradientDark = LinearGradient(
    colors: [AppColors.cyan400, AppColors.blue600],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient successGradient = LinearGradient(
    colors: [AppColors.green600, AppColors.green500],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient warningGradient = LinearGradient(
    colors: [AppColors.amber500, Color(0xFFf59e0b)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient errorGradient = LinearGradient(
    colors: [AppColors.red500, AppColors.red600],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
