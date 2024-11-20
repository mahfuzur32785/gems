import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:village_court_gems/controller/Local_store_controller/local_store.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/main.dart';
import 'package:village_court_gems/services/all_services/all_services.dart';
import 'package:village_court_gems/util/constant.dart';
import 'package:village_court_gems/view/visit_report/visit_report_offline.dart';

class ConnectivityProvider {
  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;
  List<ConnectivityResult> _connectivityResult = [];
  List<ConnectivityResult> get connectivityResult => _connectivityResult;
  bool isConnected = false;
 

  Future<bool> rcheckInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com').timeout(Duration(seconds: 3));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    } on TimeoutException catch (_) {
      return Future.value(false);
    } on SocketException catch (_) {
      return Future.value(false);
    }
  }

  clearConnectivitySubscription() {
    connectivitySubscription.cancel();
  }

  bool backUpFieldSubmitProcessing = false;

  

  Future<void> fieldSubmitAutoSync() async {
  
    List<Map<String, dynamic>> localFldData = [];
    final checkNetwork = await ConnectivityProvider().rcheckInternetConnection();
   // final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    if (checkNetwork) {
        //prefs.reload();
      final localFieldSubmitData =await prefs.getStringList(fieldVisitSubmitKey);

      if (localFieldSubmitData != null) {
        backUpFieldSubmitProcessing = true;
        localFieldSubmitData.forEach((element) {
          localFldData.add(jsonDecode(element));
        });
        //  notifyListeners();
        for (var item in localFldData) {
          if (item['sync'] == '0') {
            List<String> imgPath = [];
            if (item['img1'] != null) {
              imgPath.add(item['img1']!);
            }
            if (item['img2'] != null) {
              imgPath.add(item['img2']!);
            }
            if (item['img3'] != null) {
              imgPath.add(item['img3']!);
            }
            final response = await Repositores().uploadDataAndImage(
              division_id: item['division_id'] ?? '',
              district_id: item['district_id'] ?? '',
              upazila_id: item['upazila_id'] == null ? '' : item['upazila_id']!,
              union_id: item['union_id'] == null ? '' : item['union_id']!,
              latitude: item['latitude']!,
              longitude: item['longitude']!,
              office_type: item['office_type_id']!,
              locationID: item['location_id'] != null ? item['location_id']! : null,
              office_title: item['office_title']!,
              location_match: item['lacation_match']!,
              imageFile: null,
              imagesPath: imgPath,
              visitDate: item['visit_date'],
            );
            print('local response message $response');
            print("feild visit data stored jjjjjjjjjjjjjjjjj");

            if (response == "success") {
              item['sync'] = '1';
              item['img1'] = '';
              item['img2'] = '';
              item['img3'] = '';

              //
              backUpFieldSubmitProcessing = false;
              AllService().showToast("Successfully Synced Data",isError: false);
              //notifyListeners();
              // break;
            } else {
              backUpFieldSubmitProcessing = false;

              AllService().showToast("Failed to Sync Data, Try again",isError: true);
              // notifyListeners();
              return;
            }
          }
        }
        List<String> processedData = [];
        localFldData.forEach((element) {
          processedData.add(jsonEncode(element));
        });

        prefs.setStringList(fieldVisitSubmitKey, processedData);

      } else {
        return;
      }
    } else {

    }
  }

  changeLocationAutoSync() async {
    //final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    print('offline add new loc called');
    List<Map<String, dynamic>> localFldData = [];
    final checkNetwork = await ConnectivityProvider().rcheckInternetConnection();
    if (checkNetwork) {
       // prefs.reload();
      final localFieldSubmitData =await prefs.getStringList(addNewLocSubmitKey);
      if (localFieldSubmitData != null) {
        localFieldSubmitData.forEach((element) {
          localFldData.add(jsonDecode(element));
        });

        for (var item in localFldData) {
          if (item['sync'] == '0') {
            final changLocationRes = await Repositores().addChangeLocation(
              division_id: item['division_id'],
              district_id: item['district_id'] != null ? item['district_id'].toString() : '',
              upazila_id: item['upazila_id'] != null ? item['upazila_id'].toString() : '',
              union_id: item['union_id'] != null ? item['union_id'].toString() : '',
              latitude: item['latitude'].toString(),
              longitude: item['longitude'].toString(),
              remark: item['remark'].toString(),
              office_type_id: item['office_type_id'] != null ? item['office_type_id'].toString() : '',
              office_title: item['office_type_id'].toString() == "4" ? item['office_title'].toString() : "",
            );
            if (changLocationRes.message == "success") {
              item['sync'] = '1';
              List<String> imgPath = [];
              if (item['img1'] != null) {
                imgPath.add(item['img1']!);
              }
              if (item['img2'] != null) {
                imgPath.add(item['img2']!);
              }
              if (item['img3'] != null) {
                imgPath.add(item['img3']!);
              }
              final response = await Repositores().uploadDataAndImage(
                division_id: item['division_id'] ?? '',
                district_id: item['district_id'] ?? '',
                upazila_id: item['upazila_id'] ?? '',
                union_id: item['union_id'] == null ? '' : item['union_id'].toString(),
                latitude: item['latitude'].toString(),
                longitude: item['longitude'].toString(),
                office_type: item['office_type_id'].toString(),
                changeLocationID: changLocationRes.changeLocationId,
                office_title: item['office_title'].toString(),
                location_match: '0',
                imageFile: null,
                imagesPath: imgPath,
                visitDate: item['visit_date'],
              );
              print("canged location data stored jjjjjjjjjjjjjjjjj");

              if (response == 'success') {
                item['sync'] = '1';
                item['img1'] = '';
                item['img2'] = '';
                item['img3'] = '';

                AllService().showToast("Successfully Synced Data",isError: true);
              } else {
                item['sync'] = '-1';
                item['img1'] = '';
                item['img2'] = '';
                item['img3'] = '';
                AllService().showToast("Failed to Sync Data, Try again",isError: false);
              }
            }
            else{
              
            }
          }
        }
        List<String> processedData = [];
        // if (cart == null) cart = [];
        localFldData.forEach((element) {
          processedData.add(jsonEncode(element));
        });

        prefs.setStringList(addNewLocSubmitKey, processedData);
        
      }
    }
  }
  clearLocaladdNewLocData() async{
   // final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    //prefs.reload();
    List<Map<String, dynamic>> localFldData = [];
    final localFieldVisitData =await prefs.getStringList(addNewLocSubmitKey);
    if (localFieldVisitData != null) {
      localFieldVisitData.forEach((element) {
        localFldData.add(jsonDecode(element));
      });
      final syncedData = localFldData.where((e) => e['sync'] == '1').toList();
      debugPrint('local syncedData ${syncedData.length}');
      List<String> aprocessedData = [];
      // if (cart == null) cart = [];
      if (syncedData.isNotEmpty) {
        syncedData.forEach((element) {
          aprocessedData.add(jsonEncode(element));
        });
        prefs.setStringList(addNewLocSubmitKey, aprocessedData);
      }
    }
  }

  clearLocalFvData() async{
   // final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    List<String> fvprocessedData = [];
    List<Map<String, dynamic>> localFldData = [];
    final localFieldVisitData =await prefs.getStringList(fieldVisitSubmitKey);
    if (localFieldVisitData != null) {
      localFieldVisitData.forEach((element) {
        localFldData.add(jsonDecode(element));
      });
      final syncedData = localFldData.where((e) => e['sync'] == '1').toList();
      debugPrint('local syncedData ${syncedData.length}');
      if (syncedData.isNotEmpty) {
        syncedData.forEach((element) {
          fvprocessedData.add(jsonEncode(element));
        });
        prefs.setStringList(fieldVisitSubmitKey, fvprocessedData);
      }
    }
  }

