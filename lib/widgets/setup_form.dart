import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:snoutsaver/bloc/setup/setup_bloc.dart';
import 'package:snoutsaver/mock_data.dart';
import 'package:snoutsaver/models/category.dart';
import 'package:snoutsaver/widgets/dialogs/category_dialog.dart';

class SetupForm extends StatelessWidget {
  const SetupForm({
    super.key,
    required this.formKey,
    required this.incomeController,
    required this.expenseControllers,
    required this.categoryControllers,
    required this.selectedCategoryIcons,
    required this.savingGoalController,
    required this.yearsController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController incomeController;
  final List<TextEditingController> expenseControllers;
  final List<TextEditingController> categoryControllers;
  final List<IconData> selectedCategoryIcons;
  final TextEditingController savingGoalController;
  final TextEditingController yearsController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SetupBloc, SetupState>(
      builder: (context, state) {
        if (state is IncomeStepState) {
          return IncomeForm(
            incomeController: incomeController,
            formKey: formKey,
          );
        } else if (state is ExpenseStepState) {
          return ExpenseForm(
            expenseControllers: expenseControllers,
            categoryControllers: categoryControllers,
            selectedCategoryIcons: selectedCategoryIcons,
            formKey: formKey,
          );
        } else if (state is SavingGoalStepState) {
          return SavingGoalForm(
            savingGoalController: savingGoalController,
            yearsController: yearsController,
            formKey: formKey,
          );
        } else {
          return const SizedBox.shrink(); // Fallback in case of error
        }
      },
    );
  }
}

class IncomeForm extends StatelessWidget {
  const IncomeForm({
    super.key,
    required this.incomeController,
    required this.formKey,
  });

  final TextEditingController incomeController;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
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
                child: TextFormField(
                  textAlign: TextAlign.center,
                  controller: incomeController,
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
                  validator:
                      RequiredValidator(errorText: '* Required').call,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
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
      ),
    );
  }
}

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({
    super.key,
    required this.expenseControllers,
    required this.categoryControllers,
    required this.selectedCategoryIcons,
    required this.formKey
  });

  final List<TextEditingController> expenseControllers;
  final List<TextEditingController> categoryControllers;
  final List<IconData> selectedCategoryIcons;
  final GlobalKey<FormState> formKey;

  @override
  _ExpenseFormState createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final int _maxRows = 5;
  bool _showMaxRowWarning = false;

  // Method to add new expense row
  void _addExpenseRow() {
    if (widget.expenseControllers.length < _maxRows) {
      setState(() {
        widget.expenseControllers.add(TextEditingController());
        widget.categoryControllers.add(TextEditingController());
        widget.selectedCategoryIcons.add(Icons.category_rounded);
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
    if (widget.expenseControllers.length > 1) {
      setState(() {
        widget.expenseControllers.removeAt(index);
        widget.categoryControllers.removeAt(index);
        widget.selectedCategoryIcons.removeAt(index);
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
              widget.categoryControllers[index].text = selectedCategory.name;
              widget.selectedCategoryIcons[index] = selectedCategory.icon;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Monthly Expense',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Column(
            children: List.generate(widget.expenseControllers.length, (index) {
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
                                widget.selectedCategoryIcons[index],
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
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: widget.expenseControllers[index],
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
                        validator:
                            RequiredValidator(errorText: '* Required')
                                .call,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'THB',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Add & Remove icon logic
                    IconButton(
                      icon: index == widget.expenseControllers.length - 1
                          ? const Icon(Icons.add_circle_outline,
                              color: Color(0xFF8ACDD7))
                          : const Icon(Icons.remove_circle_outline,
                              color: Color(0xFF8ACDD7)),
                      onPressed: () {
                        if (index == widget.expenseControllers.length - 1) {
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
      ),
    );
  }
}

class SavingGoalForm extends StatelessWidget {
  const SavingGoalForm({
    super.key,
    required this.savingGoalController,
    required this.yearsController,
    required this.formKey,
  });

  final TextEditingController savingGoalController;
  final TextEditingController yearsController;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
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
                child: TextFormField(
                  textAlign: TextAlign.center,
                  controller: savingGoalController,
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
                  validator:
                      RequiredValidator(errorText: '* Required')
                          .call,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'THB',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 75,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  controller: yearsController,
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
                  validator: RequiredValidator(errorText: '* Required').call,
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
      ),
    );
  }
}

