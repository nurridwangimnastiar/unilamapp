import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/berita_card.dart';
import '../services/api_service.dart';
import '../models/berita_model.dart';

class BeritaListScreen extends StatefulWidget {
  const BeritaListScreen({super.key});

  @override
  State<BeritaListScreen> createState() => _BeritaListScreenState();
}

class _BeritaListScreenState extends State<BeritaListScreen> {
  final List<BeritaModel> _beritaList = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadBerita();
    // Deteksi scroll sampai bawah untuk load halaman selanjutnya
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading &&
          _hasMore) {
        _loadBerita();
      }
    });
  }

  Future<void> _loadBerita() async {
    setState(() => _isLoading = true);
    try {
      // Ambil data sesuai halaman (maksimal sampai halaman 19 sesuai dokumentasi API)
      if (_currentPage > 19) {
        setState(() {
          _hasMore = false;
          _isLoading = false;
        });
        return;
      }

      final newData = await ApiService.getBeritaByPage(_currentPage);
      setState(() {
        if (newData.isEmpty) {
          _hasMore = false;
        } else {
          _beritaList.addAll(newData);
          _currentPage++;
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat data: ${e.toString()}'),
            backgroundColor: const Color(0xFF2E7D32),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
    setState(() => _isLoading = false);
  }

  // Tarik ke atas untuk refresh ulang
  Future<void> _onRefresh() async {
    setState(() {
      _beritaList.clear();
      _currentPage = 1;
      _hasMore = true;
    });
    await _loadBerita();
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
          onRefresh: _onRefresh,
          color: const Color(0xFF2E7D32),
          child: _beritaList.isEmpty && !_isLoading
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
                  itemCount: _beritaList.length + (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Tampilkan loading di paling bawah
                    if (index == _beritaList.length) {
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
                    return BeritaCard(berita: _beritaList[index]);
                  },
                ),
        ),
      ),
    );
  }
}
