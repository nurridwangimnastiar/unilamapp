#lib/screens/berita_list_screen.dart
mport 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/berita_card.dart';
import '../controllers/berita_controller.dart';

class BeritaListScreen extends StatefulWidget {
  const BeritaListScreen({super.key});

  @override
  State<BeritaListScreen> createState() => _BeritaListScreenState();
}

class _BeritaListScreenState extends State<BeritaListScreen> {
  final BeritaController controller = Get.put(BeritaController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Panggil data pertama kali
    controller.loadBerita();

    // Deteksi scroll bawah untuk load halaman berikutnya
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !controller.isLoading.value &&
          controller.hasMore.value) {
        controller.loadBerita();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Daftar Berita',
        showBackButton: true,
      ),
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: RefreshIndicator(
          onRefresh: controller.refreshBerita,
          color: const Color(0xFF2E7D32),
          child: Obx(
            () => controller.beritaList.isEmpty && !controller.isLoading.value
                ? // Kondisi jika data kosong
                const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.newspaper_outlined,
                          size: 64,
                          color: Color(0xFF4CAF50),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Belum ada berita tersedia',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: controller.beritaList.length + (controller.isLoading.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Tampilkan loading di paling bawah
                      if (index == controller.beritaList.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                        );
                      }
                      // Tampilkan kartu berita
                      return BeritaCard(berita: controller.beritaList[index]);
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
