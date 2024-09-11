import 'package:flutter/material.dart';
import 'package:snoutsaver/widgets/add_expense.dart';
import 'package:snoutsaver/widgets/add_income.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8ACDD7),
      body: const Center(
        child: Text('Home Page'),
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
        ],
      )
      
    );
  }
}

