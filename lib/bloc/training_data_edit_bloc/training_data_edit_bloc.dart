import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:village_court_gems/bloc/Training_show_Bloc/training_show_bloc.dart';
import 'package:village_court_gems/bloc/training_data_add_Bloc/training_data_bloc.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/locationModel.dart';
import 'package:village_court_gems/models/new_TraningModel.dart';
import 'package:village_court_gems/models/triningEditModel.dart';

part 'training_data_edit_event.dart';
part 'training_data_edit_state.dart';

class TrainingDataEditBloc extends Bloc<TrainingDataEditEvent, TrainingDataEditState> {

  TrainingDataEditBloc() : super(TrainingDataEditInitialState()) {
    on<TrainingDataEditInitialEvent>(trainingDataEditInitialEvent);
    on<DistrictEditClickEvent>(districtClickEvent);
  }

  List alldata = [];
  List<District> allDistrict = [];
  List allupazila = [];
  List allunion = [];
  List EditData = [];
  TrainingEditModel? trainingEditModel;

  FutureOr<void> trainingDataEditInitialEvent(TrainingDataEditInitialEvent event, Emitter<TrainingDataEditState> emit) async {
    int? id;
    id = event.id;
    emit(TrainingDataEditLoadingState());

    var TrainingDataEditApiResponse = await Repositores().TrainigsEditAPi(id!);
    trainingEditModel = TrainingDataEditApiResponse;

    print(jsonEncode(trainingEditModel));

    if (trainingEditModel?.status == 200 && trainingEditModel?.message == "success") {
      emit(TrainingDataEditSuccessState(trainingEditModel: trainingEditModel!));
    }else{
      emit(TrainingDataEditErrorState(errorMsg: "Something Wrong"));
    }
  }

  FutureOr<void> districtClickEvent(DistrictEditClickEvent event, Emitter<TrainingDataEditState> emit) async {
    int? id;
    id = event.id;
    Map districtApiResponse = await Repositores().districtApi(id!);
    if (districtApiResponse['status'] == 200) {
      allDistrict = List.from(districtApiResponse["data"])
          .map((e) => District.fromJson(e))
          .toList();
      emit(DistrictSuccessState(
        district: allDistrict,
      ));
    }
  }

  // FutureOr<void> upazilaClickEvent(UpazilaClickEvent event, Emitter<TrainingDataBlocState> emit) async {
  //   int? id;
  //   id = event.id;
  //   print(" upazilaC blocccccccccccccccc id");
  //   print(id);
  //   Map upazilaApiResponse = await Repositores().upazilaApi(id!);
  //   if (upazilaApiResponse['status'] == 200) {
  //     allupazila = upazilaApiResponse['data'];
  //     emit(TrainingDataSuccessState(
  //       data: newTrainingModel.data,
  //       district: allDistrict,
  //       upazila: upazilaApiResponse['data'],
  //       union: [],
  //     ));
  //   }
  // }
  //
  // FutureOr<void> unionClickEvent(UnionClickEvent event, Emitter<TrainingDataBlocState> emit) async {
  //   int? id;
  //   id = event.id;
  //   print(" union blocccccccccccccccc id");
  //   print(id);
  //   Map unionApiResponse = await Repositores().unionApi(id!);
  //   if (unionApiResponse['status'] == 200) {
  //     allunion = unionApiResponse['data'];
  //     emit(TrainingDataSuccessState(
  //         data: newTrainingModel.data, district: allDistrict, upazila: allupazila, union: unionApiResponse['data']));
  //   }
  // }



}
