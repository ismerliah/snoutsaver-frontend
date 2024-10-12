import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:snoutsaver/models/category.dart';

class CategoryRepository {
  final storage = const FlutterSecureStorage();
  
  Future<List<Category>> fetchCategories() async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
        throw Exception('No access token found');
    }
    
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/categories'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['items'];
      return data
          .map((categoryJson) => Category.fromJson(categoryJson))
          .toList();
    } else {
      print('Error: ${response.statusCode}, Body: ${response.body}');
      throw Exception('Failed to load categories');
    }
  }
}
