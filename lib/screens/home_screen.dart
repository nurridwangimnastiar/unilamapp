import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'UNILAM Berita'),
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: GridView.count(
          padding: const EdgeInsets.all(20),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildMenuCard(
              context,
              icon: Icons.newspaper,
              title: 'Daftar Berita',
              onTap: () => Navigator.pushNamed(context, AppRoutes.beritaList),
            ),
            _buildMenuCard(
              context,
              icon: Icons.info,
              title: 'Tentang Kampus',
              onTap: () {},
            ),
            _buildMenuCard(
              context,
              icon: Icons.school,
              title: 'Akademik',
              onTap: () {},
            ),
            _buildMenuCard(
              context,
              icon: Icons.people,
              title: 'Kemahasiswaan',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: const Color(0xFF2E7D32)),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
