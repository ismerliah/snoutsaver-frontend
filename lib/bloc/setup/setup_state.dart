part of 'setup_bloc.dart';

@immutable
abstract class SetupState {
  final int currentStep;
  const SetupState({required this.currentStep});
}

class IncomeStepState extends SetupState {
  const IncomeStepState() : super(currentStep: 0);
}

class ExpenseStepState extends SetupState {
  const ExpenseStepState() : super(currentStep: 1);
}

class SavingGoalStepState extends SetupState {
  const SavingGoalStepState() : super(currentStep: 2);
}

class SetupCompleteState extends SetupState {
  const SetupCompleteState() : super(currentStep: 3);
}

class SetupLoadedState extends SetupState {
  final double monthlyIncome;
  final double savingGoal;
  final int year;
  final List<Map<String, dynamic>> monthlyExpenses;

  const SetupLoadedState({
    required this.monthlyIncome,
    required this.savingGoal,
    required this.year,
    required this.monthlyExpenses,
  }) : super(currentStep: 0);
}