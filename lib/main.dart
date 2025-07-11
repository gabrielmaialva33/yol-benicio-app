import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:benicio/features/auth/pages/login_page.dart';
import 'package:benicio/features/auth/services/auth_service.dart';
import 'package:benicio/features/navigation/main_navigator.dart';
import 'package:benicio/core/theme/theme_provider.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('pt_BR', null).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer2<AuthService, ThemeProvider>(
        builder: (context, authService, themeProvider, child) {
          return MaterialApp(
            title: 'YOL Advocacia',
            theme: themeProvider.themeData,
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
