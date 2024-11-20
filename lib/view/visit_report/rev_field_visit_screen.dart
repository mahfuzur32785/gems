import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartx/dartx.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:village_court_gems/bloc/Change_Location_bloc/change_location_bloc.dart';
import 'package:village_court_gems/bloc/Connectivity_bloc/connectivity_bloc_bloc.dart';
import 'package:village_court_gems/bloc/Connectivity_bloc/new_connectivity_cubit.dart';
import 'package:village_court_gems/bloc/New_Location_Bloc/new_location_bloc.dart';
import 'package:village_court_gems/camera_widget/camera_model.dart';
import 'package:village_court_gems/camera_widget/camera_widget.dart';
import 'package:village_court_gems/controller/Local_store_controller/local_store.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/main.dart';
import 'package:village_court_gems/models/Local_store_model/field_submit_local.dart';
import 'package:village_court_gems/models/Local_store_model/save_field_visit_model.dart';
import 'package:village_court_gems/models/area_model/office_type_model.dart';
import 'package:village_court_gems/models/field_visit_model/updated_new_loc_model.dart';
import 'package:village_court_gems/models/locationModel.dart';
import 'package:village_court_gems/models/tst_fv_office_model.dart';
import 'package:village_court_gems/provider/connectivity_provider.dart';
import 'package:village_court_gems/services/all_services/all_services.dart';
import 'package:village_court_gems/services/backgroundService/wm_service.dart';
import 'package:village_court_gems/services/database/localDatabaseService.dart';
import 'package:village_court_gems/util/colors.dart';
import 'package:village_court_gems/util/constant.dart';
import 'package:village_court_gems/util/date_converter.dart';
import 'package:village_court_gems/util/utils.dart';
import 'package:village_court_gems/view/home/homepage.dart';
import 'package:village_court_gems/view/visit_report/arrow_clipper.dart';
import 'package:village_court_gems/view/visit_report/field_visit_local_logic.dart';
import 'package:village_court_gems/view/visit_report/offline_sync_page.dart';
import 'package:village_court_gems/view/visit_report/show_image.dart';
import 'package:village_court_gems/view/visit_report/visit_report_online.dart';
import 'package:workmanager/workmanager.dart';

class NewFieldVisit extends StatefulWidget {
  static const pageName = 'VisitReport';
  const NewFieldVisit({super.key});

  @override
  State<NewFieldVisit> createState() => _NewFieldVisitState();
}

class _NewFieldVisitState extends State<NewFieldVisit> {
  bool isLoading = false;
  bool findeNearByOffice = false;
  int dialogCloseValue = 0;
  int locationMatched = 0;
  bool isLocationMatched = false;
  UpdNewLocationData? updNewLocationDrpModel;
  UpdNewLocationData? selectedDataFromChangedLocDrp;
  Uint8List? img1;
  Uint8List? img2;
  Uint8List? img3;
  String? img1Path;
  String? img2Path;
  String? img3Path;
  bool isSubmitLoading = false;
  bool isFieldSubmitLoading = false;
  String? diagDivisionId = '';
  String? diagdistrictId = '';
  String? diagUpazilaID = '';
  String? diagUnionID = '';
  String? diagOfficeTypeID = '';
  // final SharedPreferencesAsync prefs = SharedPreferencesAsync();

  Division? chngeLocDivValue;
  District? chngLocDistrictVal;
  Upazila? chngLocUpazilaVal;
  Union? chngLocUnionVal;
  OfficeTypeData? chngLocOfficeTypeVal;

  List<Union> dialogUnion = [];
  List<District> dialogDistrict = [];
  List<Upazila> dialogUpazila = [];
  List<Division> dialogDivision = [];
  List<OfficeTypeData> dialogOfficeTypeData = [];
  var changeLocationID;
  final NewLocationBloc locationBloc = NewLocationBloc();
  final ChangeLocationBloc changeLocationBloc = ChangeLocationBloc();
  final GlobalKey<FormState> _formKeyVisitReport = GlobalKey<FormState>();
  final GlobalKey<FormState> _chngLocformKeyVisitReport =
      GlobalKey<FormState>();
  Completer<GoogleMapController> mapControllerCompleter =
      Completer<GoogleMapController>();
  TextEditingController officeTitleCtrl = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  final ConnectivityBloc connectivityBloc = ConnectivityBloc();
  TstFVModel? selOfficeVal;
  String? selectedOffice;
  final List<TstFVModel> officeList = [
    TstFVModel(id: 1, name: 'DC/DDLG Office'),
    TstFVModel(id: 4, name: 'Other Office - (IDB)'),
    TstFVModel(id: 5, name: 'Other Office - (Mirpur)'),
    TstFVModel(id: 2, name: 'UP Office'),
    TstFVModel(id: 3, name: 'UNO Office'),
  ];

  List<TstFvAreaModel> filteredAreaList = [];

  final List<TstFvAreaModel> areaList = [
    TstFvAreaModel(
        id: 1,
        distName: 'Dhaka',
        divName: 'Dhaka',
        unionName: '',
        upazilaName: ''),
    TstFvAreaModel(
        id: 4,
        distName: 'Dhaka',
        divName: 'Dhaka',
        unionName: 'Dhaka',
        upazilaName: 'Dhamrai'),
    TstFvAreaModel(
        id: 5,
        distName: 'Dhaka',
        divName: 'Dhaka',
        unionName: 'Dhaka',
        upazilaName: 'Narayanganj'),
    TstFvAreaModel(
        id: 2,
        distName: 'Barishal',
        divName: 'Barguna',
        unionName: 'Amtali',
        upazilaName: 'Chowra'),
    TstFvAreaModel(
        id: 7,
        distName: 'Dhaka',
        divName: 'Dhaka',
        unionName: 'Dhaka',
        upazilaName: 'Savar'),
    TstFvAreaModel(
        id: 3,
        distName: 'Dhaka',
        divName: 'Dhaka',
        unionName: 'Dhaka',
        upazilaName: ''),
  ];

  getNearByOffice() async {
    setState(() {
      isLoading = true;
      findeNearByOffice = false;
    });
    await Future.delayed(
      Duration(seconds: 2),
    );
    setState(() {
      isLoading = false;
      findeNearByOffice = true;
    });
  }

  double targetLatitude = 0.0;
  double targetLongitude = 0.0;

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Geolocator.openLocationSettings();
      print('Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        AllService().showToast('You must give location permission');
        print('Location permissions are denied (actual).');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Geolocator.openAppSettings();
      print(
          'Location permissions are permanently denied, we cannot request permissions.');
      return;
    }

    // try {
    setState(() {
      isLoading = true;
    });
    var locationAccuracy = await Geolocator.getLocationAccuracy();
    if (locationAccuracy == LocationAccuracyStatus.reduced) {
      Geolocator.openAppSettings();
    } else {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      //if (position.latitude != null) {
      double latitude = position.latitude;
      double longitude = position.longitude;

      print('Latitudeonline: $latitude, Longitude: $longitude');

      //List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

      setState(() {
        targetLatitude =
            latitude; //24.37491928	23.75811967	89.6436105824.26970950;
        targetLongitude = longitude; //24.26276900 89.87942700;
        //currentAddress = "${placemarks[0].subLocality}, ${placemarks[0].locality}";
        //print('Current Address ${currentAddress}');
        updateMap();
        isLoading = false;
      });
    }

