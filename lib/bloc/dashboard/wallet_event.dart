import 'package:equatable/equatable.dart';
import '/models/wallet.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

class AddWallet extends WalletEvent {
  final Wallet wallet;

  const AddWallet(this.wallet);

  @override
  List<Object?> get props => [wallet];
}
