// import 'dart:async';

// import 'package:flutter_bloc/flutter_bloc.dart';

// enum ConnectivityStatus { WiFi, Cellular, Offline }

// class ConnectivityBloc extends Cubit<ConnectivityStatus> {
//   late StreamSubscription<ConnectivityResult> connectivitySubscription;

//   ConnectivityBloc() : super(ConnectivityStatus.Offline) {
//     connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) {
//       switch (result) {
//         case ConnectivityResult.wifi:
//           emit(ConnectivityStatus.WiFi);
//           break;
//         case ConnectivityResult.mobile:
//           emit(ConnectivityStatus.Cellular);
//           break;
//         case ConnectivityResult.none:
//           emit(ConnectivityStatus.Offline);
//           break;
//       }
//     });
//   }

//   @override
//   Future<void> close() {
//     connectivitySubscription.cancel();
//     return super.close();
//   }
// }