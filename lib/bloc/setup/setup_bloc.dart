import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'setup_event.dart';
part 'setup_state.dart';

class SetupBloc extends Bloc<SetupEvent, SetupState> {
  SetupBloc() : super(const IncomeStepState()) {
    on<NextStepEvent>(_onNextStep);
    on<PreviousStepEvent>(_onPreviousStep);
  }

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
}
