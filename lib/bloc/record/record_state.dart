part of 'record_bloc.dart';

abstract class RecordState extends Equatable {
  const RecordState();

  @override
  List<Object?> get props => [];
}

class RecordInitial extends RecordState {}

class RecordLoading extends RecordState {}

class RecordsLoaded extends RecordState {
  final List<Record> records;

  const RecordsLoaded(this.records);

  @override
  List<Object?> get props => [records];
}

class RecordSuccess extends RecordState {
  final String message;

  const RecordSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class RecordFailure extends RecordState {
  final String error;

  const RecordFailure(this.error);

  @override
  List<Object?> get props => [error];
}
