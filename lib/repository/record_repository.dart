import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:snoutsaver/models/record.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:snoutsaver/repository/user_repository.dart';

class RecordRepository {
  final storage = const FlutterSecureStorage();

  Future<void> createRecord({
  required String type,
  required double amount,
  required String categoryId,
  required String categoryName,
  String? description,
  required DateTime recordDate,
}) async {

  String? token = await storage.read(key: 'token');
  final user = await UserRepository().fetchUserDetails();
  final userId = user.id.toString();

  final recordData = {
    "user_id": int.parse(userId),
    "type": type,
    "amount": amount,
    "category_id": int.parse(categoryId),
    "category_name": categoryName,
    "description": description ?? "",
    "record_date": recordDate.toIso8601String(),
  };

  final response = await http.post(
    Uri.parse('http://10.0.2.2:8000/records'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(recordData),
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    print("Record created successfully.");
  } else {
    print("Error: ${response.statusCode}");
    print("Message: ${response.body}");
    throw Exception("Failed to create record");
  }
}

  Future<List<Record>> fetchRecords() async {
  String? token = await storage.read(key: 'token');

  final response = await http.get(
    Uri.parse('http://10.0.2.2:8000/records'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);
    List<dynamic> recordsList = data['records'];
    List<Record> records = recordsList.map((item) => Record.fromJson(item)).toList();
    return records;
  } else {
    print("Error: ${response.statusCode}");
    print("Message: ${response.body}");
    throw Exception("Failed to fetch records");
  }
}

  Future<void> updateRecord({
    required int recordId,
    required String type,
    required double amount,
    required String categoryId,
    required String categoryName,
    String? description,
    required DateTime recordDate,
  }) async {
    String? token = await storage.read(key: 'token');
  final user = await UserRepository().fetchUserDetails();
  final userId = user.id.toString();

    final recordData = {
      "user_id": int.parse(userId),
      "type": type,
      "amount": amount,
      "category_id": categoryId,
      "category_name": categoryName,
      "description": description ?? "",
      "record_date": recordDate.toIso8601String(),
    };

    final response = await http.put(
      Uri.parse('http://10.0.2.2:8000/records/$recordId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(recordData),
    );

    if (response.statusCode == 200) {
      print("Record updated successfully.");
    } else {
      print("Error: ${response.statusCode}");
      print("Message: ${response.body}");
      throw Exception("Failed to update record");
    }
  }

  Future<void> deleteRecord(int recordId) async {
    String? token = await storage.read(key: 'token');

    final response = await http.delete(
      Uri.parse('http://10.0.2.2:8000/records/$recordId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print("Record deleted successfully.");
    } else {
      print("Error: ${response.statusCode}");
      print("Message: ${response.body}");
      throw Exception("Failed to delete record");
    }
  }
}
