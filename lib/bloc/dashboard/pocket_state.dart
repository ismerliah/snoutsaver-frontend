import 'package:equatable/equatable.dart';
import '../../models/pocket.dart';

abstract class PocketState extends Equatable {
  const PocketState();

  @override
  List<Object?> get props => [];
}

class PocketInitial extends PocketState {}

class PocketLoaded extends PocketState {
  final List<Pocket> pockets;

  const PocketLoaded(this.pockets);

  @override
  List<Object?> get props => [pockets];
}
