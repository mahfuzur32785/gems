part of 'connectivity_bloc_bloc.dart';

@immutable
abstract class ConnectivityBlocState {}

 class ConnectionInitial extends ConnectivityBlocState {}

 class ConnectionSuccess extends ConnectivityBlocState {}

 class ConnectionFailure extends ConnectivityBlocState {}



