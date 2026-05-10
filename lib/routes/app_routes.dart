// lib/routes/app_routes.dart
import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/berita_list_screen.dart';
import '../screens/berita_detail_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String beritaList = '/berita-list';
  static const String beritaDetail = '/berita-detail';

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        home: (context) => const HomeScreen(),
        beritaList: (context) => const BeritaListScreen(),
        beritaDetail: (context) => const BeritaDetailScreen(),
      };

  // Navigasi dengan argumen - DITAMBAHKAN PARAMETER PERMALINK
  static void navigateToBeritaDetail(BuildContext context, String id, String title, String permalink) {
    Navigator.pushNamed(
      context,
      beritaDetail,
      arguments: {
        'id': id,
        'title': title,
        'permalink': permalink, // <-- WAJIB ADA
      },
    );
  }
}
