import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart'; // Import FilePicker
import 'package:flutter/foundation.dart';

class ApiService {
  // Use 10.0.2.2 for Android Emulator, localhost for iOS/Web
  static const String baseUrl = kIsWeb || !Platform.isAndroid 
      ? "http://127.0.0.1:5000" 
      : "http://10.0.2.2:5000";

  Future<Map<String, dynamic>> predictGunshot(PlatformFile file) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/predict'),
      );
      
      if (kIsWeb) {
        // Web: Use bytes
        if (file.bytes != null) {
            request.files.add(
              http.MultipartFile.fromBytes(
                'file',
                file.bytes!,
                filename: file.name,
              ),
            );
        } else {
             return {"error": "File bytes are empty on web"};
        }
      } else {
        // Mobile/Desktop: Use path
        if (file.path != null) {
            request.files.add(
              await http.MultipartFile.fromPath(
                'file',
                file.path!,
              ),
            );
        } else {
             return {"error": "File path is null"};
        }
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          "error": "Server error: ${response.statusCode}",
          "details": response.body
        };
      }
    } catch (e) {
      return {"error": "Connection failed", "details": e.toString()};
    }
  }
}
