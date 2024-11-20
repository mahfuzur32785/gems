import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:village_court_gems/controller/api_services/api_client.dart';
import 'package:village_court_gems/controller/global.dart';
import 'package:village_court_gems/main.dart';
import 'package:village_court_gems/models/ActivityDetailsForEditModel.dart';
import 'package:village_court_gems/models/TraningsInfoDetailsModel.dart';
import 'package:village_court_gems/models/aacoInfoEditModel.dart';
import 'package:village_court_gems/models/aacoListModel.dart';
import 'package:village_court_gems/models/aaco_model/aaco_district_model.dart';
import 'package:village_court_gems/models/aaco_model/aaco_edit_data_model.dart';
import 'package:village_court_gems/models/aaco_model/aaco_nav_model.dart';
import 'package:village_court_gems/models/activityEditModel.dart';
import 'package:village_court_gems/models/area_model/all_district_model.dart';
import 'package:village_court_gems/models/activityDetailsModel.dart';
import 'package:village_court_gems/models/area_model/all_location_data.dart';
import 'package:village_court_gems/models/area_model/all_locations_model.dart';
import 'package:village_court_gems/models/area_model/office_type_model.dart';
import 'package:village_court_gems/models/avtivity._model.dart';
import 'package:village_court_gems/models/countModel.dart';
import 'package:village_court_gems/models/field_visit_model/FieldFindingCreateModel.dart';
import 'package:village_court_gems/models/field_visit_model/change_location_model.dart';
import 'package:village_court_gems/models/field_visit_model/fieldVisitUpdateModel.dart';
import 'package:village_court_gems/models/field_visit_model/field_visit_list_details_model.dart';
import 'package:village_court_gems/models/field_visit_model/field_visit_list_model.dart';
import 'package:village_court_gems/models/field_visit_model/new_location_match_model.dart';
import 'package:village_court_gems/models/field_visit_model/updated_new_loc_model.dart';
import 'package:village_court_gems/models/footprint_model.dart';
import 'package:village_court_gems/models/frontend_model.dart';
import 'package:village_court_gems/models/locationModel.dart';
import 'package:village_court_gems/models/new_TraningModel.dart';
import 'package:village_court_gems/models/profile_model.dart';
import 'package:village_court_gems/models/progress_report_model.dart';
import 'package:village_court_gems/models/traning_details_model.dart';
import 'package:village_court_gems/models/traning_model.dart';
import 'package:village_court_gems/models/triningEditModel.dart';
import 'package:http_parser/src/media_type.dart';
import 'package:village_court_gems/services/all_services/all_services.dart';

import 'package:village_court_gems/services/database/localDatabaseService.dart';
import 'package:village_court_gems/util/constant.dart';

