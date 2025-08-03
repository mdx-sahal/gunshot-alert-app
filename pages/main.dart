import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/map_page.dart';
import 'pages/alert_history_page.dart';
import 'pages/alert_details_page.dart';
import 'pages/signup_page.dart'; // Importing the SignupPage

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Mock Alerts
  static final List<Map<String, dynamic>> mockAlerts = [
    {
      "lat": 10.8505,
      "lng": 76.2711,
      "description": "Gunshot detected in Palakkad",
      "time": "10:30 AM",
      "date": "26 Feb 2025",
    },
    {
      "lat": 9.9312,
      "lng": 76.2673,
      "description": "Gunshot detected in Kochi",
      "time": "11:15 AM",
      "date": "26 Feb 2025",
    },
    {
      "lat": 8.5241,
      "lng": 76.9366,
      "description": "Gunshot detected in Thiruvananthapuram",
      "time": "12:00 PM",
      "date": "26 Feb 2025",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VIGILO',
      theme: ThemeData(primarySwatch: Colors.red),
      initialRoute: '/login', // Start with the Login Page
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => HomePage(mockAlerts: mockAlerts),
        '/map': (context) => MapPage(),
        '/history': (context) => AlertHistoryPage(alerts: mockAlerts),
        '/signup': (context) => const SignUpPage(), // New Route for SignupPage
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/alertDetails') {
          final alert = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => AlertDetailsPage(alert: alert),
          );
        }
        return null;
      },
    );
  }
}
