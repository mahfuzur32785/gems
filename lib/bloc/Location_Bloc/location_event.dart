part of 'location_bloc.dart';

@immutable
abstract class LocationEvent {}

class LocationInitialEvent extends LocationEvent {
  Map? locationModel;
  LocationInitialEvent({required this.locationModel});
}

class LocationFilterEvent extends LocationEvent {
  final int? id;
  LocationFilterEvent({this.id});
}
