import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'alert_details_page.dart';

class AlertHistoryPage extends StatefulWidget {
  final List<Map<String, dynamic>> alerts;

  const AlertHistoryPage({super.key, required this.alerts});

  @override
  State<AlertHistoryPage> createState() => _AlertHistoryPageState();
}

class _AlertHistoryPageState extends State<AlertHistoryPage> {
  List<Map<String, dynamic>> filteredAlerts = [];
  String? selectedSortingOption;
  DateTime? selectedDate;
  TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredAlerts = widget.alerts;
  }

  void _filterByDate(DateTime date) {
    setState(() {
      selectedDate = date;
      filteredAlerts =
          widget.alerts.where((alert) {
            final alertDate = DateFormat('dd MMM yyyy').parse(alert['date']);
            return alertDate == date;
          }).toList();
    });
  }

  void _filterByLocation(String location) {
    setState(() {
      filteredAlerts =
          widget.alerts.where((alert) {
            return alert["description"].toLowerCase().contains(
              location.toLowerCase(),
            );
          }).toList();
    });
  }

  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      _filterByDate(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5B3A83), // Set background color
      appBar: AppBar(
        title: const Text(
          "Alert History",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF3D2968), // Darker shade for AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range, color: Colors.white),
            onPressed: _pickDate,
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: locationController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: "Search by Location",
                hintText: "Enter location name...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: _filterByLocation,
            ),
          ),
          Expanded(
            child:
                filteredAlerts.isEmpty
                    ? const Center(
                      child: Text(
                        "No alerts available",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    )
                    : ListView.builder(
                      itemCount: filteredAlerts.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: const Color(
                            0xFF3D2968,
                          ), // Darker shade for cards
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            title: Text(
                              filteredAlerts[index]["description"],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              "Date: ${filteredAlerts[index]["date"]}, Time: ${filteredAlerts[index]["time"]}",
                              style: const TextStyle(color: Colors.white70),
                            ),
                            leading: const Icon(
                              Icons.history,
                              color: Colors.orangeAccent,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => AlertDetailsPage(
                                        alert: filteredAlerts[index],
                                      ),
                                ),
                              );
                            },
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
