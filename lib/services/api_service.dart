import 'package:dio/dio.dart';
import '../models/berita_model.dart';

class ApiService {
  static const String baseUrl = 'https://unilam.ac.id/api/v1';
  static final Dio _dio = Dio();

  // Ambil daftar berita per halaman (1 - 19)
  static Future<List<BeritaModel>> getBeritaByPage(int page) async {
    try {
      final response = await _dio.get('$baseUrl/berita?page=$page');
      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> list = data['datas']['data'];
        return list.map((json) => BeritaModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Error mengambil data: $e');
    }
  }

  // Ambil detail berita berdasarkan permalink
  static Future<BeritaModel?> getBeritaDetail(String permalink) async {
    try {
      final response = await _dio.get(permalink);
      if (response.statusCode == 200) {
        final data = response.data;
        return BeritaModel.fromJson(data['data']);
      }
      return null;
    } catch (e) {
      throw Exception('Error mengambil detail: $e');
    }
  }
}
