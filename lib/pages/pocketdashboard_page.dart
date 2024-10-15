import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snoutsaver/repository/pocket_repository.dart';
import 'package:snoutsaver/repository/user_repository.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? imgUrl;
  String? name;

  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
    _fetchPockets();
    // context.read<PocketBloc>().add(LoadedPocketsEvent());
  }

  Future<void> _fetchUserDetails() async {
    try {
      final user = await UserRepository().fetchUserDetails();
      // final token = await storage.read(key: "token");
      // print('token: $token');

      setState(() {
        imgUrl = user.profilePicture ?? '';
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _fetchPockets() async {
    try {
      final pocket = await PocketRepository().fetchPockets();
      final currentpocket =
          int.parse(await storage.read(key: "currentPocket") ?? '0');

      print("currentpocket : $currentpocket");
      // print('token: $token');

      setState(() {
        name = pocket[currentpocket].name;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8ACDD7),
      appBar: AppBar(
        elevation: 2,
        shadowColor: Colors.black45,
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
        title: Text(
          name ?? '',
          style: GoogleFonts.outfit(
            textStyle: const TextStyle(
                fontSize: 32, color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ),
        leading: IconButton(
          padding: const EdgeInsets.only(left: 10),
          icon: const Icon(Icons.arrow_back_ios, size: 30),
          onPressed: () {
            storage.delete(key: 'currentPocket');
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFffc0d9),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(width: 3, color: const Color(0xFFffca4d)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: imgUrl != null && imgUrl!.isNotEmpty
                      ? Image.network(
                          imgUrl!,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.person,
                          size: 30, color: Color(0xFFffca4d)),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // TODAY
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              shadowColor: Colors.black45,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/today');
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Today',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          // Total income
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            // child: const Text(
                            //   'Total Income: \$1000',
                            //   style: TextStyle(color: Colors.green),
                            // ),
                          ),
                          const SizedBox(width: 16),
                          // Total expense
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            // child: const Text(
                            //   'Total Expense: \$500',
                            //   style: TextStyle(color: Colors.red),
                            // ),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              shadowColor: Colors.black45,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/month');
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'This Month',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          // Total income
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            // child: const Text(
                            //   'Total Income: \$5000',
                            //   style: TextStyle(color: Colors.green),
                            // ),
                          ),
                          const SizedBox(width: 16),
                          // Total expense
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            // child: const Text(
                            //   'Total Expense: \$2000',
                            //   style: TextStyle(color: Colors.red),
                            // ),
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
        backgroundColor: const Color(0xFFffc0d9), // Your original theme color
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
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
