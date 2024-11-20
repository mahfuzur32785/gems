import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:village_court_gems/controller/Local_store_controller/local_store.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/main.dart';
import 'package:village_court_gems/models/area_model/all_location_data.dart';
import 'package:village_court_gems/models/area_model/office_type_model.dart';
import 'package:village_court_gems/models/locationModel.dart';
import 'package:village_court_gems/services/database/localDatabaseService.dart';

part 'change_location_event.dart';
part 'change_location_state.dart';

class ChangeLocationBloc extends Bloc<ChangeLocationEvent, ChangeLocationState> {
  ChangeLocationBloc() : super(ChangeLocationInitialState()) {
    on<ChangeLocationInitialEvent>(changeLocationInitialEvent);
    on<DistrictClickEvent>(districtClickEvent);
    on<UpazilaClickEvent>(upazilaClickEvent);
    on<UnionClickEvent>(unionClickEvent);
  }
  List<Map<String, dynamic>> otherOfficevList = [];
  List<OfficeTypeData> officeTypeList = [];
  List<Division> allDivision = [];
  List<District> allDistrict = [];
  List<Upazila> allUpazila = [];
  List<Union> allUnion = [];

  Future<void> changeLocationInitialEvent(
    ChangeLocationInitialEvent event,
    Emitter<ChangeLocationState> emit,
  ) async {
    emit(ChangeLocationLoadingState());
   // final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
    List<OfficeTypeData> OfficeTypeDataList = await Helper().getOfficeTypeData();
    officeTypeList = OfficeTypeDataList;
    List<AllLocationData> otherOfficeList = [];

    // List<Division> storeDivisionData = await Helper().getDivisionData();
    List<Division> storeDivisionData = [];

    //var alllist = LocalStore().allLocationBox.values.toList();
    var allLocationDataFromLocal = await Helper().getAllLocationData(); //LocalStore().allLocationBox.values.toList();
    var allDivisionData = allLocationDataFromLocal.where(
      (element) => element.districtId == null && element.upazilaId == null && element.unionId == null && element.officeTypeId.toString() != '4',
    );
    var otherOfficeData = await prefs.getStringList('fetchotheroff');
    if (otherOfficeData != null) {
      otherOfficeData.forEach((element) {
        otherOfficevList.add(jsonDecode(element));
      });
    }

    // otherOfficeData

    allDivisionData.forEach((element) {
      storeDivisionData.add(Division(id: element.id, divisionName: element.nameEn, divisionId: element.divisionId));
    });

    // var districtList =
    //     alllist.where((element) => element.upazilaId == null && element.unionId == null && element.divisionId != null && element.districtId != null);
    // var upazillaList = alllist.where((element) => element.unionId == null);
    // var unionList =
    //     alllist.where((element) => element.divisionId != null && element.districtId != null && element.upazilaId != null && element.unionId != null);
    allDivision = storeDivisionData;
    emit(ChangeLocationSuccessState(
        officeTypeList: officeTypeList, division: allDivision, district: [], upazila: [], union: [], otherOfficeList: otherOfficevList));
  }

  districtClickEvent(DistrictClickEvent event, Emitter<ChangeLocationState> emit) async {
    log('previous all district ${allDistrict.length}');
    log('previous all upazila ${allUpazila.length}');
    log('previous all union ${allUnion.length}');
    allDistrict.clear();
    allUpazila.clear();
    allUnion.clear();
    int? id;
    id = event.id;
    print('selected district ID ${id}');
    var allLocationDataFromLocal = await Helper().getAllLocationData(); //LocalStore().allLocationBox.values.toList();
    //List<District> storeDistrictData = await Helper().getDistrictData();
    List<District> storeDistrictData = [];
    // var alllist = LocalStore().allLocationBox.values.toList();
    var districtList = allLocationDataFromLocal
        .where((element) =>
            element.upazilaId == null &&
            element.unionId == null &&
            element.divisionId != null &&
            element.districtId != null &&
            element.officeTypeId.toString() != '4')
        .toList();
    districtList.forEach((element) {
      storeDistrictData.add(District(
        divisionId: element.divisionId,
        districtId: element.districtId,
        districtName: element.nameEn,
      ));
    });
    storeDistrictData.forEach((element) {
      if (element.divisionId == id) {
        allDistrict.add(element);
      }
    });
    log('all district length${allDistrict.length}');
    emit(ChangeLocationSuccessState(
        officeTypeList: officeTypeList, division: allDivision, district: allDistrict, upazila: [], union: [], otherOfficeList: otherOfficevList));
  }

  upazilaClickEvent(UpazilaClickEvent event, Emitter<ChangeLocationState> emit) async {
    log('previous all upClickEvent district ${allDistrict.length}');
    log('previous all upClickEvent upazila ${allUpazila.length}');
    log('previous all upClickEvent union ${allUnion.length}');
    int? id;
    id = event.id;
    print('selected Upazilla ID ${id}');
    allUpazila.clear();
    allUnion.clear();
    var allLocationDataFromLocal = await Helper().getAllLocationData(); //LocalStore().allLocationBox.values.toList();
    //List<Upazila> storeUpazilaData = await Helper().getUpazilaData();
    List<Upazila> storeUpazilaData = [];
    // var alllist = LocalStore().allLocationBox.values.toList();
    var upazillaList = allLocationDataFromLocal
        .where((element) =>
            element.upazilaId != null &&
            element.unionId == null &&
            element.divisionId != null &&
            element.districtId != null &&
            element.officeTypeId.toString() != '4')
        .toList();

    upazillaList.forEach((element) {
      storeUpazilaData.add(Upazila(
        upazilaId: element.upazilaId,
        upazilaName: element.nameEn,
        districtId: element.districtId,
        divisionId: element.divisionId,
      ));
    });

    storeUpazilaData.forEach(
      (element) {
        if (element.districtId == id) {
          allUpazila.add(element);
        }
      },
    );

    print("all up length ${allUpazila.length}");
    emit(ChangeLocationSuccessState(
        officeTypeList: officeTypeList,
        division: allDivision,
        district: allDistrict,
        upazila: allUpazila,
        union: [],
        otherOfficeList: otherOfficevList));
  }

  unionClickEvent(UnionClickEvent event, Emitter<ChangeLocationState> emit) async {
    int? id;
    id = event.id;
    allUnion.clear();
    var allLocationDataFromLocal = await Helper().getAllLocationData(); //LocalStore().allLocationBox.values.toList();
    //List<Union> storeUnionData = await Helper().getUnionData();
    List<Union> storeUnionData = [];
    // var alllist = LocalStore().allLocationBox.values.toList();
    var unionList = allLocationDataFromLocal.where((element) =>
        element.divisionId != null &&
        element.districtId != null &&
        element.upazilaId != null &&
        element.unionId != null &&
        element.officeTypeId.toString() != '4');
    print(storeUnionData);
    unionList.forEach((element) {
      storeUnionData.add(Union(
          unionId: element.unionId,
          unionName: element.nameEn,
          divisionId: element.divisionId,
          districtId: element.districtId,
          upazilaId: element.upazilaId));
    });
    storeUnionData.forEach(
      (e) {
        if (e.upazilaId == id) {
          allUnion.add(e);
        }
      },
    );
    print("all union length ${allUnion.length}");
    print(allUnion);
    emit(ChangeLocationSuccessState(
        officeTypeList: officeTypeList,
        division: allDivision,
        district: allDistrict,
        upazila: allUpazila,
        union: allUnion,
        otherOfficeList: otherOfficevList));
  }
}
