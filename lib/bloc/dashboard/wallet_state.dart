import 'package:equatable/equatable.dart';
import '/models/wallet.dart';

abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {}

class WalletLoaded extends WalletState {
  final List<Wallet> wallets;

  const WalletLoaded(this.wallets);

  @override
  List<Object?> get props => [wallets];
}
