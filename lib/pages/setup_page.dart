import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snoutsaver/bloc/setup/setup_bloc.dart';
import 'package:snoutsaver/models/category.dart';
import 'package:snoutsaver/repository/setup_repository.dart';
import 'package:snoutsaver/widgets/setup_form.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _savingGoalController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();

  final List<TextEditingController> _expenseControllers = [];
  final List<TextEditingController> _categoryControllers = [];
  final List<IconData> _selectedCategoryIcons = [];

  bool isEditing = false;
  final setupRepository = SetupRepository();

  String formatAmount(double amount) {
    if (amount == amount.toInt()) {
      return amount.toInt().toString();
    } else {
      return amount.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    _checkSetupData();
  }

  Future<void> _checkSetupData() async {
    if (await setupRepository.hasSetupData()) {
      _loadSetupData();
    } else {
      _initializeEmptyFields();
    }
  }

  void _initializeEmptyFields() {
    setState(() {
      _expenseControllers.add(TextEditingController());
      _categoryControllers.add(TextEditingController());
      _selectedCategoryIcons.add(Icons.category_rounded);
    });
  }

  void _loadSetupData() async {
    final setupData = await setupRepository.fetchSetupData();

    if (setupData != null) {
      setState(() {
        // Pre-fill form fields with setup data
        _incomeController.text = formatAmount(setupData['monthly_income']);
        _savingGoalController.text = formatAmount(setupData['saving_goal']);
        _yearsController.text = setupData['year'].toString();

        for (var expense in setupData['monthly_expenses']) {
          _expenseControllers.add(TextEditingController(text: formatAmount(expense['amount'])));
          _categoryControllers.add(TextEditingController(text: expense['category_id'].toString()));
          _selectedCategoryIcons.add(Category.convertIcon(expense['category_id'], expense['icon']));
        }

        isEditing = true;
      });
    } else {
      _initializeEmptyFields();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SetupBloc(),
      child: Scaffold(
        backgroundColor: const Color(0xFF8ACDD7),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Back button
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  padding: const EdgeInsets.only(left: 16),
                  icon: const Icon(Icons.arrow_back_ios, size: 30),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              // LOGO
              Container(
                width: 276,
                height: 118,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),

              // Stepper form container
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                  child: BlocBuilder<SetupBloc, SetupState>(
                    builder: (context, state) {
                      return Column(
                        children: <Widget>[
                          // Stepper items
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              StepperItem(
                                stepNumber: 1,
                                label: 'Income',
                                isActive: state is IncomeStepState,
                                isCompleted: state.currentStep > 0,
                              ),
                              StepperItem(
                                stepNumber: 2,
                                label: 'Expense',
                                isActive: state is ExpenseStepState,
                                isCompleted: state.currentStep > 1,
                              ),
                              StepperItem(
                                stepNumber: 3,
                                label: 'Saving Goal',
                                isActive: state is SavingGoalStepState,
                                isCompleted: state.currentStep > 2,
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Display form
                          SetupForm(
                            formKey: _formKey,
                            incomeController: _incomeController,
                            savingGoalController: _savingGoalController,
                            yearsController: _yearsController,
                            expenseControllers: _expenseControllers,
                            categoryControllers: _categoryControllers,
                            selectedCategoryIcons: _selectedCategoryIcons,
                          ),

                          const SizedBox(height: 24),

                          // Next and Back Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (state.currentStep > 0)
                                OutlinedButton(
                                  onPressed: () {
                                    context
                                        .read<SetupBloc>()
                                        .add(PreviousStepEvent());
                                  },
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                    side: const BorderSide(
                                        color: Color(0xFFff90bc), width: 2),
                                  ),
                                  child: Text(
                                    'Back',
                                    style: GoogleFonts.outfit(
                                      color: const Color(0xFFff90bc),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              const Spacer(),
                              ElevatedButton(
                                // If validation passes, navigate to next step
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    if (state.currentStep < 2) {
                                      context
                                          .read<SetupBloc>()
                                          .add(NextStepEvent());
                                    } else {
                                      final List<Map<String, dynamic>>
                                          monthlyExpenses = [];
                                      for (int i = 0; i < _expenseControllers.length; i++) {
                                        monthlyExpenses.add({
                                          "amount": double.parse(_expenseControllers[i].text),
                                          "category_id": _categoryControllers[i].text,
                                        });
                                      }
                                      // Submit form and navigate to dashboard
                                      context.read<SetupBloc>().add(
                                            SubmitFormEvent(
                                              monthlyIncome: double.parse(_incomeController.text),
                                              monthlyExpenses: monthlyExpenses,
                                              savingGoal: double.parse(_savingGoalController.text),
                                              year: int.parse(_yearsController.text),
                                              isEditing: isEditing,
                                            ),
                                          );
                                      Navigator.pushNamed(context, '/dashboard');
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFff90bc),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                ),
                                child: Text(
                                  'Next',
                                  style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StepperItem extends StatelessWidget {
  final int stepNumber;
  final String label;
  final bool isActive;
  final bool isCompleted;

  const StepperItem({
    super.key,
    required this.stepNumber,
    required this.label,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive || isCompleted
                  ? const Color(0xFFFF90BC)
                  : Colors.grey.shade500,
              width: 2.0,
            ),
          ),
          child: CircleAvatar(
            radius: 15,
            backgroundColor:
                isCompleted ? const Color(0xFFFF90BC) : Colors.white,
            child: isCompleted
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                  )
                : Text(
                    '$stepNumber',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      color: isActive
                          ? const Color(0xFFFF90BC)
                          : Colors.grey.shade700,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: isActive || isCompleted
                ? const Color(0xFFFF90BC)
                : Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}
