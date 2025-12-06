import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/entry.dart';

class ApiService {
  // Replace with your real endpoint when available.
  static const baseUrl = 'https://example.com/api';

  Future<List<Entry>> fetchEntries() async {
    final uri = Uri.parse('\$baseUrl/entries');
    final resp = await http.get(uri).timeout(const Duration(seconds: 10));
    if (resp.statusCode == 200) {
      final list = jsonDecode(resp.body) as List;
      return list.map((e) => Entry.fromJson(e)).toList();
    } else {
      throw Exception('API error: \${resp.statusCode}');
    }
  }

  Future<Entry> postEntry(Entry e) async {
    final uri = Uri.parse('\$baseUrl/entries');
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(e.toJson()),
    );
    if (resp.statusCode == 201 || resp.statusCode == 200) {
      return Entry.fromJson(jsonDecode(resp.body));
    } else {
      throw Exception('API post error: \${resp.statusCode}');
    }
  }
}
