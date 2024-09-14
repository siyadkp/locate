import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../service/location_service.dart';

class MapController extends GetxController {
  GoogleMapController? mapController; // Controller for GoogleMap
  LatLng? currentPosition; // Store user's current location
  Marker? userMarker; // Marker for user's current location
  Marker? destinationMarker; // Marker for entered address
  double? distance; // Distance between current location and entered address

  // Initialize location
  @override
  void onInit() {
    super.onInit();
    getUserCurrentLocation();
  }

  // Function to fetch user's current location
  Future<void> getUserCurrentLocation() async {
    Position position = await LocationService.getCurrentLocation();
    currentPosition = LatLng(position.latitude, position.longitude);
    userMarker = Marker(
      markerId: MarkerId('currentLocation'),
      position: currentPosition!,
      infoWindow: InfoWindow(title: 'You are here'),
    );
    update(); // Notify UI about changes
  }

  // Function to convert address to coordinates and calculate distance
  Future<void> searchAddress(String address) async {
    List<Location> locations =
        await LocationService.getCoordinatesFromAddress(address);
    if (locations.isNotEmpty) {
      LatLng destPosition =
          LatLng(locations[0].latitude, locations[0].longitude);
      destinationMarker = Marker(
        markerId: MarkerId('destination'),
        position: destPosition,
        infoWindow: InfoWindow(title: 'Destination'),
      );

      distance = LocationService.calculateDistance(
        currentPosition!.latitude,
        currentPosition!.longitude,
        destPosition.latitude,
        destPosition.longitude,
      );
      update(); // Notify UI
    }
  }

  // Called when the map is created
  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
}
