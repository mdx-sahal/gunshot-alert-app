import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

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
    );
  }
}
