import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatelessWidget {
  final List<Map<String, dynamic>> alerts = [
    {
      "lat": 10.8505,
      "lng": 76.2711,
      "description": "Gunshot detected in Palakkad",
    },
    {"lat": 9.9312, "lng": 76.2673, "description": "Gunshot detected in Kochi"},
    {
      "lat": 8.5241,
      "lng": 76.9366,
      "description": "Gunshot detected in Thiruvananthapuram",
    },
  ];

  MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gunshot Detection Map")),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(10.8505, 76.2711), // Kerala
          initialZoom: 7.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers:
                alerts.map((alert) {
                  return Marker(
                    point: LatLng(alert["lat"], alert["lng"]),
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 30,
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
