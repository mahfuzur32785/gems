import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:village_court_gems/controller/Local_store_controller/local_store.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/field_visit_model/updated_new_loc_model.dart';
import 'package:village_court_gems/provider/connectivity_provider.dart';
import 'package:village_court_gems/services/backgroundService/wm_service.dart';
import 'package:village_court_gems/services/database/localDatabaseService.dart';
import 'package:village_court_gems/util/utils.dart';
import 'package:village_court_gems/view/visit_report/field_visit_local_logic.dart';

part 'new_location_bloc_event.dart';
part 'new_location_bloc_state.dart';

class NewLocationBloc extends Bloc<NewLocationBlocEvent, NewLocationBlocState> {
  NewLocationBloc() : super(NewLocationInitialState()) {
    on<NewLocationInitialEvent>(newLocationInitialEvent);
  }
  UpdNewLocationData? singleLocation;
  Future<void> newLocationInitialEvent(NewLocationInitialEvent event, Emitter<NewLocationBlocState> emit) async {
    emit(NewLocationLoadingState());
    Map? locationBody;

    locationBody = event.locationModel;
    print("bloc location  ${locationBody}");
    final checkNetworkConnection = await Utils().rcheckInternetConnection();
    if (checkNetworkConnection) {
      var locationApiResponse = await Repositores().updatednewLocationMatchedApi(locationBody);
      if (locationApiResponse.status == 200 || locationApiResponse.status == 201) {
        await Repositores().allLocationInForeground();
    //      var token = await Helper().getUserToken();
    // locationFetchedOnLogin(token: token);
        if (locationApiResponse.message == "no data available") {
          emit(DialogShownState(message: "Not Matched"));
        } else {
          singleLocation = locationApiResponse.data?.first;
          emit(NewLocationSuccessState(locationData: locationApiResponse.data ?? [], singleLocation: singleLocation));
        }
      } else if (locationApiResponse.status == 408) {
        List<UpdNewLocationData> offlineFilteredData = [];
        var allLocationDataFromLocal = await Helper().getAllLocationData();
        final locationDistance = await Helper().getSettingCash();

        offlineFilteredData = FieldVisitLocalUtil()
            .formatFilteredLocation(allLocationDataFromLocal, double.parse(locationBody['latitude']), double.parse(locationBody['longitude']),  double.parse(locationDistance));
        if (offlineFilteredData.isEmpty) {
          emit(DialogShownState(message: "Not Matched"));
        } else {
          emit(NewLocationSuccessState(locationData: offlineFilteredData ?? [], singleLocation: singleLocation));
        }
      }
    } else {
      List<UpdNewLocationData> offlineFilteredData = [];
      var allLocationDataFromLocal = await Helper().getAllLocationData();
      final locationDistance = await Helper().getSettingCash();

      offlineFilteredData = FieldVisitLocalUtil()
          .formatFilteredLocation(allLocationDataFromLocal, double.parse(locationBody['latitude']), double.parse(locationBody['longitude']), double.parse(locationDistance));
      if (offlineFilteredData.isEmpty) {
        emit(DialogShownState(message: "Not Matched"));
      } else {
        emit(NewLocationSuccessState(locationData: offlineFilteredData ?? [], singleLocation: singleLocation));
      }
    }
  }
}
