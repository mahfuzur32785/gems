import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:village_court_gems/bloc/Connectivity_bloc/connectivity_bloc_bloc.dart';

class NetworkHelper {
  List<ConnectivityResult> connectionStatus = [ConnectivityResult.none];
  Future<void> updateConnectionStatus(List<ConnectivityResult> result) async {
   
      connectionStatus = result;
      if (connectionStatus[0] == ConnectivityResult.none) {
         ConnectivityBloc().add(ConnectivityNotify(isNetworkConnected: false));
        
      }else{
          ConnectivityBloc().add(ConnectivityNotify(isNetworkConnected: true));
      }
    
    // ignore: avoid_print
    print('Connectivity changed: $connectionStatus');
  }
  void networkChange() {
    Connectivity().onConnectivityChanged.listen(
      updateConnectionStatus
    //   (result) {
    //   print('network connectivity result $result');
      

    //   // if (result.contains(ConnectivityResult.none)) {
    //   //   ConnectivityBloc().add(ConnectivityNotify());
    //   // } else if (result.contains(ConnectivityResult.wifi)) {
    //   //   ConnectivityBloc().add(ConnectivityNotify(isNetworkConnected: true));
    //   // } else if (result.contains(ConnectivityResult.mobile)) {
    //   //   ConnectivityBloc().add(ConnectivityNotify(isNetworkConnected: true));
    //   // }
    // },
    );
    
  }
}
