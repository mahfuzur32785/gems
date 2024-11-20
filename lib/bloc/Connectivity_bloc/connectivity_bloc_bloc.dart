import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:village_court_gems/helper/network_helper.dart';

part 'connectivity_bloc_event.dart';
part 'connectivity_bloc_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityBlocEvent, ConnectivityBlocState> {
  ConnectivityBloc._() : super(ConnectionInitial()) {
    on<ConnectivityObserve>(networkObserve);
    on<ConnectivityNotify>(notifyConnectionStatus);
  }
  static final ConnectivityBloc _instance = ConnectivityBloc._();

  factory ConnectivityBloc() => _instance;
  void networkObserve(event, emit) {
    NetworkHelper().networkChange();
  }

  void notifyConnectionStatus(ConnectivityNotify event, Emitter<ConnectivityBlocState> emit) {
    if (event.isNetworkConnected) {
      emit(ConnectionSuccess());
    } else {
      emit(ConnectionFailure());
    }
  }

  // checkConnection
}
