import 'package:get/get.dart';
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/berita_list_screen.dart';
import '../screens/berita_detail_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String beritaList = '/berita-list';
  static const String beritaDetail = '/berita-detail';

  static final routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: beritaList, page: () => const BeritaListScreen()),
    GetPage(name: beritaDetail, page: () => const BeritaDetailScreen()),
  ];

  // Navigasi dengan argumen
  static void navigateToBeritaDetail(String id, String title, String permalink) {
    Get.toNamed(
      beritaDetail,
      arguments: {
        'id': id,
        'title': title,
        'permalink': permalink,
      },
    );
  }
}
