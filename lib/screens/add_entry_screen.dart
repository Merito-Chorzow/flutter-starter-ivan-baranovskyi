import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../services/location_service.dart';
import '../services/entry_store.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Запит дозволу на доступ до локації
  Future<bool> requestPermission() async {
    LocationPermission permission;

    // Перевіряємо поточний статус дозволу
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true; // дозвіл надано
  }

  /// Повертає поточну позицію
  Future<Position> getCurrent() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({Key? key}) : super(key: key);

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _titleC = TextEditingController();
  final _descC = TextEditingController();
  double? _lat;
  double? _lng;
  String? _photoPath;
  bool _loadingLocation = false;
  bool _submitting = false; // додано, щоб уникнути помилок

  final _loc = LocationService();

  Future<void> _pickImage() async {
    final p = ImagePicker();
    final res = await p.pickImage(source: ImageSource.camera, maxWidth: 1024);
    if (res != null) {
      setState(() {
        _photoPath = res.path;
      });
    }
  }

  Future<void> _getLocation() async {
    setState(() => _loadingLocation = true);
    try {
      // Виклик методу requestPermission з LocationService
      final ok = await _loc.requestPermission();
      if (!ok) throw Exception('Brak uprawnień do lokalizacji');
      final pos = await _loc.getCurrent();
      setState(() {
        _lat = pos.latitude;
        _lng = pos.longitude;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd pobierania lokalizacji: $e')),
      );
    } finally {
      setState(() => _loadingLocation = false);
    }
  }

  Future<void> _submit() async {
    if (_titleC.text.isEmpty) return;
    setState(() => _submitting = true);
    try {
      await Provider.of<EntryStore>(context, listen: false).addLocal(
        title: _titleC.text,
        description: _descC.text,
        lat: _lat,
        lng: _lng,
        photoPath: _photoPath,
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Błąd: $e')));
    } finally {
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dodaj wpis')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleC,
              decoration: const InputDecoration(labelText: 'Tytuł'),
            ),
            TextField(
              controller: _descC,
              decoration: const InputDecoration(labelText: 'Opis'),
              maxLines: 3,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _loadingLocation ? null : _getLocation,
                  icon: const Icon(Icons.my_location),
                  label: const Text('Pobierz lokalizację'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Zrób zdjęcie'),
                ),
              ],
            ),
            if (_lat != null) Text('Lokalizacja: $_lat, $_lng'),
            if (_photoPath != null) Text('Zdjęcie: $_photoPath'),
            const Spacer(),
            ElevatedButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Zapisz'),
            ),
          ],
        ),
      ),
    );
  }
}
