import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:snoutsaver/repository/setup_repository.dart';
part 'setup_event.dart';
part 'setup_state.dart';

class SetupBloc extends Bloc<SetupEvent, SetupState> {
  SetupBloc() : super(const IncomeStepState()) {
    on<NextStepEvent>(_onNextStep);
    on<PreviousStepEvent>(_onPreviousStep);
    on<SubmitFormEvent>(_onSubmitForm);
  }

  final storage = const FlutterSecureStorage();

  void _onNextStep(NextStepEvent event, Emitter<SetupState> emit) {
    if (state is IncomeStepState) {
      emit(const ExpenseStepState());
    } else if (state is ExpenseStepState) {
      emit(const SavingGoalStepState());
    }
  }

  void _onPreviousStep(PreviousStepEvent event, Emitter<SetupState> emit) {
    if (state is SavingGoalStepState) {
      emit(const ExpenseStepState());
    } else if (state is ExpenseStepState) {
      emit(const IncomeStepState());
    }
  }

  Future<void> _onSubmitForm(SubmitFormEvent event, Emitter<SetupState> emit) async {
    if (state is SavingGoalStepState) {
      try {
        await SetupRepository().submitSetup(
          monthlyIncome: event.monthlyIncome,
          monthlyExpenses: event.monthlyExpenses,
          savingGoal: event.savingGoal,
          year: event.year
        );
      } catch (error) {
        print("Failed to submit setup: $error");
      }
    }
  }

}
