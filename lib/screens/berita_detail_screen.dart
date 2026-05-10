// lib/screens/berita_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart'; // <-- PAKAI PAKET BARU
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/custom_app_bar.dart';
import '../services/api_service.dart';
import '../models/berita_model.dart';

class BeritaDetailScreen extends StatefulWidget {
  const BeritaDetailScreen({super.key});

  @override
  State<BeritaDetailScreen> createState() => _BeritaDetailScreenState();
}

class _BeritaDetailScreenState extends State<BeritaDetailScreen> {
  BeritaModel? _berita;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        _loadDetailBerita(args['permalink'] ?? '');
      } else {
        setState(() {
          _errorMessage = 'Link berita tidak valid';
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _loadDetailBerita(String permalink) async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      final data = await ApiService.getBeritaDetail(permalink);
      setState(() {
        _berita = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat detail berita: ${e.toString()}';
        _isLoading = false;
      });
    }
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)));
    }
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Color(0xFF4CAF50), size: 60),
              const SizedBox(height: 12),
              Text(_errorMessage!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Color(0xFF666666))),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32)),
                onPressed: () => Navigator.pop(context),
                child: const Text('Kembali', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }
    if (_berita != null) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _berita!.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20), height: 1.4),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Oleh: ${_berita!.author}', style: const TextStyle(fontSize: 12, color: Color(0xFF666666))),
                Text(_berita!.publishedDate.substring(0, 10), style: const TextStyle(fontSize: 12, color: Color(0xFF2E7D32), fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 16),
            if (_berita!.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: _berita!.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
                    width: double.infinity,
                    height: 180,
                    color: const Color(0xFFE8F5E9),
                    child: const Icon(Icons.image_not_supported, color: Color(0xFF4CAF50), size: 48),
                  ),
                ),
              ),
            const SizedBox(height: 20),

            // ISI BERITA PAKAI flutter_html -> RAPI DAN SESUAI ASLI
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Html(
                data: _berita!.content,
                style: {
                  "p": Style(textAlign: TextAlign.justify, fontSize: FontSize(14), lineHeight: LineHeight(1.7), color: const Color(0xFF333333)),
                },
              ),
            ),

            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.visibility, color: Color(0xFF2E7D32), size: 16),
                  const SizedBox(width: 6),
                  Text('${_berita!.viewers} kali dilihat', style: const TextStyle(fontSize: 12, color: Color(0xFF1B5E20), fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return const Center(child: Text('Data tidak ditemukan'));
  }
}
