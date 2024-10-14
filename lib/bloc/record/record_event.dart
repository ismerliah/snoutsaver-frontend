part of 'record_bloc.dart';

sealed class RecordEvent extends Equatable {
  const RecordEvent();

  @override
  List<Object?> get props => [];
}

class LoadRecordsEvent extends RecordEvent {}

class CreateRecordEvent extends RecordEvent {
  final String type;
  final double amount;
  final String categoryId;
  final String categoryName;
  final String? description;
  final DateTime recordDate;

  const CreateRecordEvent({
    required this.type,
    required this.amount,
    required this.categoryId,
    required this.categoryName,
    this.description,
    required this.recordDate,
  });

  @override
  List<Object?> get props => [type, amount, categoryId, categoryName, description, recordDate];
}

class UpdateRecordEvent extends RecordEvent {
  final int recordId;
  final String type;
  final double amount;
  final String categoryId;
  final String categoryName;
  final String? description;
  final DateTime recordDate;

  const UpdateRecordEvent({
    required this.recordId,
    required this.type,
    required this.amount,
    required this.categoryId,
    required this.categoryName,
    this.description,
    required this.recordDate,
  });

  @override
  List<Object?> get props => [recordId, type, amount, categoryId, categoryName, description, recordDate];
}

class DeleteRecordEvent extends RecordEvent {
  final int recordId;

  const DeleteRecordEvent({
    required this.recordId,
  });

  @override
  List<Object?> get props => [recordId];
}
