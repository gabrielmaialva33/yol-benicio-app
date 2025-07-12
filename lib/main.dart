import 'package:benicio/features/auth/pages/login_page.dart';
import 'package:benicio/features/auth/services/auth_service.dart';
import 'package:benicio/features/navigation/main_navigator.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'core/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await initializeDateFormatting('pt_BR', null);
    runApp(const MyApp());
  } catch (e) {
    // Fallback if localization fails
    debugPrint('Failed to initialize date formatting: $e');
    runApp(const MyApp());
  }
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
            debugShowCheckedModeBanner: false,
            routes: {
              '/login': (context) => const LoginPage(),
            },
            builder: (context, child) {
              // Wrap in MediaQuery to ensure proper constraints
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler:
                      TextScaler.linear(1.0), // Prevent font scaling issues
                ),
                child: child ?? const SizedBox.shrink(),
              );
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
