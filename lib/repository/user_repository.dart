import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  final storage = const FlutterSecureStorage();
  
  Future<void> createUser({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    var response = await http.post(
      Uri.parse("http://10.0.2.2:8000/users/create"),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        "username": username,
        "email": email,
        "password": password,
        "confirm_password": confirmPassword,
        // "provider": "default",
      }),
    );

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 400) {
      final Map<String, dynamic> result = jsonDecode(response.body);
      if (result['detail'] == "Username already exists") {
        throw Exception("Username already exists");
      } else if (result['detail'] == "Email already exists") {
        throw Exception("Email already exists");
      } else if (result['detail'] == "Passwords do not match") {
        throw Exception("Passwords do not match");
      }
    } else {
      throw Exception("Failed to authenticate: ${response.body}");
    }
  }

  Future<void> createUserwithGoogle({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    var response = await http.post(
      Uri.parse("http://10.0.2.2:8000/users/create"),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        "username": username,
        "email": email,
        "password": password,
        "confirm_password": confirmPassword,
        // "provider": "google",
      }),
    );
    if (response.statusCode == 200) {
      return;
    }
  }

  Future<void> signinUser({
    required String username,
    required String password,
  }) async {
    var response = await http.post(
      Uri.parse("http://10.0.2.2:8000/token"),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        "username": username,
        "password": password,
      },
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // Store the token securely
      String? accessToken = data['access_token'];
      if (accessToken != null) {
        await storage.write(key: "accesstoken", value: accessToken);
        // Check token
        String? storedToken = await storage.read(key: "accesstoken");
        if (storedToken != null) {
          return;
        } else {
          throw Exception("Access token not stored");
        }
      } 
    } else {
      throw Exception("Failed to authenticate: ${response.body}");
    }
  }
}
