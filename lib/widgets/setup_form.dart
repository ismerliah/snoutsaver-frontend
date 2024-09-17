import 'package:flutter/material.dart';
import 'package:snoutsaver/mock_data.dart';
import 'package:snoutsaver/models/category.dart';
import 'package:snoutsaver/widgets/category_dialog.dart';

class SetupForm extends StatefulWidget {
  final int currentStep;
  final TextEditingController incomeController;
  final TextEditingController savingGoalController;
  final TextEditingController yearsController;

  const SetupForm({
    super.key,
    required this.currentStep,
    required this.incomeController,
    required this.savingGoalController,
    required this.yearsController,
  });

  @override
  SetupFormState createState() => SetupFormState();
}

class SetupFormState extends State<SetupForm> {
  List<TextEditingController> expenseControllers = [TextEditingController()];
  List<TextEditingController> categoryControllers = [TextEditingController()];
  List<IconData> selectedCategoryIcons = [Icons.category_rounded];

  final int _maxRows = 5;
  bool _showMaxRowWarning = false;

  String _incomeErrorMessage = '';
  String _expenseErrorMessage = '';
  String _savingGoalErrorMessage = '';

  // Method to add new expense row
  void _addExpenseRow() {
    if (expenseControllers.length < _maxRows) {
      setState(() {
        expenseControllers.add(TextEditingController());
        categoryControllers.add(TextEditingController());
        selectedCategoryIcons.add(Icons.category_rounded);
        _showMaxRowWarning = false;
      });
    } else {
      setState(() {
        _showMaxRowWarning = true;
      });
    }
  }

  // Method to remove expense row
  void _removeExpenseRow(int index) {
    if (expenseControllers.length > 1) {
      setState(() {
        expenseControllers.removeAt(index);
        categoryControllers.removeAt(index);
        selectedCategoryIcons.removeAt(index);
        _showMaxRowWarning = false;
      });
    }
  }

  // Category selection dialog
  void selectCategory(
      BuildContext context, List<Category> categories, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CategoryDialog(
          categories: categories,
          onCategorySelected: (Category selectedCategory) {
            setState(() {
              categoryControllers[index].text = selectedCategory.name;
              selectedCategoryIcons[index] = selectedCategory.icon;
            });
          },
        );
      },
    );
  }

  // Income validation method
  bool validateIncome() {
    if (widget.incomeController.text.isEmpty || !isNumeric(widget.incomeController.text)) {
      setState(() {
        _incomeErrorMessage = 'Please enter a valid income.';
      });
      return false;
    }
    setState(() {
      _incomeErrorMessage = '';
    });
    return true;
  }

  // Expense validation method
  bool validateExpenses() {
    for (int i = 0; i < expenseControllers.length; i++) {
      if (expenseControllers[i].text.isEmpty || categoryControllers[i].text.isEmpty) {
        setState(() {
          _expenseErrorMessage = 'Please fill in all expense fields.';
        });
        return false;
      }
    }
    setState(() {
      _expenseErrorMessage = '';
    });
    return true;
  }

  // Saving goal validation method
  bool validateSavingGoal() {
    if (widget.savingGoalController.text.isEmpty || !isNumeric(widget.savingGoalController.text)) {
      setState(() {
        _savingGoalErrorMessage = 'Please enter a valid saving goal.';
      });
      return false;
    }
    if (widget.yearsController.text.isEmpty || !isNumeric(widget.yearsController.text)) {
      setState(() {
        _savingGoalErrorMessage = 'Please enter the number of years.';
      });
      return false;
    }
    setState(() {
      _savingGoalErrorMessage = '';
    });
    return true;
  }

  bool isNumeric(String value) {
    if (value.isEmpty) {
      return false;
    }
    final number = num.tryParse(value);
    return number != null;
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.currentStep) {
      case 0: // Step 1: Income
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Monthly Income',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: widget.incomeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      errorText: _incomeErrorMessage.isNotEmpty ? _incomeErrorMessage : null,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF8ACDD7)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF8ACDD7)),
                      ),
                      border: const UnderlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'THB',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        );

      case 1: // Step 2: Expense
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Monthly Expense',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Display all expense rows
            Column(
              children: List.generate(expenseControllers.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      // Category Selector
                      Expanded(
                        flex: 0,
                        child: GestureDetector(
                          onTap: () {
                            selectCategory(context, expenseCategories, index);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  selectedCategoryIcons[index],
                                  color: const Color(0xFF8ACDD7),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.expand_more),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Expense Input
                      Expanded(
                        flex: 1,
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: expenseControllers[index],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            errorText: _expenseErrorMessage.isNotEmpty ? _expenseErrorMessage : null,
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF8ACDD7)),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF8ACDD7)),
                            ),
                            border: const UnderlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'THB',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(width: 16),

                      // Add & Remove icon logic
                      IconButton(
                        icon: index == expenseControllers.length - 1
                            ? const Icon(Icons.add_circle_outline,
                                color: Color(0xFF8ACDD7))
                            : const Icon(Icons.remove_circle_outline,
                                color: Color(0xFF8ACDD7)),
                        onPressed: () {
                          if (index == expenseControllers.length - 1) {
                            _addExpenseRow();
                          } else {
                            _removeExpenseRow(index);
                          }
                        },
                      ),
                    ],
                  ),
                );
              }),
            ),

            if (_showMaxRowWarning)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  'Maximum of 5 expense rows reached',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
          ],
        );

      case 2: // Step 3: Saving Goal
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Saving Goal',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: widget.savingGoalController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      errorText: _savingGoalErrorMessage.isNotEmpty ? _savingGoalErrorMessage : null,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF8ACDD7)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF8ACDD7)),
                      ),
                      border: const UnderlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'THB',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 75,
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: widget.yearsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF8ACDD7)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF8ACDD7)),
                      ),
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'years',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        );

      default:
        return const SizedBox.shrink(); // Fallback in case of error
    }
  }
}
