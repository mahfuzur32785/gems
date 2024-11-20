import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:village_court_gems/main.dart';
import 'package:village_court_gems/models/area_model/all_location_data.dart';
import 'package:village_court_gems/models/area_model/office_type_model.dart';
import 'package:village_court_gems/models/locationModel.dart';
import 'package:village_court_gems/util/constant.dart';

class Helper {
 // final SharedPreferencesAsync prefs = SharedPreferencesAsync();
  userToken(String token) async {
   await prefs.setString('token', token);
  }

  getUserToken() async {
    String? stringValue =await prefs.getString('token');
    return stringValue;
  }

  getSettingCash() async {
    String? stringValue =await prefs.getString(allSetting);
    return stringValue;
  }

  Future<void> deleteToken() async {
   await prefs.remove('token');
  }

  


//Division
  Future<void> DivisionDataInsert(List DivisionData) async {
    String locationDataJson = jsonEncode(DivisionData);
    prefs.setString('DivisionlocationData', locationDataJson);
  }

  Future<List<Division>> getDivisionData() async {
    String? locationDataJson =await prefs.getString('DivisionlocationData');

    if (locationDataJson == null || locationDataJson.isEmpty) {
      // If the stored data is empty or null, return an empty list
      return [];
    }

    List<Division> storedLocationData = List<dynamic>.from(jsonDecode(locationDataJson)).map((e) => Division.fromJson(e)).toList();
    return storedLocationData;
  }

  Future<List> updateDivisionData(List<Map<String, dynamic>> updates) async {
    List storedLocationData = await getDivisionData();

    // Apply updates to the stored data
    for (var update in updates) {
      int idToUpdate = update['id'];
      int indexToUpdate = storedLocationData.indexWhere((item) => item['id'] == idToUpdate);

      if (indexToUpdate != -1) {
        // Replace the item with the updated data
        storedLocationData[indexToUpdate] = update;
      }
    }

    // Save the modified list back to SharedPreferences
    prefs.setString('DivisionlocationData', jsonEncode(storedLocationData));

    // Return the updated list
    return storedLocationData;
  }

  // Future<void> updateDivisionData(int idToUpdate, Map<String, dynamic> newData) async {
  //

  //   List storedLocationData = await getDivisionData();

  //   // Find the item with the specified id for update
  //   int indexToUpdate = storedLocationData.indexWhere((item) => item['id'] == idToUpdate);

  //   if (indexToUpdate != -1) {
  //     // Replace the item with the updated data
  //     storedLocationData[indexToUpdate] = newData;

  //     // Save the modified list back to SharedPreferences
  //     prefs.setString('DivisionlocationData', jsonEncode(storedLocationData));
  //   }
  // }

  //office-type list
  Future<void> officeTypeDataInsert(List officeTypeData) async {
    String locationDataJson = jsonEncode(officeTypeData);
    prefs.setString('officeTypeData', locationDataJson);
  }

  Future<List<OfficeTypeData>> getOfficeTypeData() async {
    String? locationDataJson =await prefs.getString('officeTypeData');
    if (locationDataJson == null || locationDataJson.isEmpty) {
      // If the stored data is empty or null, return an empty list
      return [];
    }
    List<OfficeTypeData> storedLocationData = List<dynamic>.from(jsonDecode(locationDataJson)).map((e) => OfficeTypeData.fromJson(e)).toList();
    return storedLocationData;
  }

  Future<void> allLocationDataInsert({required List allLocationData}) async {
    String locationDataJson = jsonEncode(allLocationData);
    prefs.setString(allLocationSp, locationDataJson);
  }

  Future<void> allSettingCashed({required String distance}) async {
    prefs.setString(allSetting, distance);
  }

  Future<List<AllLocationData>> getAllLocationData() async {
    //prefs.reload();
    String? locationDataJson = await prefs.getString(allLocationSp);
    if (locationDataJson == null || locationDataJson.isEmpty) {
      // If the stored data is empty or null, return an empty list
      return [];
    }
    List<AllLocationData> storedLocationData = List<dynamic>.from(jsonDecode(locationDataJson)).map((e) => AllLocationData.fromJson(e)).toList();
    return storedLocationData;
  }

  Future<void> storeFieldSubmit({required var data}) async {
    String localFieldData = jsonEncode(data);
    final storedLocalData = await prefs.getStringList('fieldSubmit');
    if (storedLocalData != null) {
      
    } else {
      prefs.setStringList('fieldSubmit', data);
    }
  }

  //district

  Future<void> DistrictDataInsert(List DistrictData) async {
    String locationDataJson = jsonEncode(DistrictData);
    prefs.setString('DistrictlocationData', locationDataJson);
  }

  Future<List<District>> getDistrictData() async {
    String? locationDataJson =await prefs.getString('DistrictlocationData');
    if (locationDataJson == null || locationDataJson.isEmpty) {
      // If the stored data is empty or null, return an empty list
      return [];
    }
    List<District> storedLocationData = List<dynamic>.from(jsonDecode(locationDataJson)).map((e) => District.fromJson(e)).toList();
    return storedLocationData;
  }

  //upazila
  Future<void> UpazilaDataInsert(List UpazilaData) async {
    String locationDataJson = jsonEncode(UpazilaData);
    prefs.setString('UpazilalocationData', locationDataJson);
  }

  Future<List<Upazila>> getUpazilaData() async {
    String? locationDataJson =await prefs.getString('UpazilalocationData');
    if (locationDataJson == null || locationDataJson.isEmpty) {
      // If the stored data is empty or null, return an empty list
      return [];
    }
    List<Upazila> storedLocationData = List<dynamic>.from(jsonDecode(locationDataJson)).map((e) => Upazila.fromJson(e)).toList();
    return storedLocationData;
  }

  //union
  Future<void> UnionDataInsert(List UnionData) async {
    String locationDataJson = jsonEncode(UnionData);
    prefs.setString('UnionLocationData', locationDataJson);
  }

  Future<List<Union>> getUnionData() async {
    String? locationDataJson =await prefs.getString('UnionLocationData');
    if (locationDataJson == null || locationDataJson.isEmpty) {
      // If the stored data is empty or null, return an empty list
      return [];
    }
    List<Union> storedLocationData = List<dynamic>.from(jsonDecode(locationDataJson)).map((e) => Union.fromJson(e)).toList();
    return storedLocationData;
  }
}
