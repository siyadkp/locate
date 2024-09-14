import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controller/map_controller.dart';

class MapView extends StatelessWidget {
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapController>(
      // GetX controller for map
      init: MapController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Map Location & Distance'),
            backgroundColor: Colors.blue,
          ),
          body: Column(
            children: [
              // TextField for entering the address
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Enter an address',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (addressController.text.isNotEmpty) {
                    controller.searchAddress(addressController.text);
                  }
                },
                child: const Text('Find Location'),
              ),
              Expanded(
                child: GoogleMap(
                  onMapCreated: controller.onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: controller.currentPosition ?? const LatLng(0, 0),
                    zoom: 15.0,
                  ),
                  markers: {
                    if (controller.userMarker != null) controller.userMarker!,
                    if (controller.destinationMarker != null)
                      controller.destinationMarker!,
                  },
                ),
              ),
              if (controller.distance != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      'Distance: ${controller.distance!.toStringAsFixed(2)} km'),
                ),
            ],
          ),
        );
      },
    );
  }
}
