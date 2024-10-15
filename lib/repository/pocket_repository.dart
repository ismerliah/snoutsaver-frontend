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

  Future<List<Pocket>> fetchPockets() async {
     try {
      String? token = await storage.read(key: "token");

      final user = await UserRepository().fetchUserDetails();
      final userId = user.id.toString();
      var response = await http.get(
        Uri.parse("http://10.0.2.2:8000/pockets/$userId"),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Debug: Print the exact structure of the 'responseData'
        print("Response Data: $responseData");

        // Check if 'items' exists and is a list
        if (responseData['items'] != null && responseData['items'] is List) {
          final List<dynamic> items = responseData['items'];

          // Debug: Print the items to verify it's a list of maps
          print("Items: $items");

          // Convert the list of dynamic maps to List<Pocket>
          return items.map((pocketData) {
            // Print each pocketData for verification
            print("Pocket Data: $pocketData");
            return Pocket.fromJson(pocketData);
          }).toList();
        } else {
          throw Exception("Unexpected data structure for 'items'");
        }
      } else {
        print("API Error: ${response.statusCode} - ${response.body}");
        throw Exception("Failed to fetch pockets");
      }
    } catch (e) {
      print("Error in fetchPockets: $e");
      throw Exception(e);
    }
  }
}