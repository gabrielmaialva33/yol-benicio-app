import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yolapp/features/dashboard/pages/dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      title: 'Yol App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        brightness: Brightness.light,
        textTheme: GoogleFonts.interTextTheme(textTheme),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.orange,
        brightness: Brightness.dark,
        textTheme: GoogleFonts.interTextTheme(textTheme.apply(
            bodyColor: Colors.white, displayColor: Colors.white)),
      ),
      themeMode: ThemeMode.system,
      home: const DashboardPage(),
    );
  }
}
