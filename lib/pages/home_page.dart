import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:snoutsaver/bloc/authentication/app_bloc.dart';
import 'package:snoutsaver/widgets/add_expense.dart';
import 'package:snoutsaver/widgets/add_income.dart';

import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final storage = const FlutterSecureStorage();
  
  void _addTransaction({required bool isIncome}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.85,
          child: isIncome ? const AddIncome() : const AddExpense(),
        );
      },
    );
  }

    Future<String> fetchUserDetails() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        throw Exception('No access token found');
      }
  
      var response = await http.get(
        Uri.parse('http://10.0.2.2:8000/users/me'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
  
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load user details: ${response.body}');
      }
    } catch (e) {
      // debugPrint('Error fetching user details: $e');
      throw Exception(e);
    }
  }

  void showUserDetails(String userDetails) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('User Details'),
          content: Text(userDetails),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8ACDD7),
      body: Center(
        child: FutureBuilder<String>(
          future: fetchUserDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showUserDetails(snapshot.data!);
              });
              return const SizedBox.shrink();
            } else {
              return const Text('No user details available');
            }
          },
        ),
      ),

      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Add Income Button
          FloatingActionButton(
            onPressed: () => _addTransaction(isIncome: true),
            child: const Icon(Icons.add),
          ),

          // Add Expense Button
          FloatingActionButton(
            onPressed: () => _addTransaction(isIncome: false),
            child: const Icon(Icons.remove),
          ),

          // Delete Token 
          FloatingActionButton(
            onPressed: () {
              storage.delete(key: "token");
            }, 
            child: const Icon(Icons.delete)
          ),

          // Sign Out Button
          FloatingActionButton(
            onPressed: () {
              context.read<AuthenticationBloc>().add(SignOutEvent());
              // Map<String, String> allValues = await storage.readAll();
              // debugPrint(allValues.toString());
              Navigator.pushNamed(context, '/welcome');
            }, 
            child: const Icon(Icons.logout)
          ),

          // FloatingActionButton(
          //   onPressed: () async {
          //     context.read<AuthenticationBloc>().add(SignoutWithGoogle());
          //     // Map<String, String> allValues = await storage.readAll();
          //     // debugPrint(allValues.toString());
          //     // debugPrint("delete token");
          //     Navigator.pushNamed(context, '/welcome');
          //     // await GoogleAuth.signoutWithGoogle();
          //     // if (mounted) {
          //     //   Map<String, String> allValues = await storage.readAll();
          //     //   debugPrint(allValues.toString());
          //     //   storage.delete(key: "accesstoken");
          //     //   debugPrint("delete token");
          //     //   Navigator.push(context,MaterialPageRoute(builder: (context) => const WelcomePage()),);
          //     // }
          //   },
          //   child: const Text('Sign Out'),
          // )
        ],
      )
      
    );
  }
}

