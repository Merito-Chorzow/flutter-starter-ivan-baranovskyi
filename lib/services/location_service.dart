import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<bool> ensurePermission() async {
    LocationPermission p = await Geolocator.checkPermission();
    if (p == LocationPermission.denied) {
      p = await Geolocator.requestPermission();
    }
    return p == LocationPermission.always || p == LocationPermission.whileInUse;
  }

  Future<Position> getCurrent() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) throw Exception('Location services disabled');
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
  }
}
