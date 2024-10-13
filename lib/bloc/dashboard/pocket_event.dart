import 'package:equatable/equatable.dart';
import '../../models/pocket.dart';

abstract class PocketEvent extends Equatable {
  const PocketEvent();

  @override
  List<Object?> get props => [];
}

class AddPocket extends PocketEvent {
  final Pocket pocket;

  const AddPocket(this.pocket);

  @override
  List<Object?> get props => [pocket];
}
