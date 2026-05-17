// lib/models/berita_model.dart
class BeritaModel {
  final String id;
  final String title;
  final String subtitle;
  final String content;
  final String imageUrl;
  final String publishedDate;
  final String author;
  final int viewers;
  final String permalink;

  BeritaModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.imageUrl,
    required this.publishedDate,
    required this.author,
    required this.viewers,
    required this.permalink,
  });

  factory BeritaModel.fromJson(Map<String, dynamic> json) {
    return BeritaModel(
      id: json['id'].toString(),
      title: json['meta_title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['meta_image_id'] ?? '',
      publishedDate: json['published_date'] ?? '',
      author: json['author'] ?? '',
      viewers: json['viewers'] ?? 0,
      permalink: json['permalink'] ?? '',
    );
  }
}
