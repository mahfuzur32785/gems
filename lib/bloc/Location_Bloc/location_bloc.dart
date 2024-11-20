import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/field_visit_model/new_location_match_model.dart';
import 'package:village_court_gems/models/locationModel.dart';
import 'package:village_court_gems/services/all_services/all_services.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitialState()) {
    on<LocationInitialEvent>(locationInitialEvent);
    on<LocationFilterEvent>(locationfilterEvent);
  }

  bool isAllEmpty = false;
  NewLocationMatchModel? newLocationMatchModel;
  Map<String, dynamic> areaData = {};
  List<OfficeTypeList> officeList = [];

  FutureOr<void> locationInitialEvent(LocationInitialEvent event, Emitter<LocationState> emit) async {
    emit(LocationLoadingState());
    // LocationModel? locationModel;
    officeList.clear();
    areaData = {};

    NewLocationMatchModel newLocationMatchModel;
    Map? locationBody;

    locationBody = event.locationModel;
    print("bloc location  ${locationBody}");

    // Map locationBody = {
    //   "latitude": 22.08589095.toString(),
    //   "longitude": 90.22874768.toString(),
    // };
    // Map locationBody = {
    //   "latitude": 23.8127958.toString(),
    //   "longitude": 90.4288492.toString(),
    // };

    //var locationApiResponse = await Repositores().LocationApi(locationBody);
    var locationApiResponse = await Repositores().updatednewLocationMatchedApi(locationBody);

    // log(jsonEncode(locationApiResponse));

    // newLocationMatchModel = locationApiResponse;
    newLocationMatchModel = NewLocationMatchModel();
    officeList = newLocationMatchModel.officeType?.officeTypeList ?? [];

    if (newLocationMatchModel.message != "no data available" && newLocationMatchModel.officeType != null) {
      List<LocMatchedDivision> divisionList = [];
      List<LocMatchedDistrict> districtList = [];
      List<LocMatchedUpazila> upazilaList = [];
      List<LocMatchedUnion> unionList = [];

      final Map<String, dynamic> officeTypeData = newLocationMatchModel.officeType!.data as Map<String, dynamic>;
      areaData = officeTypeData;
      String? selectedOfficeId;
      String officeTitle = '';
      var locationID;
      selectedOfficeId = officeList[0].id.toString();

      for (var element in areaData[selectedOfficeId]['divisions']) {
        divisionList.add(LocMatchedDivision.fromJson(element));
      }
      if (areaData[selectedOfficeId.toString()]['districts'][0].isNotEmpty) {
        for (var element in areaData[selectedOfficeId.toString()]['districts']) {
          districtList.add(LocMatchedDistrict.fromJson(element));
        }
      } else {
        districtList = [];
      }
      if (areaData[selectedOfficeId.toString()]['unions'][0].isEmpty) {
        unionList = [];
      } else {
        for (var element in areaData[selectedOfficeId.toString()]['unions']) {
          unionList.add(LocMatchedUnion.fromJson(element));
        }
      }
      if (areaData[selectedOfficeId.toString()]['upazilas'][0].isEmpty) {
        upazilaList = [];
      } else {
        for (var element in areaData[selectedOfficeId.toString()]['upazilas']) {
          upazilaList.add(LocMatchedUpazila.fromJson(element));
        }
      }
      // if (selectedOfficeId == '4') {
      //   if (divisionList.isNotEmpty && unionList.isNotEmpty && districtList.isNotEmpty && upazilaList.isNotEmpty) {
      //     officeTitle = unionList.first.officeTitle;
      //     locationID = unionList.first.locationID;
      //   } else if (divisionList.isNotEmpty && districtList.isNotEmpty && upazilaList.isNotEmpty && unionList.isEmpty) {
      //     officeTitle = upazilaList.first.officeTitle;
      //     locationID = upazilaList.first.locationID;
      //   } else if (divisionList.isNotEmpty && districtList.isNotEmpty && upazilaList.isEmpty && unionList.isEmpty) {
      //     officeTitle = districtList.first.officeTitle;
      //     locationID = districtList.first.locationID;
      //   } else if (divisionList.isNotEmpty && districtList.isEmpty && upazilaList.isEmpty && unionList.isEmpty) {
      //     officeTitle = divisionList.first.officeTitle;
      //     locationID = divisionList.first.locationID;
      //   }
      //   //officeTitle = officeList[0].
      // } else {
      //   if (divisionList.isNotEmpty && unionList.isNotEmpty && districtList.isNotEmpty && upazilaList.isNotEmpty) {
          
      //     locationID = unionList.first.locationID;
      //   } else if (divisionList.isNotEmpty && districtList.isNotEmpty && upazilaList.isNotEmpty && unionList.isEmpty) {
          
      //     locationID = upazilaList.first.locationID;
      //   } else if (divisionList.isNotEmpty && districtList.isNotEmpty && upazilaList.isEmpty && unionList.isEmpty) {
         
      //     locationID = districtList.first.locationID;
      //   } else if (divisionList.isNotEmpty && districtList.isEmpty && upazilaList.isEmpty && unionList.isEmpty) {
          
      //     locationID = divisionList.first.locationID;
      //   }
      // }

      emit(
        LocationSuccessState(
          areaData: officeTypeData,
          officeTitle: officeTitle,
          officeList: officeList,
          division: divisionList,
          district: districtList,
          upazila: upazilaList,
          union: unionList,
          locationID: locationID,
        ),
      );
    } else {
      print("222222222222222222222222222222222222");
      emit(DialogShownState(message: "Not Matched"));
    }
  }

  locationfilterEvent(LocationFilterEvent event, Emitter<LocationState> emit) {
    List<LocMatchedDivision> divisionList = [];
    List<LocMatchedDistrict> districtList = [];
    List<LocMatchedUpazila> upazilaList = [];
    List<LocMatchedUnion> unionList = [];
    String officeTitle = '';
    var locationID;
    final key = event.id;

    if (areaData.isNotEmpty) {
      for (var element in areaData[key.toString()]['divisions']) {
        divisionList.add(LocMatchedDivision.fromJson(element));
      }
      if (areaData[key.toString()]['districts'][0].isNotEmpty) {
        for (var element in areaData[key.toString()]['districts']) {
          districtList.add(LocMatchedDistrict.fromJson(element));
        }
      } else {
        districtList = [];
      }
      if (areaData[key.toString()]['upazilas'][0].isEmpty) {
        upazilaList = [];
      } else {
        for (var element in areaData[key.toString()]['upazilas']) {
          upazilaList.add(LocMatchedUpazila.fromJson(element));
        }
      }
      if (areaData[key.toString()]['unions'][0].isEmpty) {
        unionList = [];
      } else {
        for (var element in areaData[key.toString()]['unions']) {
          unionList.add(LocMatchedUnion.fromJson(element));
        }
      }
    }
    // if (key.toString() == '4') {
    //   if (divisionList.isNotEmpty && unionList.isNotEmpty && districtList.isNotEmpty && upazilaList.isNotEmpty) {
    //     officeTitle = unionList.last.officeTitle;
    //     locationID = unionList.last.locationID;
    //   } else if (divisionList.isNotEmpty && districtList.isNotEmpty && upazilaList.isNotEmpty && unionList.isEmpty) {
    //     officeTitle = upazilaList.last.officeTitle;
    //     locationID = upazilaList.last.locationID;
    //   } else if (divisionList.isNotEmpty && districtList.isNotEmpty && upazilaList.isEmpty && unionList.isEmpty) {
    //     officeTitle = districtList.last.officeTitle;
    //     locationID = districtList.last.locationID;
    //   } else if (divisionList.isNotEmpty && districtList.isEmpty && upazilaList.isEmpty && unionList.isEmpty) {
    //     officeTitle = divisionList.last.officeTitle;
    //     locationID = divisionList.last.locationID;
    //   }
    //   //officeTitle = officeList[0].
    // } else {
    //   if (divisionList.isNotEmpty && unionList.isNotEmpty && districtList.isNotEmpty && upazilaList.isNotEmpty) {
       
    //     locationID = unionList.last.locationID;
    //   } else if (divisionList.isNotEmpty && districtList.isNotEmpty && upazilaList.isNotEmpty && unionList.isEmpty) {
       
    //     locationID = upazilaList.last.locationID;
    //   } else if (divisionList.isNotEmpty && districtList.isNotEmpty && upazilaList.isEmpty && unionList.isEmpty) {
       
    //     locationID = districtList.last.locationID;
    //   } else if (divisionList.isNotEmpty && districtList.isEmpty && upazilaList.isEmpty && unionList.isEmpty) {
        
    //     locationID = divisionList.last.locationID;
    //   }
    // }

    emit(LocationFilterState(
        officeID: key.toString(),
        locationID: locationID,
        officeList: officeList,
        division: divisionList,
        district: districtList,
        upazila: upazilaList,
        union: unionList,
        officTitle: officeTitle));
  }
}
