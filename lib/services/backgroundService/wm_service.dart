import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http_parser/src/media_type.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:village_court_gems/controller/api_services/api_client.dart';
import 'package:village_court_gems/util/constant.dart';
import 'package:workmanager/workmanager.dart';

const fieldVisitTask = 'bg_undp_gems.fieldvisit';
const fetchAllLocationTask = 'bg_undp_gems.fetchallloc';
const addChngLocationTask = 'bg_undp_gems.addnewchng';
const clearaddnewFvData = 'bg_undp_gems.clraddnfvloc';
const clearFieldVisitLocalData = 'bg_undp_gems.clrfvloc';
const fetchotheroffice = 'bg_undp_gems.fetchothoff';
const iosAllLocBg = 'bg_ios_undp_gems.fallocbg';

@pragma('vm:entry-point')
void callBackDispacher() {
  Workmanager().executeTask((taskName, inputData) async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    //prefs.reload();
    switch (taskName) {
      case fetchotheroffice:
        final url = Uri.parse("${APIClients.BASE_URL}api/change-other-office");

        var token = await prefs.getString('token');
        if (token == null) {
          print('no token in bg');
          //break;
        }
        else {
          final headers = {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          };
          try {

            List<String> otherOfficeList = [];
            final response = await http.get(url, headers: headers);
            if (response.statusCode == 200) {
              final decodedAllData = jsonDecode(response.body);
              List list = decodedAllData['data'];
              list.forEach((element) {
                otherOfficeList.add(jsonEncode(element));
              });

              //String locationDataJson = jsonEncode(decodedAllData['data']);

              await prefs.setStringList('fetchotheroff', otherOfficeList);
              print('1 all location fetched in workmanager');
            } else {
              print('Error: ${response.reasonPhrase}');
            }
          } catch (e) {}

          //prefs.setString('fetchotheroff', locationDataJson);
        }
        break;

      case fetchAllLocationTask:
        final url = Uri.parse("${APIClients.BASE_URL}api/all-location-duplicates?date=");
        var token;
        if (inputData?['token'] == null) {
           token = await prefs.getString('token');
        } else {
          token = inputData?['token'];
        }

        if (token == null) {
          print('no token in bg');
          //break;
        } else {
          final headers = {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          };
          try {
            final response = await http.get(url, headers: headers);

            print(response.statusCode);
            if (response.statusCode == 200) {
              final decodedAllData = jsonDecode(response.body);
              String locationDataJson = jsonEncode(decodedAllData['data']);
              await prefs.setString(allLocationSp, locationDataJson);
              print('2 all location fetched in workmanager');
            } else {
              print('Error: ${response.reasonPhrase}');
            }
          } catch (e) {
            print(e);
          }
        }

        break;
      case iosAllLocBg:
        print('ios periodic fetch location');
        final url = Uri.parse("${APIClients.BASE_URL}api/all-location-duplicates?date=");
        var token;
        if (inputData?['token'] == null) {
          token = await prefs.getString('token');
        } else {
          token = inputData?['token'];
        }

        if (token == null) {
          print('no token in bg');
          //break;
        } else {
          final headers = {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          };
          try {
            final response = await http.get(url, headers: headers);

            print(response.statusCode);
            if (response.statusCode == 200) {
              final decodedAllData = jsonDecode(response.body);
              String locationDataJson = jsonEncode(decodedAllData['data']);
              await prefs.setString(allLocationSp, locationDataJson);
              print('3 all location fetched in workmanager');
            } else {
              print('Error: ${response.reasonPhrase}');
            }
          } catch (e) {
            print(e);
          }
        }
        break;
      case addChngLocationTask:
        // try {
          List<Map<String, dynamic>> localFldData = [];
          var token = await prefs.getString('token');
          if (token == null) {
            print('no token in bg');
            //break;
          } else {
            var headers = {
              'Content-Type': 'multipart/form-data',
              'Accept': '*/*',
              'Authorization': 'Bearer $token',
            };
            //prefs.reload();
            final localFieldVisitData = await prefs.getStringList(addNewLocSubmitKey);
            if (localFieldVisitData != null) {
              localFieldVisitData.forEach((element) {
                localFldData.add(jsonDecode(element));
              });
              for (var nLData in localFldData) {
                if (nLData['sync'] == '0') {
                  var storeChngLocrequest = http.MultipartRequest('POST', Uri.parse('${APIClients.BASE_URL}api/store-change-location'));

                  storeChngLocrequest.headers.addAll(headers);

                  storeChngLocrequest.fields['division_id'] = nLData['division_id'];
                  storeChngLocrequest.fields['district_id'] = nLData['district_id'];
                  storeChngLocrequest.fields['upazila_id'] = nLData['upazila_id'];
                  storeChngLocrequest.fields['union_id'] = nLData['union_id'];
                  storeChngLocrequest.fields['latitude'] = nLData['latitude'];
                  storeChngLocrequest.fields['longitude'] = nLData['longitude'];
                  storeChngLocrequest.fields['office_type_id'] = nLData['office_type_id'];
                  storeChngLocrequest.fields['office_title'] = nLData['office_title'];
                  storeChngLocrequest.fields['remark'] = nLData['remark'].toString();
                  var response = await http.Response.fromStream(await storeChngLocrequest.send());
                  Map chResponse = jsonDecode(response.body);

                  if (response.statusCode == 200) {
                    debugPrint('local change location success - chng loc ID ${chResponse['change_location_id'].toString()}');
                    nLData['sync'] = '1';
                    List<String> fvimgPath = [];
                    if (nLData['img1'] != null) {
                      fvimgPath.add(nLData['img1']!);
                    }
                    if (nLData['img2'] != null) {
                      fvimgPath.add(nLData['img2']!);
                    }
                    if (nLData['img3'] != null) {
                      fvimgPath.add(nLData['img3']!);
                    }

                    var fvRequest = http.MultipartRequest('POST', Uri.parse('${APIClients.BASE_URL}api/store-field-visit'));

                    fvRequest.headers.addAll(headers);
                    final fvuploadList = <http.MultipartFile>[];
                    if (fvimgPath.isNotEmpty) {
                      for (final imageFiles in fvimgPath) {
                        fvuploadList.add(
                          await http.MultipartFile.fromPath(
                            'photos[]',
                            imageFiles.toString(),
                            filename: imageFiles.split('/').last,
                            contentType: MediaType('image', 'jpg'),
                          ),
                        );
                      }
                    }
                    fvRequest.files.addAll(fvuploadList);
                    fvRequest.fields['division_id'] = nLData['division_id'].toString();
                    fvRequest.fields['district_id'] = nLData['district_id'].toString();
                    fvRequest.fields['upazila_id'] = nLData['upazila_id'];
                    fvRequest.fields['union_id'] = nLData['union_id'];
                    fvRequest.fields['latitude'] = nLData['latitude'];
                    fvRequest.fields['longitude'] = nLData['longitude'];
                    fvRequest.fields['change_location_id'] = chResponse['change_location_id'].toString();
                    fvRequest.fields['office_type_id'] = nLData['office_type_id'];
                    fvRequest.fields['office_title'] = nLData['office_title'];
                    fvRequest.fields['lacation_match'] = '0';
                    fvRequest.fields['visit_date'] = nLData['visit_date'];

                    print("bg final request body ${fvRequest.fields}");

                    var fvsresponse = await http.Response.fromStream(await fvRequest.send());
                    if (fvsresponse.statusCode == 200) {
                      nLData['sync'] = '1';
                      nLData['img1'] = '';
                      nLData['img2'] = '';
                      nLData['img3'] = '';
                      print('Background work task change location for field visit Success');
                    } else {
                      print('local location changed fl submit  failed');
                    }
                    // var str = response.body;
                  } else if (response.statusCode == 422) {
                    debugPrint('change location failed duplicate 422');
                    nLData['sync'] = '422';
                    //return ChangeLocationModel.fromJson(jsonDecode(str));
                  } else {
                     debugPrint('change location failed smthing went wrong ${response.statusCode}');
                    nLData['sync']= '400';
                    // return ChangeLocationModel(message: 'Something went wrong');
                  }
                }
              }
              List<String> processedData = [];
              // if (cart == null) cart = [];
              localFldData.forEach((element) {
                processedData.add(jsonEncode(element));
              });

              await prefs.setStringList(addNewLocSubmitKey, processedData);
            } else {
              //no data
            }
          }

          // print("requist body ${request.fields}");
          //  print("requist body photo ${request.files.toList().length}");
        // } catch (e) {
        //   debugPrint('bg Error chngloc ${e.toString()}');
        //   //return ChangeLocationModel(message: e.toString());
        // }

        break;
      case fieldVisitTask:
        try {
          List<Map<String, dynamic>> localFldData = [];
          var token = await prefs.getString('token');
          if (token == null) {
            print('no token in bg');
            //break;
          } else {
            var headers = {
              'Content-Type': 'multipart/form-data',
              'Accept': '*/*',
              'Authorization': 'Bearer $token',
            };
            final localFieldVisitData = await prefs.getStringList('fieldVisitSubmitKey');

            if (localFieldVisitData != null) {
              localFieldVisitData.forEach((element) {
                localFldData.add(jsonDecode(element));
              });
              for (var item in localFldData) {
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
                var request = http.MultipartRequest('POST', Uri.parse('${APIClients.BASE_URL}api/store-field-visit'));
                request.headers.addAll(headers);
                final uploadList = <http.MultipartFile>[];
                if (imgPath.isNotEmpty) {
                  for (final imageFiles in imgPath) {
                    uploadList.add(
                      await http.MultipartFile.fromPath(
                        'photos[]',
                        imageFiles.toString(),
                        filename: imageFiles.split('/').last,
                        contentType: MediaType('image', 'jpg'),
                      ),
                    );
                  }
                }
                request.files.addAll(uploadList);
                request.fields['division_id'] = item['division_id'];
                request.fields['district_id'] = item['district_id'];
                request.fields['upazila_id'] = item['upazila_id'];
                request.fields['union_id'] = item['union_id'];
                request.fields['latitude'] = item['latitude'];
                request.fields['longitude'] = item['longitude'];
                request.fields['location_id'] = item['location_id'].toString();
                request.fields['office_type_id'] = item['office_type_id'];
                request.fields['office_title'] = item['office_title'];
                request.fields['lacation_match'] = '1';
                request.fields['visit_date'] = item['visit_date'];

                print("background request body ${request.fields}");

                var response = await http.Response.fromStream(await request.send());
                if (response.statusCode == 200) {
                  item['sync'] = '1';
                  item['img1'] = '';
                  item['img2'] = '';
                  item['img3'] = '';
                  print('Background work task fld vist  Success');
                } else {
                  print('Background work task fld vist  failed');
                }
              }
              List<String> processedData = [];
              // if (cart == null) cart = [];
              localFldData.forEach((element) {
                processedData.add(jsonEncode(element));
              });

              await prefs.setStringList('fieldVisitSubmitKey', processedData);
              //prefs.reload();
            }
          }
        } catch (e) {
          print('Background work task fld vist  failed ${e.toString()}');
        }
        break;
      case clearaddnewFvData:
        List<Map<String, dynamic>> localFldData = [];

        final localFieldVisitData = await prefs.getStringList(addNewLocSubmitKey);
        if (localFieldVisitData != null) {
          localFieldVisitData.forEach((element) {
            localFldData.add(jsonDecode(element));
          });
          var syncedData = localFldData.where((e) => e['sync'] == '1').toList();
          List<String> aprocessedData = [];
          // if (cart == null) cart = [];
          if (syncedData.isNotEmpty) {
            syncedData.forEach((element) {
              aprocessedData.add(jsonEncode(element));
            });
          }

          await prefs.setStringList(addNewLocSubmitKey, aprocessedData);
        }

        break;
      case clearFieldVisitLocalData:
        List<Map<String, dynamic>> localFldData = [];
        final localFieldVisitData = await prefs.getStringList('fieldVisitSubmitKey');
        if (localFieldVisitData != null) {
          localFieldVisitData.forEach((element) {
            localFldData.add(jsonDecode(element));
          });
          var syncedData = localFldData.where((e) => e['sync'] == '1').toList();
          List<String> aprocessedData = [];
          // if (cart == null) cart = [];
          if (syncedData.isNotEmpty) {
            syncedData.forEach((element) {
              aprocessedData.add(jsonEncode(element));
            });
          }

          await prefs.setStringList('fieldVisitSubmitKey', aprocessedData);
        }
        break;
      default:
        return Future.value(false);
    }
    return Future.value(true);
  });
}

