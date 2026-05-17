lib/controllers/berita_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart'; // ✅ TAMBAHKAN INI (supaya Colors & Color dikenali)
import '../models/berita_model.dart';
import '../services/api_service.dart';

class BeritaController extends GetxController {
  final RxList<BeritaModel> beritaList = <BeritaModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasMore = true.obs;
  int currentPage = 1;

  BeritaModel? beritaDetail;
  final RxBool isLoadingDetail = false.obs;
  RxString errorMessage = ''.obs;

  // Ambil daftar berita
  Future<void> loadBerita() async {
    if (isLoading.value) return;
    isLoading.value = true;
    errorMessage.value = '';

    try {
      if (currentPage > 19) {
        hasMore.value = false;
        return;
      }

      final newData = await ApiService.getBeritaByPage(currentPage);
      if (newData.isEmpty) {
        hasMore.value = false;
      } else {
        beritaList.addAll(newData);
        currentPage++;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Gagal Memuat',
        e.toString(),
        backgroundColor: Color(0xFF2E7D32), // ✅ HAPUS 'const' di sini
        colorText: Colors.white,             // ✅ Sudah bisa dipakai karena ada import
        duration: const Duration(seconds: 2),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh ulang daftar
  Future<void> refreshBerita() async {
    beritaList.clear();
    currentPage = 1;
    hasMore.value = true;
    await loadBerita();
  }

  // Ambil detail berita
  Future<void> loadBeritaDetail(String permalink) async {
    isLoadingDetail.value = true;
    errorMessage.value = '';
    beritaDetail = null;

    try {
      final data = await ApiService.getBeritaDetail(permalink);
      beritaDetail = data;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoadingDetail.value = false;
    }
  }
}
