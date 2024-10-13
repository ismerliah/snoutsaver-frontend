import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SetupRepository {
  final storage = const FlutterSecureStorage();

  Future<bool> hasSetupData() async {
    String? token = await storage.read(key: 'token');

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/setups'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 404) {
      return false;
    } else {
      throw Exception("Failed to check setup status: ${response.statusCode}");
    }
  }
  
  Future<Map<String, dynamic>> fetchSetupData() async {
    String? token = await storage.read(key: 'token');

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/setups'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch setup data: ${response.statusCode}");
    }
  }

  Future<void> submitSetup({
    required double monthlyIncome,
    required List<Map<String, dynamic>> monthlyExpenses,
    required double savingGoal,
    required int year,
  }) async {
    final Map<String, dynamic> setupData = {
      "monthly_income": monthlyIncome,
      "monthly_expenses": monthlyExpenses,
      "saving_goal": savingGoal,
      "year": year,
    };

    String? token = await storage.read(key: 'token');

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/setups'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(setupData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Setup submitted successfully.");
    } else {
      print("Error: ${response.statusCode}");
      print("Message: ${response.body}");
      throw Exception("Failed to submit setup");
    }
  }

  Future<void> updateSetup({
    required double monthlyIncome,
    required List<Map<String, dynamic>> monthlyExpenses,
    required double savingGoal,
    required int year,
  }) async {
    final Map<String, dynamic> setupData = {
      "monthly_income": monthlyIncome,
      "monthly_expenses": monthlyExpenses,
      "saving_goal": savingGoal,
      "year": year,
    };

    String? token = await storage.read(key: 'token');

    final response = await http.put(
      Uri.parse('http://10.0.2.2:8000/setups'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(setupData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Setup updated successfully.");
    } else {
      print("Error: ${response.statusCode}");
      print("Message: ${response.body}");
      throw Exception("Failed to update setup");
    }
  }
}
