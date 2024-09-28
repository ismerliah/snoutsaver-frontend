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