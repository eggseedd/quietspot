import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationMap extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String locationName;
  final bool isInteractive;

  const LocationMap({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.locationName,
    this.isInteractive = false,
  });

  @override
  Widget build(BuildContext context) {
    final latLng = LatLng(latitude, longitude);

    return FlutterMap(
      options: MapOptions(
        initialCenter: latLng,
        initialZoom: 15,
        interactionOptions: InteractionOptions(
          flags: isInteractive
              ? InteractiveFlag.all
              : InteractiveFlag.none,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.quietspot',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: latLng,
              width: 120,
              height: 100,
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 110),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      locationName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Icon(
                    Icons.location_on,
                    color: Colors.red[600],
                    size: 32,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
