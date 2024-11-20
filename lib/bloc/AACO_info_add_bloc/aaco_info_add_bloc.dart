import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/aaco_model/aaco_district_model.dart';
import 'package:village_court_gems/models/area_model/all_district_model.dart';
import 'package:village_court_gems/models/locationModel.dart';

part 'aaco_info_add_event.dart';
part 'aaco_info_add_state.dart';

class AacoInfoAddBloc extends Bloc<AacoInfoAddEvent, AacoInfoAddState> {
  AacoInfoAddBloc() : super(AacoInfoAddInitialState()) {
    on<AacoInfoAddInitialEvent>(aacoInfoAddInitialEvent);
    on<AacoUpazilaClickEvent>(aacoUpazilaClickEvent);
    on<AacoUnionClickEvent>(aacoUnionClickEvent);
  }
  List<Upazila> allupazila = [];
  List<Union> union = [];
  // AllDistrictModel? allDistrictModel;
  AacoDistListModel? allDistrictModel;
  FutureOr<void> aacoInfoAddInitialEvent(AacoInfoAddInitialEvent event, Emitter<AacoInfoAddState> emit) async {
    emit(AacoInfoAddLoadingState());
// ignore_for_file: unused_local_variable
    // allDistrictModel = await Repositores().allDistrictApi();
      allDistrictModel = await Repositores().getAAcoDistrictData();
    print("api call allDistrict from bloc");
    if (allDistrictModel != null) {
      if (allDistrictModel!.status == '200') {
         emit(AacoInfoAddSuccessState(district: allDistrictModel!.districts!,upazila: [],union: []));
      }else{
          emit(AacoInfoAddSuccessState(district: [],upazila: [],union: []));
      }
     
    }
  }

  FutureOr<void> aacoUpazilaClickEvent(AacoUpazilaClickEvent event, Emitter<AacoInfoAddState> emit) async {
    allupazila.clear();
    union.clear();
    int? id;
    id = event.id;
    print(" upazilaC blocccccccccccccccc id");
    print(id);
    Map upazilaApiResponse = await Repositores().upazilaApi(id!);
    if (upazilaApiResponse['status'] == 200) {
     for (var element in upazilaApiResponse['data']) {
       allupazila.add(Upazila.fromJson(element));
     }
    
      emit(AacoInfoAddSuccessState(district: allDistrictModel!.districts!, upazila: allupazila,union: union));
    }
  }

  FutureOr<void> aacoUnionClickEvent(AacoUnionClickEvent event, Emitter<AacoInfoAddState> emit) async {
  union.clear();
    int? id;
    id = event.id;
    print(" union blocccccccccccccccc id");
    print(id);
    Map unionApiResponse = await Repositores().unionApi(id!);
    if (unionApiResponse['status'] == 200) {
      for (var element in unionApiResponse['data']) {
       union.add(Union.fromJson(element));
     }
      emit(AacoInfoAddSuccessState(district: allDistrictModel!.districts!, upazila: allupazila, union:union ));
    }else{
        emit(AacoInfoAddSuccessState(district: allDistrictModel!.districts!, upazila: allupazila, union:[] ));
    }
  }
}
