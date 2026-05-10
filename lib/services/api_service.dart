import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/berita_model.dart';

class ApiService {
  static const String baseUrl = 'https://unilam.ac.id/api/v1';

  // Ambil daftar berita per halaman (1 - 19)
  static Future<List<BeritaModel>> getBeritaByPage(int page) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/berita?page=$page'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
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
      final response = await http.get(Uri.parse(permalink));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return BeritaModel.fromJson(data['data']);
      }
      return null;
    } catch (e) {
      throw Exception('Error mengambil detail: $e');
    }
  }
}
