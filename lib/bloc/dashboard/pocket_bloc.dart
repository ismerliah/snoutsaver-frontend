import 'package:flutter_bloc/flutter_bloc.dart';
import 'pocket_event.dart';
import 'pocket_state.dart';
import '../../models/pocket.dart';

class PocketBloc extends Bloc<PocketEvent, PocketState> {
  PocketBloc() : super(PocketInitial()) {
    on<AddPocket>(_onAddWallet);
  }

  void _onAddWallet(AddPocket event, Emitter<PocketState> emit) {
    final currentState = state;
    if (currentState is PocketLoaded) {
      final updatedPockets = List<Pocket>.from(currentState.pockets)
        ..add(event.pocket);
      emit(PocketLoaded(updatedPockets));
    } else {
      emit(PocketLoaded([event.pocket]));
    }
  }
}
