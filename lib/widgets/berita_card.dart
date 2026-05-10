// lib/widgets/berita_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; // <-- TAMBAHKAN INI
import '../models/berita_model.dart'; // <-- UBAH PATHNYA KE models
import '../routes/app_routes.dart';

class BeritaCard extends StatelessWidget {
  final BeritaModel berita;

  const BeritaCard({super.key, required this.berita});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          AppRoutes.navigateToBeritaDetail(context, berita.id, berita.title, berita.permalink);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Berita - PAKAI CachedNetworkImage
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: berita.imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: berita.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 80,
                          height: 80,
                          color: const Color(0xFFE8F5E9),
                          child: const CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF2E7D32)),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 80,
                          height: 80,
                          color: const Color(0xFFE8F5E9),
                          child: const Icon(Icons.image_not_supported, color: Color(0xFF4CAF50)),
                        ),
                      )
                    : Container(
                        width: 80,
                        height: 80,
                        color: const Color(0xFFE8F5E9),
                        child: const Icon(Icons.article, color: Color(0xFF4CAF50)),
                      ),
              ),
              const SizedBox(width: 12),
              // Konten Teks
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      berita.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B5E20),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      berita.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          berita.publishedDate.substring(0, 10),
                          style: const TextStyle(fontSize: 11, color: Color(0xFF2E7D32)),
                        ),
                        Text(
                          '${berita.viewers} dilihat',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF4CAF50)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
