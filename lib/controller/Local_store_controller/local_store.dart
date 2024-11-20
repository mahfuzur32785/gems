import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/Local_store_model/field_submit_local.dart';
import 'package:village_court_gems/models/Local_store_model/local_image_model.dart';
import 'package:village_court_gems/models/Local_store_model/save_field_visit_model.dart';
import 'package:village_court_gems/models/area_model/all_location_data.dart';
import 'package:village_court_gems/models/area_model/all_locations_model.dart';

class LocalStore {
  Box<AllLocationData> allLocationBox = Hive.box<AllLocationData>('alllocation');
  Box<SaveLocalFieldModel> addChangeLocationBox = Hive.box<SaveLocalFieldModel>('savelocfield');
  Box<FieldSubmitLocal> fieldSubmitBox = Hive.box<FieldSubmitLocal>('fieldsubmit');
  Box<LocalImageModel> saveFldImgBox = Hive.box<LocalImageModel>('locfldimg');
  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;

  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  ConnectivityResult get connectivityResult => _connectivityResult;
  bool isConnected = true;
  //bool get isConnected => _connectivityResult != ConnectivityResult.none;
  networkChange() {
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) async {
      if (result.contains(ConnectivityResult.mobile)) {
        isConnected = true;
      } else if (result.contains(ConnectivityResult.wifi)) {
        isConnected = true;
      } else if (result.contains(ConnectivityResult.none)) {
        isConnected = false;
      }

      print('connection $isConnected');
    });
  }

  storeAllLocationDataToLocal(List<AllLocationData> locationData) async {
   // allLocationBox.clear();

    if (allLocationBox.isEmpty) {
      allLocationBox.addAll(locationData);

      //allLocationBox.addAll(locationData);
     print('add local location data  ${allLocationBox.values.toList().length}');
    } else {
      for (var element in locationData) {
        final index = allLocationBox.values.toList().indexWhere((e) => e.id == element.id);
        if (index != -1) {
          allLocationBox.putAt(index, element);
        } else {
          allLocationBox.add(element);
        }
      }
       print('update local location data  ${allLocationBox.values.toList().length}');
    }
    final localList = allLocationBox.values.toList();

    // else {
    //   for (var element in locationData) {
    //     if (!allLocationBox.values.any(
    //       (e) => e.id == element.id,
    //     )) {
    //       allLocationBox.add(element);
    //     }
    //   }
    // }
  }

  storeDataForAddnewOffice(SaveLocalFieldModel saveLocalmodel) {
    final saveFieldList = addChangeLocationBox.values.toList();
    if (saveFieldList.isEmpty) {
      addChangeLocationBox.add(saveLocalmodel);
    } else {
      int index = -1;
      index = addChangeLocationBox.values.toList().indexWhere((element) =>
          element.divisionID == saveLocalmodel.divisionID &&
          element.districtID == saveLocalmodel.districtID &&
          (element.unionID == saveLocalmodel.unionID || element.upazillaID == saveLocalmodel.upazillaID));
      if (index != -1) {
        addChangeLocationBox.putAt(index, saveLocalmodel);
      } else {}
    }
    final upList = addChangeLocationBox.values.toList();

    //var p=upList upList.firstWhere((element) => false).
  }

  storeFieldSubmitData(FieldSubmitLocal fieldSubmitLocal) {
    final saveFieldList = fieldSubmitBox.values.toList();
    if (saveFieldList.isEmpty) {
      fieldSubmitBox.add(fieldSubmitLocal);
    } else {
      int index = -1;
      index = fieldSubmitBox.values.toList().indexWhere((element) =>
          element.unionID == fieldSubmitLocal.unionID ||
          element.divisionID == fieldSubmitLocal.divisionID ||
          element.districtID == fieldSubmitLocal.districtID ||
          element.upazillaID == fieldSubmitLocal.upazillaID);
      if (index != -1) {
        fieldSubmitBox.putAt(index, fieldSubmitLocal);
      }
    }
    final upList = fieldSubmitBox.values.toList();
    //var p=upList upList.firstWhere((element) => false).
  }

  sendLocalAddNewOfficeToServer() {}

  storeLocalFieldImgData() {}
}

// Future<AllLocationModel?> backgroundLocationFetch(RootIsolateToken rootIsolateToken) async {
//   BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
//   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//   final token = sharedPreferences.getString('token') ?? '';
//   final locationsData = await Repositores().allLocationBg(token);
//   if (locationsData != null) {
//     return locationsData;
//   } else {
//     return null;
//   }
// }
