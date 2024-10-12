part of 'setup_bloc.dart';

@immutable
abstract class SetupEvent {}

class NextStepEvent extends SetupEvent {}

class PreviousStepEvent extends SetupEvent {}

class SubmitFormEvent extends SetupEvent {
  final double monthlyIncome;
  final List<Map<String, dynamic>> monthlyExpenses;
  final double savingGoal;
  final int year;

  SubmitFormEvent({
    required this.monthlyIncome,
    required this.monthlyExpenses,
    required this.savingGoal,
    required this.year,
  });
}