void periodicallLocationFetch() {
  Workmanager().registerPeriodicTask(fetchAllLocationTask, fetchAllLocationTask,
      frequency: Duration(minutes: 15), constraints: Constraints(networkType: NetworkType.connected));
}

void iosperiodicLocationFetch(){
  Workmanager().registerPeriodicTask(iosAllLocBg, iosAllLocBg,
      constraints: Constraints(networkType: NetworkType.connected),initialDelay: Duration(seconds: 1));
}

void locationFetchedOnLogin({String? token}) {
  Workmanager().registerOneOffTask(fetchAllLocationTask, fetchAllLocationTask, inputData: {'token': token});
}

void fieldVisitSubmitTask() {
  Workmanager().registerOneOffTask(
    fieldVisitTask,
    fieldVisitTask,
    constraints: Constraints(networkType: NetworkType.connected),
  );
}

void changeFieldVisitLocationOnce() {
  Workmanager().registerOneOffTask(
    addChngLocationTask,
    addChngLocationTask,
    constraints: Constraints(networkType: NetworkType.connected),
  );
}

clearDataInBg() {
  Workmanager()
      .registerPeriodicTask(clearFieldVisitLocalData, clearFieldVisitLocalData, constraints: Constraints(networkType: NetworkType.connected));
  Workmanager().registerPeriodicTask(clearaddnewFvData, clearaddnewFvData, constraints: Constraints(networkType: NetworkType.connected));
}

void fetchOtherOffice() {
  Workmanager().registerOneOffTask(
    fetchotheroffice,
    fetchotheroffice,
    constraints: Constraints(networkType: NetworkType.connected),
  );
}


// Future<void> allLocationDataInsert({required List allLocationData}) async {
//   String locationDataJson = jsonEncode(allLocationData);
//   prefs.setString(allLocationSp, locationDataJson);
// }
