import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error(LocationServiceDisabledException());
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(LocationPermissionDeniedException());
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(LocationPermissionDeniedForeverException());
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);
  }

  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }
}

class LocationServiceDisabledException implements Exception {
  final String message = 'Location services are disabled.';
}

class LocationPermissionDeniedException implements Exception {
  final String message = 'Location permissions are denied.';
}

class LocationPermissionDeniedForeverException implements Exception {
  final String message = 'Location permissions are permanently denied.';
}
