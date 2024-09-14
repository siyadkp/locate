import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  // Get the current location of the user
  static Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  // Convert an address to coordinates (latitude and longitude)
  static Future<List<Location>> getCoordinatesFromAddress(
      String address) async {
    return await locationFromAddress(address);
  }

  // Calculate distance between two points in kilometers
  static double calculateDistance(
      double startLat, double startLng, double endLat, double endLng) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng) /
        1000; // in kilometers
  }
}
