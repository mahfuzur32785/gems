part of 'new_location_bloc.dart';

@immutable
abstract class NewLocationBlocEvent {}

class NewLocationInitialEvent extends NewLocationBlocEvent {
  final Map locationModel;

  NewLocationInitialEvent({required this.locationModel});

  
}