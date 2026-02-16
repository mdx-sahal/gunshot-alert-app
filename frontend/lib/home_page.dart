import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'api_service.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> mockAlerts;

  const HomePage({super.key, required this.mockAlerts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5B2C6F), // Violet Shade
      appBar: AppBar(
        title: Text(
          "VIGILO",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w800,
            fontSize: 32, // Increased font size
            letterSpacing: 1.5,
            color: Colors.white, // White color for the title
          ),
        ),
        backgroundColor: const Color(
          0xFF4A235A,
        ), // Darker Violet Shade for AppBar
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ZoomIn(
                  child: Column(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.map,
                          size: 40,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/map');
                        },
                      ),
                      const Text(
                        "Maps",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                ZoomIn(
                  child: Column(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.history,
                          size: 40,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/history');
                        },
                      ),
                      const Text(
                        "Alert History",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child:
                mockAlerts.isEmpty
                    ? FadeIn(
                      child: const Center(
                        child: Text(
                          "No alerts available",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                    : ListView.separated(
                      itemCount: mockAlerts.length,
                      separatorBuilder:
                          (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final alert = mockAlerts[index];
                        return FadeInUp(
                          delay: Duration(milliseconds: index * 100),
                          child: Card(
                            color: const Color(
                              0xFFD7BDE2,
                            ), // Light Violet Shade for Cards
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12),
                              title: Text(
                                alert["description"],
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                "Time: ${alert["time"]}, Date: ${alert["date"]}",
                                style: GoogleFonts.poppins(
                                  color: Colors.black87,
                                ),
                              ),
                              leading: const Icon(
                                Icons.warning,
                                color: Colors.red,
                                size: 32,
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                                color: Colors.grey,
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/alertDetails',
                                  arguments: alert,
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// ... (imports remain)

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['wav'],
          );

          if (result != null) {
            PlatformFile file = result.files.single;
            
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(child: CircularProgressIndicator()),
            );

            final apiService = ApiService();
            final response = await apiService.predictGunshot(file);

            if (context.mounted) Navigator.pop(context);

            if (context.mounted) {
              bool isError = response.containsKey('error');
              String prediction = response['prediction'] ?? "Unknown";
              bool isGunshot = prediction == "Gunshot Detected";
              
              LatLng? currentLocation;
              if (isGunshot && !isError) {
                try {
                  LocationPermission permission = await Geolocator.checkPermission();
                  if (permission == LocationPermission.denied) {
                    permission = await Geolocator.requestPermission();
                  }
                  if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
                    Position position = await Geolocator.getCurrentPosition();
                    currentLocation = LatLng(position.latitude, position.longitude);
                  }
                } catch (e) {
                  debugPrint("Error getting location: $e");
                }
              }

              if (!context.mounted) return;

              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                     isError ? "Error" : "Analysis Result",
                     style: TextStyle(color: isError || isGunshot ? Colors.red : Colors.green),
                  ),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isError)
                          Text(response['error'].toString())
                        else ...[
                           Text(
                            prediction.toUpperCase(),
                            style: TextStyle(
                              fontSize: 24, 
                              fontWeight: FontWeight.bold,
                              color: isGunshot ? Colors.red : Colors.green
                            ),
                           ),
                           const SizedBox(height: 10),
                           if (isGunshot && currentLocation != null) ...[
                             const Text("Incident Location Detected:", style: TextStyle(fontWeight: FontWeight.bold)),
                             const SizedBox(height: 10),
                             SizedBox(
                               height: 200,
                               child: FlutterMap(
                                 options: MapOptions(
                                   initialCenter: currentLocation,
                                   initialZoom: 15.0,
                                 ),
                                 children: [
                                   TileLayer(
                                     urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                     subdomains: const ['a', 'b', 'c'],
                                   ),
                                   MarkerLayer(
                                     markers: [
                                       Marker(
                                         point: currentLocation,
                                         child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                                       ),
                                     ],
                                   ),
                                 ],
                               ),
                             ),
                           ] else if (isGunshot)
                             const Text("Location access needed to pin incident."),
                        ]
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );
            }
          }
        },
        label: const Text("Analyze Audio"),
        icon: const Icon(Icons.mic),
        backgroundColor: const Color(0xFFD7BDE2),
      ),
    );
  }
}
