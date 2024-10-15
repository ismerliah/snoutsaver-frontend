import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snoutsaver/bloc/pocket/pocket_bloc.dart';
import 'package:snoutsaver/bloc/pocket/pocket_event.dart';
import 'package:snoutsaver/bloc/pocket/pocket_state.dart';
import 'package:snoutsaver/repository/user_repository.dart';
import 'package:snoutsaver/widgets/loading.dart';

class AllPocketPage extends StatefulWidget {
  const AllPocketPage({super.key});

  @override
  State<AllPocketPage> createState() => _AllPocketPageState();
}

class _AllPocketPageState extends State<AllPocketPage> {
  String? imgUrl;
  String? username;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
    context.read<PocketBloc>().add(LoadedPocketsEvent());
  }

  Future<void> _fetchUserDetails() async {
    try {
      final user = await UserRepository().fetchUserDetails();
      // final token = await storage.read(key: "token");
      // print('token: $token');

      setState(() {
        username = user.username;
        imgUrl = user.profilePicture ?? '';
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
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
        title: Text(
          username ?? '',
          style: GoogleFonts.outfit(
            textStyle: const TextStyle(
                fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),
          ),
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(width: 4, color: const Color(0xFFffca4d)),
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
      body: BlocConsumer<PocketBloc, PocketState>(
        listener: (context, state) {
          if (state is PocketFailure) {
            print(state.error);
          } else if (state is PocketLoading) {
            print("Loading...");
          }
        },
        builder: (context, state) {
          if (state is PocketLoading) {
            return const Loading(); // Use your custom loading widget
          } else if (state is PocketLoaded) {
            final pockets =
                state.pockets; // Access pockets from PocketLoaded state
            return Column(
              children: [
                // Display the goals progress bar
                Card(
                  child: InkWell(
                    onTap: () {
                      // Add any click event handler here (edit saving goal?)
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Goals',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                              height:
                                  8), // Add space between text and progress bar
                          LinearProgressIndicator(
                            minHeight: 15,
                            value:
                                0.5, // Replace with actual progress value from your data
                            backgroundColor: Colors.grey,
                            valueColor: AlwaysStoppedAnimation(Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Display the list of wallets
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: pockets.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          tileColor: Colors.white,
                          title: Text(
                            pockets[index].name ?? 'Pocket',
                            style: GoogleFonts.outfit(
                              textStyle: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          subtitle: Text(
                            '${pockets[index].balance} ฿',
                            style: GoogleFonts.outfit(
                              textStyle: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  ),
                            ),
                          ),
                          onTap: () {
                            // Handle the logic to edit the pocket data (name and balance)
                            Navigator.pushNamed(context, '/dashboard');
                          },
                        );
                      },
                    ),
                  ),
                ),

                // Button to add a new wallet
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () => _showAddWalletDialog(context),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.add),
                    ),
                  ),
                ),
              ],
            );
          } else {
            print("Unknown state: $state"); // Debugging line
            return const Text('Error loading pockets');
          }
        },
      ),
    );
  }

  // Show the add wallet dialog
  void _showAddWalletDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddWalletDialog();
      },
    );
  }
}

class AddWalletDialog extends StatefulWidget {
  @override
  _AddWalletDialogState createState() => _AddWalletDialogState();
}

class _AddWalletDialogState extends State<AddWalletDialog> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  double balance = 0.0;
  double monthlyExpense = 0.0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Pocket'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter wallet name';
                }
                return null;
              },
              onSaved: (value) {
                name = value!;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Balance'),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                balance = double.tryParse(value!) ?? 0.0;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Monthly Expense'),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                monthlyExpense = double.tryParse(value!) ?? 0.0;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              // // final wallet = Pocket(
              // //   name: name,
              // //   balance: balance,
              // //   // monthlyExpense: monthlyExpense,
              // // );
              // // Add the wallet using BLoC
              // context.read<PocketBloc>().add(AddPocket(wallet));
              // Navigator.of(context).pop();
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
