part of 'aaco_info_edit_bloc.dart';

@immutable
abstract class AacoInfoEditState {}

abstract class AacoInfoEditActionState extends AacoInfoEditState {}

class AacoInfoEditInitialState extends AacoInfoEditState {}

class AacoInfoEditLoadingState extends AacoInfoEditState {}

class AacoInfoDetailsDataState extends AacoInfoEditState {
 final AacoInfo aacoInfData;
  AacoOptionsDropdown? recruitmentSts;
 
  AacoInfoDetailsDataState({required this.aacoInfData, this.recruitmentSts});
}
