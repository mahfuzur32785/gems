import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

enum ConnectivityState { connected, disconnected }
class ConnectivityCubit extends Cubit<ConnectivityState>{
  final Connectivity _connectivity;
   late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  ConnectivityCubit(this._connectivity) : super(ConnectivityState.disconnected){
   _connectivitySubscription= _connectivity.onConnectivityChanged.listen((event) {
     print('network connectivity result $event');
      print('network connectivity result ${event.length}');
      if (event[0] == ConnectivityResult.mobile || event[0] == ConnectivityResult.wifi) {
        emit(ConnectivityState.connected);
      } else {
        emit(ConnectivityState.disconnected);
      }
     });
  }
   @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}