Future<void> removeAllUserData()async{
  //final SharedPreferencesAsync prefs = SharedPreferencesAsync();
   await prefs.remove(allLocationSp);
  await prefs.remove(addNewLocSubmitKey);
  await prefs.remove(fieldVisitSubmitKey);
 

  }


 

  
}

  // Future<void> fieldSubmitAutoSync() async {
  //   LocalStore localStore = LocalStore();

  //   final localFieldSubmitData = localStore.fieldSubmitBox.values.toList();
  //   if (localFieldSubmitData.isNotEmpty) {
  //     backUpFieldSubmitProcessing = true;
  //     //  notifyListeners();
  //     for (var item in localFieldSubmitData) {
  //       if (item.syncStatus == 'offline') {
  //         List<String> imgPath = [];
  //         if (item.locimg1 != null) {
  //           imgPath.add(item.locimg1!);
  //         }
  //         if (item.locimg2 != null) {
  //           imgPath.add(item.locimg2!);
  //         }
  //         if (item.locimg3 != null) {
  //           imgPath.add(item.locimg3!);
  //         }
  //         final response = await Repositores().uploadDataAndImage(
  //           division_id: item.divisionID.toString(),
  //           district_id: item.districtID.toString(),
  //           upazila_id: item.upazillaID == null ? '' : item.upazillaID.toString(),
  //           union_id: item.unionID == null ? '' : item.unionID.toString(),
  //           latitude: item.latitude.toString(),
  //           longitude: item.longitude.toString(),
  //           office_type: item.officeTypeID.toString(),
  //           locationID: item.locationID,
  //           office_title: item.officeTitle.toString(),
  //           location_match: item.locationMatch.toString(),
  //           imageFile: null,
  //           imagesPath: imgPath,
  //         );
  //         print('local response message $response');
  //         if (response == "success") {
  //           localStore.fieldSubmitBox.clear();
  //           backUpFieldSubmitProcessing = false;
  //           AllService().tost("Successfully Synced Data");
  //           //notifyListeners();
  //           break;
  //         } else {
  //           backUpFieldSubmitProcessing = false;
  //           localStore.fieldSubmitBox.clear();
  //           AllService().tost("Failed to Sync Data, Try again");
  //           // notifyListeners();
  //           return;
  //         }
  //       }
  //     }
  //   } else {
  //     return;
  //   }
  // }

