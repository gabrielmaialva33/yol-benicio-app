import 'package:flutter/material.dart';
import 'package:yolapp/features/dashboard/pages/dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yol App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        brightness: Brightness.light,
        fontFamily: 'Inter',
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.orange,
        brightness: Brightness.dark,
        fontFamily: 'Inter',
      ),
      themeMode: ThemeMode.system,
      home: const DashboardPage(),
    );
  }
}
