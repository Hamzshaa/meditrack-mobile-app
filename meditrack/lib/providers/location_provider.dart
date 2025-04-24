import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:meditrack/data/services/location_service.dart';

part 'location_provider.g.dart';

@riverpod
LocationService locationService(LocationServiceRef ref) {
  return LocationService();
}

@riverpod
class CurrentLocation extends _$CurrentLocation {
  @override
  Future<Position> build() async {
    return _fetchLocation();
  }

  Future<Position> _fetchLocation() async {
    final service = ref.read(locationServiceProvider);
    try {
      return await service.getCurrentLocation();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> refreshLocation() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() => _fetchLocation());
  }

  Future<bool> openSettings() async {
    final service = ref.read(locationServiceProvider);
    return service.openLocationSettings();
  }
}