//   changeLocationAutoSync({required BuildContext context}) async {
//     print('offline add new loc called');
//     //  backUpFieldSubmitProcessing = true;
//     //  notifyListeners();
//     LocalStore localStore = LocalStore();
//     final localData = localStore.addChangeLocationBox.values.toList();
//     if (localData.isNotEmpty) {
//       for (var element in localData) {
//         if (element.syncStatus == 'offline') {
//           if (element.isChangeLocation == 'true') {
//             final changLocationRes = await Repositores().addChangeLocation(
//               division_id: element.divisionID.toString(),
//               district_id: element.districtID != null ? element.districtID.toString() : '',
//               upazila_id: element.upazillaID != null ? element.upazillaID.toString() : '',
//               union_id: element.unionID != null ? element.unionID.toString() : '',
//               latitude: element.latitude.toString(),
//               longitude: element.longitude.toString(),
//               remark: element.remark.toString(),
//               office_type_id: element.officeTypeID != null ? element.officeTypeID.toString() : '',
//               // office_type_id: selectedOffice == "DC/DDLG Office"
//               //     ? "1"
//               //     : selectedOffice == "UNO Office"
//               //         ? "3"
//               //         : selectedOffice == "UP Office"
//               //             ? "2"
//               //             : selectedOffice == "Other Office"
//               //                 ? "4"
//               //                 : "",
//               office_title: element.officeTypeID.toString() == "4" ? element.officeTitle.toString() : "",
//             );
//             if (changLocationRes.message == "success") {
//               List<String> imgPath = [];
//               if (element.clocimg1 != null) {
//                 imgPath.add(element.clocimg1!);
//               }
//               if (element.clocimg2 != null) {
//                 imgPath.add(element.clocimg2!);
//               }
//               if (element.clocimg3 != null) {
//                 imgPath.add(element.clocimg3!);
//               }
//               final response = await Repositores().uploadDataAndImage(
//                 division_id: element.divisionID.toString(),
//                 district_id: element.districtID.toString(),
//                 upazila_id: element.upazillaID == null ? '' : element.upazillaID.toString(),
//                 union_id: element.unionID == null ? '' : element.unionID.toString(),
//                 latitude: element.latitude.toString(),
//                 longitude: element.longitude.toString(),
//                 office_type: element.officeTypeID.toString(),
//                 locationID: changLocationRes.changeLocationId,
//                 office_title: element.officeTitle.toString(),
//                 location_match: '0',
//                 imageFile: null,
//                 imagesPath: imgPath,
//               );

//               localStore.addChangeLocationBox.clear();
//               backUpFieldSubmitProcessing = false;
//               AllService().tost("Successfully Synced Data");
//               //  notifyListeners();
//               break;
//             } else {
//               backUpFieldSubmitProcessing = false;
//               localStore.addChangeLocationBox.clear();
//               AllService().tost("Failed to Sync Data, Try again");

//               //   notifyListeners();
//               return;
//             }
//           }
//         }
//       }
//     }
//   }
// }

 
// enum ConnectivityStatus { connected, disconnected }
// //enum ConnectivityEvent { checkConnectivity }

// class ConnectivityBloc extends Bloc<ConnectivityStatus, bool> {
//    late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;

//   ConnectivityBloc() : super(false) {
//     on<ConnectivityStatus>((event, emit) async {
//       await checkConnectivity(emit, event);
//     });
  
//   }
// checkConnectivity(Emitter<ConnectivityStatus> emit, LoginEvent event){
//     connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) {
//             if (result.contains(ConnectivityResult.mobile)) {
//         add(ConnectivityStatus.connected);
//       } else if (result.contains(ConnectivityResult.wifi)) {
//         add(ConnectivityStatus.connected);
//       } else if (result.contains(ConnectivityResult.none)) {
//         add(ConnectivityStatus.disconnected);
//       }

// //       print('connection $isConnected');
//       //add(ConnectivityEvent.checkConnectivity);
//     });
// }
 
//   @override
//   Stream<bool> mapEventToState(ConnectivityStatus event) async* {
//     yield event == ConnectivityStatus.connected;
//   }

//   @override
//   Future<void> close() {
//     connectivitySubscription.cancel();
//     return super.close();
//   }
// }