class Repositores {
  Future<Map> loginAPi(String mobile, String password) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/login?mobile=$mobile&password=$password");
    final headers = {'Content-Type': 'application/json'};
    Map<String, String> body = {
      "mobile": mobile,
      "password": password,
    };
    print(body);
    try {
      final Response response = await http.post(url, headers: headers, body: jsonEncode(body));
      print("status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('loginAPi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.reasonPhrase}');
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  // logout
  Future<Map> LogoutAPi() async {
    final url = Uri.parse("${APIClients.BASE_URL}api/logout");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.post(url, headers: headers, body: {});
      print("LogoutAPi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('LogoutAPi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('LogoutAPi Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<ProfileModel> GetProfileApi() async {
    final url = Uri.parse("${APIClients.BASE_URL}api/profile");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("GetProfileApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('GetProfileApi repopose');
        print(jsonDecode(response.body));
        return ProfileModel.fromJson(json.decode(response.body));
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return ProfileModel(
      message: '',
      status: 0,
    );
  }

  Future<String> settingApi() async {
    final url = Uri.parse("${APIClients.BASE_URL}api/app-setting");
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("GetSettingApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('GetSettingApi repopose');
        print(jsonDecode(response.body));
        return json.decode(response.body)['data']['distance'].toString();
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return '';
  }

  Future<Map> otp_Verification(String otp) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/otp?otp=$otp");

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $g_Token',
    };

    Map<String, String> body = {"otp": otp};
    print(body);
    try {
      final Response response = await http.post(url, headers: headers, body: jsonEncode(body));
      print("otp_Verification status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('otp_Verification repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<NewTrainingModel> allTrainigsInfoSettingApi() async {
    final url = Uri.parse("${APIClients.BASE_URL}api/training-info-setting");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final Response response = await http.get(url, headers: headers);
      print("trainingInfoSettingApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('trainingInfoSettingApi repopose');
        print(jsonDecode(response.body));
        return NewTrainingModel.fromJson(json.decode(response.body));
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return NewTrainingModel(data: [], status: 2, message: '');
  }

  Future<Map> divisionApi() async {
    final url = Uri.parse("${APIClients.BASE_URL}api/division");
    //String a = "18|Lh1LWJJflj1FmVi2N6gdr7zNn0J8kl9Wri9CFakX52d1ae52";
    // String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("districtApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('districtApi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<OfficeTypeModel?>? getOfficeTypeApi() async {
    final url = Uri.parse("${APIClients.BASE_URL}api/office-type");
    OfficeTypeModel? officeTypeModel = OfficeTypeModel();

    //String a = "18|Lh1LWJJflj1FmVi2N6gdr7zNn0J8kl9Wri9CFakX52d1ae52";
    // String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("districtApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('districtApi repopose');
        print(jsonDecode(response.body));
        officeTypeModel = OfficeTypeModel.fromJson(jsonDecode(response.body));
        return officeTypeModel;
      } else {
        officeTypeModel = null;
        // print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
      return officeTypeModel;
    }
    return officeTypeModel;
  }

  Future<List<FootprintResponseModel>?>? getFootprintsApi() async {
    final url = Uri.parse("${APIClients.BASE_URL}api/footprints");

    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final Response response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        return List<dynamic>.from(jsonDecode(response.body)["data"]).map((e) => FootprintResponseModel.fromJson(e)).toList();
      }
    } catch (e) {
      print(e);
      return [];
    }
    return [];
  }

  Future<List<FootprintResponseModel>?>? getFootprintsApiOpen() async {
    final url = Uri.parse("${APIClients.BASE_URL}api/field-visit-footprints");

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    try {
      final Response response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        return List<dynamic>.from(jsonDecode(response.body)["data"]).map((e) => FootprintResponseModel.fromJson(e)).toList();
      }
    } catch (e) {
      print(e);
      return [];
    }
    return [];
  }

  Future<FrontendModel>? getFrontendApi() async {
    final url = Uri.parse("${APIClients.BASE_URL}api/frontend");

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    try {
      final Response response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        return FrontendModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print(e);
      return FrontendModel();
    }
    return FrontendModel();
  }

  //For offline store all location in cache
  Future<void> allLocationInForeground() async {
    String? lastDate;
    lastDate = await prefs.getString(latestDate);

    final url = Uri.parse("${APIClients.BASE_URL}api/all-location-duplicates?date=${lastDate??"null"}");
    var token = await Helper().getUserToken();
    if (token == null) {
      return null;
    } else {
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      // try {
        final Response response = await http.get(url, headers: headers);

        print(response.statusCode);
        if (response.statusCode == 200) {
          log('All Location Fetched ${url}');
          // log('dfhdgfhdgfh ${jsonDecode(response.body)}');
          final decodedAllData = jsonDecode(response.body);
          String locationDataJson = jsonEncode(decodedAllData['data']);
          List<AllLocationData> oldData = [];
          List<AllLocationData> newData = [];
          List<AllLocationData> storedFinalCallLocationData = [];

         
          var ldata = await prefs.getString(allLocationSp);
 print("First key is empty or not: ${ldata}");
          if(ldata == null) {
            await prefs.setString(allLocationSp, locationDataJson);
            String? locationDataFirstCall = await prefs.getString(allLocationSp);
            oldData = List<dynamic>.from(jsonDecode(locationDataFirstCall!)).map((e) => AllLocationData.fromJson(e)).toList();
            DateTime? lastDate;
            for (var item in storedFinalCallLocationData) {
              if(item.updatedAt !=null ){
                String updatedAtString = item.updatedAt!;
                DateTime updatedAtDate = DateTime.parse(updatedAtString);
                if (lastDate == null || updatedAtDate.isAfter(lastDate)) {
                  lastDate = updatedAtDate;
                }
              }
            }
            await prefs.setString(latestDate, lastDate.toString());
            print("1 First Call Data (OldData): hhhhh ${oldData.length}");
            print("1 After first cached (NewData): hhhhh ${newData.length}");
            print("1 Store cached modified and new data (FinalData): hhhhhh ${storedFinalCallLocationData.length}");
            print("1 Last Date: hhhhhh ${lastDate}");

          } else{
            String? locationDataFirstCall = await prefs.getString(allLocationSp);
            oldData = List<dynamic>.from(jsonDecode(locationDataFirstCall!)).map((e) => AllLocationData.fromJson(e)).toList();

            newData = List<dynamic>.from(jsonDecode(locationDataJson)).map((e) => AllLocationData.fromJson(e)).toList();
            for (var newItem in newData) {
              int index = oldData.indexWhere((oldItem) => oldItem.id == newItem.id);
              if (index != -1) {
                oldData[index] = newItem;
              } else {
                oldData.add(newItem);
              }
            }

            String finalData = jsonEncode(oldData);
            await prefs.setString(allLocationSp, finalData);
            String? locationDataFinalCall = await prefs.getString(allLocationSp);
            storedFinalCallLocationData = List<dynamic>.from(jsonDecode(locationDataFinalCall!)).map((e) => AllLocationData.fromJson(e)).toList();
            DateTime? lastDate;
            for (var item in storedFinalCallLocationData) {
              if(item.updatedAt !=null ){
                String updatedAtString = item.updatedAt!;
                DateTime updatedAtDate = DateTime.parse(updatedAtString);
                if (lastDate == null || updatedAtDate.isAfter(lastDate)) {
                  lastDate = updatedAtDate;
                }
              }
            }
            await prefs.setString(latestDate, lastDate.toString());

            print("2 First Call Data (OldData): hhhhh ${oldData.length}");
            print("2 After first cached (NewData): hhhhh ${newData.length}");
            print("2 Store cached modified and new data (FinalData): hhhhhh ${storedFinalCallLocationData.length}");
            print("2 Last Date: hhhhhh ${lastDate}");
          }

        } else {
          print('Error: ${response.reasonPhrase}');
        }
      // } catch (e) {
      //   print(e);
      // }
    }

    return null;
  }

  Future<void> allLocationBg(String token) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/all-location-duplicates?date=");

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {

      final Response response = await http.get(url, headers: headers);
      print(response.statusCode);
      if (response.statusCode == 200) {
        log('gdsgsdfgdsfg ${jsonDecode(response.body)}');
        final decodedAllData = jsonDecode(response.body);
        String locationDataJson = jsonEncode(decodedAllData['data']);
        await prefs.setString(allLocationSp, locationDataJson);
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<Map> districtApi(int id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/division-wise-district/$id");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("districtApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('districtApi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<Map> districtOfflineApi() async {
    final url = Uri.parse("${APIClients.BASE_URL}api/districts");
    final headers = {
      'Accept': 'application/json',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("districtOfflineApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('districtOfflineApi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<Map> upazilaApi(int id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/district-wise-upazila/$id");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("upazilatApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('upazilatApi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<Map> upazilaOflineApi() async {
    final url = Uri.parse("${APIClients.BASE_URL}api/upazilas");

    final headers = {'Accept': 'application/json'};
    try {
      final Response response = await http.get(url, headers: headers);
      print("upazilaOflineApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('upazilaOflineApi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<Map> unionApi(int id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/upazila-wise-union/$id");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("unionApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('unionApi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<Map> unionOflineApi() async {
    final url = Uri.parse("${APIClients.BASE_URL}api/unions");

    final headers = {'Accept': 'application/json'};
    try {
      final Response response = await http.get(url, headers: headers);
      print("unionOflineApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('unionOflineApi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<Map> trainingInfoSubmit(dynamic trainingBody) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/training");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final Response response = await http.post(url, headers: headers, body: trainingBody);
      print("training update status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('training update response');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<Map> trainingInfoUpdate(dynamic trainingBody, String id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/training/$id");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final Response response = await http.post(url, headers: headers, body: trainingBody);
      print("trainingInfoUpdate status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('trainingInfoUpdate repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<TrainingModel> allTrainigsShowApi() async {
    final url = Uri.parse("${APIClients.BASE_URL}api/training-info-setting");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    // try {
    final Response response = await http.get(url, headers: headers);
    print("trainingInfoSettingApi status Code");
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('trainingInfoSettingApi response');
      print(jsonDecode(response.body));
      return TrainingModel.fromJson(json.decode(response.body));
    } else {
      print('Error: ${response.reasonPhrase}');
    }
    // } catch (e) {
    //   print(e);
    // }
    return TrainingModel(data: [], status: 2, message: '');
  }

  Future<TrainingDetailsModels> TrainigsDetailsAPi() async {
    final url = Uri.parse("${APIClients.BASE_URL}api/training");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final Response response = await http.get(url, headers: headers);
    print("TrainigsDetailsAPi status Code");
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('TrainigsDetailsAPi repopose');
      print(jsonDecode(response.body));
      return TrainingDetailsModels.fromJson(json.decode(response.body));
    } else {
      print('Error: ${response.reasonPhrase}');
    }

    return TrainingDetailsModels(data: [], status: 1, message: "");
  }

  Future<Activity> ActivityApi() async {
    final url = Uri.parse("${APIClients.BASE_URL}api/activity-info-setting");
    String token = await Helper().getUserToken();
    //http://127.0.0.1:8000/api/activity
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("ActivityApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('ActivityApi repopose');
        print(jsonDecode(response.body));
        return Activity.fromJson(json.decode(response.body));
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return Activity(data: [], status: 1, message: "");
  }

  Future<ProgressReportModel> progressReportApi() async {
    final url = Uri.parse("${APIClients.BASE_URL}api/progress-reports");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("ActivityApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('ActivityApi repopose');
        print(jsonDecode(response.body));
        return ProgressReportModel.fromJson(json.decode(response.body));
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return ProgressReportModel();
  }

  // Future<ActivityListModel> ActivityDetailsList() async {
  //   final url = Uri.parse("${APIClients.BASE_URL}api/activity");
  //   String token = await Helper().getUserToken();
  //   // String a = "10|GOY3kH493UHQRnr2hUlaubxvYPwmoTJsWmZvJfDz19edffaf";
  //   final headers = {
  //     'Accept': 'application/json',
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $token',
  //   };

  //   final Response response = await http.get(url, headers: headers);
  //   print("ActivityDetailsList status Code");
  //   print(response.statusCode);
  //   if (response.statusCode == 200) {
  //     print('ActivityDetailsList repopose');
  //     print(jsonDecode(response.body));
  //     return ActivityListModel.fromJson(json.decode(response.body));
  //   } else {
  //     print('Error: ${response.reasonPhrase}');
  //   }

  //   return ActivityListModel(data: [], status: 0, message: "");
  // }

  Future<ActivityDetailsModel> ActivityDetailsApi(String id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/activity-info-setting-generate/$id");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("ActivityDetailsApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('ActivityDetailsApi repopose');
        print(jsonDecode(response.body));
        return ActivityDetailsModel.fromJson(json.decode(response.body));
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return ActivityDetailsModel(activityDetailsModel: [], status: 1, message: "");
  }

  Future<ActivityDetailsForEditModel> ActivityDetailsForEditApi(String id, String currentPage) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/activity-info-wise-activity/$id?page=$currentPage");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("ActivityDetailsForEditApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('ActivityDetailsForEditApi repopose');
        print(jsonDecode(response.body));
        return ActivityDetailsForEditModel.fromJson(json.decode(response.body));
      } else {
        print('ActivityDetailsForEditApi Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return ActivityDetailsForEditModel(status: 0, message: '', data: []);
  }

  Future<Map> ActivityDataSubmitApi(dynamic activityBody) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/activity");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.post(url, headers: headers, body: activityBody);
      print("ActivityDataSubmitApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('ActivityDataSubmitApi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<ActivityEditModel> ActivityDataEditApi(String id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/activity-edit/$id");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final Response response = await http.get(url, headers: headers);
    print("ActivityDataEditApi status Code");
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('ActivityDataEditApi repopose');
      print(jsonDecode(response.body));
      return ActivityEditModel.fromJson(json.decode(response.body));
    } else {
      print('ActivityDataEditApi Error: ${response.reasonPhrase}');
    }

    return ActivityEditModel(status: 0, message: '', activityEditData: []);
  }

  Future<Map> ActivityDataEditSubmitApi(dynamic activityEditData, String id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/activity-update/$id");
    // String token = await Helper().getUserToken();
    //   String token = '18|Lh1LWJJflj1FmVi2N6gdr7zNn0J8kl9Wri9CFakX52d1ae52';
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.post(url, headers: headers, body: activityEditData);
      print("ActivityDataEditSubmitApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('ActivityDataEditSubmitApi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('ActivityDataEditSubmitApi Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<LocationModel> LocationApi(dynamic locationBody) async {
    // final url = Uri.parse("${APIClients.BASE_URL}api/location");
    final url = Uri.parse("${APIClients.BASE_URL}api/new-location");
    print("url is: ${url}");
    print("new-location body data is: ${locationBody}");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    // try {
    final Response response = await http.post(url, headers: headers, body: locationBody);
    print("LocationApi status Code");
    log('${response.statusCode}');
    if (response.statusCode == 200) {
      print('LocationApi repopose');
      Map jsonx = jsonDecode(response.body);
      log('${response.body}');
      //log(jsonDecode(response.body));
      return LocationModel.fromJson(json.decode(response.body));
    } else {
      print('Error: ${response.reasonPhrase}');
    }
    // } catch (e) {
    //   print(e);
    // }
    return LocationModel(unions: [], upazilas: [], districts: [], divisions: [], status: 0);
  }

  Future<UpdNewLocation> updatednewLocationMatchedApi(dynamic locationBody) async {
    // final url = Uri.parse("${APIClients.BASE_URL}api/location");
    final url = Uri.parse("${APIClients.BASE_URL}api/new-location");
    print("url is: ${url}");
    print("body data is: ${locationBody}");
    try {
      String token = await Helper().getUserToken();
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      // try {
      final Response response = await http.post(url, headers: headers, body: locationBody).timeout(Duration(seconds: 15));
      print("LocationApi status Code");
      log('${response.statusCode}');
      if (response.statusCode == 200) {
        print('LocationApi repopose');
        Map jsonx = jsonDecode(response.body);
        log('${response.body}');
        //log(jsonDecode(response.body));
        return UpdNewLocation.fromJson(json.decode(response.body));
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } on TimeoutException catch (_) {
      return UpdNewLocation(data: [], status: 408);
    } on Exception catch (e) {
      return UpdNewLocation(data: [], status: 0);
    }
    // } catch (e) {
    //   print(e);
    // }
    return UpdNewLocation(data: [], status: 0);
  }

  // Future<NewLocationMatchModel> newLocationMatchedApi(dynamic locationBody) async {
  //   // final url = Uri.parse("${APIClients.BASE_URL}api/location");
  //   final url = Uri.parse("${APIClients.BASE_URL}api/new-location");
  //   print("url is: ${url}");
  //   print("body data is: ${locationBody}");
  //   String token = await Helper().getUserToken();
  //   final headers = {
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer $token',
  //   };
  //   // try {
  //   final Response response = await http.post(url, headers: headers, body: locationBody);
  //   print("LocationApi status Code");
  //   log('${response.statusCode}');
  //   if (response.statusCode == 200) {
  //     print('LocationApi repopose');
  //     Map jsonx = jsonDecode(response.body);
  //     log('${response.body}');
  //     //log(jsonDecode(response.body));
  //     return NewLocationMatchModel.fromJson(json.decode(response.body));
  //   } else {
  //     print('Error: ${response.reasonPhrase}');
  //   }
  //   // } catch (e) {
  //   //   print(e);
  //   // }
  //   return NewLocationMatchModel(officeType: null, status: 0);
  // }

  Future<String> uploadDataAndImage({
    required String division_id,
    required String district_id,
    required String upazila_id,
    required String union_id,
    required String latitude,
    required String longitude,
    // required String visit_purpose,
    required String office_type,
    required String office_title,
    required String location_match,
    String? locationID,
    int? changeLocationID,
    List<File>? imageFile,
    List<String>? imagesPath,
    required String visitDate,
  }) async {
    try {
      String token = await Helper().getUserToken();

      var headers = {
        'Content-Type': 'multipart/form-data',
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };
      var request = http.MultipartRequest('POST', Uri.parse('${APIClients.BASE_URL}api/store-field-visit'));
      print("file upload url: ${request.url}");
      request.headers.addAll(headers);
      final uploadList = <MultipartFile>[];
      if (imageFile != null) {
        for (final imageFiles in imageFile) {
          uploadList.add(
            await MultipartFile.fromPath(
              'photos[]',
              imageFiles.path.toString(),
              filename: imageFiles.path.split('/').last,
              contentType: MediaType('image', 'jpg'),
            ),
          );
        }
      }
      if (imagesPath != null) {
        for (final imageFiles in imagesPath) {
          uploadList.add(
            await MultipartFile.fromPath(
              'photos[]',
              imageFiles.toString(),
              filename: imageFiles.split('/').last,
              contentType: MediaType('image', 'jpg'),
            ),
          );
        }
      }

      request.files.addAll(uploadList);
      request.fields['division_id'] = division_id.toString();
      request.fields['district_id'] = district_id.toString();
      request.fields['upazila_id'] = upazila_id.toString();
      request.fields['union_id'] = union_id.toString();
      request.fields['latitude'] = latitude.toString();
      request.fields['longitude'] = longitude.toString();
      if (changeLocationID != null) {
        request.fields['change_location_id'] = changeLocationID.toString();
      }
      if (locationID != null) {
        request.fields['location_id'] = locationID.toString();
      }

      //request.fields['visit_purpose'] = visit_purpose;
      request.fields['office_type_id'] = office_type;
      request.fields['office_title'] = office_title;
      request.fields['lacation_match'] = location_match;
      request.fields['visit_date'] = visitDate;

      print("requist body ${request.fields}");
      print("requist body photo ${request.files.toList().length}");

      var response = await http.Response.fromStream(await request.send()).timeout(Duration(seconds: 15));
      var str = response.body;
      print("file upload response ${str}");
      if (response.statusCode == 200) {
        return jsonDecode(str)["message"];
      } else {
        return "Something Wrong";
      }
    } on TimeoutException catch (_) {
      return "timeout";
    } catch (e) {
      return "$e";
    }
  }

  Future<ChangeLocationModel> addChangeLocation({
    required String division_id,
    required String district_id,
    required String upazila_id,
    required String union_id,
    required String office_type_id,
    required String office_title,
    required String latitude,
    required String longitude,
    required String remark,
  }) async {
    try {
      String token = await Helper().getUserToken();

      var headers = {
        'Content-Type': 'multipart/form-data',
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };
      var request = http.MultipartRequest('POST', Uri.parse('${APIClients.BASE_URL}api/store-change-location'));
      print("file upload url: ${request.url}");
      request.headers.addAll(headers);

      request.fields['division_id'] = division_id.toString();
      request.fields['district_id'] = district_id.toString();
      request.fields['upazila_id'] = upazila_id.toString();
      request.fields['union_id'] = union_id.toString();
      request.fields['latitude'] = latitude.toString();
      request.fields['longitude'] = longitude.toString();
      request.fields['office_type_id'] = office_type_id;
      request.fields['office_title'] = office_title;
      request.fields['remark'] = remark;

      print("request body ${request.fields}");
      //  print("requist body photo ${request.files.toList().length}");

      var response = await http.Response.fromStream(await request.send()).timeout(Duration(seconds: 15));
      var str = response.body;
      print("file upload response ${str}");
      if (response.statusCode == 200) {
        return ChangeLocationModel.fromJson(jsonDecode(str));
      } else if (response.statusCode == 422) {
        return ChangeLocationModel.fromJson(jsonDecode(str));
      } else {
        return ChangeLocationModel(message: 'Something went wrong');
      }
    } catch (e) {
      return ChangeLocationModel(message: e.toString());
    }
  }

  Future<Map> ChangeLocationSubmitApi(dynamic changeLocationData) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/store-change-location");
    // String token = await Helper().getUserToken();
    //   String token = '18|Lh1LWJJflj1FmVi2N6gdr7zNn0J8kl9Wri9CFakX52d1ae52';
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.post(url, headers: headers, body: changeLocationData);
      print("ChangeLocationSubmitApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('ChangeLocationSubmitApi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<TrainingEditModel> TrainigsEditAPi(var id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/training/$id");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    print("Training EditAPi $url");

    final Response response = await http.get(url, headers: headers);
    print("Training EditAPi status Code");
    print(response.statusCode);
    if (response.statusCode == 200) {
      // log("Training EditAPi response: ${jsonDecode(response.body)}");
      return TrainingEditModel.fromJson(json.decode(response.body));
    } else {
      print('Error: ${response.reasonPhrase}');
    }

    return TrainingEditModel();
  }

  Future<Map> TrainigsEditSubmitAPi(dynamic trainingBody, String id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/training/$id");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.post(url, headers: headers, body: trainingBody);
      print("TrainigsEditSubmitAPi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('TrainigsEditSubmitAPi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('TrainigsEditSubmitAPi Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<AacoListModel?>? acooListApi(int currentPage, String searchText) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/aaco-informations?page=${currentPage}&q=${searchText}");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final Response response = await http.get(url, headers: headers);
    print("AacooListApi status Code");
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('AacooListApi repopose');
      print(jsonDecode(response.body));
      return AacoListModel.fromJson(json.decode(response.body));
    } else {
      print('Error: ${response.reasonPhrase}');
    }

    return null;
  }

  Future<AllDistrictModel> allDistrictApi() async {
    final url = Uri.parse("${APIClients.BASE_URL}api/districts");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("allDistrictApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('allDistrictApi repopose');
        print(jsonDecode(response.body));
        return AllDistrictModel.fromJson(json.decode(response.body));
      } else {
        print('allDistrictApi Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return AllDistrictModel(data: [], status: 0, message: '');
  }

//for aaco
  Future<AacoDistListModel?>? getAAcoDistrictData() async {
    final url = Uri.parse("${APIClients.BASE_URL}api/aaco-informations-district");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("aaco district status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('aaco dist repopose');
        print(jsonDecode(response.body));
        return AacoDistListModel.fromJson(json.decode(response.body));
      } else {
        print('allDistrictApi Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<AacoNonAVListModel?>? getNonAvailabilityData() async {
    final url = Uri.parse("${APIClients.BASE_URL}api/aaco-informations-non-availability");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("aaco nonav status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('aaco nonav repopose');
        print(jsonDecode(response.body));
        return AacoNonAVListModel.fromJson(json.decode(response.body));
      } else {
        print('nonav Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<AacoNonAVListModel?>? getrsnNonCompletionAaco() async {
    final url = Uri.parse("${APIClients.BASE_URL}api/aaco-informations-non-completion");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("aaco nonav status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('aaco nonav repopose');
        print(jsonDecode(response.body));
        return AacoNonAVListModel.fromJson(json.decode(response.body));
      } else {
        print('noncompl Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<Map> AACOInfoSubmitAPi(dynamic aacoInfoBody) async {
    log('aaco submit json $aacoInfoBody');
    final url = Uri.parse("${APIClients.BASE_URL}api/aaco-informations");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.post(url, headers: headers, body: aacoInfoBody);
      print("AACOInfoSubmitAPi status Code");
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        print('AACOInfoSubmitAPi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else if (response.statusCode == 422) {
        return jsonDecode(response.body);
      } else {
        print('AACOInfoSubmitAPi Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<AAcoInfoEditDataModel> AACOInfoEditApi(String id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/aaco-informations/$id");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("AACOInfoEditApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('AACOInfoEditApi repopose');
        print(jsonDecode(response.body));
        return AAcoInfoEditDataModel.fromJson(json.decode(response.body));
      } else {
        print('AACOInfoEditApi Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return AAcoInfoEditDataModel(status: 0, message: '');
  }

  Future<Map> AACOInfoEditDataSubmitAPi({required dynamic EditDataaacoInfoBody, required String id}) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/aaco-informations/$id");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.post(url, headers: headers, body: EditDataaacoInfoBody);
      print("AACOInfoEditDataSubmitAPi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('AACOInfoEditDataSubmitAPi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('AACOInfoEditDataSubmitAPi Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<Map> AACOInfoDeleteAPi(String id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/aaco-informations/$id");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.delete(
        url,
        headers: headers,
      );
      print("AACOInfoDeleteAPi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('AACOInfoDeleteAPi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('AACOInfoDeleteAPi Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<TrainingInfoDetailsModel> TrainingsInfoDetailsApi(int currentPage, String id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/training-info-wise-training-list/$id?page=$currentPage");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("TrainingsInfoDetailsApi url ${url}");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('TrainingsInfoDetailsApi repopose');
        print(jsonDecode(response.body));
        return TrainingInfoDetailsModel.fromJson(json.decode(response.body));
      } else {
        print('TrainingsInfoDetailsApi Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return TrainingInfoDetailsModel(status: 0, message: '', data: []);
  }

  //field visit api
  Future<FieldVisitListModel> fieldVisitListApi({
    required String current_page,
    required String location,
    required String formDate,
    required String toDate,
    required String officeType,
    required String status}) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/field-visit-lists?q=$location&from_date=$formDate&to_date=$toDate&office_type=$officeType&status=$status&page=$current_page");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("FiedVisitListApi $url");
      print("FiedVisitListApi status Code");

      print(response.statusCode);
      if (response.statusCode == 200) {
        print('FiedVisitListApi repopose');
        log(jsonDecode(response.body).toString());
        return FieldVisitListModel.fromJson(json.decode(response.body));
      } else {
        print('FiedVisitListApi Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return FieldVisitListModel(
      status: 0,
      message: '',
      data: [],
    );
  }

  Future<FieldVisitListDetailsModel> fieldVisitListDetailsApi(String id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/field-visit-list/$id");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    print("askdjhfjkdasf ${url}");
    try {
      final Response response = await http.get(url, headers: headers).timeout(Duration(seconds: 5));
      print("FiedVisitListDetailsApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('FiedVisitListDetailsApi repopose');
        log('${jsonEncode(response.body)}');
        return FieldVisitListDetailsModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 500) {
        print('FiedVisitListDetailsApi Error: ${response.reasonPhrase}');
        return FieldVisitListDetailsModel(status: 500, message: '', visit: [], fieldFindings: []);
      } else {
        print('FiedVisitListDetailsApi Error: ${response.reasonPhrase}');
        return FieldVisitListDetailsModel(status: 400, message: '', visit: [], fieldFindings: []);
      }
    } on TimeoutException catch (_) {
      AllService().showToast("Connection Timed Out, Try again", isError: true);
      //return FieldVisitListDetailsModel(status: 0, message: '', visit: [], fieldFindings: []);
    } catch (e) {
      print(e);
    }
    return FieldVisitListDetailsModel(status: 0, message: '', visit: [], fieldFindings: []);
  }

  Future<FieldFindingCreateModel> FiedFindingCreatesApi(String id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/field-finding-create/$id");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.get(url, headers: headers);
      print("FiedFindingCreatesApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('FiedFindingCreatesApi repopose');
        log(jsonDecode(response.body).toString());
        // print(jsonDecode(response.body));
        return FieldFindingCreateModel.fromJson(json.decode(response.body));
      } else {
        print('FiedFindingCreatesApi Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return FieldFindingCreateModel(status: 0, message: '', data: []);
  }

  Future<Map> FiedFindingSubmitApi(dynamic storeBody) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/field-finding-store");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.post(url, headers: headers, body: jsonEncode(storeBody));
      print("FiedFindingSubmitApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('FiedFindingSubmitApi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('FiedFindingSubmitApi Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<CountModel> countAPi() async {
    final url = Uri.parse("${APIClients.BASE_URL}api/count");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.get(
        url,
        headers: headers,
      );
      print("coutAPi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('coutAPi repopose');
        print(jsonDecode(response.body));
        return CountModel.fromJson(json.decode(response.body));
      } else {
        print('coutAPi Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return CountModel(status: 0, message: '', activityInfoCount: 0, trainingInfoCount: 0, fieldVisitCount: 0, accoInfoCount: 0);
  }

  Future<FieldVisitUpdateModel> FiedFindingUpdateApi(String id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/field-finding-edit/$id");
    String token = await Helper().getUserToken();
    print("FiedFindingUpdateApi $url");
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http
          .get(
            url,
            headers: headers,
          )
          .timeout(Duration(seconds: 3));
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('FiedFindingUpdateApi repopose');
        print(jsonDecode(response.body));
        return FieldVisitUpdateModel.fromJson(json.decode(response.body));
      } else {
        print('FiedFindingUpdateApi Error: ${response.reasonPhrase}');
      }
    } on TimeoutException catch (_) {
      AllService().showToast("Connection Time Out", isError: true);
    } catch (e) {
      print(e);
    }
    return FieldVisitUpdateModel(status: 0, message: '', question: [], data: '');
  }

  Future<Map> FiedFindingUpdateSubmitApi(dynamic storeBody, String id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/field-finding-update/$id");
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final Response response = await http.post(url, headers: headers, body: jsonEncode(storeBody));
      print("FiedFindingUpdateSubmitApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('FiedFindingUpdateSubmitApi repopose');
        print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        print('FiedFindingUpdateSubmitApi Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  Future<String> uploadFieldVisitImage({List<String>? imagesPath, String? id}) async {
    try {
      String token = await Helper().getUserToken();
      var headers = {
        'Content-Type': 'multipart/form-data',
        'Accept': '*/*',
        'Authorization': 'Bearer $token',
      };
      var request = http.MultipartRequest('POST', Uri.parse('${APIClients.BASE_URL}api/field-visit-photo-update'));
      print("file upload url: ${request.url}");
      request.headers.addAll(headers);
      final uploadList = <MultipartFile>[];
      if (imagesPath != null) {
        for (final imageFiles in imagesPath) {
          uploadList.add(
            await MultipartFile.fromPath(
              'photos[]',
              imageFiles.toString(),
              filename: imageFiles.split('/').last,
              contentType: MediaType('image', 'jpg'),
            ),
          );
        }
      }
      request.files.addAll(uploadList);
      request.fields['field_visit_id'] = id.toString();

      print("uploadFieldVisitImage body ${request.fields}");
      print("uploadFieldVisitImage body photo ${request.files.toList().length}");

      var response = await http.Response.fromStream(await request.send()).timeout(Duration(seconds: 15));
      var str = response.body;
      print("file upload response ${str}");
      if (response.statusCode == 200) {
        return "success";
      } else {
        return "Something Wrong";
      }
    } on TimeoutException catch (_) {
      return "timeout";
    } catch (e) {
      return "$e";
    }
  }

}
