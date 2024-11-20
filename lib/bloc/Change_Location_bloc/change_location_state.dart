part of 'change_location_bloc.dart';

@immutable
abstract class ChangeLocationState {}

abstract class ChangeLocationActionState extends ChangeLocationState {}

class ChangeLocationInitialState extends ChangeLocationState {}

class ChangeLocationLoadingState extends ChangeLocationState {}

class ChangeLocationSuccessState extends ChangeLocationState {
  final List<OfficeTypeData> officeTypeList;
  final List<Division> division;
  final List<District> district;
  final List<Upazila> upazila;
  final List<Union> union;
  final List<Map<String, dynamic>> otherOfficeList;

  ChangeLocationSuccessState({
    required this.officeTypeList,
    required this.division,
    required this.district,
    required this.upazila,
    required this.union,
    required this.otherOfficeList,
  });
}
