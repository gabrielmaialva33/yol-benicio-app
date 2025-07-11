import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:yolapp/features/auth/pages/login_page.dart';
import 'package:yolapp/features/auth/services/auth_service.dart';
import 'package:yolapp/features/navigation/main_navigator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthService(),
      child: Consumer<AuthService>(
        builder: (context, authService, child) {
          final textTheme = Theme
              .of(context)
              .textTheme;
          return MaterialApp(
            title: 'Yol App',
            theme: ThemeData(
              primaryColor: const Color(0xFF582FFF),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF582FFF),
                brightness: Brightness.light,
              ),
              brightness: Brightness.light,
              textTheme: GoogleFonts.interTextTheme(textTheme),
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF1F2A37),
                elevation: 0,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF582FFF),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            darkTheme: ThemeData(
              primaryColor: const Color(0xFF1F2A37),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF1F2A37),
                brightness: Brightness.dark,
              ),
              brightness: Brightness.dark,
              textTheme: GoogleFonts.interTextTheme(textTheme.apply(
                  bodyColor: Colors.white, displayColor: Colors.white)),
              scaffoldBackgroundColor: const Color(0xFF1F2A37),
            ),
            themeMode: ThemeMode.light,
            routes: {
              '/login': (context) => const LoginPage(),
            },
            home: authService.isAuthenticated
                ? const MainNavigator()
                : const LoginPage(),
          );
        },
      ),
    );
  }
}
