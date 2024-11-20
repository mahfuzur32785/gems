part of 'location_bloc.dart';

@immutable
abstract class LocationState {}

abstract class LocationActionState extends LocationState {}

class LocationInitialState extends LocationState {}

class LocationLoadingState extends LocationState {}

class DialogShownState extends LocationState {
  final String message;
  DialogShownState({required this.message});
}

class LocationSuccessState extends LocationState {
  final Map<String, dynamic> areaData;
  final String? officeTitle;
  final List<OfficeTypeList> officeList;
  final List<LocMatchedDivision> division;
  final List<LocMatchedDistrict> district;
  final List<LocMatchedUpazila> upazila;
  final List<LocMatchedUnion> union;
  final dynamic locationID;
  LocationSuccessState({
    required this.areaData,
    this.officeTitle,
    required this.officeList,
    required this.division,
    required this.district,
    required this.upazila,
    required this.union,
    required this.locationID
  });
}

class LocationFilterState extends LocationState {
  final String officeID;
  final dynamic locationID;
  final List<OfficeTypeList> officeList;
  final List<LocMatchedDivision> division;
  final List<LocMatchedDistrict> district;
  final List<LocMatchedUpazila> upazila;
  final List<LocMatchedUnion> union;
  final String? officTitle;
  LocationFilterState({
    required this.officeID,
    required this.locationID,
    required this.officeList,
    required this.division,
    required this.district,
    required this.upazila,
    required this.union,
    this.officTitle
  });
}
