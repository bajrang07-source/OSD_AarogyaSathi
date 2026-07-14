/// Location service stub.
/// Phase 5: Implement with geolocator package.
class LocationService {
  LocationService._();
  static final LocationService instance = LocationService._();

  // Returns (lat, lng) or null if permission denied / unavailable
  Future<(double, double)?> getCurrentLocation() async {
    // TODO Phase 5: use geolocator to get GPS fix
    return null;
  }

  Future<bool> requestPermission() async {
    // TODO Phase 5: permission_handler
    return false;
  }
}
