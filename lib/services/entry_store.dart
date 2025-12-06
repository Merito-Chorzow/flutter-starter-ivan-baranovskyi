import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/entry.dart';
import 'api_service.dart';

class EntryStore extends ChangeNotifier {
  final ApiService _api = ApiService();
  final List<Entry> _items = [];
  bool isLoading = false;
  String? error;
  bool isDark = false;

  List<Entry> get items => List.unmodifiable(_items);

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final list = await _api.fetchEntries();
      _items.clear();
      _items.addAll(list);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addLocal({
    required String title,
    required String description,
    double? lat,
    double? lng,
    String? photoPath,
  }) async {
    final e = Entry(
      id: const Uuid().v4(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
      lat: lat,
      lng: lng,
      photoPath: photoPath,
    );
    _items.insert(0, e);
    notifyListeners();
    // Try to post to API, but don't crash on failure.
    try {
      final posted = await _api.postEntry(e);
      // Replace local item with server response (if server provides id or additional data)
      _items.removeWhere((it) => it.id == e.id);
      _items.insert(0, posted);
      notifyListeners();
    } catch (_) {
      // keep local entry; could mark as unsynced in a real app
    }
  }

  Entry? getById(String id) => _items.firstWhere(
    (e) => e.id == id,
    orElse: () => Entry(
      id: id,
      title: 'Not found',
      description: '',
      createdAt: DateTime.now(),
    ),
  );

  void toggleTheme() {
    isDark = !isDark;
    notifyListeners();
  }
}
