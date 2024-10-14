import 'package:equatable/equatable.dart';
import '../../models/pocket.dart';

abstract class PocketEvent extends Equatable {
  const PocketEvent();

  @override
  List<Object?> get props => [];
}

class CreateSetupPocketEvent extends PocketEvent {
  final String name;
  final double balance;
  final List<Map<String, dynamic>> monthlyExpenses;

  const CreateSetupPocketEvent({
    required this.name,
    required this.balance,
    required this.monthlyExpenses,
  });
}

class LoadedPocketsEvent extends PocketEvent {}

class AddPocket extends PocketEvent {
  final Pocket pocket;

  const AddPocket(this.pocket);

  @override
  List<Object?> get props => [pocket];
}



