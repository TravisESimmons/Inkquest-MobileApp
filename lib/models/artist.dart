// lib/models/artist.dart
class Artist {
  final String name;
  final String style;
  final int rate;

  Artist({required this.name, required this.style, required this.rate});

  factory Artist.fromMap(Map<String, dynamic> data) {
    return Artist(
      name: data['name'] ?? '',
      style: data['style'] ?? '',
      rate: data['rate'] ?? 0,
    );
  }
}
