import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snoutsaver/repository/record_repository.dart';
import 'package:snoutsaver/models/record.dart';

part 'record_event.dart';
part 'record_state.dart';

class RecordBloc extends Bloc<RecordEvent, RecordState> {

  RecordBloc() : super(RecordInitial()) {
    on<LoadRecordsEvent>(_onLoadRecords);
    on<CreateRecordEvent>(_onCreateRecord);
    on<UpdateRecordEvent>(_onUpdateRecord);
    on<DeleteRecordEvent>(_onDeleteRecord);
  }

  Future<void> _onLoadRecords(LoadRecordsEvent event, Emitter<RecordState> emit) async {
    emit(RecordLoading());
    try {
      final records = await RecordRepository().fetchRecords();
      emit(RecordsLoaded(records));
    } catch (error) {
      emit(RecordFailure(error.toString()));
    }
  }

  Future<void> _onCreateRecord(CreateRecordEvent event, Emitter<RecordState> emit) async {
    emit(RecordLoading());
    try {
      await RecordRepository().createRecord(
        type: event.type,
        amount: event.amount,
        categoryId: event.categoryId,
        categoryName: event.categoryName,
        description: event.description,
        recordDate: event.recordDate,
      );
      emit(const RecordSuccess("Record created successfully!"));
      final records = await RecordRepository().fetchRecords();
      emit(RecordsLoaded(records));
    } catch (error) {
      emit(RecordFailure(error.toString()));
    }
  }

  Future<void> _onUpdateRecord(UpdateRecordEvent event, Emitter<RecordState> emit) async {
    emit(RecordLoading());
    try {
      await RecordRepository().updateRecord(
        recordId: event.recordId,
        type: event.type,
        amount: event.amount,
        categoryId: event.categoryId,
        categoryName: event.categoryName,
        description: event.description,
        recordDate: event.recordDate,
      );
      emit(const RecordSuccess("Record updated successfully!"));
      final records = await RecordRepository().fetchRecords();
      emit(RecordsLoaded(records));
    } catch (error) {
      emit(RecordFailure(error.toString()));
    }
  }

  Future<void> _onDeleteRecord(DeleteRecordEvent event, Emitter<RecordState> emit) async {
    emit(RecordLoading());
    try {
      await RecordRepository().deleteRecord(event.recordId);
      final records = await RecordRepository().fetchRecords();
      emit(RecordsLoaded(records));
    } catch (error) {
      emit(RecordFailure(error.toString()));
    }
  }
}
