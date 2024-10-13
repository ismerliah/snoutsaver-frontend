import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snoutsaver/bloc/dashboard/wallet_bloc.dart';
import 'package:snoutsaver/bloc/dashboard/wallet_event.dart';
import 'package:snoutsaver/bloc/dashboard/wallet_state.dart';

import '/models/wallet.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Wallets"),
      ),
      body: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
          if (state is WalletInitial) {
            return const Center(child: Text("No wallets added yet."));
          } else if (state is WalletLoaded) {
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
                  child: ListView.builder(
                    itemCount: state.wallets.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(state.wallets[index].name),
                        subtitle: Text('${state.wallets[index].balance} ฿'),
                      );
                    },
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
            return const Center(child: Text("Error loading wallets."));
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
              final wallet = Wallet(
                name: name,
                balance: balance,
                monthlyExpense: monthlyExpense,
              );
              // Add the wallet using BLoC
              context.read<WalletBloc>().add(AddWallet(wallet));
              Navigator.of(context).pop();
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