    // } catch (e) {
    //   print('Error: $e');
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connectivityBloc.add(ConnectivityObserve());
    changeLocationBloc.add(ChangeLocationInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.secondaryColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () async {
            Navigator.pop(context);
            // await prefs.remove(allLocationFirstCall);
            // await prefs.remove(allLocationSp);
            // await prefs.remove(latestDate);
          },
        ),
        centerTitle: true,
        title: BlocBuilder<ConnectivityCubit, ConnectivityState>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, netState) {
            if (netState == ConnectivityState.disconnected) {
              return Row(
                children: [
                  Text(
                    "New Field Visit Track ",
                    style: TextStyle(
                        fontSize: 17.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Offline',
                      style: TextStyle(fontSize: 13, color: Colors.white),
                    ),
                  ),
                ],
              );
            } else if (netState == ConnectivityState.connected) {
              return Text(
                "New Field Visit Track",
                style: TextStyle(
                    fontSize: 17.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              );
            } else {
              return SizedBox();
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKeyVisitReport,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        backgroundColor: MyColors.secondaryColor,
                      ),
                      onPressed: () async {
                        setState(() {
                          dialogCloseValue = 0;
                          updNewLocationDrpModel = null;
                          selectedDataFromChangedLocDrp = null;
                          diagDivisionId = null;
                          selectedOffice = '';
                          diagUpazilaID = null;
                          diagdistrictId = null;
                          diagUpazilaID = null;
                          chngeLocDivValue = null;
                          chngLocDistrictVal = null;
                          chngLocUpazilaVal = null;
                          chngLocOfficeTypeVal = null;

                          chngLocUnionVal = null;
                        });
                        // await getNearByOffice();
                        // setState(() {
                        //   dialogCloseValue = 0;
                        //   selectedOfficeId = null;
                        // });
                        await _getCurrentLocation();
                      },
                      child: isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            ) // Show the indicator when loading
                          : const Text(
                              "Find Nearby Office",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => VisitReportOnline(),
                    //     ));
                  },
                  child: Text(
                    "My Location ",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                  ),
                ),
                Text(
                  'Latitude: ${targetLatitude}, Longitude: ${targetLongitude}',
                  style: TextStyle(fontSize: 15.0),
                ),
                // SizedBox(height: 10),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _mapViewWidget(),

                    Divider(),
                    //const SizedBox(height: 10),
                    // SizedBox(
                    //   height: 50.0.h,
                    //   child: TextField(
                    //     readOnly: true,
                    //     controller: TextEditingController(text: DateConverter.localDateToIsoString(DateTime.now())),
                    //     decoration: const InputDecoration(
                    //         enabledBorder: OutlineInputBorder(
                    //           borderSide: BorderSide(width: 1, color: Colors.black),
                    //         ),
                    //         focusedBorder: OutlineInputBorder(
                    //           borderSide: BorderSide(width: 1, color: Colors.black),
                    //         ),
                    //         contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    //         hintText: "Visit Date",
                    //         suffixIcon: Icon(Icons.calendar_today),
                    //         label: Text('Visit Date')),
                    //   ),
                    // ),

                    // Container(
                    //   height: 50,
                    //   decoration: BoxDecoration(
                    //     border: Border.all(color: Colors.black),
                    //     borderRadius: BorderRadius.circular(5)
                    //   ),
                    //   child: Row(
                    //     children: [
                    //       Padding(
                    //         padding: const EdgeInsets.only(left:8.0),
                    //         child: Text('Visit Date :',style: TextStyle(fontWeight: FontWeight.w500),),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (dialogCloseValue == 0) ...[
                          BlocConsumer<NewLocationBloc, NewLocationBlocState>(
                            bloc: locationBloc,
                            buildWhen: (previous, current) =>
                                previous != current,
                            listener: (context, state) {
                              if (state is DialogShownState) {
                                if (state.message != "" ||
                                    state.message != "null") {
                                  // selectedOffice = null;
                                  isLocationMatched = true;
                                  setState(() {});
                                  AllService().showToast("Location not match",
                                      isError: true);
                                  locationMatched = 0;
                                  showCustomDialog();
                                }
                              } else if (state is NewLocationSuccessState) {
                                //setState(() {
                                updNewLocationDrpModel =
                                    state.locationData.first;
                                // });
                              }
                            },
                            builder: (context, state) {
                              if (state is NewLocationLoadingState) {
                                return Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              } else if (state is NewLocationSuccessState) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    updNewLocationDrpModel?.distance != null
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'Distance:',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 10),
                                                ),
                                                Text(
                                                  ' ${updNewLocationDrpModel!.distance!.toDouble().toStringAsFixed(2)}m',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 10),
                                                ),
                                              ],
                                            ),
                                          )
                                        : SizedBox.shrink(),
                                    _officeDropdown(state.locationData),
                                    updNewLocationDrpModel == null
                                        ? const SizedBox(height: 10)
                                        : Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 8),
                                            child: Wrap(
                                              runAlignment: WrapAlignment.start,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.start,
                                              children: [
                                                //breadcrumTile(updNewLocationDrpModel?.divisionName ?? ''),
                                                breadcrumTile(
                                                    updNewLocationDrpModel
                                                            ?.districtName ??
                                                        '',
                                                    isEnd: updNewLocationDrpModel
                                                                ?.upazilaName !=
                                                            null
                                                        ? updNewLocationDrpModel!
                                                                .upazilaName!
                                                                .isEmpty
                                                            ? true
                                                            : false
                                                        : true),
                                                breadcrumTile(
                                                    updNewLocationDrpModel
                                                            ?.upazilaName ??
                                                        '',
                                                    isEnd: updNewLocationDrpModel
                                                                ?.unionName !=
                                                            null
                                                        ? updNewLocationDrpModel!
                                                                .unionName!
                                                                .isEmpty
                                                            ? true
                                                            : false
                                                        : true),
                                                breadcrumTile(
                                                    updNewLocationDrpModel
                                                            ?.unionName ??
                                                        '',
                                                    isEnd: true),
                                              ],
                                            ),
                                          ),
                                    // Row(
                                    //   crossAxisAlignment: CrossAxisAlignment.start,
                                    //   mainAxisAlignment: MainAxisAlignment.start,
                                    //   children: [
                                    //     Text(
                                    //       'Distance(in meter) :',
                                    //       style: TextStyle(fontWeight: FontWeight.w500),
                                    //     ),
                                    //     Text(' ${updNewLocationDrpModel?.distance ?? ''}'),
                                    //   ],
                                    // ),
                                    Divider(),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      height: 50.0.h,
                                      child: TextField(
                                        readOnly: true,
                                        controller: TextEditingController(
                                            text: DateConverter
                                                .localDateToIsoString(
                                                    DateTime.now())),
                                        decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.black),
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 10),
                                            hintText: "Visit Date",
                                            suffixIcon:
                                                Icon(Icons.calendar_today),
                                            label: Text('Visit Date')),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            print(
                                                'online add new office clicked');
                                            print(
                                                'online add new office clicked');
                                            setState(() {
                                              // upazilaId = '';
                                              // unionID = '';
                                              // districtId = '';
                                              // divisionId = '';
                                              diagDivisionId = null;
                                              selectedOffice = '';
                                              diagUpazilaID = null;
                                              diagdistrictId = null;
                                              diagUpazilaID = null;
                                              chngeLocDivValue = null;
                                              chngLocDistrictVal = null;
                                              chngLocUpazilaVal = null;
                                              chngLocOfficeTypeVal = null;
                                              chngLocUnionVal = null;
                                              dialogDivision.clear();
                                              dialogDistrict.clear();
                                              dialogUpazila.clear();
                                              dialogUnion.clear();
                                              dialogOfficeTypeData.clear();
                                              changeLocationBloc.add(
                                                  ChangeLocationInitialEvent());
                                            });
                                            showCustomDialog();
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 8),
                                            alignment: Alignment.center,
                                            width: 120.w,
                                            height: 35.h,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: MyColors.secondaryColor),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 3.0.w, right: 3.0.w),
                                              child: FittedBox(
                                                child: Text(
                                                  "Add New Office",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Divider(),
                                    //SizedBox(height: 6),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      child: const Text(
                                        "Capture Image",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    imageSelectWidget(context),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 45,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          backgroundColor:
                                              MyColors.secondaryColor,
                                        ),
                                        onPressed: isFieldSubmitLoading
                                            ? null
                                            : () {
                                                log('loc mathced submit ${jsonEncode(updNewLocationDrpModel)}');
                                                if (updNewLocationDrpModel !=
                                                    null) {
                                                  if (img1Path != null ||
                                                      img2Path != null ||
                                                      img3Path != null) {
                                                    submitFieldVisit(
                                                        dialogclose: 0,
                                                        officeTitle: '');
                                                  } else {
                                                    AllService().showToast(
                                                        'Please Upload at least 1 Image (up to 3) ',
                                                        isError: true);
                                                  }
                                                } else {
                                                  AllService().showToast(
                                                      'Please Enter all data',
                                                      isError: true);
                                                }
                                                // log('union select from submit $unionID');
                                              },
                                        child: isFieldSubmitLoading
                                            ? Center(
                                                child:
                                                    AllService.LoadingToast())
                                            : const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Submit',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return SizedBox();
                            },
                          ),
                        ] else ...[
                          // selectedDataFromChangedLocDrp == null
                          //     ? SizedBox.shrink()
                          //     : Row(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         mainAxisAlignment: MainAxisAlignment.end,
                          //         children: [
                          //           Text(
                          //             'Distance(in meter) :',
                          //             style: TextStyle(fontWeight: FontWeight.w500),
                          //           ),
                          //           Text(' ${selectedDataFromChangedLocDrp?.distance ?? ''}'),
                          //         ],
                          //       ),
                          selectedDataFromChangedLocDrp == null
                              ? SizedBox.shrink()
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0, vertical: 8),
                                  child: TextField(
                                    controller: selectedDataFromChangedLocDrp!
                                                .officeTypeId ==
                                            4
                                        ? TextEditingController(
                                            text: selectedDataFromChangedLocDrp!
                                                .officeTypeName)
                                        : TextEditingController(
                                            text: selectedDataFromChangedLocDrp!
                                                .officeTypeName),
                                    readOnly: true,
                                    decoration: const InputDecoration(
                                      labelText: 'Selected Office',
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 7),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                          selectedDataFromChangedLocDrp == null
                              ? const SizedBox(height: 10)
                              : Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  child: Wrap(
                                    runAlignment: WrapAlignment.start,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    children: [
                                      breadcrumTile(updNewLocationDrpModel
                                              ?.divisionName ??
                                          ''),
                                      breadcrumTile(
                                          selectedDataFromChangedLocDrp
                                                  ?.districtName ??
                                              '',
                                          isEnd: selectedDataFromChangedLocDrp
                                                      ?.upazilaName !=
                                                  null
                                              ? selectedDataFromChangedLocDrp!
                                                      .upazilaName!.isEmpty
                                                  ? true
                                                  : false
                                              : true),
                                      breadcrumTile(
                                          selectedDataFromChangedLocDrp
                                                  ?.upazilaName ??
                                              '',
                                          isEnd: selectedDataFromChangedLocDrp
                                                      ?.unionName !=
                                                  null
                                              ? selectedDataFromChangedLocDrp!
                                                      .unionName!.isEmpty
                                                  ? true
                                                  : false
                                              : true),
                                      breadcrumTile(
                                          selectedDataFromChangedLocDrp
                                                  ?.unionName ??
                                              '',
                                          isEnd: true),
                                    ],
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.0),
                            child: Divider(),
                          ),
                          SizedBox(
                            height: 50.0.h,
                            child: TextField(
                              readOnly: true,
                              controller: TextEditingController(
                                  text: DateConverter.localDateToIsoString(
                                      DateTime.now())),
                              decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.black),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: Colors.black),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  hintText: "Visit Date",
                                  suffixIcon: Icon(Icons.calendar_today),
                                  label: Text('Visit Date')),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  print('online add new office clicked');
                                  print('online add new office clicked');
                                  setState(() {
                                    // upazilaId = '';
                                    // unionID = '';
                                    // districtId = '';
                                    // divisionId = '';
                                    diagDivisionId = null;
                                    selectedOffice = '';
                                    diagUpazilaID = null;
                                    diagdistrictId = null;
                                    diagUpazilaID = null;
                                    chngeLocDivValue = null;
                                    chngLocDistrictVal = null;
                                    chngLocUpazilaVal = null;
                                    chngLocOfficeTypeVal = null;
                                    // selectedDataFromChangedLocDrp = null;
                                    chngLocUnionVal = null;
                                    dialogDivision.clear();
                                    dialogDistrict.clear();
                                    dialogUpazila.clear();
                                    dialogUnion.clear();
                                    dialogOfficeTypeData.clear();
                                    changeLocationBloc
                                        .add(ChangeLocationInitialEvent());
                                  });
                                  showCustomDialog(isLocNotMatched: true);
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  alignment: Alignment.center,
                                  width: 120.w,
                                  height: 35.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: MyColors.secondaryColor),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 3.0.w, right: 3.0.w),
                                    child: Text(
                                      "Add New Office",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Divider(),
                          SizedBox(height: 15),
                          const Text("Capture Image"),
                          const SizedBox(height: 6),
                          imageSelectWidget(context),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              backgroundColor: MyColors.secondaryColor,
                            ),
                            onPressed: isFieldSubmitLoading
                                ? null
                                : () {
                                    log('loc add submit ${jsonEncode(selectedDataFromChangedLocDrp)}');
                                    // log('union select from submit $unionID');
                                    if (selectedDataFromChangedLocDrp == null) {
                                      AllService().showToast(
                                          'Please Insert all data',
                                          isError: true);
                                    } else {
                                      if (img1Path != null ||
                                          img2Path != null ||
                                          img3Path != null) {
                                        submitFieldVisit(
                                            dialogclose: 1, officeTitle: '');
                                      } else {
                                        AllService().showToast(
                                            'Please Upload at least 1 Image (up to 3) ',
                                            isError: true);
                                      }
                                    }
                                  },
                            child: isFieldSubmitLoading
                                ? Center(child: AllService.LoadingToast())
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Submit',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                          ),
                        ]
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Wrap imageSelectWidget(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      runAlignment: WrapAlignment.start,
      children: [
        singleImage(
          img: img1,
          function: () async {
            CameraDataModel? camModel = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CameraScreen(),
                ));
            if (camModel != null || camModel is CameraDataModel) {
              final img = camModel.xpictureFile;
              if (img != null) {
                final compressedFile1 = await imageProcessing(imgFile: img!);
                final byte = compressedFile1!.readAsBytesSync();
                setState(() {
                  img1 = byte;
                  img1Path = compressedFile1.path;
                });
                log('image 1 path $img1Path');
              } else {
                return;
              }
            }
          },
          imgStep: '1',
        ),
        singleImage(
          img: img2,
          function: () async {
            CameraDataModel? camModel = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CameraScreen(),
                ));
            if (camModel != null || camModel is CameraDataModel) {
              final img = camModel.xpictureFile;
              if (img != null) {
                final compressedFile1 = await imageProcessing(imgFile: img);
                final byte = compressedFile1!.readAsBytesSync();
                setState(() {
                  img2 = byte;
                  img2Path = compressedFile1.path;
                });
                log('image 2 path $img2Path');
              } else {
                return;
              }
            }
          },
          imgStep: '2',
        ),
        singleImage(
          img: img3,
          function: () async {
            CameraDataModel? camModel = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CameraScreen(),
                ));
            if (camModel != null || camModel is CameraDataModel) {
              final img = camModel.xpictureFile;
              if (img != null) {
                final compressedFile1 = await imageProcessing(imgFile: img!);
                final byte = compressedFile1!.readAsBytesSync();
                setState(() {
                  img3 = byte;
                  img3Path = compressedFile1.path;
                });
                //log('image 2 path $img2Path');
              } else {
                return;
              }
            }
          },
          imgStep: '3',
        ),
      ],
    );
  }

  chngLocAreaTileWidget() {
    Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8),
        child: TextField(
          controller: TextEditingController(text: ''),
          readOnly: true,
          decoration: const InputDecoration(
            labelText: 'Division',
            contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 7),
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  Padding brDividerWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8),
      child: Icon(
        Icons.arrow_forward,
        size: 16,
        // style: TextStyle(
        //   fontSize: 18,
        //   color: Colors.grey,
        // ),
      ),
    );
  }

  breadcrumTile(String name, {bool isEnd = false}) {
    return name.isEmpty
        ? SizedBox.shrink()
        : Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            alignment: WrapAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
                //decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(5)),
                child: Text(
                  '${name}',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
              name.isEmpty
                  ? SizedBox.shrink()
                  : isEnd
                      ? SizedBox.shrink()
                      : brDividerWidget(),
            ],
          );
  }

  _officeDropdown(List<UpdNewLocationData> locationData) {
    return DropdownButtonFormField<UpdNewLocationData>(
      isExpanded: true,
      //value: null,
      value: locationData.isNotEmpty ? updNewLocationDrpModel : null,
      onChanged: (newValue) {
        setState(() {
          updNewLocationDrpModel = newValue;
        });

        log('sel office ${jsonEncode(updNewLocationDrpModel)}');

        // filteredAreaList.clear();
        // selOfficeVal = newValue;

        // filteredAreaList = areaList.where((element) => element.id == selOfficeVal!.id).toList();

        // districtId = '';
        // divisionId = '';
        // upazilaId = '';
        // unionID = '';
        // // officeTitle = null;
        // // officeTitle = newValue!.name;
        // locationID = null;
        // selectedOfficeId = null;
        // selectedOfficeId = newValue!.id.toString();
        // locationBloc.add(LocationFilterEvent(id: newValue!.id));

        setState(() {});
      },
      items: locationData.map<DropdownMenuItem<UpdNewLocationData>>((item) {
        return DropdownMenuItem<UpdNewLocationData>(
          onTap: () {},
          value: item,
          child: Text("${item.officeTypeName}"),
        );
      }).toList(),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        labelText: 'Select Office Type',
      ),
      validator: (value) {
        if (value == null) {
          return 'Please Select Office Type';
        }
        return null;
      },
    );
  }

  singleImage(
      {Uint8List? img,
      required VoidCallback function,
      required String imgStep}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
      child: SizedBox(
        height: 90,
        width: 100,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: Stack(
            clipBehavior: Clip.none,
            fit: StackFit.expand,
            children: [
              img != null
                  ? Container(
                      decoration: BoxDecoration(
                          color: Color(0xff989eb1).withOpacity(0.4),
                          borderRadius: BorderRadius.circular(3)),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShowSingleImage(
                                img: img,
                                isImgUrl: false,
                              ),
                            ),
                          );
                        },
                        child: Image(
                          image: MemoryImage(img),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: function,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add_a_photo,
                            color: Color(0xFF3F51B5),
                            size: 40,
                          ),
                        ),
                      ),
                    ),
              img != null
                  ? Positioned(
                      right: 5,
                      top: 5,
                      child: GestureDetector(
                          onTap: () {
                            if (imgStep == '1') {
                              setState(() {
                                img1 = null;
                                img1Path = null;
                              });
                            } else if (imgStep == '2') {
                              setState(() {
                                img2 = null;
                                img2Path = null;
                              });
                            } else if (imgStep == '3') {
                              setState(() {
                                img3 = null;
                                img3Path = null;
                              });
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(2)),
                            child: Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.white,
                            ),
                          )))
                  : SizedBox.shrink(),
              img != null
                  ? Positioned(
                      left: 5,
                      top: 5,
                      child: GestureDetector(
                          onTap: function,
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(2)),
                            child: Icon(
                              Icons.add,
                              size: 18,
                              color: Colors.white,
                            ),
                          )))
                  : SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }

  Container _mapViewWidget() {
    return Container(
      height: 150,
      child: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          if (!mapControllerCompleter.isCompleted) {
            mapControllerCompleter.complete(controller);
          }
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(
            targetLatitude,
            targetLongitude,
          ),
          zoom: 14.0,
        ),
        zoomControlsEnabled: false,
        markers: {
          Marker(
            markerId: MarkerId("MyLocation"),
            position: LatLng(
              targetLatitude,
              targetLongitude,
            ),
            infoWindow: InfoWindow(title: "My Location"),
          ),
        },
      ),
    );
  }

  void updateMap() async {
    if (mapControllerCompleter.isCompleted) {
      mapControllerCompleter.future.then((controller) {
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                targetLatitude,
                targetLongitude,
              ),
              zoom: 14.0,
            ),
          ),
        );
      });

      //String token = await Helper().getUserToken();
      //print(token);
      locationBloc.add(NewLocationInitialEvent(locationModel: {
        "latitude": targetLatitude.toString(),
        "longitude": targetLongitude.toString()
      }));
      // locationBloc.add(LocationInitialEvent(locationModel: {"latitude": targetLatitude.toString(), "longitude": targetLongitude.toString()}));
    } else {
      print('Map controller is not completed');
    }
  }

  submitFieldVisit({required int dialogclose, String officeTitle = ''}) async {
    final connectivityResult =
        await ConnectivityProvider().rcheckInternetConnection();
    if (connectivityResult) {
      if (_formKeyVisitReport.currentState!.validate()) {
        if (targetLatitude == 0.0 && targetLongitude == 0.0) {
          return AllService()
              .showToast("Select Current Location", isError: true);
        }

        //  else if (visitPurposeController.text.isEmpty) {
        //   return AllService().tost("Visit Purpose Input Required");
        // }

        // else if (galleryImages!.length == 0) {
        //   return AllService().tost("Please Upload Image");
        // }
        setState(() {
          isFieldSubmitLoading = true;
        });
        List<String> imgPath = [];
        if (img1Path != null) {
          imgPath.add(img1Path!);
        }
        if (img2Path != null) {
          imgPath.add(img2Path!);
        }
        if (img3Path != null) {
          imgPath.add(img3Path!);
        }

        if (dialogCloseValue == 0) {
          // dialog is closed that means location is matched if dialogclose value is one that means user selected ADD NEW OFFICE Button
          //if location is matched then user will upload it to the db.
          //   List<String> fieldVisitData = [];
          //   Map fvMap = {
          //     "division_id": updNewLocationDrpModel!.divisionId!.toString(),
          //     "district_id": updNewLocationDrpModel!.districtId!.toString(),
          //     "union_id": updNewLocationDrpModel?.unionId == null ? '' : updNewLocationDrpModel!.unionId.toString(),
          //     "upazila_id": updNewLocationDrpModel?.upazilaId == null ? '' : updNewLocationDrpModel!.upazilaId.toString(),
          //     "latitude": targetLatitude.toString(),
          //     "longitude": targetLongitude.toString(),
          //     "lacation_match": '1',
          //     "office_type_id": updNewLocationDrpModel!.officeTypeId!.toString(),
          //     "office_title": updNewLocationDrpModel?.officeTitle != null ? updNewLocationDrpModel!.officeTitle.toString() : '',
          //     "sync": '1',
          //     "location_id": updNewLocationDrpModel!.locationId,
          //     "img1": img1Path,
          //     "img2": img2Path,
          //     "img3": img3Path,
          //   };
          //   final fvJson = jsonEncode(fvMap);
          //   final localFieldVisitData = prefs.getStringList(fieldVisitSubmitKey);
          //   if (localFieldVisitData == null) {
          //     fieldVisitData.add(fvJson);
          //     prefs.setStringList(fieldVisitSubmitKey, fieldVisitData); //'fieldVisitSubmitList'
          //     prefs.reload();
          //   } else {
          //     fieldVisitData = localFieldVisitData;
          //     localFieldVisitData.add(fvJson);
          //     prefs.setStringList(fieldVisitSubmitKey, fieldVisitData);
          //     prefs.reload();
          //   }
          // fieldVisitSubmitTask();
          //    setState(() {
          //       isFieldSubmitLoading = false;
          //       updNewLocationDrpModel = null;
          //       img1Path = null;
          //       img2Path = null;
          //       img3Path = null;
          //     });
          //THis is a simple alert dialog to show it to the user that visit Report is added successfully

          // await QuickAlert.show(
          //   context: context,
          //   type: QuickAlertType.success,
          //   text: "Visit Report Added successfully",
          // );
          final response = await Repositores().uploadDataAndImage(
            division_id: updNewLocationDrpModel!.divisionId!.toString(),
            district_id: updNewLocationDrpModel!.districtId!.toString(),
            upazila_id: updNewLocationDrpModel?.upazilaId == null
                ? ''
                : updNewLocationDrpModel!.upazilaId.toString(),
            union_id: updNewLocationDrpModel?.unionId != null
                ? updNewLocationDrpModel!.unionId.toString()
                : '', //selectedUnion != unionID ? selectedUnion.toString() : unionID.toString(),//unionID.toString(),
            latitude: targetLatitude.toString(),
            longitude: targetLongitude.toString(),
            //isit_purpose: visitPurposeController.text,
            office_type: updNewLocationDrpModel!.officeTypeId!.toString(),
            office_title: updNewLocationDrpModel?.officeTitle != null
                ? updNewLocationDrpModel!.officeTitle.toString()
                : '',
            location_match: '1', //locationMatched.toString(),
            locationID: updNewLocationDrpModel!.locationId.toString(),
            changeLocationID: null,
            imageFile: null,
            imagesPath: imgPath,
            visitDate: DateConverter.formatYMD(DateTime.now()),

            //imageFile: galleryImages ?? [],
          );
          // //then((value) async {
          if (response == "success") {
            setState(() {
              isFieldSubmitLoading = false;
              updNewLocationDrpModel = null;
              img1Path = null;
              img2Path = null;
              img3Path = null;
            });
            //THis is a simple alert dialog to show it to the user that visit Report is added successfully

            await QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: "Visit Report Added successfully",
            );

            Navigator.pop(context);
          } else {
            await QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              text: "Visit Report Add Failed",
            );
            setState(() {
              isFieldSubmitLoading = false;
            });
          }
          // });
        } else {
          //If dialogCloseValue is 1 that means user selected new office from dialog and then location match value is '1'

          await Repositores()
              .uploadDataAndImage(
            division_id: selectedDataFromChangedLocDrp!.divisionId
                .toString(), //== null ? '' : diagDivisionId.toString(),
            district_id: selectedDataFromChangedLocDrp!.districtId != -1
                ? selectedDataFromChangedLocDrp!.districtId.toString()
                : '',
            upazila_id: selectedDataFromChangedLocDrp!.upazilaId != -1
                ? selectedDataFromChangedLocDrp!.upazilaId.toString()
                : '',
            union_id: selectedDataFromChangedLocDrp!.unionId != -1
                ? selectedDataFromChangedLocDrp!.unionId.toString()
                : '',
            latitude: targetLatitude.toString(),
            longitude: targetLongitude.toString(),
            //isit_purpose: visitPurposeController.text,
            office_type:
                selectedDataFromChangedLocDrp!.officeTypeId!.toString(),
            office_title: selectedDataFromChangedLocDrp?.officeTitle != null
                ? selectedDataFromChangedLocDrp!.officeTitle!
                : '',
            changeLocationID: changeLocationID,
            location_match: '0', //locationMatched.toString(),
            imagesPath: imgPath ?? [],
            visitDate: DateConverter.formatYMD(DateTime.now()),
          )
              .then((value) async {
            if (value == "success") {
              setState(() {
                diagDivisionId = '';
                diagUpazilaID = '';
                diagUnionID = '';
                diagdistrictId = '';
                selectedDataFromChangedLocDrp = null;
                diagOfficeTypeID = null;
                img1Path = null;
                img2Path = null;
                img3Path = null;
              });
              await QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                text: "Visit Report Added successfully",
              );
              Navigator.pop(context);
              // await Navigator.of(context).pushReplacement(
              //   MaterialPageRoute(
              //     builder: (context) {
              //       return FieldFindingCreatePage(
              //         id: dataResponse['data']['id'].toString(),
              //       );
              //     },
              //   ),
              // );
              setState(() {
                isFieldSubmitLoading = false;
              });
            } else {
              await QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                text: "Visit Report Add Failed",
              );
              setState(() {
                isFieldSubmitLoading = false;
              });
            }
          });
        }
      }
    } else {
      if (dialogclose == 0) {
        if (_formKeyVisitReport.currentState!.validate()) {
          List<String> imgPath = [];
          if (img1Path != null) {
            imgPath.add(img1Path!);
          }
          if (img2Path != null) {
            imgPath.add(img2Path!);
          }
          if (img3Path != null) {
            imgPath.add(img3Path!);
          }
          List<String> fieldVisitData = [];
          Map fvMap = {
            "division_id": updNewLocationDrpModel!.divisionId!.toString(),
            "district_id": updNewLocationDrpModel!.districtId!.toString(),
            "union_id": updNewLocationDrpModel?.unionId == null
                ? ''
                : updNewLocationDrpModel!.unionId.toString(),
            "upazila_id": updNewLocationDrpModel?.upazilaId == null
                ? ''
                : updNewLocationDrpModel!.upazilaId.toString(),
            "latitude": targetLatitude.toString(),
            "longitude": targetLongitude.toString(),
            "datetime": DateConverter.formatDate(DateTime.now()),
            "office_type": updNewLocationDrpModel?.officeTypeName.toString(),
            "lacation_match": '1',
            "office_type_id": updNewLocationDrpModel!.officeTypeId!.toString(),
            "office_title": updNewLocationDrpModel?.officeTitle != null
                ? updNewLocationDrpModel!.officeTitle.toString()
                : '',
            "sync": '0',
            "location_id": updNewLocationDrpModel!.locationId.toString(),
            "img1": img1Path,
            "img2": img2Path,
            "img3": img3Path,
            "visit_date": DateConverter.formatYMD(DateTime.now()),
          };
          final fvJson = jsonEncode(fvMap);
          //prefs.reload();
          final localFieldVisitData =
              await prefs.getStringList(fieldVisitSubmitKey);
          if (localFieldVisitData == null) {
            fieldVisitData.add(fvJson);
            await prefs.setStringList(
                fieldVisitSubmitKey, fieldVisitData); //'fieldVisitSubmitList'
          } else {
            fieldVisitData = localFieldVisitData;
            localFieldVisitData.add(fvJson);
            await prefs.setStringList(fieldVisitSubmitKey, fieldVisitData);
          }
          var getlDa = await getlocalData();
          localFieldVisitDataListNotifier.value = getlDa;

          log("ashfkjdf ${localFieldVisitData}");

          // final localFieldData = FieldSubmitLocal(
          //   districtID: updNewLocationDrpModel!.districtId!.toString(),
          //   divisionID: updNewLocationDrpModel!.divisionId!.toString(),
          //   unionID: updNewLocationDrpModel?.unionId == null ? '' : updNewLocationDrpModel!.unionId.toString(),
          //   upazillaID: updNewLocationDrpModel?.upazilaId == null ? '' : updNewLocationDrpModel!.upazilaId.toString(),
          //   latitude: targetLatitude.toString(),
          //   longitude: targetLongitude.toString(),
          //   officeTitle: updNewLocationDrpModel?.officeTitle != null ? updNewLocationDrpModel!.officeTitle.toString() : '',
          //   officeTypeID: updNewLocationDrpModel!.officeTypeId!.toString(),
          //   locationID: updNewLocationDrpModel!.locationId,
          //   locationMatch: '1',
          //   syncStatus: 'offline',
          //   locimg1: img1Path,
          //   locimg2: img2Path,
          //   locimg3: img3Path,
          // );

          //}

          // LocalStore().storeFieldSubmitData(localFieldData);
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: "Visit Report Added Locally",
          );
          Navigator.pop(context);
        } else {}
      } else {
        // prefs.reload();
        List<String> imgPath = [];
        if (img1Path != null) {
          imgPath.add(img1Path!);
        }
        if (img2Path != null) {
          imgPath.add(img2Path!);
        }
        if (img3Path != null) {
          imgPath.add(img3Path!);
        }
        List<Map<String, dynamic>> newAddChngLocData = [];
        // prefs.reload();
        final addChangeLocData = await prefs.getStringList(addNewLocSubmitKey);
        if (addChangeLocData != null) {
          addChangeLocData.forEach((element) {
            newAddChngLocData.add(jsonDecode(element));
          });
          log('local storage field Data ${jsonEncode(newAddChngLocData)}');

          final localIndex = newAddChngLocData.indexWhere((e) =>
              e['district_id'].toString() ==
                  selectedDataFromChangedLocDrp!.districtId.toString() &&
              e['division_id'].toString() ==
                  selectedDataFromChangedLocDrp?.divisionId?.toString() &&
              e['upazila_id'].toString() ==
                  (selectedDataFromChangedLocDrp!.upazilaId == null
                      ? ''
                      : selectedDataFromChangedLocDrp!.upazilaId.toString()) &&
              e['union_id'].toString() ==
                  (selectedDataFromChangedLocDrp?.unionId == null
                      ? ''
                      : selectedDataFromChangedLocDrp!.unionId.toString()) &&
              e['office_type_id'].toString() ==
                  selectedDataFromChangedLocDrp!.officeTypeId!.toString() &&
              e['office_title'].toString() == officeTitleCtrl.text.toString());

          log('local storage local Index $localIndex');
          if (localIndex != -1) {
            newAddChngLocData[localIndex]['img1'] = img1Path;
            newAddChngLocData[localIndex]['img2'] = img2Path;
            newAddChngLocData[localIndex]['img3'] = img3Path;
          }
          log('local final storage field Data ${jsonEncode(newAddChngLocData)}');

          List<String> processedData = [];
          // if (cart == null) cart = [];
          newAddChngLocData.forEach((element) {
            processedData.add(jsonEncode(element));
          });
          await prefs.setStringList(addNewLocSubmitKey, processedData);
          //prefs.reload();
        } else {
          // List<String> fieldVisitData = [];
          // Map fvMap = {
          //   "division_id": selectedDataFromChangedLocDrp!.divisionId.toString(),
          //   "district_id": selectedDataFromChangedLocDrp!.districtId.toString(),
          //   "union_id": selectedDataFromChangedLocDrp?.unionId == null ? '' : selectedDataFromChangedLocDrp!.unionId.toString(),
          //   "upazila_id": selectedDataFromChangedLocDrp?.upazilaId == null ? '' : selectedDataFromChangedLocDrp!.upazilaId.toString(),
          //   "latitude": targetLatitude.toString(),
          //   "longitude": targetLongitude.toString(),
          //   "lacation_match": '0',
          //   "office_type_id": selectedDataFromChangedLocDrp!.officeTypeId!.toString(),
          //   "office_title": selectedDataFromChangedLocDrp?.officeTitle != null ? updNewLocationDrpModel!.officeTitle.toString() : '',
          //   "sync": '0',
          //   "location_id": '',
          //   "img1": img1Path,
          //   "img2": img2Path,
          //   "img3": img3Path,
          // };
        }

        // LocalStore localStore = LocalStore();
        // final localIndex = localStore.addChangeLocationBox.values.toList().indexWhere((e) =>
        //     e.districtID.toString() == selectedDataFromChangedLocDrp!.districtId.toString() &&
        //     e.divisionID.toString() == selectedDataFromChangedLocDrp?.divisionId?.toString() &&
        //     e.upazillaID.toString() == selectedDataFromChangedLocDrp!.upazilaId.toString() &&
        //     e.unionID.toString() == selectedDataFromChangedLocDrp!.unionId.toString() &&
        //     e.officeTypeID.toString() == selectedDataFromChangedLocDrp!.officeTypeId!.toString());
        // final locData = localStore.addChangeLocationBox.getAt(localIndex);
        // locData!.clocimg1 = img1Path;
        // locData!.clocimg2 = img2Path;
        // locData!.clocimg3 = img3Path;

        // final fvJson = jsonEncode(fvMap);
        // final localFieldVisitData = prefs.getStringList(fieldVisitSubmitKey);
        // if (localFieldVisitData == null) {
        //   fieldVisitData.add(fvJson);
        //   prefs.setStringList(fieldVisitSubmitKey, fieldVisitData); //'fieldVisitSubmitList'
        // } else {
        //   fieldVisitData = localFieldVisitData;
        //   localFieldVisitData.add(fvJson);
        //   prefs.setStringList(fieldVisitSubmitKey, fieldVisitData);
        // }

        // final localFieldData = FieldSubmitLocal(
        //   districtID: selectedDataFromChangedLocDrp!.divisionId.toString(),
        //   divisionID: selectedDataFromChangedLocDrp!.divisionId!.toString(),
        //   unionID: selectedDataFromChangedLocDrp?.unionId == null ? '' : selectedDataFromChangedLocDrp!.unionId.toString(),
        //   upazillaID: selectedDataFromChangedLocDrp?.upazilaId == null ? '' : selectedDataFromChangedLocDrp!.upazilaId.toString(),
        //   latitude: targetLatitude.toString(),
        //   longitude: targetLongitude.toString(),
        //   officeTitle: selectedDataFromChangedLocDrp?.officeTitle != null ? updNewLocationDrpModel!.officeTitle.toString() : '',
        //   officeTypeID: selectedDataFromChangedLocDrp!.officeTypeId!.toString(),
        //   locationID:null,
        //   locationMatch: '0',
        //   syncStatus: 'offline',
        //   locimg1: img1Path,
        //   locimg2: img2Path,
        //   locimg3: img3Path,

        // );
        //}

        // LocalStore().storeFieldSubmitData(localFieldData);
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "Visit Report Added Locally",
        );
        Navigator.pop(context);
      }

      // AllService().internetCheckDialog(context);
    }
  }

  File createFile(String path) {
    final file = File(path);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    return file;
  }

  Future<File?> imageProcessing({required XFile imgFile}) async {
    // final appDir = await getApplicationDocumentsDirectory();
    // var uniqueFileName = DateTime.now().toString();
    // var filename = '${appDir.absolute.path}/undpgems/$uniqueFileName.jpg';
    // final File emptyfile = createFile('${appDir.absolute.path}/undpgems.jpg');

    // final file2 = File(imgFile.path);
    // var nf = await file2.copy(appDir.absolute.path);

    // var targetPath ='${appDir.absolute.path}' + '/$uniqueFileName.jpg';
    final appDir = await getApplicationDocumentsDirectory();

    // Create a unique filename using the current time
    var uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    var targetPath = '${appDir.absolute.path}/undpgems/$uniqueFileName.jpg';

    // Create the directory if it does not exist
    final directory = Directory('${appDir.absolute.path}/undpgems');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }

    // Convert the XFile to a File object
    final file = File(imgFile.path);

    // Compress the image using the compressImgAndGetFile function
    // final compressedFile = await compressImgAndGetFile(file, targetPath);

    // final lastIndex = file2.absolute.path.lastIndexOf(new RegExp(r'.jp'));
    // final splitted = file2.absolute.path.substring(0, (lastIndex));
    // final outPath2 = "${splitted}_out${file2.absolute.path.substring(lastIndex)}";
    final compressedFile2 =
        await Utils().compressImgAndGetFile(file, targetPath);
    return compressedFile2;
  }

  showCustomDialog({bool isLocNotMatched = false}) {
    officeTitleCtrl.clear();
    remarkController.clear();

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Form(
                  key: _chngLocformKeyVisitReport,
                  child: Wrap(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isLocationMatched)
                              Row(
                                children: [
                                  Icon(
                                    Icons.info,
                                    size: 18,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Office Not found",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 12),
                                  ),
                                ],
                              ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: isLocationMatched ? 20 : 0),
                              child: const Text(
                                "Add New Office",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),

                            ///Office Dropdown

                            SizedBox(height: 10),

                            BlocConsumer<ChangeLocationBloc,
                                    ChangeLocationState>(
                                bloc: changeLocationBloc,
                                //listenWhen: (previous, current) => current is ChangeLocationSuccessState,
                                //buildWhen: (previous, current) => current is ChangeLocationSuccessState,
                                listener: (context, state) {
                                  // TODO: implement listener
                                },
                                builder: (context, state) {
                                  if (state is ChangeLocationLoadingState) {
                                    return Container(
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    );
                                  } else if (state
                                      is ChangeLocationSuccessState) {
                                    dialogUnion = state.union;
                                    dialogUpazila = state.upazila;
                                    dialogDistrict = state.district;
                                    dialogDivision = state.division;
                                    dialogOfficeTypeData = state.officeTypeList;

                                    return Column(
                                      children: [
                                        DropdownButtonFormField<OfficeTypeData>(
                                          isExpanded: true,
                                          decoration: const InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black),
                                              ),
                                              labelText: 'Select Office Type',
                                              hintText: "Select Office Type"),
                                          value: chngLocOfficeTypeVal,
                                          items: state.officeTypeList.map<
                                              DropdownMenuItem<
                                                  OfficeTypeData>>((item) {
                                            return DropdownMenuItem<
                                                OfficeTypeData>(
                                              value: item,
                                              onTap: () {
                                                log('selected office ID ${item.id}');
                                              },
                                              child: Text("${item.name}"),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              chngLocOfficeTypeVal = newValue;
                                              selectedOffice =
                                                  newValue!.name.toString();
                                              diagOfficeTypeID =
                                                  newValue.id!.toString();
                                            });
                                            log('Selected Office from dialog $selectedOffice');
                                          },
                                          validator: (value) {
                                            if (value == null) {
                                              return 'Please select office';
                                            }
                                            return null;
                                          },
                                        ),

                                        /// Office Title
                                        Visibility(
                                          visible:
                                              selectedOffice == "Other Office",
                                          child: Column(
                                            children: [
                                              SizedBox(height: 10),
                                              TextFormField(
                                                controller: officeTitleCtrl,
                                                maxLines: 1,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: "Office title",
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 10),
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Please enter office title';
                                                  } else {
                                                    if (state.otherOfficeList
                                                        .any((e) =>
                                                            e['office_title'] ==
                                                            value.trim())) {
                                                      return 'Office Title Already Exist';
                                                    }
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10),

                                        ///Division Dropdown
                                        Visibility(
                                          visible: chngLocOfficeTypeVal != null,
                                          child:
                                              DropdownButtonFormField<Division>(
                                            isExpanded: true,
                                            validator: (value) {
                                              if (value == null) {
                                                return 'Division is required';
                                              }
                                              return null;
                                            },
                                            decoration: const InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black),
                                              ),
                                              labelText: 'Select Division',
                                            ),
                                            value: chngeLocDivValue,
                                            //value: state.division.isEmpty ? null : state.division[0],
                                            onTap: () {
                                              // setState(() {
                                              //   state.district.clear();
                                              //   state.upazila.clear();
                                              //   state.union.clear();
                                              // });
                                            },
                                            items: state.division.map<
                                                DropdownMenuItem<Division>>(
                                              (entry) {
                                                return DropdownMenuItem<
                                                    Division>(
                                                  value: entry,
                                                  child: Text(
                                                      entry.divisionName ?? ""),
                                                );
                                              },
                                            ).toList(),
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            onChanged: (newValue) {
                                              // state.district.clear();
                                              // state.upazila.clear();
                                              // state.union.clear();

                                              setState(() {
                                                chngLocDistrictVal = null;
                                                chngLocUpazilaVal = null;
                                                chngLocUnionVal = null;
                                                chngeLocDivValue = newValue;

                                                diagDivisionId = newValue
                                                    ?.divisionId
                                                    .toString();
                                                changeLocationBloc.add(
                                                    DistrictClickEvent(
                                                        id: newValue?.id));
                                              });
                                              // for (Division entry in state.division) {
                                              //   if (selectedDivision == entry.nameEn) {
                                              //     //divisionId = entry.divisionId.toString();
                                              //     divisionId = entry.id.toString();
                                              //     diagDivisionId = entry.id.toString();
                                              //     changeLocationBloc.add(DistrictClickEvent(id: entry.id));
                                              //   }
                                              // }
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 10),

                                        ///District Dropdown
                                        Visibility(
                                          visible: selectedOffice ==
                                                  'UNO Office' ||
                                              selectedOffice ==
                                                  'DC/DDLG Office' ||
                                              selectedOffice == 'UP Office' ||
                                              selectedOffice == 'Other Office',
                                          child: Column(
                                            children: [
                                              DropdownButtonFormField<District>(
                                                isExpanded: true,
                                                value: chngLocDistrictVal,
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                //value: state.district.isEmpty ? null : state.district[0], // selectedDistrict,
                                                validator:
                                                    (selectedOffice ==
                                                                'UNO Office' ||
                                                            selectedOffice ==
                                                                'DC/DDLG Office' ||
                                                            selectedOffice ==
                                                                'UP Office' ||
                                                            selectedOffice ==
                                                                'Other Office')
                                                        ? (value) {
                                                            if (value == null) {
                                                              return 'District is required';
                                                            }
                                                            return null;
                                                          }
                                                        : null,
                                                onChanged:
                                                    state.district.isEmpty
                                                        ? null
                                                        : (entry) {
                                                            // state.upazila.clear();
                                                            // state.union.clear();
                                                            setState(() {
                                                              chngLocUpazilaVal =
                                                                  null;
                                                              chngLocUnionVal =
                                                                  null;
                                                              chngLocDistrictVal =
                                                                  entry;

                                                              // for (District entry in state.district) {
                                                              // if (selectedDistrict == entry.nameEn) {

                                                              diagdistrictId = entry
                                                                  ?.districtId
                                                                  .toString();
                                                            });
                                                            changeLocationBloc.add(
                                                                UpazilaClickEvent(
                                                                    id: entry
                                                                        ?.districtId));
                                                            // }
                                                            //  }
                                                          },
                                                items: state.district.map<
                                                    DropdownMenuItem<District>>(
                                                  (entry) {
                                                    return DropdownMenuItem<
                                                        District>(
                                                      value: entry,
                                                      child: Text(
                                                          entry.districtName ??
                                                              ""),
                                                    );
                                                  },
                                                ).toList(),

                                                decoration:
                                                    const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 10),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black),
                                                  ),
                                                  labelText: 'Select District',
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                            ],
                                          ),
                                        ),

                                        ///Upazilla Dropdown
                                        Visibility(
                                          visible:
                                              selectedOffice == 'UNO Office' ||
                                                  selectedOffice ==
                                                      'Other Office' ||
                                                  selectedOffice == 'UP Office',
                                          child: Column(
                                            children: [
                                              DropdownButtonFormField<Upazila>(
                                                isExpanded: true,
                                                value: chngLocUpazilaVal,
                                                //  value: state.upazila.isEmpty ? null : state.upazila[0], //selectedUpazila,
                                                validator: (selectedOffice ==
                                                            'UNO Office' ||
                                                        selectedOffice ==
                                                            'UP Office')
                                                    ? (value) {
                                                        if (value == null) {
                                                          return 'Upazilla is required';
                                                        }
                                                        return null;
                                                      }
                                                    : null,
                                                onChanged: state.upazila.isEmpty
                                                    ? null
                                                    : (newValue) {
                                                        setState(() {
                                                          // chngLocDistrictVal = null;
                                                          // chngLocUpazilaVal = null;
                                                          chngLocUnionVal =
                                                              null;
                                                          chngLocUpazilaVal =
                                                              newValue;

                                                          diagUpazilaID =
                                                              newValue!
                                                                  .upazilaId
                                                                  .toString();

                                                          // for (Upazila entry in state.upazila) {
                                                          //   if (selectedUpazila == entry.nameEn) {
                                                          //     upazilaId = entry.id.toString();
                                                          //     diagUpazilaID = entry.id.toString();
                                                          //     changeLocationBloc.add(UnionClickEvent(id: entry.id));
                                                          //   }
                                                          // }
                                                        });
                                                        changeLocationBloc.add(
                                                            UnionClickEvent(
                                                                id: newValue!
                                                                    .upazilaId));
                                                      },
                                                items: state.upazila.map<
                                                    DropdownMenuItem<
                                                        Upazila>>((item) {
                                                  return DropdownMenuItem<
                                                      Upazila>(
                                                    value: item,
                                                    child: Text(
                                                        item.upazilaName ?? ""),
                                                  );
                                                }).toList(),
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                decoration:
                                                    const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 10),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black),
                                                  ),
                                                  labelText: 'Select Upazila',
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                            ],
                                          ),
                                        ),

                                        ///Union Dropdown
                                        Visibility(
                                          visible: selectedOffice ==
                                                  'UP Office' ||
                                              selectedOffice == 'Other Office',
                                          child: Column(
                                            children: [
                                              DropdownButtonFormField<Union>(
                                                isExpanded: true,
                                                value: chngLocUnionVal,

                                                // value: state.union.isEmpty ? null : state.union[0], //selectedUnion,
                                                validator: (selectedOffice ==
                                                        'UP Office')
                                                    ? (value) {
                                                        if (value == null) {
                                                          return 'Union is required';
                                                        }
                                                        return null;
                                                      }
                                                    : null,
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                onChanged: state.union.isEmpty
                                                    ? null
                                                    : (newValue) {
                                                        setState(() {
                                                          chngLocUnionVal =
                                                              newValue;

                                                          diagUnionID = newValue
                                                              ?.unionId
                                                              .toString();
                                                          // for (Union entry in state.union) {
                                                          //   if (selectedUnion == entry.nameEn) {
                                                          //     unionID = entry.id.toString();
                                                          //     diagUnionID = entry.id.toString();
                                                          //   }
                                                          // }
                                                        });
                                                      },
                                                items: state.union.map<
                                                    DropdownMenuItem<
                                                        Union>>((item) {
                                                  return DropdownMenuItem<
                                                      Union>(
                                                    value: item,
                                                    child: Text(
                                                        item.unionName ?? ""),
                                                  );
                                                }).toList(),
                                                decoration:
                                                    const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 10),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.black),
                                                  ),
                                                  labelText: 'Select Union',
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  return Container();
                                }),

                            Visibility(
                              visible: chngLocOfficeTypeVal != null,
                              child: TextFormField(
                                controller: remarkController,
                                maxLines: 1,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Remark",
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                ),
                                // validator: null,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter remark';
                                  }
                                  return null;
                                },
                              ),
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            /// Button Section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // TextButton(
                                //     onPressed: () {
                                //       log('chnage location dialog diagDivisionID ${diagDivisionId.toString()}');
                                //       log('chnage location dialog diagDistrictID ${diagdistrictId.toString()}');
                                //       log('chnage location dialog diagUpazilaID ${diagUpazilaID.toString()}');
                                //       log('chnage location dialog diagunionID ${diagUnionID.toString()}');
                                //       log('chnage location dialog selectOfficeID ${diagOfficeTypeID.toString()}');
                                //       log('chnage location dialog officeTitle  ${officeTitleCtrl.text.toString()}');
                                //       log('chnage location dialog officeTitle  ${remarkController.text.toString()}');

                                //       //  division_id: diagDivisionId.toString(), //divisionId.toString(),
                                //       //         district_id: diagdistrictId.toString(),
                                //       //         upazila_id: diagUpazilaID.toString(),
                                //       //         union_id: diagUnionID.toString(),
                                //       //         latitude: targetLatitude.toString(),
                                //       //         longitude: targetLongitude.toString(),
                                //       //         remark: remarkController.text,
                                //       //         office_type_id: ,
                                //       //         office_title: officeTitleCtrl.text,
                                //     },
                                //     child: Text('Test')),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      diagOfficeTypeID = null;
                                      chngeLocDivValue = null;
                                      chngLocDistrictVal = null;
                                      chngLocUpazilaVal = null;
                                      chngLocUnionVal = null;
                                      chngLocOfficeTypeVal = null;
                                      // selectedDataFromChangedLocDrp = null;
                                      dialogUnion.clear();
                                      dialogUpazila.clear();
                                      dialogDivision.clear();
                                      dialogDistrict.clear();
                                      changeLocationBloc
                                          .add(ChangeLocationInitialEvent());
                                    });
                                    if (isLocNotMatched) {
                                      dialogCloseValue = 1;

                                      Navigator.of(context)
                                          .pop(dialogCloseValue);
                                    } else {
                                      dialogCloseValue = 0;

                                      Navigator.of(context)
                                          .pop(dialogCloseValue);
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 0)),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                TextButton(
                                  onPressed: () async {
                                    final connectivityResult =
                                        await ConnectivityProvider()
                                            .rcheckInternetConnection();
                                    if (connectivityResult) {
                                      if (_chngLocformKeyVisitReport
                                          .currentState!
                                          .validate()) {
                                        setState(() {
                                          isSubmitLoading = true;
                                        });

                                        await Repositores()
                                            .addChangeLocation(
                                          division_id: diagDivisionId
                                              .toString(), //divisionId.toString(),
                                          district_id: diagdistrictId == null
                                              ? ''
                                              : diagdistrictId.toString(),
                                          upazila_id: diagUpazilaID == null
                                              ? ''
                                              : diagUpazilaID.toString(),
                                          union_id: diagUnionID == null
                                              ? ''
                                              : diagUnionID.toString(),
                                          latitude: targetLatitude.toString(),
                                          longitude: targetLongitude.toString(),
                                          remark: remarkController.text,
                                          office_type_id:
                                              diagOfficeTypeID == null
                                                  ? ''
                                                  : diagOfficeTypeID!,
                                          office_title: officeTitleCtrl.text,
                                        )
                                            .then((value) async {
                                          if (value.message == 'success') {
                                            setState(
                                              () {
                                                changeLocationID =
                                                    value.changeLocationId;
                                                selectedDataFromChangedLocDrp = UpdNewLocationData(
                                                    officeTypeId:
                                                        chngLocOfficeTypeVal!
                                                            .id,
                                                    officeTitle: chngLocOfficeTypeVal?.id == 4
                                                        ? officeTitleCtrl.text
                                                        : chngLocOfficeTypeVal!
                                                            .name,
                                                    officeTypeName: chngLocOfficeTypeVal?.id == 4
                                                        ? '${chngLocOfficeTypeVal!.name} (${officeTitleCtrl.text})'
                                                        : '${chngLocOfficeTypeVal!.name}',
                                                    districtId: chngLocDistrictVal
                                                            ?.districtId ??
                                                        -1,
                                                    upazilaId: chngLocUpazilaVal
                                                            ?.upazilaId ??
                                                        -1,
                                                    divisionId: chngeLocDivValue
                                                            ?.divisionId ??
                                                        -1,
                                                    unionId:
                                                        chngLocUnionVal?.unionId ??
                                                            -1,
                                                    districtName: chngLocDistrictVal
                                                            ?.districtName ??
                                                        '',
                                                    upazilaName: chngLocUpazilaVal
                                                            ?.upazilaName ??
                                                        '',
                                                    unionName: chngLocUnionVal
                                                            ?.unionName ??
                                                        '',
                                                    divisionName:
                                                        chngeLocDivValue?.divisionName ?? '');
                                                log('add change locatin ${jsonEncode(selectedDataFromChangedLocDrp)}');

                                                // diagOfficeTypeID = null;
                                                // chngeLocDivValue = null;
                                                // chngLocDistrictVal = null;
                                                // chngLocUpazilaVal = null;
                                                // chngLocUnionVal = null;
                                              },
                                            );

                                            await QuickAlert.show(
                                              context: context,
                                              type: QuickAlertType.success,
                                              text:
                                                  "New Visit Report Added successfully",
                                            );
                                            dialogCloseValue = 1;
                                            Navigator.of(context)
                                                .pop(dialogCloseValue);

                                            setState(() {
                                              isSubmitLoading = false;
                                            });
                                          } else if (value.status == 422) {
                                            await QuickAlert.show(
                                              context: context,
                                              type: QuickAlertType.error,
                                              text: value.message,
                                            );
                                            setState(() {
                                              isSubmitLoading = false;
                                            });
                                          } else {
                                            await QuickAlert.show(
                                              context: context,
                                              type: QuickAlertType.error,
                                              text:
                                                  "New Visit Report Add Failed",
                                            );
                                            setState(() {
                                              isSubmitLoading = false;
                                            });
                                          }
                                        });
                                      }
                                    } else {
                                      if (_chngLocformKeyVisitReport
                                          .currentState!
                                          .validate()) {
                                        var localFieldVisitData = await prefs
                                            .getStringList(addNewLocSubmitKey);
                                        List<String> addNewLocData = [];

                                        Map fvMap = {
                                          "division_id":
                                              chngeLocDivValue?.divisionId ==
                                                      null
                                                  ? ''
                                                  : chngeLocDivValue?.divisionId
                                                      .toString(),
                                          "district_id": chngLocDistrictVal
                                                      ?.districtId ==
                                                  null
                                              ? ''
                                              : chngLocDistrictVal?.districtId
                                                  .toString(),
                                          "union_id":
                                              chngLocUnionVal?.unionId == null
                                                  ? ''
                                                  : chngLocUnionVal?.unionId
                                                      .toString(),
                                          "upazila_id":
                                              chngLocUpazilaVal?.upazilaId ==
                                                      null
                                                  ? ''
                                                  : chngLocUpazilaVal?.upazilaId
                                                      .toString(),
                                          "latitude": targetLatitude.toString(),
                                          "longitude":
                                              targetLongitude.toString(),
                                          "office_type": chngLocOfficeTypeVal
                                              ?.name
                                              .toString(),
                                          'datetime': DateConverter.formatDate(
                                              DateTime.now()),
                                          "remark": remarkController.text,
                                          "office_type_id":
                                              chngLocOfficeTypeVal!.id == null
                                                  ? ''
                                                  : chngLocOfficeTypeVal!.id!
                                                      .toString(),
                                          "office_title": officeTitleCtrl.text,
                                          "sync": '0',
                                          'img1': '',
                                          'img2': '',
                                          'img3': '',
                                          'location_id': '',
                                          "visit_date": DateConverter.formatYMD(
                                              DateTime.now()),
                                        };
                                        final fvJson = jsonEncode(fvMap);

                                        if (localFieldVisitData == null) {
                                          addNewLocData.add(fvJson);
                                          await prefs.setStringList(
                                              addNewLocSubmitKey,
                                              addNewLocData); //'fieldVisitSubmitList'
                                        } else {
                                          addNewLocData = localFieldVisitData;
                                          addNewLocData.add(fvJson);
                                          await prefs.setStringList(
                                              addNewLocSubmitKey,
                                              addNewLocData);
                                        }
                                        var getlDa = await getlocalData();
                                        localFieldVisitDataListNotifier.value =
                                            getlDa;
                                        setState(
                                          () {
                                            selectedDataFromChangedLocDrp =
                                                UpdNewLocationData(
                                                    officeTypeId:
                                                        chngLocOfficeTypeVal!
                                                            .id,
                                                    officeTitle: officeTitleCtrl
                                                        .text, //chngLocOfficeTypeVal!.name,
                                                    officeTypeName:
                                                        chngLocOfficeTypeVal!.id == 4
                                                            ? '${chngLocOfficeTypeVal!.name} (${officeTitleCtrl.text})'
                                                            : '${chngLocOfficeTypeVal!.name}',
                                                    districtId: chngLocDistrictVal
                                                            ?.districtId ??
                                                        null,
                                                    upazilaId: chngLocUpazilaVal
                                                            ?.upazilaId ??
                                                        null,
                                                    divisionId: chngeLocDivValue
                                                            ?.divisionId ??
                                                        null,
                                                    unionId: chngLocUnionVal
                                                            ?.unionId ??
                                                        null,
                                                    districtName:
                                                        chngLocDistrictVal
                                                                ?.districtName ??
                                                            '',
                                                    upazilaName:
                                                        chngLocUpazilaVal
                                                                ?.upazilaName ??
                                                            '',
                                                    unionName: chngLocUnionVal
                                                            ?.unionName ??
                                                        '',
                                                    divisionName:
                                                        chngeLocDivValue
                                                                ?.divisionName ??
                                                            '');
                                          },
                                        );
                                        log('add chng model ${jsonEncode(selectedDataFromChangedLocDrp)}');
                                        await QuickAlert.show(
                                          context: context,
                                          type: QuickAlertType.success,
                                          text: "New Office Added Locally",
                                        );
                                        dialogCloseValue = 1;
                                        Navigator.of(context)
                                            .pop(dialogCloseValue);

                                        setState(() {
                                          isSubmitLoading = false;
                                        });
                                      }
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: MyColors.secondaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 0)),
                                  child: isSubmitLoading
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : const Text(
                                          'Submit',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    ).then((value) {
      print("asdlfkjaksd2 ${value}");
      setState(() {});
    });
  }
}
