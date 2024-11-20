import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/aacoInfoEditModel.dart';
import 'package:village_court_gems/models/aaco_model/aaco_edit_data_model.dart';
import 'package:village_court_gems/models/aaco_model/aaco_options_dropdown.dart';
import 'package:village_court_gems/models/area_model/all_district_model.dart';

part 'aaco_info_edit_event.dart';
part 'aaco_info_edit_state.dart';

class AacoInfoEditBloc extends Bloc<AacoInfoEditEvent, AacoInfoEditState> {
  AacoInfoEditBloc() : super(AacoInfoEditInitialState()) {
    on<AacoInfoEditInitialEvent>(aacoInfoEditInitialEvent);
  }
  AllDistrictModel? allDistrictModel;
  AAcoInfoEditDataModel? aacoInfoEditModel;
  List allupazila = [];
  FutureOr<void> aacoInfoEditInitialEvent(AacoInfoEditInitialEvent event, Emitter<AacoInfoEditState> emit) async {
    emit(AacoInfoEditLoadingState());
    int? id;
    id = event.id;
    aacoInfoEditModel = await Repositores().AACOInfoEditApi(id.toString());
    if (aacoInfoEditModel!.status == 200) {
      allDistrictModel = await Repositores().allDistrictApi();
      if (aacoInfoEditModel!.status == 200) {
        // final recruitmentSts = AacoOptionsDropdown(
        //   optionID: aacoInfoEditModel!.data!.recruitmentStatus!,
        //   optionName: 'Yes'
        //   // optionName: aacoInfoEditModel!.data!.recruitmentStatus! == 0
        //   //     ? 'No'
        //   //     : aacoInfoEditModel!.data!.recruitmentStatus! == 1
        //   //         ? 'Yes'
        //   //         : aacoInfoEditModel!.data!.recruitmentStatus! == 2
        //   //             ? 'Processing'
        //   //             : 'Yes',
        // );
        emit(AacoInfoDetailsDataState(aacoInfData: aacoInfoEditModel!.data!, recruitmentSts: null));
      }
    }
  }

  // FutureOr<void> aacoInfoEditUpazilaClickEvent(AacoInfoEditUpazilaClickEvent event, Emitter<AacoInfoEditState> emit) async {
  //   int? id;
  //   id = event.id;
  //   print(" upazilaC blocccccccccccccccc id");
  //   print(id);
  //   Map upazilaApiResponse = await Repositores().upazilaApi(id!);
  //   if (upazilaApiResponse['status'] == 200) {
  //     allupazila = upazilaApiResponse['data'];
  //     emit(AacoInfoEditSuccessState(
  //       data: aacoInfoEditModel!.data!,
  //       district: allDistrictModel!.data,
  //       upazila: allupazila,
  //     ));
  //   }
  // }

  // FutureOr<void> aacoInfoEditUnionClickEvent(AacoInfoEditUnionClickEvent event, Emitter<AacoInfoEditState> emit) async {
  //   int? id;
  //   id = event.id;
  //   print(" union blocccccccccccccccc id");
  //   print(id);
  //   Map unionApiResponse = await Repositores().unionApi(id!);
  //   if (unionApiResponse['status'] == 200) {
  //     emit(AacoInfoEditSuccessState(
  //         data: aacoInfoEditModel!.data!,
  //         district: allDistrictModel!.data,
  //         upazila: allupazila,
  //         union: unionApiResponse['data']));
  //   }
  // }
}
