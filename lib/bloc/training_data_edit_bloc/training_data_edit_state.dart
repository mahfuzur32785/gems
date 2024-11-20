part of 'training_data_edit_bloc.dart';

@immutable
abstract class TrainingDataEditState {}

abstract class TrainingDataEditActionState extends TrainingDataEditState {}

class TrainingDataEditInitialState extends TrainingDataEditState {}

class TrainingDataEditLoadingState extends TrainingDataEditState {}

class DistrictSuccessState extends TrainingDataEditState {
  List<District> district = [];
  DistrictSuccessState({required this.district});
}

class TrainingDataEditSuccessState extends TrainingDataEditState {
  TrainingEditModel trainingEditModel;
  TrainingDataEditSuccessState({required this.trainingEditModel});
}

class TrainingDataEditErrorState extends TrainingDataEditState {
  String errorMsg;
  TrainingDataEditErrorState({required this.errorMsg});
}
