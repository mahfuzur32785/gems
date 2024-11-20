import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart' as toast;
import 'package:village_court_gems/bloc/training_data_edit_bloc/training_data_edit_bloc.dart';
import 'package:village_court_gems/controller/api_services/api_client.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/helper/location_helper.dart';
import 'package:village_court_gems/models/locationModel.dart';
import 'package:village_court_gems/models/new_TraningModel.dart';
import 'package:village_court_gems/services/all_services/all_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:village_court_gems/services/database/localDatabaseService.dart';
import 'package:village_court_gems/util/colors.dart';
import 'dart:async';

import 'package:village_court_gems/view/trainings/custom_dropdown_widget.dart';
import 'package:village_court_gems/widget/custom_appbar.dart';

class TrainingEditPage extends StatefulWidget {
  const TrainingEditPage({super.key, required this.id, required this.allTraining});
  final int id;
  final List<AllTrainingData> allTraining;

  @override
  State<TrainingEditPage> createState() => _TrainingEditPageState();
}

class _TrainingEditPageState extends State<TrainingEditPage> {
  DateTime? fromSelectedDate;
  DateTime? toSelectedDate;
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController trainingVenueController = TextEditingController();
  final GlobalKey<FormState> _trainingFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _trainingOldFormKey = GlobalKey<FormState>();
  List minority_group_ids = [];

//  Participant Activation Controller
  List<TextEditingController> participantActivationControllerMale = [];
  List<TextEditingController> participantActivationControllerFemale = [];
  List<TextEditingController> totalParticipantActivationController = [];
  TextEditingController totalParticipantActivationControllerMale = TextEditingController();
  TextEditingController totalParticipantActivationControllerFemale = TextEditingController();
  TextEditingController totalParticipantActivationControllerMaleFemale = TextEditingController();
// Participant Activation Function
  void totalParticipantActivation(int index) {
    int maleValue = int.tryParse(participantActivationControllerMale[index].text) ?? 0;
    int femaleValue = int.tryParse(participantActivationControllerFemale[index].text) ?? 0;

    int total = maleValue + femaleValue;
    totalParticipantActivationController[index].text = total.toString();
  }

  void TotalParticipantActivationMale_Female() {
    int totalMale = 0;
    int totalFemale = 0;
    for (int i = 0; i < participantActivationControllerMale.length; i++) {
      int maleValue = int.tryParse(participantActivationControllerMale[i].text) ?? 0;
      totalMale = totalMale + maleValue;
    }
    totalParticipantActivationControllerMale.text = totalMale.toString();

    for (int i = 0; i < participantActivationControllerFemale.length; i++) {
      int femaleValue = int.tryParse(participantActivationControllerFemale[i].text) ?? 0;
      totalFemale += femaleValue;
    }
    totalParticipantActivationControllerFemale.text = totalFemale.toString();
  }

// participants Maintenance Area Controller
  List<TextEditingController> participantMaintenanceControllerMale = [];
  List<TextEditingController> participantMaintenanceControllerFemale = [];
  List<TextEditingController> totalParticipantMaintenanceController = [];
  TextEditingController totalParticipantMaintenanceControlleMale = TextEditingController();
  TextEditingController totalParticipantMaintenanceControlleFemale = TextEditingController();
  TextEditingController totalParticipantMaintenanceControlleMaleFemale = TextEditingController();

// Participant Maintenance Function
  void TotalParticipantMaintenance(int index) {
    int maleValue = int.tryParse(participantMaintenanceControllerMale[index].text) ?? 0;
    int femaleValue = int.tryParse(participantMaintenanceControllerFemale[index].text) ?? 0;

    int total = maleValue + femaleValue;
    totalParticipantMaintenanceController[index].text = total.toString();
  }

  void TotalParticipantMaintenanceMale_Female() {
    int totalMale = 0;
    int totalFemale = 0;
    for (int i = 0; i < participantMaintenanceControllerMale.length; i++) {
      int maleValue = int.tryParse(participantMaintenanceControllerMale[i].text) ?? 0;
      totalMale += maleValue;
    }
    totalParticipantMaintenanceControlleMale.text = totalMale.toString();

    for (int i = 0; i < participantMaintenanceControllerFemale.length; i++) {
      int femaleValue = int.tryParse(participantMaintenanceControllerFemale[i].text) ?? 0;
      totalFemale += femaleValue;
    }
    totalParticipantMaintenanceControlleFemale.text = totalFemale.toString();
  }

  // Minority Activation  Controller
  List<TextEditingController> minorityActivationControllerMale = [];
  List<TextEditingController> minorityActivationControllerFemale = [];
  List<TextEditingController> totalMinorityActivationController = [];
  TextEditingController totalMinorityActivationControlleMale = TextEditingController();
  TextEditingController totalMinorityActivationControlleFemale = TextEditingController();
  TextEditingController totalMinorityActivationControlleMaleFemale = TextEditingController();
//Minority Activation Function
  void TotalMinorityActivation(int index) {
    int maleValue = int.tryParse(minorityActivationControllerMale[index].text) ?? 0;
    int femaleValue = int.tryParse(minorityActivationControllerFemale[index].text) ?? 0;

    int total = maleValue + femaleValue;
    totalMinorityActivationController[index].text = total.toString();
  }

  void TotalMinorityActivationMale_Female() {
    int totalMale = 0;
    int totalFemale = 0;
    for (int i = 0; i < minorityActivationControllerMale.length; i++) {
      int maleValue = int.tryParse(minorityActivationControllerMale[i].text) ?? 0;
      totalMale += maleValue;
    }
    totalMinorityActivationControlleMale.text = totalMale.toString();

    for (int i = 0; i < minorityActivationControllerFemale.length; i++) {
      int femaleValue = int.tryParse(minorityActivationControllerFemale[i].text) ?? 0;
      totalFemale += femaleValue;
    }
    totalMinorityActivationControlleFemale.text = totalFemale.toString();
  }

  // Minority Maintenance  Controller

  List<TextEditingController> minorityMaintenanceControllerMale = [];
  List<TextEditingController> minorityMaintenanceControllerFemale = [];
  List<TextEditingController> totalMinorityMaintenanceController = [];
  TextEditingController totalMinorityMaintenanceControlleMale = TextEditingController();
  TextEditingController totalMinorityMaintenanceControlleFemale = TextEditingController();
  TextEditingController totalMinorityMaintenanceControlleMaleFemale = TextEditingController();

//Minority Maintenance Function
  void TotalMinorityMaintenance(int index) {
    int maleValue = int.tryParse(minorityMaintenanceControllerMale[index].text) ?? 0;
    int femaleValue = int.tryParse(minorityMaintenanceControllerFemale[index].text) ?? 0;

    int total = maleValue + femaleValue;
    totalMinorityMaintenanceController[index].text = total.toString();
  }

  void TotalMinorityMaintenanceMale_Female() {
    int totalMale = 0;
    int totalFemale = 0;
    for (int i = 0; i < minorityMaintenanceControllerMale.length; i++) {
      int maleValue = int.tryParse(minorityMaintenanceControllerMale[i].text) ?? 0;
      totalMale += maleValue;
    }
    totalMinorityMaintenanceControlleMale.text = totalMale.toString();

    for (int i = 0; i < minorityMaintenanceControllerFemale.length; i++) {
      int femaleValue = int.tryParse(minorityMaintenanceControllerFemale[i].text) ?? 0;
      totalFemale += femaleValue;
    }
    totalMinorityMaintenanceControlleFemale.text = totalFemale.toString();
  }

  Future<void> _fromSelectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fromSelectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        fromSelectedDate = picked;
        // Format the date as "dd/MM/yyyy"
        fromDateController.text = DateFormat('dd/MM/yyyy').format(fromSelectedDate!);
      });
    }
  }

  Future<void> _toSelectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: toSelectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        toSelectedDate = picked;
        // Format the date as "dd/MM/yyyy"

        toDateController.text = DateFormat('dd/MM/yyyy').format(toSelectedDate!);
      });
    }
  }

  AllTrainingData? selectedValue;

  Division? divisionEdit;
  District? districtEdit;
  Upazila? upazilaEdit;
  Union? unionEdit;

  List<Division> divisionList = [];
  List<District> districtList = [];
  List<Upazila> upazilaList = [];
  List<Union> unionList = [];

  String? selectedDivision;
  List<AllTrainingData> venue = [];
  String? selectedDistrict;
  String? selectedUpazila;
  String? selectedUion;
  var global = 0;
  int globalIndexParticipantActivation = 0;
  List<String> maleInputValues = [];
  List<String> femaleInputValues = [];
  List<List<int>> maleValuesList = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> inputData = [];

