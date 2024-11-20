part of 'new_location_bloc.dart';

@immutable
abstract class NewLocationBlocState {}

final class NewLocationInitialState extends NewLocationBlocState {}

class NewLocationLoadingState extends NewLocationBlocState {}

class DialogShownState extends NewLocationBlocState {
  final String message;
  DialogShownState({required this.message});
}
class NewLocationSuccessState extends NewLocationBlocState {
  final List<UpdNewLocationData> locationData;
  final UpdNewLocationData? singleLocation;
  
  NewLocationSuccessState({
    required this.locationData,
    required this.singleLocation
  
  });
}