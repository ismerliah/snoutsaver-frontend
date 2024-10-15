import 'package:equatable/equatable.dart';
import '../../models/pocket.dart';

abstract class PocketState extends Equatable {
  const PocketState();

  @override
  List<Object?> get props => [];
}

class PocketInitial extends PocketState {}

class PocketLoading extends PocketState {}

class PocketFailure extends PocketState {
  final String error;

  const PocketFailure({required this.error});

  @override
  String toString() => error;
}

class CreatedPocketSuccess extends PocketState {}

class CreatedPocketFailure extends PocketState {
  final String error;

  const CreatedPocketFailure({required this.error});

  @override
  String toString() => error;
}

class PocketLoaded extends PocketState {
  final List<Pocket> pockets;
  
  const PocketLoaded(this.pockets);
}

