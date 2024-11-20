part of 'training_data_edit_bloc.dart';

@immutable
abstract class TrainingDataEditEvent {}

class TrainingDataEditInitialEvent extends TrainingDataEditEvent {
  int? id;
  TrainingDataEditInitialEvent({required this.id});
}

class DistrictEditClickEvent extends TrainingDataEditEvent {
  int? id;
  DistrictEditClickEvent({required this.id});
}

class UpazilaEditClickEvent extends TrainingDataEditEvent {
  int? id;
  UpazilaEditClickEvent({required this.id});
}

class UnionEditClickEvent extends TrainingDataEditEvent {
  int? id;
  UnionEditClickEvent({required this.id});
}
