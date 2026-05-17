#lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Tambah GetX
import 'routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // Ganti MaterialApp jadi GetMaterialApp
      title: 'UNILAM Berita',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2E7D32),
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF2E7D32),
          secondary: const Color(0xFF4CAF50),
          background: const Color(0xFFF5F5F5),
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2E7D32),
          elevation: 4,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF1B5E20)),
          bodyMedium: TextStyle(color: Color(0xFF666666)),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes, // Ganti 'routes' jadi 'getPages'
    );
  }
}
