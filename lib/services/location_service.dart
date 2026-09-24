import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    // Check location service enabled hai ya nahi
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception('Location service is disabled');
    }

    // Permission check
    LocationPermission permission =
    await Geolocator.checkPermission();

    // Permission nahi mili to request karo
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }

    // Permission permanently denied
    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permission permanently denied',
      );
    }

    // Current location
    return await Geolocator.getCurrentPosition();
  }
}