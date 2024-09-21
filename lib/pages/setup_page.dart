import 'package:flutter/material.dart';
import 'package:snoutsaver/pages/dashboard_page.dart';
import 'package:snoutsaver/widgets/setup_form.dart';
import 'package:snoutsaver/widgets/stepper_item.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _savingGoalController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();

  final List<TextEditingController> _expenseControllers = [TextEditingController()];
  final List<TextEditingController> _categoryControllers = [TextEditingController()];
  final List<IconData> _selectedCategoryIcons = [Icons.category_rounded];

  // Method to next step
  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        if (_currentStep < 2) {
          _currentStep++;
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardPage()),
          );
        }
      });
    }
  }

  // Method to previous step
  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8ACDD7),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 60.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
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
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StepperItem(
                          stepNumber: 1,
                          label: 'Income',
                          isActive: _currentStep == 0,
                          isCompleted: _currentStep > 0,
                        ),
                        StepperItem(
                          stepNumber: 2,
                          label: 'Expense',
                          isActive: _currentStep == 1,
                          isCompleted: _currentStep > 1,
                        ),
                        StepperItem(
                          stepNumber: 3,
                          label: 'Saving Goal',
                          isActive: _currentStep == 2,
                          isCompleted: _currentStep > 2,
                        ),
                      ],
                    ),
        
                    const SizedBox(height: 24),
        
                    // Display form
                    SetupForm(
                      formKey: _formKey,
                      currentStep: _currentStep,
                      incomeController: _incomeController,
                      savingGoalController: _savingGoalController,
                      yearsController: _yearsController,
                      expenseControllers: _expenseControllers,
                      categoryControllers: _categoryControllers,
                      selectedCategoryIcons: _selectedCategoryIcons,
                    ),
        
                    const SizedBox(height: 24),
        
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentStep > 0)
                          OutlinedButton(
                            onPressed: _previousStep,
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              side: const BorderSide(
                                  color: Color(0xFFff90bc), width: 2),
                            ),
                            child: const Text(
                              'Back',
                              style: TextStyle(
                                color: Color(0xFFff90bc),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        const Spacer(),
                        ElevatedButton(
                          // If validation passes, navigate to next step
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _nextStep();
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
                          child: const Text(
                            'Next',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
