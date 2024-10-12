import 'package:flutter/material.dart';
import 'package:snoutsaver/models/category.dart';
import 'package:snoutsaver/repository/category_repository.dart';
import 'package:snoutsaver/widgets/record_form.dart';

class TodaySummaryPage extends StatefulWidget {
  const TodaySummaryPage({super.key});

  @override
  State<TodaySummaryPage> createState() => _TodaySummaryPageState();
}

class _TodaySummaryPageState extends State<TodaySummaryPage> {
  int _currentIndex = 0;
  late Future<List<Category>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = CategoryRepository().fetchCategories();
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _addTransaction() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const FractionallySizedBox(
          heightFactor: 0.85,
          child: RecordBottomsheet(),
        );
      },
    );
  }

  // Sample data for transactions
  final Map<String, List<Map<String, dynamic>>> transactions = {
    'Salary': [
      {'name': 'Transaction 1', 'amount': 50, 'date': '2022-01-01'},
      {'name': 'Transaction 2', 'amount': 20, 'date': '2022-01-02'},
    ],
    'Gift': [
      {'name': 'Transaction 1', 'amount': 100, 'date': '2022-01-01'},
    ],
    'Home': [
      {'name': 'Transaction 1', 'amount': 100, 'date': '2022-01-01'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8ACDD7),
      appBar: AppBar(
        title: const Text(
          'Today',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFF90BC),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {}, // Add profile icon click event handler
          ),
        ],
      ),
      body: FutureBuilder<List<Category>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load categories'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No categories found'));
          }

          final List<Category> categories = _currentIndex == 0
              ? snapshot.data!.where((c) => c.type == 'income').toList()
              : snapshot.data!.where((c) => c.type == 'expense').toList();

          return Center(
            child: Column(
              children: [
                const SizedBox(height: 24),
                RecordTabbar(onTabChanged: _onTabChanged),
                const SizedBox(height: 8),

                // Accordion separated by Category
                TransactionList(
                  categories: categories,
                  transactions: transactions,
                  currentIndex: _currentIndex,
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTransaction(),
        shape: const CircleBorder(),
        backgroundColor: const Color(0xFFFFD200),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }
}

class TransactionList extends StatelessWidget {
  const TransactionList({
    super.key,
    required this.categories,
    required this.transactions,
    required int currentIndex,
  }) : _currentIndex = currentIndex;

  final List<Category> categories;
  final Map<String, List<Map<String, dynamic>>> transactions;
  final int _currentIndex;

  @override
  Widget build(BuildContext context) {
    // Filter categories with transactions
    final filteredCategories = categories.where((category) {
      final categoryTransactions = transactions[category.name];
      return categoryTransactions != null && categoryTransactions.isNotEmpty;
    }).toList();

    return Expanded(
      child: filteredCategories.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 90.0),
                child: Text(
                  '${_currentIndex == 0 ? 'Income' : 'Expense'} not found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                final category = filteredCategories[index];
                final categoryTransactions = transactions[category.name] ?? [];
        
                // Sum the total amount for the category
                final int totalAmount = categoryTransactions.fold<int>(
                  0,
                  (sum, transaction) => sum + (transaction['amount'] as int),
                );
        
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ExpansionTile(
                    shape: const Border(),
                    backgroundColor: Colors.white,
                    collapsedBackgroundColor: Colors.white,
                    childrenPadding: const EdgeInsets.all(4),
                    leading: Icon(category.icon, color: const Color(0xFFFF90BC)),
                    title: Text(
                      '${category.name} (Total: $totalAmount ฿)',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    children: categoryTransactions.map((transaction) {
                      return ListTile(
                        subtitle: Text(transaction['date']),
                        title: Text(transaction['name']),
                        trailing: Text(
                          '${transaction['amount']} ฿',
                          style: TextStyle(
                            color: _currentIndex == 0 ? Colors.green : Colors.red,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
    );
  }
}
