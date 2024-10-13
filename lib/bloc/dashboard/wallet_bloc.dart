import 'package:flutter_bloc/flutter_bloc.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';
import '/models/wallet.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(WalletInitial()) {
    on<AddWallet>(_onAddWallet);
  }

  void _onAddWallet(AddWallet event, Emitter<WalletState> emit) {
    final currentState = state;
    if (currentState is WalletLoaded) {
      final updatedWallets = List<Wallet>.from(currentState.wallets)
        ..add(event.wallet);
      emit(WalletLoaded(updatedWallets));
    } else {
      emit(WalletLoaded([event.wallet]));
    }
  }
}
