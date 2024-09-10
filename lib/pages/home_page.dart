import 'package:flutter/material.dart';
import 'package:snoutsaver/widgets/add_income.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _addIncome() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const FractionallySizedBox(
          heightFactor: 0.85,
          child: AddIncome(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8ACDD7),
      body: const Center(
        child: Text('Home Page'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addIncome,
        child: const Icon(Icons.add),
      ),
    );
  }
}