//api data submit info
  String training_info_setting_id = '';
  String location_id = '';
  String divisionId = '';
  String districtId = '';
  String upazilaId = '';
  String unionId = '';
  String training_from_date = '';
  String training_to_date = '';
  List participant_level_id = [];
  String participant_other_id = '0';

  // int total_male = 0;
  // int total_female = 0;
  // int total_participant = 0;
  int trylenth = 0;

  int globalValue = 0;
  int activationGlobal = 0;
  int participantGlobal = 0;
  int minorityActivationGlobal = 0;
  int minorityParticipantGlobal = 0;
  //google lat long
  late GoogleMapController mapController;
  LocationHelper locationHelper = LocationHelper();
  Position? currentLocation;
  // LocationData? currentLocation;
  // Location location = Location();
  Completer<GoogleMapController> mapControllerCompleter = Completer();

 void initLocation() async {
    try {
      var userLocation = await locationHelper.determinePosition();
      setState(() {
        currentLocation = userLocation;

        print("locationnnnnnnnnnnnnnnnnnnnn");

        print(currentLocation!.latitude);
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  final TrainingDataEditBloc trainingEditDataBloc = TrainingDataEditBloc();

  @override
  void initState() {
    trainingEditDataBloc.add(TrainingDataEditInitialEvent(id: widget.id));
    initLocation();
    mapControllerCompleter.future.then((controller) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              currentLocation?.latitude ?? 0.0,
              currentLocation?.longitude ?? 0.0,
            ),
            zoom: 14.0,
          ),
        ),
      );
    });

    print("akfjhdasjfhkjasd ${widget.allTraining.length}");

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  int activationTotalMale = 0;
  int activationTotalFemale = 0;
  int activationTotalMaleFemale = 0;


  Future<List<District>> districtApi(int id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/division-wise-district/$id");
    // String a = "10|GOY3kH493UHQRnr2hUlaubxvYPwmoTJsWmZvJfDz19edffaf";
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.get(url, headers: headers);
      print("districtApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('districtApi repopose');
        print(jsonDecode(response.body));
        return List.from(jsonDecode(response.body)["data"])
            .map((e) => District.fromJson(e))
            .toList();
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List<Upazila>> upazilaApi(int id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/district-wise-upazila/$id");
    // String a = "10|GOY3kH493UHQRnr2hUlaubxvYPwmoTJsWmZvJfDz19edffaf";
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.get(url, headers: headers);
      print("upazilatApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('upazilatApi repopose');
        print(jsonDecode(response.body));
        return List.from(jsonDecode(response.body)["data"])
            .map((e) => Upazila.fromJson(e))
            .toList();
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List<Union>> unionApi(int id) async {
    final url = Uri.parse("${APIClients.BASE_URL}api/upazila-wise-union/$id");
    //  String a = "10|GOY3kH493UHQRnr2hUlaubxvYPwmoTJsWmZvJfDz19edffaf";
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
      final response = await http.get(url, headers: headers);
      print("unionApi status Code");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('unionApi repopose');
        print(jsonDecode(response.body));
        return List.from(jsonDecode(response.body)["data"])
            .map((e) => Union.fromJson(e))
            .toList();
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e);
    }
    return [];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: "Training Information update",
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 15.0.w, right: 15.0.w),
        child: BlocConsumer<TrainingDataEditBloc, TrainingDataEditState>(
          bloc: trainingEditDataBloc,
          listenWhen: (previous, current) => current is TrainingDataEditActionState,
          buildWhen: (previous, current) => current is! TrainingDataEditActionState,
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            if (state is TrainingDataEditLoadingState) {
              return Container(
                child: const Center(child: CircularProgressIndicator()),
              );
            }
            else if(state is TrainingDataEditErrorState){
              return Container(
                child: Center(child: Text(state.errorMsg)),
              );
            }
            else if (state is TrainingDataEditSuccessState) {

              globalValue++;
              if(globalValue==1){
                venue.add(widget.allTraining.singleWhere((element) =>
                state.trainingEditModel.data![0].title == element.title.toString()));
                training_info_setting_id = state.trainingEditModel.data![0].trainingInfoSettingId.toString();
                location_id = state.trainingEditModel.data![0].locationId.toString();
                divisionId = state.trainingEditModel.data![0].selectedDivId.toString();
                districtId = state.trainingEditModel.data![0].selectedDisId.toString();
                upazilaId = state.trainingEditModel.data![0].selectedUpaId.toString();
                unionId = state.trainingEditModel.data![0].selectedUniId.toString();

                divisionList = state.trainingEditModel.data![0].divisions!;
                districtList = state.trainingEditModel.data![0].districts!;
                upazilaList = state.trainingEditModel.data![0].upazilas!;
                unionList = state.trainingEditModel.data![0].unions!;

                ///Activation
                for(int i=0;  i <state.trainingEditModel.activations!.length; i++){
                  participantActivationControllerMale.add(TextEditingController(text: state.trainingEditModel.activations![i].activationMale.toString()));
                  participantActivationControllerFemale.add(TextEditingController(text: state.trainingEditModel.activations![i].activationFemale.toString()));
                  totalParticipantActivationController.add(TextEditingController(text: state.trainingEditModel.activations![i].activationTotal.toString()));
                }

                ///Maintenance
                for(int i=0;  i <state.trainingEditModel.maintenances!.length; i++){
                  participantMaintenanceControllerMale.add(TextEditingController(text: state.trainingEditModel.maintenances![i].maintenanceMale.toString()));
                  participantMaintenanceControllerFemale.add(TextEditingController(text: state.trainingEditModel.maintenances![i].maintenanceFemale.toString()));
                  totalParticipantMaintenanceController.add(TextEditingController(text: state.trainingEditModel.maintenances![i].maintenanceTotal.toString()));
                }

                for(int i=0;  i <state.trainingEditModel.minorityActivations!.length; i++){
                  minorityActivationControllerMale.add(TextEditingController(text: state.trainingEditModel.minorityActivations?[i].activationMale.toString()));
                  minorityActivationControllerFemale.add(TextEditingController(text: state.trainingEditModel.minorityActivations?[i].activationFemale.toString()));
                  totalMinorityActivationController.add(TextEditingController(text: state.trainingEditModel.minorityActivations?[i].activationTotal.toString()));
                }

                for(int i=0;  i <state.trainingEditModel.minorityMaintenances!.length; i++){
                  minorityMaintenanceControllerMale.add(TextEditingController(text: state.trainingEditModel.minorityMaintenances![i].maintenanceMale.toString()));
                  minorityMaintenanceControllerFemale.add(TextEditingController(text: state.trainingEditModel.minorityMaintenances![i].maintenanceFemale.toString()));
                  totalMinorityMaintenanceController.add(TextEditingController(text: state.trainingEditModel.minorityMaintenances![i].maintenanceTotal.toString()));
                }

                ///Old Training name
                selectedValue = state.trainingEditModel.data![0].title == ""
                    ? null
                    : widget.allTraining.singleWhere((element) =>
                state.trainingEditModel.data![0].title == element.title.toString());

                ///Old division
                if(state.trainingEditModel.data![0].divisions!.isNotEmpty && state.trainingEditModel.data![0].selectedDivId != ""){
                  divisionEdit = state.trainingEditModel.data![0].divisions!.singleWhere((element) => element.id ==
                      int.parse("${state.trainingEditModel.data![0].selectedDivId}"));
                }
                ///Old district
                if(state.trainingEditModel.data![0].districts!.isNotEmpty && state.trainingEditModel.data![0].selectedDisId != ""){
                  districtEdit = state.trainingEditModel.data![0].districts!.singleWhere((element) => element.id ==
                      int.parse("${state.trainingEditModel.data![0].selectedDisId}"));
                }
                ///Old Upazilla
                if(state.trainingEditModel.data![0].upazilas!.isNotEmpty && state.trainingEditModel.data![0].selectedUpaId != ""){
                  upazilaEdit = state.trainingEditModel.data![0].upazilas!.singleWhere((element) => element.id ==
                      int.parse("${state.trainingEditModel.data![0].selectedUpaId}"));
                }
                ///Old Union
                if(state.trainingEditModel.data![0].unions!.isNotEmpty && state.trainingEditModel.data![0].selectedUniId != ""){
                  unionEdit = state.trainingEditModel.data![0].unions!.singleWhere((element) => element.id ==
                      int.parse("${state.trainingEditModel.data![0].selectedUniId}"));
                }

                ///Old Training Date
                fromDateController.text =  state.trainingEditModel.data![0].trainingFromDate??"";
                toDateController.text =  state.trainingEditModel.data![0].trainingToDate??"";

                /// Old Activation
                totalParticipantActivationControllerMale.text = state.trainingEditModel.subTotalActivationMale.toString();
                totalParticipantActivationControllerFemale.text = state.trainingEditModel.subTotalActivationFemale.toString();
                totalParticipantActivationControllerMaleFemale.text = state.trainingEditModel.subTotalActivationTotal.toString();

                /// Old Maintenance
                totalParticipantMaintenanceControlleMale.text = state.trainingEditModel.subTotalMaintenanceMale.toString();
                totalParticipantMaintenanceControlleFemale.text = state.trainingEditModel.subTotalMaintenanceFemale.toString();
                totalParticipantMaintenanceControlleMaleFemale.text = state.trainingEditModel.subTotalMaintenanceTotal.toString();

                /// Old Minority Activation
                totalMinorityActivationControlleMale.text = state.trainingEditModel.subTotalMinorityActivationMale.toString();
                totalMinorityActivationControlleFemale.text = state.trainingEditModel.subTotalMinorityActivationFemale.toString();
                totalMinorityActivationControlleMaleFemale.text = state.trainingEditModel.subTotalMinorityActivationTotal.toString();

                /// Old Minority Maintenance
                totalMinorityMaintenanceControlleMale.text = state.trainingEditModel.subTotalMinorityMaintenanceMale.toString();
                totalMinorityMaintenanceControlleFemale.text = state.trainingEditModel.subTotalMinorityMaintenanceFemale.toString();
                totalMinorityMaintenanceControlleMaleFemale.text = state.trainingEditModel.subTotalMinorityMaintenanceTotal.toString();

                remarkController.text = state.trainingEditModel.data?[0].remark??"";
                trainingVenueController.text = state.trainingEditModel.data?[0].trainingVenue??"";

              }

              return SingleChildScrollView(
                child: Column(children: [
                  SizedBox(
                    height: 10.h,
                  ),

                  ///Training Dropdown
                  Padding(
                    padding: EdgeInsets.only(left: 2, right: 2),
                    child: DropdownButtonFormField<AllTrainingData>(
                      isExpanded: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelText: 'Select Training Name'),
                      value: selectedValue,
                      onChanged: (AllTrainingData? newValue) {
                        venue.add(newValue!);
                        if(state.trainingEditModel.data![0].trainingInfoSettingId.toString()==newValue.id.toString()){
                          venue.clear();
                          participant_level_id.clear();
                          fromDateController.clear();
                          toDateController.clear();
                          //Participant Activation
                          participantActivationControllerMale.clear();
                          participantActivationControllerFemale.clear();
                          totalParticipantActivationController.clear();
                          totalParticipantActivationControllerMale.clear();
                          totalParticipantActivationControllerFemale.clear();
                          totalParticipantActivationControllerMaleFemale.clear();
                          //Participant Maintenanc
                          participantMaintenanceControllerMale.clear();
                          participantMaintenanceControllerFemale.clear();
                          totalParticipantMaintenanceController.clear();
                          totalParticipantMaintenanceControlleMale.clear();
                          totalParticipantMaintenanceControlleFemale.clear();
                          totalParticipantMaintenanceControlleMaleFemale.clear();
                          //Ethnic Activation
                          minorityActivationControllerMale.clear();
                          minorityActivationControllerFemale.clear();
                          totalMinorityActivationController.clear();
                          totalMinorityActivationControlleMale.clear();
                          totalMinorityActivationControlleFemale.clear();
                          totalMinorityActivationControlleMaleFemale.clear();
                          //Ethnic Maintenance
                          minorityMaintenanceControllerMale.clear();
                          minorityMaintenanceControllerFemale.clear();
                          totalMinorityMaintenanceController.clear();
                          totalMinorityMaintenanceControlleMale.clear();
                          totalMinorityMaintenanceControlleFemale.clear();
                          totalMinorityMaintenanceControlleMaleFemale.clear();

                          divisionEdit = null;
                          districtEdit = null;
                          upazilaEdit = null;
                          unionEdit = null;

                          remarkController.clear();
                          trainingVenueController.clear();

                          participantActivationControllerMale.clear();
                          participantActivationControllerFemale.clear();
                          totalParticipantActivationController.clear();

                          location_id = '';

                          setState(() {
                            globalValue = 0;
                          });
                          trainingEditDataBloc.add(TrainingDataEditInitialEvent(id: widget.id));
                        }
                        else {
                          setState(() {
                            print("wwwwwwwwwwwwwwwwwww");
                            venue.remove(selectedValue);
                            // maleControllers.clear();
                            // femaleController.clear();
                            participant_level_id.clear();
                            fromDateController.clear();
                            toDateController.clear();
                            //Participant Activation
                            participantActivationControllerMale.clear();
                            participantActivationControllerFemale.clear();
                            totalParticipantActivationController.clear();
                            totalParticipantActivationControllerMale.clear();
                            totalParticipantActivationControllerFemale.clear();
                            totalParticipantActivationControllerMaleFemale.clear();
                            //Participant Maintenanc
                            participantMaintenanceControllerMale.clear();
                            participantMaintenanceControllerFemale.clear();
                            totalParticipantMaintenanceController.clear();
                            totalParticipantMaintenanceControlleMale.clear();
                            totalParticipantMaintenanceControlleFemale.clear();
                            totalParticipantMaintenanceControlleMaleFemale.clear();
                            //Ethnic Activation
                            minorityActivationControllerMale.clear();
                            minorityActivationControllerFemale.clear();
                            totalMinorityActivationController.clear();
                            totalMinorityActivationControlleMale.clear();
                            totalMinorityActivationControlleFemale.clear();
                            totalMinorityActivationControlleMaleFemale.clear();
                            //Ethnic Maintenance
                            minorityMaintenanceControllerMale.clear();
                            minorityMaintenanceControllerFemale.clear();
                            totalMinorityMaintenanceController.clear();
                            totalMinorityMaintenanceControlleMale.clear();
                            totalMinorityMaintenanceControlleFemale.clear();
                            totalMinorityMaintenanceControlleMaleFemale.clear();

                            divisionEdit = null;
                            districtEdit = null;
                            upazilaEdit = null;
                            unionEdit = null;

                            remarkController.clear();
                            trainingVenueController.clear();

                            participantActivationControllerMale.clear();
                            participantActivationControllerFemale.clear();
                            totalParticipantActivationController.clear();

                            location_id = '';

                            participant_other_id = '0';
                            selectedValue = newValue;
                            training_info_setting_id = selectedValue!.id.toString();
                            print(training_info_setting_id.toString());
                            print(venue[0].locationLevel.id);
                          });
                        }
                      },
                      items: widget.allTraining.map<DropdownMenuItem<AllTrainingData>>((AllTrainingData item) {
                        return DropdownMenuItem<AllTrainingData>(
                          value: item,
                          child: Container(
                              width: double.infinity,
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.grey, width: 1),
                                ),
                              ),
                              child: Text(item.title)),
                        );
                      }).toList(),
                    ),
                  ),

                  ///Initial values are when dropdown not change ++++++++++++++++++++++++++++++++++++++++++++++++
                  if(training_info_setting_id == state.trainingEditModel.data![0].trainingInfoSettingId.toString())
                  Form(
                    key: _trainingOldFormKey,
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10.0.h,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: TextFormField(
                                readOnly: true,
                                controller: TextEditingController(text: state.trainingEditModel.data![0].locationLabel!.name.toString()),
                                decoration: InputDecoration(
                                  label: Text(
                                    'Training Location:',
                                    maxLines: 2,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Colors.black),
                                  ),
                                  hintText: "",
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 10.0.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Visibility(
                                  visible: location_id != "5",
                                  child: Expanded(
                                    child: DivisionDropdown(
                                      itemList: divisionList,
                                      hintText: "Select Division",
                                      labelText: "Select Division",
                                      selectedItem: divisionEdit,
                                      callBackFuction: (newValue){
                                        divisionId = newValue!.id.toString();
                                          // trainingEditDataBloc.add(DistrictEditClickEvent(id: int.parse(divisionId.toString())));
                                        districtApi(int.parse(divisionId.toString())).then((value){
                                          districtEdit = null;
                                          upazilaEdit = null;
                                          unionEdit = null;
                                          districtList.clear();
                                          districtList.addAll(value);
                                          setState(() {

                                          });
                                        });
                                      },
                                    ),
                                    // child: DropdownButtonFormField<Division>(
                                    //   isExpanded: true,
                                    //   decoration: const InputDecoration(
                                    //       contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    //       border: OutlineInputBorder(
                                    //         borderSide: BorderSide(color: Colors.black),
                                    //       ),
                                    //       labelText: 'Select division'),
                                    //   value: divisionEdit,
                                    //   onChanged: (Division? newValue) {
                                    //     divisionId = newValue!.id.toString();
                                    //     // trainingEditDataBloc.add(DistrictEditClickEvent(id: int.parse(divisionId.toString())));
                                    //       districtApi(int.parse(divisionId.toString())).then((value){
                                    //         districtEdit = null;
                                    //         upazilaEdit = null;
                                    //         unionEdit = null;
                                    //         districtList.clear();
                                    //         districtList.addAll(value);
                                    //         setState(() {
                                    //
                                    //         });
                                    //       });
                                    //     },
                                    //   items: state.trainingEditModel.data?[0].divisions?.map<DropdownMenuItem<Division>>(
                                    //         (entry) {
                                    //       return DropdownMenuItem<Division>(
                                    //         value: entry,
                                    //         child: Text(entry.nameEn??""),
                                    //       );
                                    //     },
                                    //   ).toList(),
                                    //   validator: (value) {
                                    //     if (value == null) {
                                    //       return 'Select division';
                                    //     }
                                    //     return null;
                                    //   },
                                    // ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Visibility(
                                  visible: districtList.isNotEmpty,
                                  child: Expanded(
                                    child: DistrictDropdown(
                                      itemList: districtList,
                                      hintText: "Select District",
                                      labelText: "Select District",
                                      selectedItem: districtEdit,
                                      callBackFuction: (District? newValue) {
                                        districtId = newValue!.id.toString();
                                        upazilaApi(int.parse(districtId.toString())).then((value){
                                          upazilaEdit = null;
                                          unionEdit = null;
                                          upazilaList.clear();
                                          upazilaList.addAll(value);
                                          setState(() {

                                          });
                                        });
                                      },
                                    ),
                                    // child: DropdownButtonFormField<District>(
                                    //   isExpanded: true,
                                    //   decoration: const InputDecoration(
                                    //       contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    //       border: OutlineInputBorder(
                                    //         borderSide: BorderSide(color: Colors.black),
                                    //       ),
                                    //       labelText: 'Select district'),
                                    //   value: districtEdit,
                                    //   onChanged: (District? newValue) {
                                    //     districtId = newValue!.id.toString();
                                    //      upazilaApi(int.parse(districtId.toString())).then((value){
                                    //       upazilaEdit = null;
                                    //       unionEdit = null;
                                    //       upazilaList.clear();
                                    //       upazilaList.addAll(value);
                                    //       setState(() {
                                    //
                                    //       });
                                    //     });
                                    //   },
                                    //   items: districtList.map<DropdownMenuItem<District>>(
                                    //         (entry) {
                                    //       return DropdownMenuItem<District>(
                                    //         value: entry,
                                    //         child: Text(entry.nameEn??""),
                                    //       );
                                    //     },
                                    //   ).toList(),
                                    //   validator: (value) {
                                    //     if (value == null) {
                                    //       return 'Select district';
                                    //     }
                                    //     return null;
                                    //   },
                                    // ),
                                  ),
                                ),

                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.0.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Visibility(
                                  visible: upazilaList.isNotEmpty,
                                  child: Expanded(
                                    child: UpzillaDropdown(
                                      itemList: upazilaList,
                                      hintText: "Select Upazilla",
                                      labelText: "Select Upazilla",
                                      selectedItem: upazilaEdit,
                                      callBackFuction: (Upazila? newValue) {
                                        upazilaId = newValue!.id.toString();
                                        unionApi(int.parse(upazilaId.toString())).then((value){
                                          unionEdit = null;
                                          unionList.clear();
                                          unionList.addAll(value);
                                          setState(() {

                                          });
                                        });
                                      },
                                    ),
                                    // DropdownButtonFormField<Upazila>(
                                    //   isExpanded: true,
                                    //   decoration: const InputDecoration(
                                    //       contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    //       border: OutlineInputBorder(
                                    //         borderSide: BorderSide(color: Colors.black),
                                    //       ),
                                    //       labelText: 'Select upazila'),
                                    //   value: upazilaEdit,
                                    //   onChanged: (Upazila? newValue) {
                                    //     upazilaId = newValue!.id.toString();
                                    //     unionApi(int.parse(upazilaId.toString())).then((value){
                                    //       unionEdit = null;
                                    //       unionList.clear();
                                    //       unionList.addAll(value);
                                    //       setState(() {
                                    //
                                    //       });
                                    //     });
                                    //   },
                                    //   items: upazilaList.map<DropdownMenuItem<Upazila>>(
                                    //         (entry) {
                                    //       return DropdownMenuItem<Upazila>(
                                    //         value: entry,
                                    //         child: Text(entry.nameEn??""),
                                    //       );
                                    //     },
                                    //   ).toList(),
                                    //   validator: (value) {
                                    //     if (value == null) {
                                    //       return 'Select upazila';
                                    //     }
                                    //     return null;
                                    //   },
                                    // ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Visibility(
                                  visible: unionList.isNotEmpty && location_id == "4",
                                  child: Expanded(
                                    child: UnionDropdown(
                                      itemList: unionList,
                                      hintText: "Select Union",
                                      labelText: "Select Union",
                                      selectedItem: unionEdit,
                                      callBackFuction: (Union? newValue) {
                                        unionId = newValue!.id.toString();
                                      },
                                    ),
                                    // DropdownButtonFormField<Union>(
                                    //   isExpanded: true,
                                    //   decoration: const InputDecoration(
                                    //       contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    //       border: OutlineInputBorder(
                                    //         borderSide: BorderSide(color: Colors.black),
                                    //       ),
                                    //       labelText: 'Select union'),
                                    //   value: unionEdit,
                                    //   onChanged: (Union? newValue) {
                                    //     unionId = newValue!.id.toString();
                                    //   },
                                    //   items: unionList.map<DropdownMenuItem<Union>>(
                                    //         (entry) {
                                    //       return DropdownMenuItem<Union>(
                                    //         value: entry,
                                    //         child: Text(entry.nameEn??""),
                                    //       );
                                    //     },
                                    //   ).toList(),
                                    //   validator: (value) {
                                    //     if (value == null) {
                                    //       return 'Select union';
                                    //     }
                                    //     return null;
                                    //   },
                                    // ),
                                  ),
                                ),

                              ],
                            ),
                            SizedBox(
                              height: 5.0.h,
                            ),
                          ],
                        ),

                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Training Date :",
                            style: TextStyle(fontSize: 16.0.sp, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 5.0.h,
                        ),

                        ///Training Date Option
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: GestureDetector(
                                onTap: () => _fromSelectDate(context),
                                child: AbsorbPointer(
                                  child: SizedBox(
                                    height: 40,
                                    child: TextFormField(
                                        readOnly: true,
                                        controller: fromDateController,
                                        decoration: const InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(width: 1, color: Colors.black),
                                          ),
                                          hintText: "dd/mm/yyyy",
                                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                          // hintStyle: TextStyle(c),
                                          suffixIcon: Icon(Icons.calendar_today),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please Select Date';
                                          }
                                          return null;
                                        }),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(flex: 1, child: Text("To")),
                            Expanded(
                              flex: 5,
                              child: GestureDetector(
                                onTap: () => _toSelectDate(context),
                                child: AbsorbPointer(
                                  child: SizedBox(
                                    height: 40,
                                    child: TextFormField(
                                        readOnly: true,
                                        controller: toDateController,
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(width: 1, color: Colors.black),
                                          ),
                                          hintText: "dd/mm/yyyy",
                                          suffixIcon: Icon(Icons.calendar_today),
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please Select Date';
                                          }
                                          return null;
                                        }),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0.h,
                        ),

                        Container(
                          height: 50,
                          alignment: Alignment.center,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            "Participant Count",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        /// Category of participants Activation Area
                        Column(
                          children: [
                            // venue.isEmpty
                            //     ? Container()
                            //     :
                            Column(
                              children: [
                                Container(
                                  color: Color.fromARGB(255, 3, 37, 110),
                                  height: 70,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 5, right: 5),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Category of the participants",
                                              style: TextStyle(color: Colors.white, fontSize: 11),
                                            ),
                                            Text(
                                              "Activation Area",
                                              style: TextStyle(color: Colors.white, fontSize: 11),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                      Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "Male",
                                              style: TextStyle(color: Colors.white, fontSize: 12),
                                            ),
                                            SizedBox(
                                              width: 35,
                                            ),
                                            Text(
                                              "female",
                                              style: TextStyle(color: Colors.white, fontSize: 12),
                                            ),
                                            SizedBox(
                                              width: 35,
                                            ),
                                            Text(
                                              "Total",
                                              style: TextStyle(color: Colors.white, fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ...List.generate(state.trainingEditModel.activations!.length,
                                        (participants_Active_Index) {

                                      if (venue[0].trainingInfoParticipantsActivation[participants_Active_Index].check ==
                                          'other') {
                                        participant_other_id = venue[0].trainingInfoParticipantsActivation[participants_Active_Index].id.toString();
                                      }
                                      if (venue[0].trainingInfoParticipantsActivation[participants_Active_Index].check ==
                                          'main') {
                                        String levelId = venue[0].trainingInfoParticipantsActivation[participants_Active_Index].id.toString();
                                        if (!participant_level_id.contains(levelId)) {
                                          participant_level_id.add(levelId);
                                        }
                                      }

                                      return Row(
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Expanded(
                                            flex: 6,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  venue[0].trainingInfoParticipantsActivation[participants_Active_Index].name,
                                                  style: TextStyle(fontSize: 14.0, color: Colors.black),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 40,
                                                  child: TextField(
                                                    keyboardType: TextInputType.number,
                                                    onTap: () => participantActivationControllerMale[participants_Active_Index].selection = TextSelection(baseOffset: 0, extentOffset: participantActivationControllerMale[participants_Active_Index].value.text.length),
                                                    controller: participantActivationControllerMale[participants_Active_Index],
                                                    decoration: const InputDecoration(
                                                        border: OutlineInputBorder(),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(width: 1, color: Colors.grey),
                                                        ),
                                                        hintText: "M",
                                                        contentPadding: EdgeInsets.only(left: 25)),
                                                    onChanged: (value) {
                                                      totalParticipantActivation(participants_Active_Index);
                                                      totalParticipantActivationControllerMale.text = participantActivationControllerMale.fold(0, (p, e){
                                                        return  p + (int.tryParse(e.text) ?? 0);
                                                      }).toString();

                                                      totalParticipantActivationControllerMaleFemale.text = ((int.tryParse(totalParticipantActivationControllerMale.text) ?? 0) + (int.tryParse(totalParticipantActivationControllerFemale.text) ?? 0)).toString();

                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15.0.h,
                                          ),
                                          Expanded(
                                              flex: 2,
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 40,
                                                    child: TextField(
                                                      keyboardType: TextInputType.number,
                                                      controller: participantActivationControllerFemale[participants_Active_Index],
                                                      onTap: () => participantActivationControllerFemale[participants_Active_Index].selection = TextSelection(baseOffset: 0, extentOffset: participantActivationControllerFemale[participants_Active_Index].value.text.length),
                                                      decoration: const InputDecoration(
                                                          border: OutlineInputBorder(),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(width: 1, color: Colors.grey),
                                                          ),
                                                          hintText: "F",
                                                          contentPadding: EdgeInsets.only(left: 25)),
                                                      onChanged: (value) {
                                                        totalParticipantActivation(participants_Active_Index);
                                                        totalParticipantActivationControllerFemale.text = participantActivationControllerFemale.fold(0, (p, e){
                                                          return  p + (int.tryParse(e.text) ?? 0);
                                                        }).toString();

                                                        totalParticipantActivationControllerMaleFemale.text = ((int.tryParse(totalParticipantActivationControllerMale.text) ?? 0) + (int.tryParse(totalParticipantActivationControllerFemale.text) ?? 0)).toString();

                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              )),
                                          SizedBox(
                                            width: 15.0.h,
                                          ),
                                          Expanded(
                                              flex: 2,
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 40,
                                                    child: TextField(
                                                      readOnly: true,
                                                      keyboardType: TextInputType.number,
                                                      controller: totalParticipantActivationController[participants_Active_Index],
                                                      decoration: const InputDecoration(
                                                          border: OutlineInputBorder(),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(width: 1, color: Colors.grey),
                                                          ),
                                                          hintText: "T",
                                                          contentPadding: EdgeInsets.only(left: 25)),
                                                      onChanged: (value) {
                                                        // Handle the female input change here if needed
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              )),
                                        ],
                                      );

                                    }),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                        height: 40.0.h,
                                        width: 100,
                                        child: TextFormField(
                                          controller: totalParticipantActivationControllerMale,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(left: 40),
                                              border: OutlineInputBorder(),
                                              labelText: 'Total Male ',
                                              labelStyle: TextStyle(fontSize: 10),
                                              floatingLabelBehavior: FloatingLabelBehavior.always),
                                        )),
                                    SizedBox(
                                        height: 40.0.h,
                                        width: 100,
                                        child: TextFormField(
                                          onChanged: (value) {},
                                          readOnly: true,
                                          controller: totalParticipantActivationControllerFemale,
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(left: 40),
                                              border: OutlineInputBorder(),
                                              labelText: 'Total Female ',
                                              labelStyle: TextStyle(fontSize: 10),
                                              floatingLabelBehavior: FloatingLabelBehavior.always),
                                        )),
                                    SizedBox(
                                        height: 40.0.h,
                                        width: 100,
                                        child: TextFormField(
                                          controller: totalParticipantActivationControllerMaleFemale,
                                          readOnly: true,
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(left: 40),
                                              border: OutlineInputBorder(),
                                              labelText: 'Total participant',
                                              labelStyle: TextStyle(fontSize: 10),
                                              floatingLabelBehavior: FloatingLabelBehavior.always),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        /// Category of participants Maintenance Area
                        Column(
                          children: [
                            Container(
                              color: Color.fromARGB(255, 3, 37, 110),
                              height: 70,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Category of the participants",
                                          style: TextStyle(color: Colors.white, fontSize: 11),
                                        ),
                                        Text(
                                          "Maintenance Area",
                                          style: TextStyle(color: Colors.white, fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(),
                                  Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Male",
                                          style: TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                        SizedBox(
                                          width: 35,
                                        ),
                                        Text(
                                          "female",
                                          style: TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                        SizedBox(
                                          width: 35,
                                        ),
                                        Text(
                                          "Total",
                                          style: TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ...List.generate(state.trainingEditModel.maintenances!.length, (Matched_Maintenance_Index) {
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              venue[0].trainingInfoParticipantsMaintenance[Matched_Maintenance_Index].name,
                                              style: TextStyle(fontSize: 14.0, color: Colors.black),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 40,
                                              child: TextField(
                                                keyboardType: TextInputType.number,
                                                controller: participantMaintenanceControllerMale[Matched_Maintenance_Index],
                                                onTap: () => participantMaintenanceControllerMale[Matched_Maintenance_Index].selection = TextSelection(baseOffset: 0, extentOffset: participantMaintenanceControllerMale[Matched_Maintenance_Index].value.text.length),
                                                decoration: const InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(width: 1, color: Colors.grey),
                                                    ),
                                                    hintText: "M",
                                                    contentPadding: EdgeInsets.only(left: 25)),
                                                onChanged: (value) {
                                                  TotalParticipantMaintenance(Matched_Maintenance_Index);
                                                  totalParticipantMaintenanceControlleMale.text = participantMaintenanceControllerMale.fold(0, (p, e){
                                                    return  p + (int.tryParse(e.text) ?? 0);
                                                  }).toString();
                                                  totalParticipantMaintenanceControlleMaleFemale.text = ((int.tryParse(totalParticipantMaintenanceControlleFemale.text) ?? 0) + (int.tryParse(totalParticipantMaintenanceControlleMale.text) ?? 0)).toString();
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15.0.h,
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 40,
                                                child: TextField(
                                                  keyboardType: TextInputType.number,
                                                  controller: participantMaintenanceControllerFemale[Matched_Maintenance_Index],
                                                  onTap: () => participantMaintenanceControllerFemale[Matched_Maintenance_Index].selection = TextSelection(baseOffset: 0, extentOffset: participantMaintenanceControllerFemale[Matched_Maintenance_Index].value.text.length),
                                                  decoration: const InputDecoration(
                                                      border: OutlineInputBorder(),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(width: 1, color: Colors.grey),
                                                      ),
                                                      hintText: "F",
                                                      contentPadding: EdgeInsets.only(left: 25)),
                                                  onChanged: (value) {
                                                    TotalParticipantMaintenance(Matched_Maintenance_Index);
                                                    totalParticipantMaintenanceControlleFemale.text = participantMaintenanceControllerFemale.fold(0, (p, e){
                                                      return  p + (int.tryParse(e.text) ?? 0);
                                                    }).toString();
                                                    totalParticipantMaintenanceControlleMaleFemale.text = ((int.tryParse(totalParticipantMaintenanceControlleFemale.text) ?? 0) + (int.tryParse(totalParticipantMaintenanceControlleMale.text) ?? 0)).toString();
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          )),
                                      SizedBox(
                                        width: 15.0.h,
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 40,
                                                child: TextField(
                                                  keyboardType: TextInputType.number,
                                                  controller: totalParticipantMaintenanceController[Matched_Maintenance_Index],
                                                  readOnly: true,
                                                  decoration: const InputDecoration(
                                                      border: OutlineInputBorder(),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(width: 1, color: Colors.grey),
                                                      ),
                                                      hintText: "T",
                                                      contentPadding: EdgeInsets.only(left: 25)),
                                                  onChanged: (value) {
                                                    // Handle the female input change here if needed
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ],
                              );
                            }),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    height: 40.0.h,
                                    width: 100,
                                    child: TextFormField(
                                      readOnly: true,
                                      controller: totalParticipantMaintenanceControlleMale,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(left: 40),
                                          border: OutlineInputBorder(),
                                          labelText: 'Total Male ',
                                          labelStyle: TextStyle(fontSize: 10),
                                          floatingLabelBehavior: FloatingLabelBehavior.always),
                                    )),
                                SizedBox(
                                    height: 40.0.h,
                                    width: 100,
                                    child: TextFormField(
                                      readOnly: true,
                                      controller: totalParticipantMaintenanceControlleFemale,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(left: 40),
                                          border: OutlineInputBorder(),
                                          labelText: 'Total Female ',
                                          labelStyle: TextStyle(fontSize: 10),
                                          floatingLabelBehavior: FloatingLabelBehavior.always),
                                    )),
                                SizedBox(
                                    height: 40.0.h,
                                    width: 100,
                                    child: TextFormField(
                                      readOnly: true,
                                      controller: totalParticipantMaintenanceControlleMaleFemale,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(left: 40),
                                          border: OutlineInputBorder(),
                                          labelText: 'Total participant',
                                          labelStyle: TextStyle(fontSize: 10),
                                          floatingLabelBehavior: FloatingLabelBehavior.always),
                                    )),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        ///Ethnic Minority Activation Area
                        Column(
                          children: [
                            Container(
                              color: Color.fromARGB(255, 3, 37, 110),
                              height: 70,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Ethnic Minority & Disadvantage Groups",
                                          style: TextStyle(color: Colors.white, fontSize: 11),
                                        ),
                                        Text(
                                          "Activation Area",
                                          style: TextStyle(color: Colors.white, fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(),
                                  Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Male",
                                          style: TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                        SizedBox(
                                          width: 35,
                                        ),
                                        Text(
                                          "female",
                                          style: TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                        SizedBox(
                                          width: 35,
                                        ),
                                        Text(
                                          "Total",
                                          style: TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ...List.generate(state.trainingEditModel.minorityActivations!.length, (Ethnic_activeIndex) {
                              String levelId = venue[0].minoritiesActivation[Ethnic_activeIndex].id.toString();
                              if (!minority_group_ids.contains(levelId)) {
                                minority_group_ids.add(levelId);
                              }

                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              venue[0].minoritiesActivation[Ethnic_activeIndex].name.toString(),
                                              style: TextStyle(fontSize: 14.0, color: Colors.black),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 40,
                                              child: TextField(
                                                keyboardType: TextInputType.number,
                                                controller: minorityActivationControllerMale[Ethnic_activeIndex],
                                                onTap: () => minorityActivationControllerMale[Ethnic_activeIndex].selection = TextSelection(baseOffset: 0, extentOffset: minorityActivationControllerMale[Ethnic_activeIndex].value.text.length),
                                                decoration: const InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(width: 1, color: Colors.grey),
                                                    ),
                                                    hintText: "M",
                                                    contentPadding: EdgeInsets.only(left: 25)),
                                                onChanged: (value) {
                                                  TotalMinorityActivation(Ethnic_activeIndex);
                                                  totalMinorityActivationControlleMale.text = minorityActivationControllerMale.fold(0, (p, e){
                                                    return  p + (int.tryParse(e.text) ?? 0);
                                                  }).toString();
                                                  totalMinorityActivationControlleMaleFemale.text = ((int.tryParse(totalMinorityActivationControlleMale.text) ?? 0) + (int.tryParse(totalMinorityActivationControlleFemale.text) ?? 0)).toString();
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15.0.h,
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 40,
                                                child: TextField(
                                                  keyboardType: TextInputType.number,
                                                  controller: minorityActivationControllerFemale[Ethnic_activeIndex],
                                                  onTap: () => minorityActivationControllerFemale[Ethnic_activeIndex].selection = TextSelection(baseOffset: 0, extentOffset: minorityActivationControllerFemale[Ethnic_activeIndex].value.text.length),
                                                  decoration: const InputDecoration(
                                                      border: OutlineInputBorder(),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(width: 1, color: Colors.grey),
                                                      ),
                                                      hintText: "F",
                                                      contentPadding: EdgeInsets.only(left: 25)),
                                                  onChanged: (value) {
                                                    TotalMinorityActivation(Ethnic_activeIndex);
                                                    totalMinorityActivationControlleFemale.text = minorityActivationControllerFemale.fold(0, (p, e){
                                                      return  p + (int.tryParse(e.text) ?? 0);
                                                    }).toString();
                                                    totalMinorityActivationControlleMaleFemale.text = ((int.tryParse(totalMinorityActivationControlleMale.text) ?? 0) + (int.tryParse(totalMinorityActivationControlleFemale.text) ?? 0)).toString();
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          )),
                                      SizedBox(
                                        width: 15.0.h,
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 40,
                                                child: TextField(
                                                  readOnly: true,
                                                  keyboardType: TextInputType.number,
                                                  controller: totalMinorityActivationController[Ethnic_activeIndex],
                                                  decoration: const InputDecoration(
                                                      border: OutlineInputBorder(),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(width: 1, color: Colors.grey),
                                                      ),
                                                      hintText: "T",
                                                      contentPadding: EdgeInsets.only(left: 25)),
                                                  onChanged: (value) {
                                                    // Handle the female input change here if needed
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ],
                              );
                            }),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    height: 40.0.h,
                                    width: 100,
                                    child: TextFormField(
                                      readOnly: true,
                                      controller: totalMinorityActivationControlleMale,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(left: 40),
                                          border: OutlineInputBorder(),
                                          labelText: 'Total Male ',
                                          labelStyle: TextStyle(fontSize: 10),
                                          floatingLabelBehavior: FloatingLabelBehavior.always),
                                    )),
                                SizedBox(
                                    height: 40.0.h,
                                    width: 100,
                                    child: TextFormField(
                                      readOnly: true,
                                      controller: totalMinorityActivationControlleFemale,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(left: 40),
                                          border: OutlineInputBorder(),
                                          labelText: 'Total Female ',
                                          labelStyle: TextStyle(fontSize: 10),
                                          floatingLabelBehavior: FloatingLabelBehavior.always),
                                    )),
                                SizedBox(
                                    height: 40.0.h,
                                    width: 100,
                                    child: TextFormField(
                                      readOnly: true,
                                      controller: totalMinorityActivationControlleMaleFemale,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(left: 40),
                                          border: OutlineInputBorder(),
                                          labelText: 'Total participant',
                                          labelStyle: TextStyle(fontSize: 10),
                                          floatingLabelBehavior: FloatingLabelBehavior.always),
                                    )),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        ///Ethnic Minority Maintenance
                        Column(
                          children: [
                            Container(
                              color: Color.fromARGB(255, 3, 37, 110),
                              height: 70,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Ethnic Minority & Disadvantage Groups",
                                          style: TextStyle(color: Colors.white, fontSize: 11),
                                        ),
                                        Text(
                                          "Maintenance Area",
                                          style: TextStyle(color: Colors.white, fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(),
                                  Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Male",
                                          style: TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                        SizedBox(
                                          width: 35,
                                        ),
                                        Text(
                                          "female",
                                          style: TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                        SizedBox(
                                          width: 35,
                                        ),
                                        Text(
                                          "Total",
                                          style: TextStyle(color: Colors.white, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ...List.generate(state.trainingEditModel.minorityMaintenances!.length, (Ethnic_MaintenanceIndex) {

                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              venue[0].minoritiesMaintenance[Ethnic_MaintenanceIndex].name,
                                              style: TextStyle(fontSize: 14.0, color: Colors.black),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 40,
                                              child: TextField(
                                                keyboardType: TextInputType.number,
                                                controller: minorityMaintenanceControllerMale[Ethnic_MaintenanceIndex],
                                                onTap: () => minorityMaintenanceControllerMale[Ethnic_MaintenanceIndex].selection = TextSelection(baseOffset: 0, extentOffset: minorityMaintenanceControllerMale[Ethnic_MaintenanceIndex].value.text.length),
                                                decoration: const InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    enabledBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(width: 1, color: Colors.grey),
                                                    ),
                                                    hintText: "M",
                                                    contentPadding: EdgeInsets.only(left: 25)),
                                                onChanged: (value) {
                                                  TotalMinorityMaintenance(Ethnic_MaintenanceIndex);
                                                  totalMinorityMaintenanceControlleMale.text = minorityMaintenanceControllerMale.fold(0, (p, e){
                                                    return  p + (int.tryParse(e.text) ?? 0);
                                                  }).toString();
                                                  totalMinorityMaintenanceControlleMaleFemale.text = ((int.tryParse(totalMinorityMaintenanceControlleFemale.text) ?? 0) + (int.tryParse(totalMinorityMaintenanceControlleMale.text) ?? 0)).toString();
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15.0.h,
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 40,
                                                child: TextField(
                                                  keyboardType: TextInputType.number,
                                                  controller: minorityMaintenanceControllerFemale[Ethnic_MaintenanceIndex],
                                                  onTap: () => minorityMaintenanceControllerFemale[Ethnic_MaintenanceIndex].selection = TextSelection(baseOffset: 0, extentOffset: minorityMaintenanceControllerFemale[Ethnic_MaintenanceIndex].value.text.length),
                                                  decoration: const InputDecoration(
                                                      border: OutlineInputBorder(),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(width: 1, color: Colors.grey),
                                                      ),
                                                      hintText: "F",
                                                      contentPadding: EdgeInsets.only(left: 25)),
                                                  onChanged: (value) {
                                                    TotalMinorityMaintenance(Ethnic_MaintenanceIndex);
                                                    totalMinorityMaintenanceControlleFemale.text = minorityMaintenanceControllerFemale.fold(0, (p, e){
                                                      return  p + (int.tryParse(e.text) ?? 0);
                                                    }).toString();
                                                    totalMinorityMaintenanceControlleMaleFemale.text = ((int.tryParse(totalMinorityMaintenanceControlleFemale.text) ?? 0) + (int.tryParse(totalMinorityMaintenanceControlleMale.text) ?? 0)).toString();
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          )),
                                      SizedBox(
                                        width: 15.0.h,
                                      ),
                                      Expanded(
                                          flex: 2,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 40,
                                                child: TextField(
                                                  readOnly: true,
                                                  keyboardType: TextInputType.number,
                                                  controller: totalMinorityMaintenanceController[Ethnic_MaintenanceIndex],
                                                  decoration: const InputDecoration(
                                                      border: OutlineInputBorder(),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(width: 1, color: Colors.grey),
                                                      ),
                                                      hintText: "T",
                                                      contentPadding: EdgeInsets.only(left: 25)),
                                                  onChanged: (value) {
                                                    // Handle the female input change here if needed
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ],
                              );
                            }),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    height: 40.0.h,
                                    width: 100,
                                    child: TextFormField(
                                      readOnly: true,
                                      controller: totalMinorityMaintenanceControlleMale,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(left: 40),
                                          border: OutlineInputBorder(),
                                          labelText: 'Total Male ',
                                          labelStyle: TextStyle(fontSize: 10),
                                          floatingLabelBehavior: FloatingLabelBehavior.always),
                                    )),
                                SizedBox(
                                    height: 40.0.h,
                                    width: 100,
                                    child: TextFormField(
                                      readOnly: true,
                                      controller: totalMinorityMaintenanceControlleFemale,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(left: 40),
                                          border: OutlineInputBorder(),
                                          labelText: 'Total Female ',
                                          labelStyle: TextStyle(fontSize: 10),
                                          floatingLabelBehavior: FloatingLabelBehavior.always),
                                    )),
                                SizedBox(
                                    height: 40.0.h,
                                    width: 100,
                                    child: TextFormField(
                                      readOnly: true,
                                      controller: totalMinorityMaintenanceControlleMaleFemale,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(left: 40),
                                          border: OutlineInputBorder(),
                                          labelText: 'Total participant',
                                          labelStyle: TextStyle(fontSize: 10),
                                          floatingLabelBehavior: FloatingLabelBehavior.always),
                                    )),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.0.w, right: 5.0.w),
                          child: TextFormField(
                            controller: remarkController,
                            maxLines: 2,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Remarks',
                                floatingLabelBehavior: FloatingLabelBehavior.always),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Remarks Field';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10.0.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.0.w, right: 5.0.w),
                          child: TextFormField(
                            controller: trainingVenueController,
                            maxLines: 1,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Training Venue',
                                floatingLabelBehavior: FloatingLabelBehavior.always),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Training Venue Field';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10.0.h,
                        ),

                        _isLoading
                            ? Center(child: AllService.LoadingToast())
                            : Center(
                          child: SizedBox(
                            width: 330.w,
                            height: 40.h,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7.0.r),
                                  ),
                                  backgroundColor: MyColors.secondaryColor,
                                ),
                                onPressed: () async {
                                  final connectivityResult = await (Connectivity().checkConnectivity());
                                  if(_trainingOldFormKey.currentState!.validate()){
                                    if (connectivityResult.contains(ConnectivityResult.mobile)  ||
                                        connectivityResult.contains(ConnectivityResult.wifi)
                                       ) {

                                      getTextValuesActivationMaleFemale();
                                      getTextValuesMaintenanceMaleFemale();
                                      getTextValuesMinorityActivationMaleFemale();
                                      getTextValuesMinorityMaintenanceMaleFemale();
                                      print(a_male);
                                      int total_male = 0;
                                      int total_female = 0;
                                      int total_minority_male = 0;
                                      int total_minority_female = 0;
                                      int total_participant = 0;
                                      int total_minority_participant = 0;

                                      total_male = int.parse(
                                          totalParticipantActivationControllerMale
                                              .text) +
                                          int.parse(
                                              totalParticipantMaintenanceControlleMale
                                                  .text);

                                      total_female = int.parse(
                                          totalParticipantActivationControllerFemale
                                              .text) +
                                          int.parse(
                                              totalParticipantMaintenanceControlleFemale
                                                  .text);
                                      total_participant =
                                          total_male + total_female;

                                      print(
                                          "TOTAL male ${total_male} total female ${total_female} all total ${total_participant}");
                                      total_minority_male = int.parse(
                                          totalMinorityActivationControlleMale
                                              .text) +
                                          int.parse(
                                              totalMinorityMaintenanceControlleMale
                                                  .text);
                                      total_minority_female = int.parse(
                                          totalMinorityActivationControlleFemale
                                              .text) +
                                          int.parse(
                                              totalMinorityMaintenanceControlleFemale
                                                  .text);
                                      total_minority_participant =
                                          total_minority_male +
                                              total_minority_female;

                                      print(
                                          "TOTAL minority male ${total_minority_male} total minority female ${total_minority_female} all minority total ${total_minority_participant}");

                                      Map trainingBody = {
                                        "training_info_setting_id": training_info_setting_id,
                                        "location_id": location_id,
                                        "division": divisionId,
                                        "district": districtId,
                                        "upazila": upazilaId,
                                        "union": unionId,
                                        "training_from_date": fromDateController
                                            .text,
                                        "training_to_date": toDateController
                                            .text,
                                        "training_venue": trainingVenueController.text,
                                        "participant_level_id": participant_level_id,
                                        "a_male": a_male,
                                        "a_female": a_female,
                                        "a_total": a_total,
                                        "m_male": m_male,
                                        "m_female": m_female,
                                        "m_total": m_total,
                                        "minority_group_id": minority_group_ids,
                                        "minority_a_male": minority_a_male,
                                        "minority_a_female": minority_a_female,
                                        "minority_a_total": minority_a_total,
                                        "minority_m_male": minority_m_male,
                                        "minority_m_female": minority_m_female,
                                        "minority_m_total": minority_m_total,
                                        if (participant_other_id !=
                                            '0') "participant_other_id": participant_other_id,
                                        if (participant_other_id !=
                                            '0') "a_other_male": a_other_male,
                                        if (participant_other_id !=
                                            '0') "a_other_female": a_other_female,
                                        if (participant_other_id !=
                                            '0') "a_other_total": a_other_total
                                            .toString(),
                                        if (participant_other_id !=
                                            '0') "m_other_male": m_other_male,
                                        if (participant_other_id !=
                                            '0') "m_other_female": m_other_female,
                                        if (participant_other_id !=
                                            '0') "m_other_total": m_other_total
                                            .toString(),
                                        "total_male": total_male,
                                        "total_female": total_female,
                                        "total_participant": total_participant,
                                        "total_minority_male": total_minority_male,
                                        "total_minority_female": total_minority_female,
                                        "total_minority_participant": total_minority_participant,
                                        "longitude": currentLocation?.latitude
                                            .toString() ?? '0.0',
                                        "latitude": currentLocation?.longitude
                                            .toString() ?? '0.0',
                                        "remark": remarkController.text
                                      };
                                      log("Test update data: " +
                                          jsonEncode(trainingBody));
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      print(jsonEncode(trainingBody));
                                      Map a = await Repositores().trainingInfoUpdate(jsonEncode(trainingBody), widget.id.toString());
                                      if (a['status'] == 201) {
                                        await QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.success,
                                          text: "Training Update Successfully!",
                                        );
                                        // await Navigator.of(context).pushAndRemoveUntil(
                                        //     MaterialPageRoute(builder: (context) => Homepage()),
                                        //         (Route<dynamic> route) => false);
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      } else {
                                        await QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.error,
                                          text: "Something went wrong please try again later",
                                        );
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }
                                    } else {
                                      AllService().internetCheckDialog(context);
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  }
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Submit',
                                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if(training_info_setting_id != state.trainingEditModel.data![0].trainingInfoSettingId.toString())
                  /// If change training dropdown +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                  Form(
                    key: _trainingFormKey,
                    child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10.0.h,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: TextFormField(
                                  readOnly: true,
                                  controller: TextEditingController(text: venue[0].locationLevel.name.toString()),
                                  decoration: InputDecoration(
                                    label: Text(
                                      'Training Location:',
                                      maxLines: 2,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1, color: Colors.black),
                                    ),
                                    hintText: "",
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.0.h,
                              ),
                            ],
                          ),

                         Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Visibility(
                                    visible: venue[0].locationLevel.id != 5,
                                    child: Expanded(
                                      child:  DivisionDropdown(
                                        itemList: divisionList,
                                        hintText: "Select Division",
                                        labelText: "Select Division",
                                        selectedItem: divisionEdit,
                                        callBackFuction: (newValue){
                                          divisionId = newValue!.id.toString();
                                          // trainingEditDataBloc.add(DistrictEditClickEvent(id: int.parse(divisionId.toString())));
                                          districtApi(int.parse(divisionId.toString())).then((value){
                                            districtEdit = null;
                                            upazilaEdit = null;
                                            unionEdit = null;
                                            districtList.clear();
                                            districtList.addAll(value);
                                            setState(() {

                                            });
                                          });
                                        },
                                      ),
                                      /*DropdownButtonFormField<Division>(
                                        isExpanded: true,
                                        decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black),
                                            ),
                                            labelText: 'Select division'),
                                        value: divisionEdit,
                                        onChanged: (Division? newValue) {
                                          divisionId = newValue!.id.toString();
                                        },
                                        items: state.trainingEditModel.data?[0].divisions?.map<DropdownMenuItem<Division>>(
                                              (entry) {
                                            return DropdownMenuItem<Division>(
                                              value: entry,
                                              child: Text(entry.nameEn??""),
                                            );
                                          },
                                        ).toList(),
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Select division';
                                          }
                                          return null;
                                        },
                                      ),*/
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Visibility(
                                    visible: (venue[0].locationLevel.id != 5 && (venue[0].locationLevel.id == 4 ||venue[0].locationLevel.id == 2 || venue[0].locationLevel.id == 3)),
                                    child: Expanded(
                                      child: DistrictDropdown(
                                        itemList: districtList,
                                        hintText: "Select District",
                                        labelText: "Select District",
                                        selectedItem: districtEdit,
                                        callBackFuction: (District? newValue) {
                                          districtId = newValue!.id.toString();
                                          upazilaApi(int.parse(districtId.toString())).then((value){
                                            upazilaEdit = null;
                                            unionEdit = null;
                                            upazilaList.clear();
                                            upazilaList.addAll(value);
                                            setState(() {

                                            });
                                          });
                                        },
                                      ),
                                        /*DropdownButtonFormField<District>(
                                        isExpanded: true,
                                        decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black),
                                            ),
                                            labelText: 'Select district'),
                                        value: districtEdit,
                                        onChanged: (District? newValue) {
                                          districtId = newValue!.id.toString();
                                        },
                                        items: state.trainingEditModel.data?[0].districts?.map<DropdownMenuItem<District>>(
                                              (entry) {
                                            return DropdownMenuItem<District>(
                                              value: entry,
                                              child: Text(entry.nameEn??""),
                                            );
                                          },
                                        ).toList(),
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Select district';
                                          }
                                          return null;
                                        },
                                      ),*/
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Visibility(
                                    visible: (venue[0].locationLevel.id != 5 && (venue[0].locationLevel.id == 3 || venue[0].locationLevel.id == 4)),
                                    child: Expanded(
                                      child:  UpzillaDropdown(
                                        itemList: upazilaList,
                                        hintText: "Select Upazilla",
                                        labelText: "Select Upazilla",
                                        selectedItem: upazilaEdit,
                                        callBackFuction: (Upazila? newValue) {
                                          upazilaId = newValue!.id.toString();
                                          unionApi(int.parse(upazilaId.toString())).then((value){
                                            unionEdit = null;
                                            unionList.clear();
                                            unionList.addAll(value);
                                            setState(() {

                                            });
                                          });
                                        },
                                      ),
                                      /*DropdownButtonFormField<Upazila>(
                                        isExpanded: true,
                                        decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black),
                                            ),
                                            labelText: 'Select upazila'),
                                        value: upazilaEdit,
                                        onChanged: (Upazila? newValue) {
                                          upazilaId = newValue!.id.toString();
                                        },
                                        items: state.trainingEditModel.data?[0].upazilas?.map<DropdownMenuItem<Upazila>>(
                                              (entry) {
                                            return DropdownMenuItem<Upazila>(
                                              value: entry,
                                              child: Text(entry.nameEn??""),
                                            );
                                          },
                                        ).toList(),
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Select upazila';
                                          }
                                          return null;
                                        },
                                      ),*/
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Visibility(
                                    visible: (venue[0].locationLevel.id != 5 && venue[0].locationLevel.id == 4),
                                    child: Expanded(
                                      child: UnionDropdown(
                                        itemList: unionList,
                                        hintText: "Select Union",
                                        labelText: "Select Union",
                                        selectedItem: unionEdit,
                                        callBackFuction: (Union? newValue) {
                                          unionId = newValue!.id.toString();
                                        },
                                      ),
                                      // DropdownButtonFormField<Union>(
                                      //   isExpanded: true,
                                      //   decoration: const InputDecoration(
                                      //       contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                      //       border: OutlineInputBorder(
                                      //         borderSide: BorderSide(color: Colors.black),
                                      //       ),
                                      //       labelText: 'Select union'),
                                      //   value: unionEdit,
                                      //   onChanged: (Union? newValue) {
                                      //     unionId = newValue!.id.toString();
                                      //   },
                                      //   items: state.trainingEditModel.data?[0].unions?.map<DropdownMenuItem<Union>>(
                                      //         (entry) {
                                      //       return DropdownMenuItem<Union>(
                                      //         value: entry,
                                      //         child: Text(entry.nameEn??""),
                                      //       );
                                      //     },
                                      //   ).toList(),
                                      //   validator: (value) {
                                      //     if (value == null) {
                                      //       return 'Select union';
                                      //     }
                                      //     return null;
                                      //   },
                                      // ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 10.0.h,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Training Date :",
                              style: TextStyle(fontSize: 16.0.sp, color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 5.0.h,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: GestureDetector(
                                  onTap: () => _fromSelectDate(context),
                                  child: AbsorbPointer(
                                    child: SizedBox(
                                      // height: 40,
                                      child: TextFormField(
                                          readOnly: true,
                                          controller: fromDateController,
                                          decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(width: 1, color: Colors.black),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.red,
                                                )),
                                            focusedErrorBorder: UnderlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(4)),
                                              borderSide: BorderSide(
                                                width: 1,
                                                color: Colors.red,
                                              ),
                                            ),
                                            hintText: "dd/mm/yyyy",
                                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                            // hintStyle: TextStyle(c),
                                            suffixIcon: Icon(Icons.calendar_today),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please Select Date';
                                            }
                                            return null;
                                          }),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(flex: 1, child: Text("To")),
                              Expanded(
                                flex: 5,
                                child: GestureDetector(
                                  onTap: () => _toSelectDate(context),
                                  child: AbsorbPointer(
                                    child: SizedBox(
                                      // height: 40,
                                      child: TextFormField(
                                          readOnly: true,
                                          controller: toDateController,
                                          decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(width: 1, color: Colors.black),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.red,
                                                )),
                                            focusedErrorBorder: UnderlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(4)),
                                              borderSide: BorderSide(
                                                width: 1,
                                                color: Colors.red,
                                              ),
                                            ),
                                            hintText: "dd/mm/yyyy",
                                            suffixIcon: Icon(Icons.calendar_today),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please Select Date';
                                            }
                                            return null;
                                          }),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),


                          venue.isEmpty
                              ? Container()
                              : Column(
                            children: [
                              SizedBox(
                                height: 10.0.h,
                              ),
                              Container(
                                height: 50,
                                alignment: Alignment.center,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  "Participant Count",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),

                          // Category of participants Activation Area
                          Column(
                            children: [
                              venue.isEmpty
                                  ? Container()
                                  : Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    color: Color.fromARGB(255, 3, 37, 110),
                                    height: 70,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 5, right: 5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Category of the participants",
                                                style: TextStyle(color: Colors.white, fontSize: 11),
                                              ),
                                              Text(
                                                "Activation Area",
                                                style: TextStyle(color: Colors.white, fontSize: 11),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(),
                                        Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                "Male",
                                                style: TextStyle(color: Colors.white, fontSize: 12),
                                              ),
                                              SizedBox(
                                                width: 35,
                                              ),
                                              Text(
                                                "female",
                                                style: TextStyle(color: Colors.white, fontSize: 12),
                                              ),
                                              SizedBox(
                                                width: 35,
                                              ),
                                              Text(
                                                "Total",
                                                style: TextStyle(color: Colors.white, fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ...List.generate(venue[0].trainingInfoParticipantsActivation.length,
                                          (participants_ActiveIndex) {
                                        if (venue[0].trainingInfoParticipantsActivation[participants_ActiveIndex].check ==
                                            'other') {
                                          participant_other_id = venue[0]
                                              .trainingInfoParticipantsActivation[participants_ActiveIndex]
                                              .id
                                              .toString();
                                        }
                                        if (venue[0].trainingInfoParticipantsActivation[participants_ActiveIndex].check ==
                                            'main') {
                                          String levelId = venue[0]
                                              .trainingInfoParticipantsActivation[participants_ActiveIndex]
                                              .id
                                              .toString();
                                          if (!participant_level_id.contains(levelId)) {
                                            participant_level_id.add(levelId);
                                          }
                                        }

                                        participantActivationControllerMale.add(TextEditingController());
                                        participantActivationControllerFemale.add(TextEditingController());
                                        totalParticipantActivationController.add(TextEditingController());

                                        return Row(
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Expanded(
                                              flex: 6,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    venue[0].trainingInfoParticipantsActivation[participants_ActiveIndex].name,
                                                    style: TextStyle(fontSize: 14.0, color: Colors.black),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    // height: 40,
                                                    child: TextFormField(
                                                      keyboardType: TextInputType.number,
                                                      controller: participantActivationControllerMale[participants_ActiveIndex],
                                                      decoration: const InputDecoration(
                                                          border: OutlineInputBorder(),
                                                          enabledBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(width: 1, color: Colors.grey),
                                                          ),
                                                          hintText: "M",
                                                          contentPadding: EdgeInsets.all(10)),
                                                      textAlign: TextAlign.center,
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return '';
                                                        }
                                                        return null;
                                                      },
                                                      onChanged: (value) {
                                                        totalParticipantActivation(participants_ActiveIndex);
                                                        TotalParticipantActivationMale_Female();
                                                        int maleCount =
                                                            int.tryParse(totalParticipantActivationControllerMale.text) ?? 0;
                                                        int femaleCount =
                                                            int.tryParse(totalParticipantActivationControllerFemale.text) ?? 0;
                                                        int total = maleCount + femaleCount;
                                                        totalParticipantActivationControllerMaleFemale.text = total.toString();
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15.0.h,
                                            ),
                                            Expanded(
                                                flex: 2,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      // height: 40,
                                                      child: TextFormField(
                                                        keyboardType: TextInputType.number,
                                                        controller:
                                                        participantActivationControllerFemale[participants_ActiveIndex],
                                                        decoration: const InputDecoration(
                                                            border: OutlineInputBorder(),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(width: 1, color: Colors.grey),
                                                            ),
                                                            hintText: "F",
                                                            contentPadding: EdgeInsets.all(10)),
                                                        textAlign: TextAlign.center,
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return '';
                                                          }
                                                          return null;
                                                        },
                                                        onChanged: (value) {
                                                          totalParticipantActivation(participants_ActiveIndex);
                                                          TotalParticipantActivationMale_Female();
                                                          int maleCount =
                                                              int.tryParse(totalParticipantActivationControllerMale.text) ?? 0;
                                                          int femaleCount =
                                                              int.tryParse(totalParticipantActivationControllerFemale.text) ?? 0;
                                                          int total = maleCount + femaleCount;
                                                          totalParticipantActivationControllerMaleFemale.text = total.toString();
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                )),
                                            SizedBox(
                                              width: 15.0.h,
                                            ),
                                            Expanded(
                                                flex: 2,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      // height: 40,
                                                      child: TextFormField(
                                                        readOnly: true,
                                                        keyboardType: TextInputType.number,
                                                        controller:
                                                        totalParticipantActivationController[participants_ActiveIndex],
                                                        decoration: const InputDecoration(
                                                            border: OutlineInputBorder(),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(width: 1, color: Colors.grey),
                                                            ),
                                                            hintText: "T",
                                                            contentPadding: EdgeInsets.only(left: 25)),
                                                        onChanged: (value) {
                                                          // Handle the female input change here if needed
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        );
                                      }),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                          height: 40.0.h,
                                          width: 100,
                                          child: TextFormField(
                                            controller: totalParticipantActivationControllerMale,
                                            readOnly: true,
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(left: 40),
                                                border: OutlineInputBorder(),
                                                labelText: 'Total Male ',
                                                labelStyle: TextStyle(fontSize: 10),
                                                floatingLabelBehavior: FloatingLabelBehavior.always),
                                          )),
                                      SizedBox(
                                          height: 40.0.h,
                                          width: 100,
                                          child: TextFormField(
                                            onChanged: (value) {},
                                            controller: totalParticipantActivationControllerFemale,
                                            readOnly: true,
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(left: 40),
                                                border: OutlineInputBorder(),
                                                labelText: 'Total Female ',
                                                labelStyle: TextStyle(fontSize: 10),
                                                floatingLabelBehavior: FloatingLabelBehavior.always),
                                          )),
                                      SizedBox(
                                          height: 40.0.h,
                                          width: 100,
                                          child: TextFormField(
                                            controller: totalParticipantActivationControllerMaleFemale,
                                            readOnly: true,
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(left: 40),
                                                border: OutlineInputBorder(),
                                                labelText: 'Total participant',
                                                labelStyle: TextStyle(fontSize: 10),
                                                floatingLabelBehavior: FloatingLabelBehavior.always),
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Category of participants Maintenance Area
                          venue.isEmpty
                              ? Container()
                              : Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                color: Color.fromARGB(255, 3, 37, 110),
                                height: 70,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 5, right: 5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Category of the participants",
                                            style: TextStyle(color: Colors.white, fontSize: 11),
                                          ),
                                          Text(
                                            "Maintenance Area",
                                            style: TextStyle(color: Colors.white, fontSize: 11),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Male",
                                            style: TextStyle(color: Colors.white, fontSize: 12),
                                          ),
                                          SizedBox(
                                            width: 35,
                                          ),
                                          Text(
                                            "female",
                                            style: TextStyle(color: Colors.white, fontSize: 12),
                                          ),
                                          SizedBox(
                                            width: 35,
                                          ),
                                          Text(
                                            "Total",
                                            style: TextStyle(color: Colors.white, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ...List.generate(venue[0].trainingInfoParticipantsMaintenance.length, (Maintenance_Index) {
                                participantMaintenanceControllerMale.add(TextEditingController());
                                participantMaintenanceControllerFemale.add(TextEditingController());
                                totalParticipantMaintenanceController.add(TextEditingController());

                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Expanded(
                                          flex: 6,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                venue[0].trainingInfoParticipantsMaintenance[Maintenance_Index].name,
                                                style: TextStyle(fontSize: 14.0, color: Colors.black),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                // height: 40,
                                                child: TextFormField(
                                                  keyboardType: TextInputType.number,
                                                  controller: participantMaintenanceControllerMale[Maintenance_Index],
                                                  decoration: const InputDecoration(
                                                      border: OutlineInputBorder(),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(width: 1, color: Colors.grey),
                                                      ),
                                                      hintText: "M",
                                                      contentPadding: EdgeInsets.all(10)),
                                                  textAlign: TextAlign.center,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return '';
                                                    }
                                                    return null;
                                                  },
                                                  onChanged: (value) {
                                                    TotalParticipantMaintenance(Maintenance_Index);
                                                    TotalParticipantMaintenanceMale_Female();
                                                    int maleCount =
                                                        int.tryParse(totalParticipantMaintenanceControlleMale.text) ?? 0;
                                                    int femaleCount =
                                                        int.tryParse(totalParticipantMaintenanceControlleFemale.text) ?? 0;
                                                    int total = maleCount + femaleCount;
                                                    totalParticipantMaintenanceControlleMaleFemale.text = total.toString();
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15.0.h,
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  // height: 40,
                                                  child: TextFormField(
                                                    keyboardType: TextInputType.number,
                                                    controller: participantMaintenanceControllerFemale[Maintenance_Index],
                                                    decoration: const InputDecoration(
                                                        border: OutlineInputBorder(),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(width: 1, color: Colors.grey),
                                                        ),
                                                        hintText: "F",
                                                        contentPadding: EdgeInsets.all(10)),
                                                    textAlign: TextAlign.center,
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return '';
                                                      }
                                                      return null;
                                                    },
                                                    onChanged: (value) {
                                                      TotalParticipantMaintenance(Maintenance_Index);
                                                      TotalParticipantMaintenanceMale_Female();
                                                      int maleCount =
                                                          int.tryParse(totalParticipantMaintenanceControlleMale.text) ?? 0;
                                                      int femaleCount =
                                                          int.tryParse(totalParticipantMaintenanceControlleFemale.text) ??
                                                              0;
                                                      int total = maleCount + femaleCount;
                                                      totalParticipantMaintenanceControlleMaleFemale.text =
                                                          total.toString();
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            )),
                                        SizedBox(
                                          width: 15.0.h,
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  // height: 40,
                                                  child: TextFormField(
                                                    keyboardType: TextInputType.number,
                                                    controller: totalParticipantMaintenanceController[Maintenance_Index],
                                                    readOnly: true,
                                                    decoration: const InputDecoration(
                                                        border: OutlineInputBorder(),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(width: 1, color: Colors.grey),
                                                        ),
                                                        hintText: "T",
                                                        contentPadding: EdgeInsets.only(left: 25)),
                                                    onChanged: (value) {
                                                      // Handle the female input change here if needed
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                  ],
                                );
                              }),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                      height: 40.0.h,
                                      width: 100,
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: totalParticipantMaintenanceControlleMale,
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(left: 40),
                                            border: OutlineInputBorder(),
                                            labelText: 'Total Male ',
                                            labelStyle: TextStyle(fontSize: 10),
                                            floatingLabelBehavior: FloatingLabelBehavior.always),
                                      )),
                                  SizedBox(
                                      height: 40.0.h,
                                      width: 100,
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: totalParticipantMaintenanceControlleFemale,
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(left: 40),
                                            border: OutlineInputBorder(),
                                            labelText: 'Total Female ',
                                            labelStyle: TextStyle(fontSize: 10),
                                            floatingLabelBehavior: FloatingLabelBehavior.always),
                                      )),
                                  SizedBox(
                                      height: 40.0.h,
                                      width: 100,
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: totalParticipantMaintenanceControlleMaleFemale,
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(left: 40),
                                            border: OutlineInputBorder(),
                                            labelText: 'Total participant',
                                            labelStyle: TextStyle(fontSize: 10),
                                            floatingLabelBehavior: FloatingLabelBehavior.always),
                                      )),
                                ],
                              ),
                            ],
                          ),

                          //Ethnic Minority Activation Area
                          venue.isEmpty
                              ? Container()
                              : Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                color: Color.fromARGB(255, 3, 37, 110),
                                height: 70,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 5, right: 5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Ethnic Minority & Disadvantage Groups",
                                            style: TextStyle(color: Colors.white, fontSize: 11),
                                          ),
                                          Text(
                                            "Activation Area",
                                            style: TextStyle(color: Colors.white, fontSize: 11),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Male",
                                            style: TextStyle(color: Colors.white, fontSize: 12),
                                          ),
                                          SizedBox(
                                            width: 35,
                                          ),
                                          Text(
                                            "female",
                                            style: TextStyle(color: Colors.white, fontSize: 12),
                                          ),
                                          SizedBox(
                                            width: 35,
                                          ),
                                          Text(
                                            "Total",
                                            style: TextStyle(color: Colors.white, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ...List.generate(venue[0].minoritiesActivation.length, (Ethnic_activeIndex) {
                                String levelId = venue[0].minoritiesActivation[Ethnic_activeIndex].id.toString();
                                if (!minority_group_ids.contains(levelId)) {
                                  minority_group_ids.add(levelId);
                                }
                                minorityActivationControllerMale.add(TextEditingController());
                                minorityActivationControllerFemale.add(TextEditingController());
                                totalMinorityActivationController.add(TextEditingController());

                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Expanded(
                                          flex: 6,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                venue[0].minoritiesActivation[Ethnic_activeIndex].name.toString(),
                                                style: TextStyle(fontSize: 14.0, color: Colors.black),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                // height: 40,
                                                child: TextFormField(
                                                  keyboardType: TextInputType.number,
                                                  controller: minorityActivationControllerMale[Ethnic_activeIndex],
                                                  decoration: const InputDecoration(
                                                      border: OutlineInputBorder(),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(width: 1, color: Colors.grey),
                                                      ),
                                                      hintText: "M",
                                                      contentPadding: EdgeInsets.all(10)),
                                                  textAlign: TextAlign.center,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return '';
                                                    }
                                                    return null;
                                                  },
                                                  onChanged: (value) {
                                                    TotalMinorityActivation(Ethnic_activeIndex);
                                                    TotalMinorityActivationMale_Female();
                                                    int maleCount =
                                                        int.tryParse(totalMinorityActivationControlleMale.text) ?? 0;
                                                    int femaleCount =
                                                        int.tryParse(totalMinorityActivationControlleFemale.text) ?? 0;
                                                    int total = maleCount + femaleCount;
                                                    totalMinorityActivationControlleMaleFemale.text = total.toString();
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15.0.h,
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  // height: 40,
                                                  child: TextFormField(
                                                    keyboardType: TextInputType.number,
                                                    controller: minorityActivationControllerFemale[Ethnic_activeIndex],
                                                    decoration: const InputDecoration(
                                                        border: OutlineInputBorder(),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(width: 1, color: Colors.grey),
                                                        ),
                                                        hintText: "F",
                                                        contentPadding: EdgeInsets.all(10)),
                                                    textAlign: TextAlign.center,
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return '';
                                                      }
                                                      return null;
                                                    },
                                                    onChanged: (value) {
                                                      TotalMinorityActivation(Ethnic_activeIndex);
                                                      TotalMinorityActivationMale_Female();
                                                      int maleCount =
                                                          int.tryParse(totalMinorityActivationControlleMale.text) ?? 0;
                                                      int femaleCount =
                                                          int.tryParse(totalMinorityActivationControlleFemale.text) ?? 0;
                                                      int total = maleCount + femaleCount;
                                                      totalMinorityActivationControlleMaleFemale.text = total.toString();
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            )),
                                        SizedBox(
                                          width: 15.0.h,
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  // height: 40,
                                                  child: TextFormField(
                                                    readOnly: true,
                                                    keyboardType: TextInputType.number,
                                                    controller: totalMinorityActivationController[Ethnic_activeIndex],
                                                    textAlign: TextAlign.center,
                                                    decoration: const InputDecoration(
                                                        border: OutlineInputBorder(),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(width: 1, color: Colors.grey),
                                                        ),
                                                        hintText: "T",
                                                        contentPadding: EdgeInsets.all(10)),
                                                    onChanged: (value) {
                                                      // Handle the female input change here if needed
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                  ],
                                );
                              }),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                      height: 40.0.h,
                                      width: 100,
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: totalMinorityActivationControlleMale,
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(left: 40),
                                            border: OutlineInputBorder(),
                                            labelText: 'Total Male ',
                                            labelStyle: TextStyle(fontSize: 10),
                                            floatingLabelBehavior: FloatingLabelBehavior.always),
                                      )),
                                  SizedBox(
                                      height: 40.0.h,
                                      width: 100,
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: totalMinorityActivationControlleFemale,
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(left: 40),
                                            border: OutlineInputBorder(),
                                            labelText: 'Total Female ',
                                            labelStyle: TextStyle(fontSize: 10),
                                            floatingLabelBehavior: FloatingLabelBehavior.always),
                                      )),
                                  SizedBox(
                                      height: 40.0.h,
                                      width: 100,
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: totalMinorityActivationControlleMaleFemale,
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(left: 40),
                                            border: OutlineInputBorder(),
                                            labelText: 'Total participant',
                                            labelStyle: TextStyle(fontSize: 10),
                                            floatingLabelBehavior: FloatingLabelBehavior.always),
                                      )),
                                ],
                              ),
                            ],
                          ),

                          //Ethnic Minority Maintenance
                          venue.isEmpty
                              ? Container()
                              : Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                color: Color.fromARGB(255, 3, 37, 110),
                                height: 70,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 5, right: 5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Ethnic Minority & Disadvantage Groups",
                                            style: TextStyle(color: Colors.white, fontSize: 11),
                                          ),
                                          Text(
                                            "Maintenance Area",
                                            style: TextStyle(color: Colors.white, fontSize: 11),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Male",
                                            style: TextStyle(color: Colors.white, fontSize: 12),
                                          ),
                                          SizedBox(
                                            width: 35,
                                          ),
                                          Text(
                                            "female",
                                            style: TextStyle(color: Colors.white, fontSize: 12),
                                          ),
                                          SizedBox(
                                            width: 35,
                                          ),
                                          Text(
                                            "Total",
                                            style: TextStyle(color: Colors.white, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ...List.generate(venue[0].minoritiesMaintenance.length, (Ethnic_MaintenanceIndex) {
                                minorityMaintenanceControllerMale.add(TextEditingController());
                                minorityMaintenanceControllerFemale.add(TextEditingController());
                                totalMinorityMaintenanceController.add(TextEditingController());
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Expanded(
                                          flex: 6,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                venue[0].minoritiesMaintenance[Ethnic_MaintenanceIndex].name,
                                                style: TextStyle(fontSize: 14.0, color: Colors.black),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                // height: 40,
                                                child: TextFormField(
                                                  keyboardType: TextInputType.number,
                                                  controller: minorityMaintenanceControllerMale[Ethnic_MaintenanceIndex],
                                                  decoration: const InputDecoration(
                                                      border: OutlineInputBorder(),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(width: 1, color: Colors.grey),
                                                      ),
                                                      hintText: "M",
                                                      contentPadding: EdgeInsets.all(10)),
                                                  textAlign: TextAlign.center,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return '';
                                                    }
                                                    return null;
                                                  },
                                                  onChanged: (value) {
                                                    TotalMinorityMaintenance(Ethnic_MaintenanceIndex);
                                                    TotalMinorityMaintenanceMale_Female();
                                                    int maleCount =
                                                        int.tryParse(totalMinorityMaintenanceControlleMale.text) ?? 0;
                                                    int femaleCount =
                                                        int.tryParse(totalMinorityMaintenanceControlleFemale.text) ?? 0;
                                                    int total = maleCount + femaleCount;
                                                    totalMinorityMaintenanceControlleMaleFemale.text = total.toString();
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15.0.h,
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  // height: 40,
                                                  child: TextFormField(
                                                    keyboardType: TextInputType.number,
                                                    controller:
                                                    minorityMaintenanceControllerFemale[Ethnic_MaintenanceIndex],
                                                    decoration: const InputDecoration(
                                                        border: OutlineInputBorder(),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(width: 1, color: Colors.grey),
                                                        ),
                                                        hintText: "F",
                                                        contentPadding: EdgeInsets.all(10)),
                                                    textAlign: TextAlign.center,
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return '';
                                                      }
                                                      return null;
                                                    },
                                                    onChanged: (value) {
                                                      TotalMinorityMaintenance(Ethnic_MaintenanceIndex);
                                                      TotalMinorityMaintenanceMale_Female();
                                                      int maleCount =
                                                          int.tryParse(totalMinorityMaintenanceControlleMale.text) ?? 0;
                                                      int femaleCount =
                                                          int.tryParse(totalMinorityMaintenanceControlleFemale.text) ?? 0;
                                                      int total = maleCount + femaleCount;
                                                      totalMinorityMaintenanceControlleMaleFemale.text = total.toString();
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            )),
                                        SizedBox(
                                          width: 15.0.h,
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  // height: 40,
                                                  child: TextFormField(
                                                    readOnly: true,
                                                    keyboardType: TextInputType.number,
                                                    controller: totalMinorityMaintenanceController[Ethnic_MaintenanceIndex],
                                                    decoration: const InputDecoration(
                                                        border: OutlineInputBorder(),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(width: 1, color: Colors.grey),
                                                        ),
                                                        hintText: "T",
                                                        contentPadding: EdgeInsets.only(left: 25)),
                                                    onChanged: (value) {
                                                      // Handle the female input change here if needed
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                  ],
                                );
                              }),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                      height: 40.0.h,
                                      width: 100,
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: totalMinorityMaintenanceControlleMale,
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(left: 40),
                                            border: OutlineInputBorder(),
                                            labelText: 'Total Male ',
                                            labelStyle: TextStyle(fontSize: 10),
                                            floatingLabelBehavior: FloatingLabelBehavior.always),
                                      )),
                                  SizedBox(
                                      height: 40.0.h,
                                      width: 100,
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: totalMinorityMaintenanceControlleFemale,
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(left: 40),
                                            border: OutlineInputBorder(),
                                            labelText: 'Total Female ',
                                            labelStyle: TextStyle(fontSize: 10),
                                            floatingLabelBehavior: FloatingLabelBehavior.always),
                                      )),
                                  SizedBox(
                                      height: 40.0.h,
                                      width: 100,
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: totalMinorityMaintenanceControlleMaleFemale,
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(left: 40),
                                            border: OutlineInputBorder(),
                                            labelText: 'Total participant',
                                            labelStyle: TextStyle(fontSize: 10),
                                            floatingLabelBehavior: FloatingLabelBehavior.always),
                                      )),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5.0.w, right: 5.0.w),
                            child: TextFormField(
                              controller: remarkController,
                              maxLines: 2,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Remarks',
                                  floatingLabelBehavior: FloatingLabelBehavior.always),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter Remarks Field';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10.0.h,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5.0.w, right: 5.0.w),
                            child: TextFormField(
                              controller: trainingVenueController,
                              maxLines: 1,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Training Venue',
                                  floatingLabelBehavior: FloatingLabelBehavior.always),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter Training Venue Field';
                                }
                                return null;
                              },
                            ),
                          ),


                          SizedBox(
                            height: 10.0.h,
                          ),

                          _isLoading
                              ? Center(child: AllService.LoadingToast())
                              : Center(
                            child: SizedBox(
                              width: 330.w,
                              height: 50.h,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    backgroundColor: MyColors.secondaryColor,
                                  ),
                                  onPressed: () async {
                                    final connectivityResult = await (Connectivity().checkConnectivity());
                                    if (connectivityResult.contains(ConnectivityResult.mobile)  ||
                                        connectivityResult.contains(ConnectivityResult.wifi)
                                       ) {
                                      if (_trainingFormKey.currentState!
                                          .validate()) {
                                        getTextValuesActivationMaleFemale();
                                        getTextValuesMaintenanceMaleFemale();
                                        getTextValuesMinorityActivationMaleFemale();
                                        getTextValuesMinorityMaintenanceMaleFemale();
                                        print(a_male);
                                        int total_male = 0;
                                        int total_female = 0;
                                        int total_minority_male = 0;
                                        int total_minority_female = 0;
                                        int total_participant = 0;
                                        int total_minority_participant = 0;

                                        total_male = int.parse(
                                            totalParticipantActivationControllerMale
                                                .text) +
                                            int.parse(
                                                totalParticipantMaintenanceControlleMale
                                                    .text);

                                        total_female = int.parse(
                                            totalParticipantActivationControllerFemale
                                                .text) +
                                            int.parse(
                                                totalParticipantMaintenanceControlleFemale
                                                    .text);
                                        total_participant =
                                            total_male + total_female;

                                        print(
                                            "TOTAL male ${total_male} total female ${total_female} all total ${total_participant}");
                                        total_minority_male = int.parse(
                                            totalMinorityActivationControlleMale
                                                .text) +
                                            int.parse(
                                                totalMinorityMaintenanceControlleMale
                                                    .text);
                                        total_minority_female = int.parse(
                                            totalMinorityActivationControlleFemale
                                                .text) +
                                            int.parse(
                                                totalMinorityMaintenanceControlleFemale
                                                    .text);
                                        total_minority_participant =
                                            total_minority_male +
                                                total_minority_female;

                                        print(
                                            "TOTAL minority male ${total_minority_male} total minority female ${total_minority_female} all minority total ${total_minority_participant}");

                                        Map trainingBody = {
                                          "training_info_setting_id": training_info_setting_id,
                                          "location_id": location_id,
                                          "division": divisionId,
                                          "district": districtId,
                                          "upazila": upazilaId,
                                          "union": unionId,
                                          "training_from_date": fromDateController
                                              .text,
                                          "training_to_date": toDateController
                                              .text,
                                          "training_venue": trainingVenueController.text,
                                          "participant_level_id": participant_level_id,
                                          "a_male": a_male,
                                          "a_female": a_female,
                                          "a_total": a_total,
                                          "m_male": m_male,
                                          "m_female": m_female,
                                          "m_total": m_total,
                                          "minority_group_id": minority_group_ids,
                                          "minority_a_male": minority_a_male,
                                          "minority_a_female": minority_a_female,
                                          "minority_a_total": minority_a_total,
                                          "minority_m_male": minority_m_male,
                                          "minority_m_female": minority_m_female,
                                          "minority_m_total": minority_m_total,
                                          if (participant_other_id !=
                                              '0') "participant_other_id": participant_other_id,
                                          if (participant_other_id !=
                                              '0') "a_other_male": a_other_male,
                                          if (participant_other_id !=
                                              '0') "a_other_female": a_other_female,
                                          if (participant_other_id !=
                                              '0') "a_other_total": a_other_total
                                              .toString(),
                                          if (participant_other_id !=
                                              '0') "m_other_male": m_other_male,
                                          if (participant_other_id !=
                                              '0') "m_other_female": m_other_female,
                                          if (participant_other_id !=
                                              '0') "m_other_total": m_other_total
                                              .toString(),
                                          "total_male": total_male,
                                          "total_female": total_female,
                                          "total_participant": total_participant,
                                          "total_minority_male": total_minority_male,
                                          "total_minority_female": total_minority_female,
                                          "total_minority_participant": total_minority_participant,
                                          "longitude": currentLocation?.latitude
                                              .toString() ?? '0.0',
                                          "latitude": currentLocation?.longitude
                                              .toString() ?? '0.0',
                                          "remark": remarkController.text
                                        };
                                        log("Test update data: " +
                                            jsonEncode(trainingBody));
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        print(jsonEncode(trainingBody));
                                        Map a = await Repositores().trainingInfoUpdate(jsonEncode(trainingBody), widget.id.toString());
                                        if (a['status'] == 201) {
                                          await QuickAlert.show(
                                            context: context,
                                            type: QuickAlertType.success,
                                            text: "Training Update Successfully!",
                                          );
                                          // await Navigator.of(context).pushAndRemoveUntil(
                                          //     MaterialPageRoute(builder: (context) => Homepage()),
                                          //         (Route<dynamic> route) => false);
                                          setState(() {
                                            _isLoading = false;
                                          });
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        } else {
                                          await QuickAlert.show(
                                            context: context,
                                            type: QuickAlertType.error,
                                            text: "Something went wrong please try again later",
                                          );
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        }
                                      }
                                    } else {
                                      AllService().internetCheckDialog(context);
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Update',
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        ],
                    ),
                  ),
                     SizedBox(
                    height: 10.0.h,
                  ),

                ]),
              );
            }

            return Container();
          },
        ),
      ),
    );
  }

  void tost(String text) {
    toast.Fluttertoast.showToast(
      msg: text,
      toastLength: toast.Toast.LENGTH_SHORT,
      gravity: toast.ToastGravity.TOP,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

//get all   Participants Activation value
  List<String> a_male = [];
  List<String> a_female = [];
  List<String> a_total = [];
  String a_other_male = '0';
  String a_other_female = '0';
  int a_other_total = 0;
  void getTextValuesActivationMaleFemale() {
    a_male.clear();
    a_female.clear();
    a_total.clear();

    for (int i = 0; i < venue[0].trainingInfoParticipantsActivation.length; i++) {
      //male
      if (venue[0].trainingInfoParticipantsActivation[i].check == 'other') {
        a_other_male = participantActivationControllerMale[i].text.isEmpty ? "0" : participantActivationControllerMale[i].text;
      } else {
        a_male.add(participantActivationControllerMale[i].text.isEmpty ? "0" : participantActivationControllerMale[i].text);
      }
      //female
      if (venue[0].trainingInfoParticipantsActivation[i].check == 'other') {
        a_other_female =
        participantActivationControllerFemale[i].text.isEmpty ? "0" : participantActivationControllerFemale[i].text;
      } else {
        a_female.add(participantActivationControllerFemale[i].text.isEmpty ? "0" : participantActivationControllerFemale[i].text);
      }
      //total
      a_total.add(totalParticipantActivationController[i].text.isEmpty ? "0" : totalParticipantActivationController[i].text);
      a_other_total = int.parse(a_other_male) + int.parse(a_other_female);
    }
  }

//get all   Participants Maintenance value
  List<String> m_male = [];
  List<String> m_female = [];
  List<String> m_total = [];
  String m_other_male = '0';
  String m_other_female = '0';
  int m_other_total = 0;
  void getTextValuesMaintenanceMaleFemale() {
    m_male.clear();
    m_female.clear();
    m_total.clear();

    for (int i = 0; i < venue[0].trainingInfoParticipantsMaintenance.length; i++) {
      //male
      if (venue[0].trainingInfoParticipantsMaintenance[i].check == 'other') {
        m_other_male = participantMaintenanceControllerMale[i].text.isEmpty ? "0" : participantMaintenanceControllerMale[i].text;
      } else {
        m_male.add(participantMaintenanceControllerMale[i].text.isEmpty ? "0" : participantMaintenanceControllerMale[i].text);
      }
      //female
      if (venue[0].trainingInfoParticipantsMaintenance[i].check == 'other') {
        m_other_female =
        participantMaintenanceControllerFemale[i].text.isEmpty ? "0" : participantMaintenanceControllerFemale[i].text;
      } else {
        m_female
            .add(participantMaintenanceControllerFemale[i].text.isEmpty ? "0" : participantMaintenanceControllerFemale[i].text);
      }
      //total
      m_total.add(totalParticipantMaintenanceController[i].text.isEmpty ? "0" : totalParticipantMaintenanceController[i].text);
      m_other_total = int.parse(m_other_male) + int.parse(m_other_female);
    }
  }

  //get all   minority   Activation value
  List<String> minority_a_male = [];
  List<String> minority_a_female = [];
  List<String> minority_a_total = [];

  void getTextValuesMinorityActivationMaleFemale() {
    minority_a_male.clear();
    minority_a_female.clear();
    minority_a_total.clear();

    for (int i = 0; i < venue[0].minoritiesActivation.length; i++) {
      //male

      minority_a_male.add(minorityActivationControllerMale[i].text.isEmpty ? "0" : minorityActivationControllerMale[i].text);

      //female

      minority_a_female
          .add(minorityActivationControllerFemale[i].text.isEmpty ? "0" : minorityActivationControllerFemale[i].text);

      //total
      minority_a_total.add(totalMinorityActivationController[i].text.isEmpty ? "0" : totalMinorityActivationController[i].text);
    }
  }

  //get all   minority   Maintenance value
  List<String> minority_m_male = [];
  List<String> minority_m_female = [];
  List<String> minority_m_total = [];

  void getTextValuesMinorityMaintenanceMaleFemale() {
    minority_m_male.clear();
    minority_m_female.clear();
    minority_m_total.clear();

    for (int i = 0; i < venue[0].minoritiesMaintenance.length; i++) {
      //male

      minority_m_male.add(minorityMaintenanceControllerMale[i].text.isEmpty ? "0" : minorityMaintenanceControllerMale[i].text);

      //female

      minority_m_female
          .add(minorityMaintenanceControllerFemale[i].text.isEmpty ? "0" : minorityMaintenanceControllerFemale[i].text);

      //total
      minority_m_total.add(totalMinorityMaintenanceController[i].text.isEmpty ? "0" : totalMinorityMaintenanceController[i].text);
    }
  }
}
