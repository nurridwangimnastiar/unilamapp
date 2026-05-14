import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/custom_app_bar.dart';
import '../controllers/berita_controller.dart';

class BeritaDetailScreen extends StatefulWidget {
  const BeritaDetailScreen({super.key});

  @override
  State<BeritaDetailScreen> createState() => _BeritaDetailScreenState();
}

class _BeritaDetailScreenState extends State<BeritaDetailScreen> {
  // Ambil instance controller yang sudah dibuat
  final BeritaController controller = Get.find();

  @override
  void initState() {
    super.initState();
    // Ambil argumen navigasi setelah selesai build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = Get.arguments as Map<String, dynamic>?;
      if (args != null) {
        controller.loadBeritaDetail(args['permalink'] ?? '');
      } else {
        controller.errorMessage.value = 'Link berita tidak valid';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Detail Berita', showBackButton: true),
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    // Gunakan Obx untuk memantau perubahan state secara reaktif
    return Obx(
      () {
        // Kondisi Sedang Memuat
        if (controller.isLoadingDetail.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF2E7D32),
            ),
          );
        }

        // Kondisi Terjadi Error
        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Color(0xFF4CAF50),
                    size: 60,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                    ),
                    onPressed: () => Get.back(),
                    child: const Text(
                      'Kembali',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Kondisi Data Berhasil Dimuat
        if (controller.beritaDetail != null) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul Berita
                Text(
                  controller.beritaDetail!.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B5E20),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),

                // Informasi Penulis & Tanggal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Oleh: ${controller.beritaDetail!.author}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666666),
                      ),
                    ),
                    Text(
                      controller.beritaDetail!.publishedDate.substring(0, 10),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Gambar Utama Berita
                if (controller.beritaDetail!.imageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: controller.beritaDetail!.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        width: double.infinity,
                        height: 180,
                        color: const Color(0xFFE8F5E9),
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Color(0xFF4CAF50),
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),

                // Isi Berita (Render HTML)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Html(
                    data: controller.beritaDetail!.content,
                    style: {
                      "p": Style(
                        textAlign: TextAlign.justify,
                        fontSize: FontSize(14),
                        lineHeight: LineHeight(1.7),
                        color: const Color(0xFF333333),
                      ),
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Informasi Jumlah Dilihat
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.visibility,
                        color: Color(0xFF2E7D32),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${controller.beritaDetail!.viewers} kali dilihat',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF1B5E20),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // Kondisi Data Tidak Ditemukan
        return const Center(
          child: Text('Data tidak ditemukan'),
        );
      },
    );
  }
}
