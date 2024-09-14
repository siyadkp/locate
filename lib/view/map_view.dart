import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import '../controller/map_controller.dart';

class LocationDistanceView extends StatelessWidget {
  final LocationController controller = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map display with markers and polylines ----------------------------
          _buildMap(),

          // Search bar and find distance button -------------------------------
          _buildSearchBarAndButton(context),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  /// Builds the Google Map with markers and polylines. ------------------------
  Widget _buildMap() {
    return GetBuilder<LocationController>(
      builder: (_) => GoogleMap(
        zoomControlsEnabled: false,
        onMapCreated: controller.setMapController,
        initialCameraPosition: CameraPosition(
          target: controller.currentLocation,
          zoom: 14,
        ),
        markers: controller.markers,
        polylines: controller.polylines,
      ),
    );
  }

  /// Builds the search bar and the find distance button. ----------------------
  Widget _buildSearchBarAndButton(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            // TextFormField with search icon, shadow, and rounded corners
            _buildSearchTextField(),

            const SizedBox(
                width: 10), // Space between the form field and the button

            // Find Distance Button
            _buildFindDistanceButton(context),
          ],
        ),
      ),
    );
  }

  /// Builds the TextFormField with a search icon. -----------------------------
  Widget _buildSearchTextField() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Background color of the TextFormField
          borderRadius: BorderRadius.circular(25), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // Shadow position
            ),
          ],
        ),
        child: TextFormField(
          controller: controller.addressController,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search, color: Colors.grey), // Search icon
            hintText: 'Enter Address',
            border: InputBorder.none, // Remove the default border
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15, // Padding inside the TextFormField
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the Find Distance Button. -----------------------------------------
  Widget _buildFindDistanceButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => controller
          .calculateDistanceAndRoute(context), // Pass context for BottomSheet
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, // Button color
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15, // Padding inside the button
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25), // Rounded button
        ),
      ),
      child: const Icon(
        Icons.search,
        color: Colors.white,
      ), // Icon inside the button
    );
  }

  /// Builds the Floating Action Button for current location. ------------------
  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: Colors.blue,
      onPressed: controller.getCurrentLocation,
      child: const Icon(
        Icons.my_location,
        color: Colors.white,
      ),
    );
  }
}
