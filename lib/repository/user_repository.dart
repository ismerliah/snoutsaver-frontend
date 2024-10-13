import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:snoutsaver/models/userdetail.dart';

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
        "provider": "default",
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
    required String profile_picture,
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
        "provider": "google",
        "profile_picture": profile_picture
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
      String? refreshToken = data['refresh_token'];
      String? expiresAt = data['expires_at'];
      if (refreshToken != null) {
        await storage.write(key: "token", value: refreshToken);
        await storage.write(key: "expires_at", value: expiresAt);
        // Check token
        String? storedToken = await storage.read(key: "token");
        if (storedToken != null) {
          return;
        } else {
          throw Exception("Refresh token not stored");
        }
      }
    } else {
      throw Exception("Failed to authenticate: ${response.body}");
    }
  }

  Future<UserDetail> fetchUserDetails() async {
    try {
      String? token = await storage.read(key: "token");
      var response = await http.get(
        Uri.parse("http://10.0.2.2:8000/users/me"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return UserDetail.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        throw Exception("Failed to fetch user details: ${response.body}");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateUserDetail({
    required String email,
    required String username,
    required String? firstName,
    required String? lastName,
    required String? profilePicture,
  }) async {
    try {
      String? token = await storage.read(key: "token");
      final user = await UserRepository().fetchUserDetails();
      final user_id = user.id.toString();

      var response = await http.put(
        Uri.parse("http://10.0.2.2:8000/users/$user_id/update"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          "email": email,
          "username": username,
          "first_name": firstName,
          "last_name": lastName,
          "profile_picture": profilePicture,
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
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      String? token = await storage.read(key: "token");
      final user = await UserRepository().fetchUserDetails();
      final user_id = user.id.toString();

      var response = await http.put(
        Uri.parse("http://10.0.2.2:8000/users/$user_id/change_password"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
           "current_password": currentPassword,
           "new_password": newPassword
        }),
      );

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 400) {
        final Map<String, dynamic> result = jsonDecode(response.body);
        if (result['detail'] == "Current password is incorrect") {
          throw Exception("Current password is incorrect");
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
