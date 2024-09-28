part of 'setup_bloc.dart';

@immutable
abstract class SetupEvent {}

class NextStepEvent extends SetupEvent {}

class PreviousStepEvent extends SetupEvent {}

class SubmitFormEvent extends SetupEvent {}