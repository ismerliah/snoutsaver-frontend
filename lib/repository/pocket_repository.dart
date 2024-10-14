import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:snoutsaver/models/pocket.dart';
import 'package:snoutsaver/repository/user_repository.dart';

class PocketRepository {
  final storage = const FlutterSecureStorage();
  Future<void> createSetupPocket({
    required String name,
    required double balance,
    required List<Map<String, dynamic>> monthlyExpenses,
  }
  ) async {
    final Map<String, dynamic> setupPocketData = {
      "name": name,
      "balance": balance,
      "monthly_expenses": monthlyExpenses,
    };

    String? token = await storage.read(key: 'token');

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/pockets'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(setupPocketData),
    );

    if (response.statusCode == 200) {
      print("Created setup pocket successfully");
    } else {
      print("Error: ${response.statusCode}");
      print("Message: ${response.body}");
      throw Exception("Failed to create setup pocket");
    }
  }

  Future<Pocket> fetchPockets() async {
     try {
      String? token = await storage.read(key: "token");

      final user = await UserRepository().fetchUserDetails();
      final user_id = user.id.toString();
      var response = await http.get(
        Uri.parse("http://10.0.2.2:8000/pockets/$user_id"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return Pocket.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        throw Exception("Failed to fetch user details: ${response.body}");
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}