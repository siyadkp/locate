import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DistanceBottomSheet extends StatelessWidget {
  final LatLng currentLocation;
  final LatLng destinationLocation;
  final double distanceInMeters;
  final String currentPlaceName;
  final String destinationPlaceName;

  DistanceBottomSheet({
    required this.currentLocation,
    required this.destinationLocation,
    required this.distanceInMeters,
    required this.currentPlaceName,
    required this.destinationPlaceName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 60,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Distance Information',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          _buildLocationInfo(
            title: 'Current Location',
            placeName: currentPlaceName,
            location: currentLocation,
          ),
          const SizedBox(height: 12),
          _buildLocationInfo(
            title: 'Destination',
            placeName: destinationPlaceName,
            location: destinationLocation,
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'Distance: ${(distanceInMeters / 1000).toStringAsFixed(2)} km',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildLocationInfo({
    required String title,
    required String placeName,
    required LatLng location,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.location_pin, color: Colors.blueGrey, size: 24),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              Text(
                placeName,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              Text(
                '(${location.latitude.toStringAsFixed(6)}, ${location.longitude.toStringAsFixed(6)})',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
