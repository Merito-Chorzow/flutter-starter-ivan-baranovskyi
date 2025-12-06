import 'dart:convert';

class Entry {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final double? lat;
  final double? lng;
  final String? photoPath; // local path or remote URL

  Entry({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.lat,
    this.lng,
    this.photoPath,
  });

  factory Entry.fromJson(Map<String, dynamic> j) => Entry(
    id: j['id'].toString(),
    title: j['title'] ?? '',
    description: j['description'] ?? '',
    createdAt: DateTime.parse(
      j['createdAt'] ?? DateTime.now().toIso8601String(),
    ),
    lat: j['lat'] != null ? (j['lat'] as num).toDouble() : null,
    lng: j['lng'] != null ? (j['lng'] as num).toDouble() : null,
    photoPath: j['photoPath'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'createdAt': createdAt.toIso8601String(),
    'lat': lat,
    'lng': lng,
    'photoPath': photoPath,
  };

  @override
  String toString() => jsonEncode(toJson());
}
