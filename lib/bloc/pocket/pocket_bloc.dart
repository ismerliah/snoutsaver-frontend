import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snoutsaver/repository/pocket_repository.dart';
import 'pocket_event.dart';
import 'pocket_state.dart';
import '../../models/pocket.dart';

class PocketBloc extends Bloc<PocketEvent, PocketState> {
  PocketBloc() : super(PocketInitial()) {
    on<CreateSetupPocketEvent>(_onCreateSetupPocket);
    on<LoadedPocketsEvent>(_onLoadedPockets);
    // on<AddPocket>(_onAddPocket);
  }

  void _onCreateSetupPocket(CreateSetupPocketEvent event, Emitter<PocketState> emit) async {
    try {
      await PocketRepository().createSetupPocket(
        name: event.name,
        balance: event.balance,
        monthlyExpenses: event.monthlyExpenses,
      );
      emit(CreatedPocketSuccess());
    } catch (e) {
      emit(CreatedPocketFailure(error: e.toString().replaceAll('Exception: ', '')));
    }
  }

  void _onLoadedPockets(LoadedPocketsEvent event, Emitter<PocketState> emit) async {
    try {
      emit(PocketLoading());
      await PocketRepository().fetchPockets();
      emit(PocketLoaded(pockets));
    } catch(e) {
      emit(PocketFailure(error: e.toString().replaceAll('Exception: ', '')));
    }
  }


  // void _onAddPocket(AddPocket event, Emitter<PocketState> emit) {
  //   final currentState = state;
  //   if (currentState is PocketLoaded) {
  //     final updatedPockets = List<Pocket>.from(currentState.pockets)
  //       ..add(event.pocket);
  //     emit(PocketLoaded(updatedPockets));
  //   } else {
  //     emit(PocketLoaded([event.pocket]));
  //   }
  // }
}
