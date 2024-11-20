part of 'connectivity_bloc_bloc.dart';

@immutable
abstract class ConnectivityBlocEvent {}

class ConnectivityObserve extends ConnectivityBlocEvent{}

class ConnectivityNotify extends ConnectivityBlocEvent{
  final bool isNetworkConnected;

  ConnectivityNotify({this.isNetworkConnected = false});

}
