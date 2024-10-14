import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DASHBOARD',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF8ACDD7),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // TODAY
            Card(
              child: InkWell(
                onTap: () {
                   Navigator.pushNamed(context, '/today');
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Today',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          // Total income
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: const Text(
                              'Total Income: \$1000',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Total expense
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: const Text(
                              'Total Expense: \$500',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // MONTH clickable card box
            Card(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/month');
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'This Month',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          // Total income
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: const Text(
                              'Total Income: \$5000',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Total expense
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: const Text(
                              'Total Expense: \$2000',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // Display the Edit Pocket dialog
              return EditPocketDialog();
            },
          );
        },
        backgroundColor: const Color(0xFF8ACDD7),
        child: const Icon(Icons.edit),
      ),
    );
  }
}

class EditPocketDialog extends StatefulWidget {
  @override
  _EditPocketDialogState createState() => _EditPocketDialogState();
}

class _EditPocketDialogState extends State<EditPocketDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Pocket'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _balanceController,
            decoration: const InputDecoration(labelText: 'Balance'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Handle the logic to save the pocket data (name and balance)
            String name = _nameController.text;
            String balance = _balanceController.text;

            // For now, simply print the values
            print('Pocket Name: $name');
            print('Pocket Balance: $balance');

            Navigator.of(context).pop(); // Close the dialog after saving
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
