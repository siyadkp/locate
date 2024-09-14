import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import '../widget/bottom_sheet/bottom_sheet_widget.dart';

class LocationController extends GetxController {
  late GoogleMapController mapController;
  LatLng currentLocation = const LatLng(0, 0);
  LatLng? destinationLocation;
  double? distanceInMeters;
  String? currentPlaceName;
  String? destinationPlaceName;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {}; // For route display
  final TextEditingController addressController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  // Fetch current location ----------------------------------------------------
  Future<void> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      currentLocation = LatLng(position.latitude, position.longitude);
      markers.add(Marker(
        markerId: const MarkerId('currentLocation'),
        position: currentLocation,
        infoWindow: const InfoWindow(title: 'Current Location'),
      ));
      update(); // Updates the UI with the new location

      mapController
          .animateCamera(CameraUpdate.newLatLngZoom(currentLocation, 14));

      // Fetch the place name for the current location
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        currentPlaceName =
            '${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.country}';
        update(); // Update UI with the place name
      }
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  // Calculate the distance and plot the route ---------------------------------
  Future<void> calculateDistanceAndRoute(BuildContext context) async {
    try {
      String address = addressController.text;
      if (address.isEmpty) {
        // Show a message if the address field is empty
        Get.snackbar(
          'Error',
          'Please enter an address to find the distance.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        destinationLocation = LatLng(location.latitude, location.longitude);

        distanceInMeters = Geolocator.distanceBetween(
          currentLocation.latitude,
          currentLocation.longitude,
          destinationLocation!.latitude,
          destinationLocation!.longitude,
        );

        markers.add(Marker(
          markerId: const MarkerId('destination'),
          position: destinationLocation!,
          infoWindow: const InfoWindow(title: 'Destination'),
        ));

        polylines.add(Polyline(
          polylineId: const PolylineId('route'),
          color: Colors.blue,
          width: 5,
          points: [currentLocation, destinationLocation!],
        ));

        update(); // Updates the UI with the new route and distance

        mapController.animateCamera(
          CameraUpdate.newLatLngZoom(destinationLocation!, 14),
        );

        // Fetch the place name for the destination location -------------------
        List<Placemark> placemarks = await placemarkFromCoordinates(
          destinationLocation!.latitude,
          destinationLocation!.longitude,
        );
        if (placemarks.isNotEmpty) {
          destinationPlaceName =
              '${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.country}';
        } else {
          // Handle case where place name could not be fetched
          destinationPlaceName =
              'Address found, but place name could not be determined';
        }
        update();

        // Show bottom sheet with distance information -------------------------
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          builder: (context) => DistanceBottomSheet(
            currentLocation: currentLocation,
            destinationLocation: destinationLocation!,
            distanceInMeters: distanceInMeters!,
            currentPlaceName: currentPlaceName ?? 'Unknown',
            destinationPlaceName: destinationPlaceName!,
          ),
        );
      } else {
        // Show a message if no locations are found for the address
        Get.snackbar(
          'Error',
          'No results found for the provided address.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("Error calculating distance and route: $e");
      // Show an error message in case of an exception
      Get.snackbar(
        'Error',
        'An error occurred while calculating the distance. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }
}
