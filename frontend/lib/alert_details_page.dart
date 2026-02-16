import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AlertDetailsPage extends StatelessWidget {
  final Map<String, dynamic> alert;

  const AlertDetailsPage({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF7E57C2), // Same violet shade as Home Page
      appBar: AppBar(title: const Text("Alert Details")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert["description"],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "📍 Location: (${alert["lat"]}, ${alert["lng"]})",
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  "🕒 Time: ${alert["time"]}",
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  "📅 Date: ${alert["date"]}",
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(alert["lat"], alert["lng"]),
                initialZoom: 15.0, // Close-up view
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(alert["lat"], alert["lng"]),
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
