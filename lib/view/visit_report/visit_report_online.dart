// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:quickalert/models/quickalert_type.dart';
// import 'package:quickalert/widgets/quickalert_dialog.dart';
// import 'package:village_court_gems/bloc/All_Count_Bloc/all_count_bloc.dart';
// import 'package:village_court_gems/bloc/Change_Location_bloc/change_location_bloc.dart';
// import 'package:village_court_gems/bloc/Connectivity_bloc/connectivity_bloc_bloc.dart';
// import 'package:village_court_gems/bloc/Location_Bloc/location_bloc.dart';
// import 'package:village_court_gems/camera_widget/camera_model.dart';
// import 'package:village_court_gems/camera_widget/camera_widget.dart';
// import 'package:village_court_gems/controller/Local_store_controller/local_store.dart';
// import 'package:village_court_gems/controller/repository/repository.dart';
// import 'package:village_court_gems/main.dart';
// import 'package:village_court_gems/models/area_model/office_type_model.dart';
// import 'package:village_court_gems/models/field_visit_model/new_location_match_model.dart';
// import 'package:village_court_gems/models/locationModel.dart';
// import 'package:village_court_gems/provider/connectivity_provider.dart';
// import 'package:village_court_gems/services/all_services/all_services.dart';
// import 'package:village_court_gems/services/database/localDatabaseService.dart';
// import 'package:village_court_gems/util/constant.dart';
// import 'package:village_court_gems/util/utils.dart';
// import 'package:village_court_gems/view/field_visit_list/field-finding-create.dart';
// import 'package:village_court_gems/view/visit_report/field_visit_local_logic.dart';
// import 'package:village_court_gems/view/visit_report/show_image.dart';
// import 'package:village_court_gems/view/visit_report/visit_report_offline.dart';

// class VisitReportOnline extends StatefulWidget {
//   static const pageName = 'VisitReport';
//   const VisitReportOnline({super.key});

//   @override
//   State<VisitReportOnline> createState() => _VisitReportOnlineState();
// }

// class _VisitReportOnlineState extends State<VisitReportOnline> {
//   int dialogCloseValue = 0;
//   int locationMatched = 0;

//   String? selectedOffice;
//   String? selectedOfficeId;
//   var locationID;
//   var changeLocationID;
//   String? officeTitle;

//   String? selectedDivision;
//   String? selectedDistrict;
//   String? selectedUpazila;
//   String? selectedUnion;
//   Uint8List? img1;
//   Uint8List? img2;
//   Uint8List? img3;
//   String? img1Path;
//   String? img2Path;
//   String? img3Path;

//   String? divisionId = '';
//   String? districtId = '';
//   String? upazilaId = '';
//   String? unionID = '';

//   String? diagDivisionId = '';
//   String? diagdistrictId = '';
//   String? diagUpazilaID = '';
//   String? diagUnionID = '';
//   String? diagOfficeTypeID = '';

//   Division? chngeLocDivValue;
//   District? chngLocDistrictVal;
//   Upazila? chngLocUpazilaVal;
//   Union? chngLocUnionVal;
//   OfficeTypeData? chngLocOfficeTypeVal;

//   TextEditingController dateController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(DateTime.now().toLocal()));
//   TextEditingController visitPurposeController = TextEditingController();
//   TextEditingController officeTitleCtrl = TextEditingController();
//   TextEditingController remarkController = TextEditingController();

//   final GlobalKey<FormState> _formKeyVisitReport = GlobalKey<FormState>();
//   final GlobalKey<FormState> _chngLocformKeyVisitReport = GlobalKey<FormState>();

//   final ChangeLocationBloc changeLocationBloc = ChangeLocationBloc();

//   // late GoogleMapController mapController;
//   // locationPck.LocationData? currentLocation;
//   // Location location = locationPck.Location();
//   Completer<GoogleMapController> mapControllerCompleter = Completer<GoogleMapController>();

//   bool isLoading = false; // Add this line to your state
//   bool _isLoading = false;
//   bool isSubmitLoading = false;

//   String currentAddress = "";
//   backupData() async {
//     //final connectivityProvider = Provider.of<ConnectivityProvider>(context);
//     //if (connectivityProvider.isConnected) {
//     print('network check success isconnected');
//     // await Provider.of<ConnectivityProvider>(context, listen: false).fieldSubmitAutoSync(context: context);
//     // await Provider.of<ConnectivityProvider>(context, listen: false).changeLocationAutoSync(context: context);
//     //} else {
//     // print('network check success is not connected');
//     //}
//   }

//   double targetLatitude = 0.0;
//   double targetLongitude = 0.0;

//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       print('Location services are disabled.');
//       return;
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         print('Location permissions are denied (actual).');
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       Geolocator.openAppSettings();
//       print('Location permissions are permanently denied, we cannot request permissions.');
//       return;
//     }

//     // try {
//     setState(() {
//       isLoading = true;
//     });

//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );

//     double latitude = position.latitude;
//     double longitude = position.longitude;

//     print('Latitudeonline: $latitude, Longitude: $longitude');

//     List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

//     setState(() {
//       targetLatitude = latitude;
//       targetLongitude = longitude;
//       currentAddress = "${placemarks[0].subLocality}, ${placemarks[0].locality}";
//       print('Current Address ${currentAddress}');
//       updateMap();
//       isLoading = false;
//     });

//     // } catch (e) {
//     //   print('Error: $e');
//     // }
//   }

//   void updateMap() async {
//     if (mapControllerCompleter.isCompleted) {
//       mapControllerCompleter.future.then((controller) {
//         controller.animateCamera(
//           CameraUpdate.newCameraPosition(
//             CameraPosition(
//               target: LatLng(
//                 targetLatitude,
//                 targetLongitude,
//               ),
//               zoom: 14.0,
//             ),
//           ),
//         );
//       });

//       String token = await Helper().getUserToken();
//       print(token);
//       locationBloc.add(LocationInitialEvent(locationModel: {"latitude": targetLatitude.toString(), "longitude": targetLongitude.toString()}));
//     } else {
//       print('Map controller is not completed');
//     }
//   }

//   // networkChange() async {
//   //   final cp = Provider.of<ConnectivityProvider>(context, listen: false);
//   //   cp.networkChange(context: context);
//   // }

//   final LocationBloc locationBloc = LocationBloc();
//   final ConnectivityBloc connectivityBloc = ConnectivityBloc();

//   @override
//   void initState() {
//     //networkChange();
//     changeLocationBloc.add(ChangeLocationInitialEvent());
//     //localStore.networkChange();

//     // TODO: implement initState
//     super.initState();
//     // connectivityBloc.add(ConnectivityObserve());
//     // networkChange();
//     //  backupData();
//   }

//   List<Union> dialogUnion = [];
//   List<District> dialogDistrict = [];
//   List<Upazila> dialogUpazila = [];
//   List<Division> dialogDivision = [];
//   List<OfficeTypeData> dialogOfficeTypeData = [];

//   List<LocMatchedDivision> locMatchedDivisionList = [];
//   List<LocMatchedDistrict> locMatchedDistrictList = [];
//   List<LocMatchedUpazila> locMatchedUpazilaList = [];
//   List<LocMatchedUnion> locMatchedUnionList = [];

//   // bool getLocationIDEnable({
//   //   required List<LocMatchedDivision> divisionList,
//   //   required List<LocMatchedDistrict> districtList,
//   //   required List<LocMatchedUnion> unionList,
//   //   required List<LocMatchedUpazila> upazilaList,
//   // }) {
//   //   bool isEnabled = false;
//   //   if (divisionList.isNotEmpty && districtList.isNotEmpty && upazilaList.isNotEmpty && unionList.isNotEmpty) {
//   //   } else if (divisionList.isNotEmpty && districtList.isNotEmpty && upazilaList.isNotEmpty && unionList.isNotEmpty) {
//   //     setState(() {
//   //       locationID = selectedValue;
//   //     });
//   //   } else if (divisionList.isNotEmpty && districtList.isNotEmpty && upazilaList.isNotEmpty && unionList.isEmpty) {
//   //     setState(() {
//   //       locationID = selectedValue;
//   //     });
//   //   } else if (divisionList.isNotEmpty && districtList.isNotEmpty && upazilaList.isEmpty && unionList.isEmpty) {
//   //     setState(() {
//   //       locationID = selectedValue;
//   //     });
//   //   } else if (divisionList.isNotEmpty && districtList.isEmpty && upazilaList.isEmpty && unionList.isEmpty) {
//   //     setState(() {
//   //       locationID = selectedValue;
//   //     });
//   //   }
//   // }

//   @override
//   void dispose() {
//     //cancelconsub();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // backupData();

//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//             onPressed: () {
//                print('test');
          
//               Navigator.pop(context);
//             },
//             icon: const Icon(Icons.arrow_back)),
//         centerTitle: true,
//         title: Text(
//           "New Field Visit Track",
//           style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body:
//           // cp.backUpFieldSubmitProcessing
//           //     ? Center(
//           //         child: Column(
//           //           mainAxisAlignment: MainAxisAlignment.center,
//           //           crossAxisAlignment: CrossAxisAlignment.center,
//           //           children: [
//           //             //AnimatedIcon(icon: AnimatedIcons.list_view, progress: progress)
//           //             SizedBox(
//           //               height: 70,
//           //               width: 70,
//           //               child: CircularProgressIndicator(
//           //                 color: Colors.green,
//           //                 strokeWidth: 10,
//           //               ),
//           //             ),
//           //             Text(
//           //               " Data is synchronizing, please wait!",
//           //               style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
//           //             ),
//           //           ],
//           //         ),
//           //       )
//           //     : !cp.isConnected
//           //         ? Center(
//           //             child: Column(
//           //               children: [
//           //                 Text('You are currently Offline'),
//           //                 ElevatedButton(
//           //                     onPressed: () {
//           //                       Navigator.pushReplacement(
//           //                           context,
//           //                           MaterialPageRoute(
//           //                             builder: (context) => VisitReportOffline(),
//           //                           ));
//           //                     },
//           //                     child: Text('Offline Page'))
//           //               ],
//           //             ),
//           //           )
//           //         :
//           BlocConsumer<ConnectivityBloc, ConnectivityBlocState>(
//         //  bloc: connectivityBloc,
//         //listenWhen: (previous, current) => current is ConnectionFailure,
//         //buildWhen: (previous, ncurrent) => ncurrent is ConnectionFailure,
//         //listenWhen: (previous, ncurrent) => ncurrent is ConnectionSuccess,
//         listener: (context, netState) {
//           if (netState is ConnectionFailure) {
//             print('network gone');
//           } else {
//             print('network online');
//           }
//         },
//         builder: (context, netState) {
//           if (netState is ConnectionFailure) {
//             return Center(
//               child: Column(
//                 children: [
//                   Text('You are currently Offline'),
//                   ElevatedButton(
//                       onPressed: () {
//                         Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => VisitReportOffline(),
//                             ));
//                       },
//                       child: Text('Offline Page'))
//                 ],
//               ),
//             );
//           } else if (netState is ConnectionSuccess) {
//             return SingleChildScrollView(
//               child: Form(
//                 key: _formKeyVisitReport,
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       //localStore.isConnected ? Text('Network is connected') : Text('OFFLINE'),

//                       ///Find Nearby Office Button
//                       SizedBox(
//                         width: double.infinity,
//                         height: 45,
//                         child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(7.0.r),
//                               ),
//                               backgroundColor: Colors.green,
//                             ),
//                             onPressed: () async {
//                               setState(() {
//                                 dialogCloseValue = 0;
//                                 selectedOfficeId = null;
//                               });
//                               await _getCurrentLocation();
//                             },
//                             child: isLoading
//                                 ? CircularProgressIndicator(
//                                     color: Colors.white,
//                                   ) // Show the indicator when loading
//                                 : const Text(
//                                     "Find Nearby Office",
//                                     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                                   )),
//                       ),

//                       SizedBox(height: 10),
//                       Text(
//                         "My Location ",
//                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
//                       ),
//                       Text(
//                         'Latitude: ${targetLatitude}, Longitude: ${targetLongitude}',
//                         style: TextStyle(fontSize: 15.0),
//                       ),
//                       SizedBox(height: 10),

//                       ///Map View Section
//                       Container(
//                         height: 150,
//                         child: GoogleMap(
//                           onMapCreated: (GoogleMapController controller) {
//                             if (!mapControllerCompleter.isCompleted) {
//                               mapControllerCompleter.complete(controller);
//                             }
//                           },
//                           initialCameraPosition: CameraPosition(
//                             target: LatLng(
//                               targetLatitude,
//                               targetLongitude,
//                             ),
//                             zoom: 14.0,
//                           ),
//                           markers: {
//                             Marker(
//                               markerId: MarkerId("MyLocation"),
//                               position: LatLng(
//                                 targetLatitude,
//                                 targetLongitude,
//                               ),
//                               infoWindow: InfoWindow(title: "My Location"),
//                             ),
//                           },
//                         ),
//                       ),

//                       ///If Location Matched
//                       if (dialogCloseValue == 0)
//                         Column(
//                           children: [
//                             BlocConsumer<LocationBloc, LocationState>(
//                                 bloc: locationBloc,
//                                 buildWhen: (previous, current) => previous != current,
//                                 listener: (context, state) {
//                                   // TODO: implement listener
//                                   if (state is DialogShownState) {
//                                     if (state.message != "" || state.message != "null") {
//                                       selectedOffice = null;
//                                       AllService().tost("Location not match");
//                                       locationMatched = 0;
//                                       showCustomDialog();
//                                     }
//                                   } else if (state is LocationSuccessState) {
//                                     selectedOfficeId = state.officeList.first.id.toString();

//                                     //     selectedUnion = selectedUnion == '' ? state.union[0].unionId.toString() : selectedUnion;

//                                     if (selectedOfficeId == '4') {
//                                       if (state.division.isNotEmpty &&
//                                           state.union.isNotEmpty &&
//                                           state.district.isNotEmpty &&
//                                           state.upazila.isNotEmpty) {
//                                         officeTitle = state.union.first.officeTitle;
//                                         locationID = state.union.first.locationID;
//                                         unionID = state.union.first.unionId.toString();
//                                         upazilaId = state.upazila.first.upazilaId.toString();
//                                         districtId = state.district.first.districtId?.toString();
//                                         divisionId = state.division[0].divisionId?.toString();
//                                       } else if (state.division.isNotEmpty &&
//                                           state.district.isNotEmpty &&
//                                           state.upazila.isNotEmpty &&
//                                           state.union.isEmpty) {
//                                         officeTitle = state.upazila.first.officeTitle;
//                                         locationID = state.upazila.first.locationID;

//                                         upazilaId = state.upazila.first.upazilaId.toString();
//                                         districtId = state.district.first.districtId?.toString();
//                                         divisionId = state.division[0].divisionId?.toString();
//                                       } else if (state.division.isNotEmpty &&
//                                           state.district.isNotEmpty &&
//                                           state.upazila.isEmpty &&
//                                           state.union.isEmpty) {
//                                         officeTitle = state.district.first.officeTitle;
//                                         locationID = state.district.first.locationID;

//                                         districtId = state.district.first.districtId?.toString();
//                                         divisionId = state.division[0].divisionId?.toString();
//                                       } else if (state.division.isNotEmpty &&
//                                           state.district.isEmpty &&
//                                           state.upazila.isEmpty &&
//                                           state.union.isEmpty) {
//                                         officeTitle = state.division.first.officeTitle;
//                                         locationID = state.division.first.locationID;
//                                         divisionId = state.division.first.divisionId.toString();
//                                       }
//                                       //officeTitle = officeList[0].
//                                     } else {
//                                       if (state.division.isNotEmpty &&
//                                           state.union.isNotEmpty &&
//                                           state.district.isNotEmpty &&
//                                           state.upazila.isNotEmpty) {
//                                         locationID = state.union.first.locationID;
//                                         unionID = state.union.first.unionId.toString();
//                                         upazilaId = state.upazila.first.upazilaId.toString();
//                                         districtId = state.district.first.districtId?.toString();
//                                         divisionId = state.division[0].divisionId?.toString();
//                                       } else if (state.division.isNotEmpty &&
//                                           state.district.isNotEmpty &&
//                                           state.upazila.isNotEmpty &&
//                                           state.union.isEmpty) {
//                                         locationID = state.upazila.first.locationID;
//                                         upazilaId = state.upazila.first.upazilaId.toString();
//                                         districtId = state.district.first.districtId?.toString();
//                                         divisionId = state.division[0].divisionId?.toString();
//                                       } else if (state.division.isNotEmpty &&
//                                           state.district.isNotEmpty &&
//                                           state.upazila.isEmpty &&
//                                           state.union.isEmpty) {
//                                         locationID = state.district.first.locationID;
//                                         districtId = state.district.first.districtId?.toString();
//                                         divisionId = state.division[0].divisionId?.toString();
//                                       } else if (state.division.isNotEmpty &&
//                                           state.district.isEmpty &&
//                                           state.upazila.isEmpty &&
//                                           state.union.isEmpty) {
//                                         locationID = state.division.first.locationID;
//                                         divisionId = state.division[0].divisionId?.toString();
//                                       }
//                                     }
//                                     setState(() {});
//                                     log('find location listener is called');
//                                   } else if (state is LocationFilterState) {
//                                     selectedOfficeId = state.officeID;

//                                     if (selectedOfficeId == '4') {
//                                       if (state.division.isNotEmpty &&
//                                           state.union.isNotEmpty &&
//                                           state.district.isNotEmpty &&
//                                           state.upazila.isNotEmpty) {
//                                         officeTitle = state.union.first.officeTitle;
//                                         locationID = state.union.first.locationID;
//                                         unionID = state.union.first.unionId.toString();
//                                         upazilaId = state.upazila.first.upazilaId.toString();
//                                         districtId = state.district.first.districtId?.toString();
//                                         divisionId = state.division[0].divisionId?.toString();
//                                       } else if (state.division.isNotEmpty &&
//                                           state.district.isNotEmpty &&
//                                           state.upazila.isNotEmpty &&
//                                           state.union.isEmpty) {
//                                         officeTitle = state.upazila.first.officeTitle;
//                                         locationID = state.upazila.first.locationID;

//                                         upazilaId = state.upazila.first.upazilaId.toString();
//                                         districtId = state.district.first.districtId?.toString();
//                                         divisionId = state.division[0].divisionId?.toString();
//                                       } else if (state.division.isNotEmpty &&
//                                           state.district.isNotEmpty &&
//                                           state.upazila.isEmpty &&
//                                           state.union.isEmpty) {
//                                         officeTitle = state.district.first.officeTitle;
//                                         locationID = state.district.first.locationID;

//                                         districtId = state.district.first.districtId?.toString();
//                                         divisionId = state.division[0].divisionId?.toString();
//                                       } else if (state.division.isNotEmpty &&
//                                           state.district.isEmpty &&
//                                           state.upazila.isEmpty &&
//                                           state.union.isEmpty) {
//                                         officeTitle = state.division.first.officeTitle;
//                                         locationID = state.division.first.locationID;
//                                         divisionId = state.division.first.divisionId.toString();
//                                       }
//                                       //officeTitle = officeList[0].
//                                     } else {
//                                       if (state.division.isNotEmpty &&
//                                           state.union.isNotEmpty &&
//                                           state.district.isNotEmpty &&
//                                           state.upazila.isNotEmpty) {
//                                         locationID = state.union.first.locationID;
//                                         unionID = state.union.first.unionId.toString();
//                                         upazilaId = state.upazila.first.upazilaId.toString();
//                                         districtId = state.district.first.districtId?.toString();
//                                         divisionId = state.division[0].divisionId?.toString();
//                                       } else if (state.division.isNotEmpty &&
//                                           state.district.isNotEmpty &&
//                                           state.upazila.isNotEmpty &&
//                                           state.union.isEmpty) {
//                                         locationID = state.upazila.first.locationID;
//                                         upazilaId = state.upazila.first.upazilaId.toString();
//                                         districtId = state.district.first.districtId?.toString();
//                                         divisionId = state.division[0].divisionId?.toString();
//                                       } else if (state.division.isNotEmpty &&
//                                           state.district.isNotEmpty &&
//                                           state.upazila.isEmpty &&
//                                           state.union.isEmpty) {
//                                         locationID = state.district.first.locationID;
//                                         districtId = state.district.first.districtId?.toString();
//                                         divisionId = state.division[0].divisionId?.toString();
//                                       } else if (state.division.isNotEmpty &&
//                                           state.district.isEmpty &&
//                                           state.upazila.isEmpty &&
//                                           state.union.isEmpty) {
//                                         locationID = state.division.first.locationID;
//                                         divisionId = state.division[0].divisionId?.toString();
//                                       }
//                                     }
//                                     setState(() {});
//                                     //     selectedUnion = selectedUnion == '' ? state.union[0].unionId.toString() : selectedUnion;
//                                   }
//                                 },
//                                 builder: (context, state) {
//                                   if (state is LocationLoadingState) {
//                                     return Container(
//                                       padding: EdgeInsets.only(top: 10),
//                                       child: Center(child: CircularProgressIndicator()),
//                                     );
//                                   } else if (state is LocationSuccessState) {
//                                     return Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         SizedBox(height: 10),

//                                         ///Office Dropdown
//                                         SizedBox(
//                                           child: DropdownButtonFormField<OfficeTypeList>(
//                                             isExpanded: true,
//                                             //value: null,
//                                             value: state.officeList.isNotEmpty ? state.officeList[0] : null,
//                                             onChanged: (newValue) {
//                                               districtId = '';
//                                               divisionId = '';
//                                               upazilaId = '';
//                                               unionID = '';
//                                               // officeTitle = null;
//                                               // officeTitle = newValue!.name;
//                                               locationID = null;
//                                               selectedOfficeId = null;
//                                               selectedOfficeId = newValue!.id.toString();
//                                               locationBloc.add(LocationFilterEvent(id: newValue!.id));
//                                               setState(() {});
//                                             },
//                                             items: state.officeList.map<DropdownMenuItem<OfficeTypeList>>((item) {
//                                               return DropdownMenuItem<OfficeTypeList>(
//                                                 onTap: () {},
//                                                 value: item,
//                                                 child: Text("${item.name}"),
//                                               );
//                                             }).toList(),
//                                             decoration: const InputDecoration(
//                                               contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//                                               border: OutlineInputBorder(
//                                                 borderSide: BorderSide(color: Colors.black),
//                                               ),
//                                               labelText: 'Select Office',
//                                             ),
//                                             validator: (value) {
//                                               if (value == null) {
//                                                 return 'Please Select Office';
//                                               }
//                                               return null;
//                                             },
//                                           ),
//                                         ),
//                                         const SizedBox(height: 10),

//                                         ///Date Section
//                                         SizedBox(
//                                           height: 50.0.h,
//                                           child: TextField(
//                                             readOnly: true,
//                                             controller: dateController,
//                                             decoration: const InputDecoration(
//                                               enabledBorder: OutlineInputBorder(
//                                                 borderSide: BorderSide(width: 1, color: Colors.black),
//                                               ),
//                                               focusedBorder: OutlineInputBorder(
//                                                 borderSide: BorderSide(width: 1, color: Colors.black),
//                                               ),
//                                               contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                               hintText: "Visit Date",
//                                               suffixIcon: Icon(Icons.calendar_today),
//                                             ),
//                                           ),
//                                         ),
//                                         //Text(state.officeTitle ?? ""),
//                                         const SizedBox(height: 10),
//                                         Visibility(
//                                           visible: selectedOfficeId == '4',
//                                           child: TextFormField(
//                                             readOnly: true,
//                                             decoration: InputDecoration(
//                                               border: OutlineInputBorder(),
//                                               labelText: 'Office Title',

//                                               enabledBorder: OutlineInputBorder(
//                                                 borderSide: BorderSide(width: 1, color: Colors.black),
//                                               ),
//                                               focusedBorder: OutlineInputBorder(
//                                                 borderSide: BorderSide(width: 1, color: Colors.black),
//                                               ),
//                                               // hintText: 'Visit Purposes',
//                                               contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                               floatingLabelBehavior: FloatingLabelBehavior.always,
//                                             ),
//                                             controller: TextEditingController(text: officeTitle),
//                                             maxLines: 1,
//                                             // validator: (value) {
//                                             //   if (value!.length > 255) {
//                                             //     return 'please enter less than 256 characters';
//                                             //   } else if (value.isEmpty) {
//                                             //     return 'Please Enter Visit Purposes';
//                                             //   }
//                                             //   return null;
//                                             // },
//                                           ),
//                                         ),

//                                         SizedBox(height: 10),

//                                         ///Add New Office Button
//                                         Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             const Text(
//                                               "",
//                                               style: TextStyle(fontWeight: FontWeight.bold),
//                                             ),
//                                             GestureDetector(
//                                               onTap: () async {
//                                                 setState(() {
//                                                   // upazilaId = '';
//                                                   // unionID = '';
//                                                   // districtId = '';
//                                                   // divisionId = '';
//                                                   diagDivisionId = null;
//                                                   diagUpazilaID = null;
//                                                   diagdistrictId = null;
//                                                   diagUpazilaID = null;
//                                                 });
//                                                 log('add new off union $unionID');
//                                                 log('add new off upazila $upazilaId');
//                                                 log('add new off district $districtId');

//                                                 showCustomDialog();
//                                               },
//                                               child: Container(
//                                                 alignment: Alignment.center,
//                                                 width: 120.w,
//                                                 height: 35.h,
//                                                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.green),
//                                                 child: Padding(
//                                                   padding: EdgeInsets.only(left: 3.0.w, right: 3.0.w),
//                                                   child: Text(
//                                                     "Add New Office",
//                                                     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//                                                   ),
//                                                 ),
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                         SizedBox(height: 15),

//                                         Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Visibility(
//                                               visible: state.division.isNotEmpty,
//                                               child: Expanded(
//                                                 child: DropdownButtonFormField<LocMatchedDivision>(
//                                                   isExpanded: true,
//                                                   decoration: const InputDecoration(
//                                                       contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                                       border: OutlineInputBorder(
//                                                         borderSide: BorderSide(color: Colors.black),
//                                                       ),
//                                                       labelText: 'Select division'),
//                                                   value: state.division.isNotEmpty ? state.division[0] : null,
//                                                   onChanged: (LocMatchedDivision? newValue) {
//                                                     setState(() {
//                                                       divisionId = null;

//                                                       divisionId = newValue?.divisionId != null ? newValue?.divisionId.toString() : '';

//                                                       if (state.district.isEmpty && state.upazila.isEmpty && state.union.isEmpty) {
//                                                         if (selectedOfficeId == '4') {
//                                                           locationID = null;
//                                                           locationID = newValue?.locationID;
//                                                           officeTitle = newValue?.officeTitle;
//                                                         } else {
//                                                           locationID = null;
//                                                           locationID = newValue?.locationID;
//                                                         }
//                                                       } else {
//                                                         return;
//                                                       }
//                                                     });
//                                                   },
//                                                   items: state.division.map<DropdownMenuItem<LocMatchedDivision>>(
//                                                     (entry) {
//                                                       return DropdownMenuItem<LocMatchedDivision>(
//                                                         value: entry,
//                                                         child: Text(entry.divisionName ?? ""),
//                                                       );
//                                                     },
//                                                   ).toList(),
//                                                   validator: (value) {
//                                                     if (value == null) {
//                                                       return 'Select division';
//                                                     }
//                                                     return null;
//                                                   },
//                                                 ),
//                                               ),
//                                             ),
//                                             SizedBox(width: 5),
//                                             Visibility(
//                                               visible: state.district.isNotEmpty,
//                                               child: Expanded(
//                                                 child: DropdownButtonFormField<LocMatchedDistrict>(
//                                                   isExpanded: true,
//                                                   decoration: const InputDecoration(
//                                                       contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                                       border: OutlineInputBorder(
//                                                         borderSide: BorderSide(color: Colors.black),
//                                                       ),
//                                                       labelText: 'Select district'),
//                                                   value: state.district.isNotEmpty ? state.district[0] : null,
//                                                   onChanged: (LocMatchedDistrict? newValue) {
//                                                     // districtId = null;
//                                                     // officeTitle = null;
//                                                     // districtId = newValue?.districtId.toString() ?? '';
//                                                     setState(() {
//                                                       districtId = null;

//                                                       districtId = newValue?.districtId.toString() ?? '';
//                                                       if (state.upazila.isEmpty && state.union.isEmpty) {
//                                                         if (selectedOfficeId == '4') {
//                                                           locationID = null;
//                                                           locationID = newValue?.locationID;
//                                                           officeTitle = newValue?.officeTitle;
//                                                         } else {
//                                                           locationID = null;
//                                                           locationID = newValue?.locationID;
//                                                         }
//                                                       } else {
//                                                         return;
//                                                       }

//                                                       //  officeTitle = null;
//                                                     });
//                                                   },
//                                                   items: state.district.map<DropdownMenuItem<LocMatchedDistrict>>(
//                                                     (entry) {
//                                                       return DropdownMenuItem<LocMatchedDistrict>(
//                                                         value: entry,
//                                                         child: Text(entry.districtName ?? ""),
//                                                       );
//                                                     },
//                                                   ).toList(),
//                                                   validator: (value) {
//                                                     if (value == null) {
//                                                       return 'Select district';
//                                                     }
//                                                     return null;
//                                                   },
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         const SizedBox(height: 10),

//                                         Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Visibility(
//                                               visible: state.upazila.isNotEmpty,
//                                               child: Expanded(
//                                                 child: DropdownButtonFormField<LocMatchedUpazila>(
//                                                   isExpanded: true,
//                                                   decoration: const InputDecoration(
//                                                       contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                                       border: OutlineInputBorder(
//                                                         borderSide: BorderSide(color: Colors.black),
//                                                       ),
//                                                       labelText: 'Select upazila'),
//                                                   value: state.upazila.isNotEmpty ? state.upazila[0] : null,
//                                                   onChanged: (LocMatchedUpazila? newValue) {
//                                                     setState(() {
//                                                       upazilaId = null;

//                                                       upazilaId = newValue?.upazilaId.toString() ?? '';
//                                                       if (state.union.isEmpty) {
//                                                         if (selectedOfficeId == '4') {
//                                                           locationID = null;
//                                                           locationID = newValue?.locationID;
//                                                           officeTitle = newValue?.officeTitle;
//                                                         } else {
//                                                           locationID = null;
//                                                           locationID = newValue?.locationID;
//                                                         }
//                                                       } else {
//                                                         return;
//                                                       }
//                                                     });
//                                                   },
//                                                   items: state.upazila.map<DropdownMenuItem<LocMatchedUpazila>>(
//                                                     (entry) {
//                                                       return DropdownMenuItem<LocMatchedUpazila>(
//                                                         value: entry,
//                                                         child: Text(entry.upazilaName ?? ""),
//                                                       );
//                                                     },
//                                                   ).toList(),
//                                                   validator: (value) {
//                                                     if (value == null) {
//                                                       return 'Select upazila';
//                                                     }
//                                                     return null;
//                                                   },
//                                                 ),
//                                               ),
//                                             ),
//                                             SizedBox(width: 5),
//                                             Visibility(
//                                               visible: state.union.isNotEmpty,
//                                               child: Expanded(
//                                                 child: DropdownButtonFormField<LocMatchedUnion>(
//                                                   isExpanded: true,
//                                                   decoration: const InputDecoration(
//                                                       contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                                       border: OutlineInputBorder(
//                                                         borderSide: BorderSide(color: Colors.black),
//                                                       ),
//                                                       labelText: 'Select union'),
//                                                   value: state.union.isNotEmpty ? state.union[0] : null,
//                                                   onChanged: (LocMatchedUnion? newValue) {
//                                                     setState(() {
//                                                       selectedUnion = null;
//                                                       unionID = null;
//                                                       locationID = null;
//                                                       selectedUnion = newValue?.unionId.toString() ?? '';
//                                                       locationID = newValue?.locationID;

//                                                       unionID = newValue?.unionId.toString() ?? "";
//                                                       officeTitle = newValue?.officeTitle;
//                                                     });

//                                                     // log('union ID $unionID');
//                                                     log('union onchanged ${unionID}');
//                                                   },
//                                                   items: state.union.map<DropdownMenuItem<LocMatchedUnion>>(
//                                                     (entry) {
//                                                       return DropdownMenuItem<LocMatchedUnion>(
//                                                         value: entry,
//                                                         child: Text(entry.unionName ?? ""),
//                                                       );
//                                                     },
//                                                   ).toList(),
//                                                   validator: (value) {
//                                                     if (value == null) {
//                                                       return 'Select union';
//                                                     }
//                                                     return null;
//                                                   },
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),

//                                         const SizedBox(height: 10),
//                                         // TextFormField(
//                                         //   decoration: InputDecoration(
//                                         //     border: OutlineInputBorder(),
//                                         //     labelText: 'Visit Purposes',
//                                         //     enabledBorder: OutlineInputBorder(
//                                         //       borderSide: BorderSide(width: 1, color: Colors.black),
//                                         //     ),
//                                         //     focusedBorder: OutlineInputBorder(
//                                         //       borderSide: BorderSide(width: 1, color: Colors.black),
//                                         //     ),
//                                         //     // hintText: 'Visit Purposes',
//                                         //     contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                         //     floatingLabelBehavior: FloatingLabelBehavior.always,
//                                         //   ),
//                                         //   controller: visitPurposeController,
//                                         //   maxLines: 3,
//                                         //   validator: (value) {
//                                         //     if (value!.length > 255) {
//                                         //       return 'please enter less than 256 characters';
//                                         //     } else if (value.isEmpty) {
//                                         //       return 'Please Enter Visit Purposes';
//                                         //     }
//                                         //     return null;
//                                         //   },
//                                         // ),

//                                         SizedBox(height: 15),
//                                         const Text("Filed Photo (You can add up to 3 image only)"),
//                                         const SizedBox(height: 6),

//                                         Wrap(
//                                           alignment: WrapAlignment.start,
//                                           runAlignment: WrapAlignment.start,
//                                           children: [
//                                             singleImage(
//                                               img: img1,
//                                               function: () async {
//                                                 CameraDataModel? camModel = await Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                       builder: (context) => CameraScreen(),
//                                                     ));
//                                                 if (camModel != null || camModel is CameraDataModel) {
//                                                   final img = camModel.xpictureFile;
//                                                   if (img != null) {
//                                                     final compressedFile1 = await imageProcessing(imgFile: img!);
//                                                     final byte = compressedFile1!.readAsBytesSync();
//                                                     setState(() {
//                                                       img1 = byte;
//                                                       img1Path = compressedFile1.path;
//                                                     });
//                                                     log('image 1 path $img1Path');
//                                                   } else {
//                                                     return;
//                                                   }
//                                                 }
//                                               },
//                                               imgStep: '1',
//                                             ),
//                                             singleImage(
//                                               img: img2,
//                                               function: () async {
//                                                 CameraDataModel? camModel = await Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                       builder: (context) => CameraScreen(),
//                                                     ));
//                                                 if (camModel != null || camModel is CameraDataModel) {
//                                                   final img = camModel.xpictureFile;
//                                                   if (img != null) {
//                                                     final compressedFile1 = await imageProcessing(imgFile: img);
//                                                     final byte = compressedFile1!.readAsBytesSync();
//                                                     setState(() {
//                                                       img2 = byte;
//                                                       img2Path = compressedFile1.path;
//                                                     });
//                                                     log('image 2 path $img2Path');
//                                                   } else {
//                                                     return;
//                                                   }
//                                                 }
//                                               },
//                                               imgStep: '2',
//                                             ),
//                                             singleImage(
//                                               img: img3,
//                                               function: () async {
//                                                 CameraDataModel? camModel = await Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                       builder: (context) => CameraScreen(),
//                                                     ));
//                                                 if (camModel != null || camModel is CameraDataModel) {
//                                                   final img = camModel.xpictureFile;
//                                                   if (img != null) {
//                                                     final compressedFile1 = await imageProcessing(imgFile: img!);
//                                                     final byte = compressedFile1!.readAsBytesSync();
//                                                     setState(() {
//                                                       img3 = byte;
//                                                       img3Path = compressedFile1.path;
//                                                     });
//                                                     //log('image 2 path $img2Path');
//                                                   } else {
//                                                     return;
//                                                   }
//                                                 }
//                                               },
//                                               imgStep: '3',
//                                             ),
//                                           ],
//                                         ),

//                                         SizedBox(height: 10),
//                                         // ElevatedButton(
//                                         //     onPressed: () {
//                                         //       log('union ID from submit  $unionID');
//                                         //       log('District ID from submit  $districtId');
//                                         //       log('Division ID  from submit  $divisionId');
//                                         //       log('loc matched tst field submit upazillaiD $upazilaId');
//                                         //     },
//                                         //     child: Text('Tst')),

//                                         ElevatedButton(
//                                             style: ElevatedButton.styleFrom(
//                                               shape: RoundedRectangleBorder(
//                                                 borderRadius: BorderRadius.circular(7.0.r),
//                                               ),
//                                               backgroundColor: Colors.green,
//                                             ),
//                                             onPressed: () async {
//                                               if (img1Path != null || img2Path != null || img3Path != null) {
//                                                 submitFieldVisit(dialogclose: 0, officeTitle: officeTitle ?? '');
//                                               } else {
//                                                 AllService().tost('Please Upload at least 1 Image up to 3 ');
//                                               }
//                                               log('office ID from submit  $selectedOfficeId');
//                                               log('union ID from submit  $unionID');
//                                               log('District ID from submit  $districtId');
//                                               log('Division ID  from submit  $divisionId');

//                                               log('UpazilaID  from submit  $upazilaId');
//                                               log('location id ${locationID}');
//                                               log('office title ${officeTitle}');
//                                             },
//                                             child: _isLoading
//                                                 ? Center(child: AllService.LoadingToast())
//                                                 : const Row(
//                                                     mainAxisAlignment: MainAxisAlignment.center,
//                                                     children: [
//                                                       Text(
//                                                         'Submit',
//                                                         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                                                       ),
//                                                     ],
//                                                   )),
//                                         SizedBox(height: 15),
//                                       ],
//                                     );
//                                   } else if (state is LocationFilterState) {
//                                     return Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         SizedBox(height: 10),

//                                         ///Office Dropdown
//                                         SizedBox(
//                                           child: DropdownButtonFormField<OfficeTypeList>(
//                                             isExpanded: true,
//                                             value: state.officeList.isNotEmpty ? state.officeList[0] : null,
//                                             onChanged: (newValue) {
//                                               districtId = '';
//                                               divisionId = '';
//                                               upazilaId = '';
//                                               unionID = '';
//                                               selectedOfficeId = null;
//                                               selectedOfficeId = newValue!.id.toString();
//                                               officeTitle = null;
//                                               officeTitle = newValue!.name;
//                                               locationID = null;
//                                               locationBloc.add(LocationFilterEvent(id: newValue!.id));
//                                               setState(() {});
//                                             },
//                                             items: state.officeList.map<DropdownMenuItem<OfficeTypeList>>((item) {
//                                               return DropdownMenuItem<OfficeTypeList>(
//                                                 onTap: () {},
//                                                 value: item,
//                                                 child: Text("${item.name}"),
//                                               );
//                                             }).toList(),
//                                             decoration: const InputDecoration(
//                                               contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//                                               border: OutlineInputBorder(
//                                                 borderSide: BorderSide(color: Colors.black),
//                                               ),
//                                               labelText: 'Select Office',
//                                             ),
//                                             validator: (value) {
//                                               if (value == null) {
//                                                 return 'Please Select Office';
//                                               }
//                                               return null;
//                                             },
//                                           ),
//                                         ),
//                                         const SizedBox(height: 10),

//                                         ///Date Section
//                                         SizedBox(
//                                           height: 50.0.h,
//                                           child: TextField(
//                                             readOnly: true,
//                                             controller: dateController,
//                                             decoration: const InputDecoration(
//                                               enabledBorder: OutlineInputBorder(
//                                                 borderSide: BorderSide(width: 1, color: Colors.black),
//                                               ),
//                                               focusedBorder: OutlineInputBorder(
//                                                 borderSide: BorderSide(width: 1, color: Colors.black),
//                                               ),
//                                               contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                               hintText: "Visit Date",
//                                               suffixIcon: Icon(Icons.calendar_today),
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(height: 10),
//                                         Visibility(
//                                           visible: selectedOfficeId == '4',
//                                           child: TextFormField(
//                                             readOnly: true,
//                                             decoration: InputDecoration(
//                                               border: OutlineInputBorder(),
//                                               labelText: 'Office Title',

//                                               enabledBorder: OutlineInputBorder(
//                                                 borderSide: BorderSide(width: 1, color: Colors.black),
//                                               ),
//                                               focusedBorder: OutlineInputBorder(
//                                                 borderSide: BorderSide(width: 1, color: Colors.black),
//                                               ),
//                                               // hintText: 'Visit Purposes',
//                                               contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                               floatingLabelBehavior: FloatingLabelBehavior.always,
//                                             ),
//                                             controller: TextEditingController(text: officeTitle),
//                                             maxLines: 1,
//                                             // validator: (value) {
//                                             //   if (value!.length > 255) {
//                                             //     return 'please enter less than 256 characters';
//                                             //   } else if (value.isEmpty) {
//                                             //     return 'Please Enter Visit Purposes';
//                                             //   }
//                                             //   return null;
//                                             // },
//                                           ),
//                                         ),
//                                         SizedBox(height: 10),

//                                         ///Add New Office Button
//                                         Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             const Text(
//                                               "",
//                                               style: TextStyle(fontWeight: FontWeight.bold),
//                                             ),
//                                             GestureDetector(
//                                               onTap: () async {
//                                                 setState(() {
//                                                   // upazilaId = '';
//                                                   // unionID = '';
//                                                   // districtId = '';
//                                                   // divisionId = '';
//                                                   diagDivisionId = null;
//                                                   diagUpazilaID = null;
//                                                   diagdistrictId = null;
//                                                   diagUpazilaID = null;
//                                                 });
//                                                 log('add new off union $unionID');
//                                                 log('add new off upazila $upazilaId');
//                                                 log('add new off district $districtId');

//                                                 showCustomDialog();
//                                               },
//                                               child: Container(
//                                                 alignment: Alignment.center,
//                                                 width: 120.w,
//                                                 height: 35.h,
//                                                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.green),
//                                                 child: Padding(
//                                                   padding: EdgeInsets.only(left: 3.0.w, right: 3.0.w),
//                                                   child: Text(
//                                                     "Add New Office",
//                                                     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//                                                   ),
//                                                 ),
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                         SizedBox(height: 15),

//                                         Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Visibility(
//                                               visible: state.division.isNotEmpty,
//                                               child: Expanded(
//                                                 child: DropdownButtonFormField<LocMatchedDivision>(
//                                                   isExpanded: true,
//                                                   decoration: const InputDecoration(
//                                                       contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                                       border: OutlineInputBorder(
//                                                         borderSide: BorderSide(color: Colors.black),
//                                                       ),
//                                                       labelText: 'Select division'),
//                                                   value: state.division.isNotEmpty ? state.division[0] : null,
//                                                   onChanged: (LocMatchedDivision? newValue) {
//                                                     setState(() {
//                                                       divisionId = null;
//                                                       officeTitle = null;
//                                                       divisionId = newValue?.divisionId.toString();
//                                                       if (state.district.isEmpty && state.upazila.isEmpty && state.union.isEmpty) {
//                                                         if (selectedOfficeId == '4') {
//                                                           locationID = null;
//                                                           locationID = newValue?.locationID;
//                                                           officeTitle = newValue?.officeTitle;
//                                                         } else {
//                                                           locationID = null;
//                                                           locationID = newValue?.locationID;
//                                                         }
//                                                       } else {
//                                                         return;
//                                                       }
//                                                     });
//                                                   },
//                                                   items: state.division.map<DropdownMenuItem<LocMatchedDivision>>(
//                                                     (entry) {
//                                                       return DropdownMenuItem<LocMatchedDivision>(
//                                                         value: entry,
//                                                         child: Text(entry.divisionName ?? ""),
//                                                       );
//                                                     },
//                                                   ).toList(),
//                                                   validator: (value) {
//                                                     if (value == null) {
//                                                       return 'Select division';
//                                                     }
//                                                     return null;
//                                                   },
//                                                 ),
//                                               ),
//                                             ),
//                                             SizedBox(width: 5),
//                                             Visibility(
//                                               visible: state.district.isNotEmpty,
//                                               child: Expanded(
//                                                 child: DropdownButtonFormField<LocMatchedDistrict>(
//                                                   isExpanded: true,
//                                                   decoration: const InputDecoration(
//                                                       contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                                       border: OutlineInputBorder(
//                                                         borderSide: BorderSide(color: Colors.black),
//                                                       ),
//                                                       labelText: 'Select district'),
//                                                   value: state.district.isNotEmpty ? state.district[0] : null,
//                                                   onChanged: (LocMatchedDistrict? newValue) {
//                                                     setState(() {
//                                                       districtId = null;
//                                                       officeTitle = null;
//                                                       districtId = newValue?.districtId.toString();
//                                                       if (state.upazila.isEmpty && state.union.isEmpty) {
//                                                         if (selectedOfficeId == '4') {
//                                                           locationID = null;
//                                                           locationID = newValue?.locationID;
//                                                           officeTitle = newValue?.officeTitle;
//                                                         } else {
//                                                           locationID = null;
//                                                           locationID = newValue?.locationID;
//                                                         }
//                                                       } else {
//                                                         return;
//                                                       }
//                                                     });
//                                                   },
//                                                   items: state.district.map<DropdownMenuItem<LocMatchedDistrict>>(
//                                                     (entry) {
//                                                       return DropdownMenuItem<LocMatchedDistrict>(
//                                                         value: entry,
//                                                         child: Text(entry.districtName ?? ""),
//                                                       );
//                                                     },
//                                                   ).toList(),
//                                                   validator: (value) {
//                                                     if (value == null) {
//                                                       return 'Select district';
//                                                     }
//                                                     return null;
//                                                   },
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         const SizedBox(height: 10),

//                                         Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Visibility(
//                                               visible: state.upazila.isNotEmpty,
//                                               child: Expanded(
//                                                 child: DropdownButtonFormField<LocMatchedUpazila>(
//                                                   isExpanded: true,
//                                                   decoration: const InputDecoration(
//                                                       contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                                       border: OutlineInputBorder(
//                                                         borderSide: BorderSide(color: Colors.black),
//                                                       ),
//                                                       labelText: 'Select upazila'),
//                                                   value: state.upazila.isNotEmpty ? state.upazila[0] : null,
//                                                   onChanged: (LocMatchedUpazila? newValue) {
//                                                     setState(() {
//                                                       upazilaId = null;
//                                                       officeTitle = null;
//                                                       upazilaId = newValue?.upazilaId.toString();
//                                                       if (state.union.isEmpty) {
//                                                         if (selectedOfficeId == '4') {
//                                                           locationID = null;
//                                                           locationID = newValue?.locationID;
//                                                           officeTitle = newValue?.officeTitle;
//                                                         } else {
//                                                           locationID = null;
//                                                           locationID = newValue?.locationID;
//                                                         }
//                                                       } else {
//                                                         return;
//                                                       }
//                                                     });
//                                                   },
//                                                   items: state.upazila.map<DropdownMenuItem<LocMatchedUpazila>>(
//                                                     (entry) {
//                                                       return DropdownMenuItem<LocMatchedUpazila>(
//                                                         value: entry,
//                                                         child: Text(entry.upazilaName ?? ""),
//                                                       );
//                                                     },
//                                                   ).toList(),
//                                                   validator: (value) {
//                                                     if (value == null) {
//                                                       return 'Select upazila';
//                                                     }
//                                                     return null;
//                                                   },
//                                                 ),
//                                               ),
//                                             ),
//                                             SizedBox(width: 5),
//                                             Visibility(
//                                               visible: state.union.isNotEmpty,
//                                               child: Expanded(
//                                                 child: DropdownButtonFormField<LocMatchedUnion>(
//                                                   isExpanded: true,
//                                                   decoration: const InputDecoration(
//                                                       contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                                       border: OutlineInputBorder(
//                                                         borderSide: BorderSide(color: Colors.black),
//                                                       ),
//                                                       labelText: 'Select union'),
//                                                   value: state.union.isNotEmpty ? state.union[0] : null,
//                                                   onChanged: (LocMatchedUnion? newValue) {
//                                                     setState(() {
//                                                       selectedUnion = null;
//                                                       unionID = null;
//                                                       selectedUnion = newValue!.unionId.toString();
//                                                       //if ( state.union.isEmpty) {
//                                                       if (selectedOfficeId == '4') {
//                                                         locationID = null;
//                                                         locationID = newValue.locationID;
//                                                         officeTitle = newValue.officeTitle;
//                                                       } else {
//                                                         locationID = null;
//                                                         locationID = newValue.locationID;
//                                                       }
//                                                       // } else {
//                                                       //   return;
//                                                       // }

//                                                       unionID = newValue.unionId.toString();
//                                                     });

//                                                     // log('union ID $unionID');
//                                                     log('union onchanged ${unionID}');
//                                                   },
//                                                   items: state.union.map<DropdownMenuItem<LocMatchedUnion>>(
//                                                     (entry) {
//                                                       return DropdownMenuItem<LocMatchedUnion>(
//                                                         value: entry,
//                                                         child: Text(entry.unionName ?? ""),
//                                                       );
//                                                     },
//                                                   ).toList(),
//                                                   validator: (value) {
//                                                     if (value == null) {
//                                                       return 'Select union';
//                                                     }
//                                                     return null;
//                                                   },
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),

//                                         const SizedBox(height: 10),
//                                         // TextFormField(
//                                         //   decoration: InputDecoration(
//                                         //     border: OutlineInputBorder(),
//                                         //     labelText: 'Visit Purposes',
//                                         //     enabledBorder: OutlineInputBorder(
//                                         //       borderSide: BorderSide(width: 1, color: Colors.black),
//                                         //     ),
//                                         //     focusedBorder: OutlineInputBorder(
//                                         //       borderSide: BorderSide(width: 1, color: Colors.black),
//                                         //     ),
//                                         //     // hintText: 'Visit Purposes',
//                                         //     contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                         //     floatingLabelBehavior: FloatingLabelBehavior.always,
//                                         //   ),
//                                         //   controller: visitPurposeController,
//                                         //   maxLines: 3,
//                                         //   validator: (value) {
//                                         //     if (value!.length > 255) {
//                                         //       return 'please enter less than 256 characters';
//                                         //     } else if (value.isEmpty) {
//                                         //       return 'Please Enter Visit Purposes';
//                                         //     }
//                                         //     return null;
//                                         //   },
//                                         // ),

//                                         SizedBox(height: 15),
//                                         const Text("Filed Photo (You can add up to 3 image only)"),
//                                         const SizedBox(height: 6),

//                                         Wrap(
//                                           alignment: WrapAlignment.start,
//                                           runAlignment: WrapAlignment.start,
//                                           children: [
//                                             singleImage(
//                                               img: img1,
//                                               function: () async {
//                                                 CameraDataModel? camModel = await Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                       builder: (context) => CameraScreen(),
//                                                     ));
//                                                 if (camModel != null || camModel is CameraDataModel) {
//                                                   final img = camModel.xpictureFile;
//                                                   if (img != null) {
//                                                     final compressedFile1 = await imageProcessing(imgFile: img!);
//                                                     final byte = compressedFile1!.readAsBytesSync();
//                                                     setState(() {
//                                                       img1 = byte;
//                                                       img1Path = compressedFile1.path;
//                                                     });
//                                                     log('image 1 path $img1Path');
//                                                   } else {
//                                                     return;
//                                                   }
//                                                 }
//                                               },
//                                               imgStep: '1',
//                                             ),
//                                             singleImage(
//                                               img: img2,
//                                               function: () async {
//                                                 CameraDataModel? camModel = await Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                       builder: (context) => CameraScreen(),
//                                                     ));
//                                                 if (camModel != null || camModel is CameraDataModel) {
//                                                   final img = camModel.xpictureFile;
//                                                   if (img != null) {
//                                                     final compressedFile1 = await imageProcessing(imgFile: img);
//                                                     final byte = compressedFile1!.readAsBytesSync();
//                                                     setState(() {
//                                                       img2 = byte;
//                                                       img2Path = compressedFile1.path;
//                                                     });
//                                                     log('image 2 path $img2Path');
//                                                   } else {
//                                                     return;
//                                                   }
//                                                 }
//                                               },
//                                               imgStep: '2',
//                                             ),
//                                             singleImage(
//                                               img: img3,
//                                               function: () async {
//                                                 CameraDataModel? camModel = await Navigator.push(
//                                                     context,
//                                                     MaterialPageRoute(
//                                                       builder: (context) => CameraScreen(),
//                                                     ));
//                                                 if (camModel != null || camModel is CameraDataModel) {
//                                                   final img = camModel.xpictureFile;
//                                                   if (img != null) {
//                                                     final compressedFile1 = await imageProcessing(imgFile: img!);
//                                                     final byte = compressedFile1!.readAsBytesSync();
//                                                     setState(() {
//                                                       img3 = byte;
//                                                       img3Path = compressedFile1.path;
//                                                     });
//                                                     //log('image 2 path $img2Path');
//                                                   } else {
//                                                     return;
//                                                   }
//                                                 }
//                                               },
//                                               imgStep: '3',
//                                             ),
//                                           ],
//                                         ),

//                                         SizedBox(height: 10),
//                                         // ElevatedButton(
//                                         //     onPressed: () {
//                                         //       log('loc matched tst field submit union $unionID');
//                                         //     },
//                                         //     child: Text('Tst')),

//                                         ElevatedButton(
//                                             style: ElevatedButton.styleFrom(
//                                               shape: RoundedRectangleBorder(
//                                                 borderRadius: BorderRadius.circular(7.0.r),
//                                               ),
//                                               backgroundColor: Colors.green,
//                                             ),
//                                             onPressed: () async {
//                                               log('office ID from submit  $selectedOfficeId');
//                                               log('union ID from submit  $unionID');
//                                               log('District ID from submit  $districtId');
//                                               log('Division ID  from submit  $divisionId');

//                                               log('UpazilaID  from submit  $upazilaId');
//                                               log('location id ${locationID}');
//                                               log('office title ${officeTitle}');
//                                               if (img1Path != null || img2Path != null || img3Path != null) {
//                                                 submitFieldVisit(dialogclose: 0, officeTitle: officeTitle ?? '');
//                                               } else {
//                                                 AllService().tost('Please Upload at least 1 Image up to 3 ');
//                                               }
//                                               //log('union selectedUnionForSubmit from submit  $selectedUnion');
//                                             },
//                                             child: _isLoading
//                                                 ? Center(child: AllService.LoadingToast())
//                                                 : const Row(
//                                                     mainAxisAlignment: MainAxisAlignment.center,
//                                                     children: [
//                                                       Text(
//                                                         'Submit',
//                                                         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                                                       ),
//                                                     ],
//                                                   )),
//                                         SizedBox(height: 15),
//                                       ],
//                                     );
//                                   }
//                                   return SizedBox();
//                                 }),
//                           ],
//                         ),

//                       ///If Location Not Matched
//                       if (dialogCloseValue == 1)
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(height: 10),

//                             ///Selected Office
//                             SizedBox(
//                               child: Theme(
//                                 data: Theme.of(context).copyWith(disabledColor: Colors.black),
//                                 child: DropdownButtonFormField<String>(
//                                   isExpanded: true,
//                                   value: selectedOffice,
//                                   onChanged: null,
//                                   // onChanged: (newValue) {},
//                                   items:
//                                       dialogOfficeTypeData.where((element) => element.name == selectedOffice).map<DropdownMenuItem<String>>((item) {
//                                     return DropdownMenuItem<String>(
//                                       value: item.name,
//                                       child: Text("${item.name}"),
//                                     );
//                                   }).toList(),
//                                   decoration: const InputDecoration(
//                                     contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//                                     border: OutlineInputBorder(
//                                       borderSide: BorderSide(color: Colors.black),
//                                     ),
//                                     labelText: 'Select Office',
//                                   ),
//                                   validator: (value) {
//                                     if (value == null || value.isEmpty) {
//                                       return 'Please Select Office';
//                                     }
//                                     return null;
//                                   },
//                                 ),
//                               ),
//                             ),

//                             ///Office Title
//                             Visibility(
//                               visible: selectedOffice == "Other Office",
//                               child: Column(
//                                 children: [
//                                   SizedBox(height: 10),
//                                   TextFormField(
//                                     controller: officeTitleCtrl,
//                                     maxLines: 1,
//                                     decoration: InputDecoration(
//                                       border: OutlineInputBorder(),
//                                       labelText: "Office title",
//                                       contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                     ),
//                                     readOnly: true,
//                                     validator: (value) {
//                                       if (value!.isEmpty) {
//                                         return 'Please enter office title';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 10),

//                             ///Date Controller
//                             SizedBox(
//                               height: 50.0.h,
//                               child: GestureDetector(
//                                 child: TextField(
//                                   readOnly: true,
//                                   controller: dateController,
//                                   decoration: const InputDecoration(
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(width: 1, color: Colors.black),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(width: 1, color: Colors.black),
//                                     ),
//                                     contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                     labelText: "Visit Date",
//                                     hintText: "Visit Date",
//                                     suffixIcon: Icon(Icons.calendar_today),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: 10),

//                             ///Add New Button
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Text(
//                                   "",
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                                 GestureDetector(
//                                   onTap: () async {
//                                     print('online add new office clicked');
//                                     setState(() {
//                                       // upazilaId = '';
//                                       // unionID = '';
//                                       // districtId = '';
//                                       // divisionId = '';
//                                       diagDivisionId = null;
//                                       selectedOffice = '';
//                                       diagUpazilaID = null;
//                                       diagdistrictId = null;
//                                       diagUpazilaID = null;
//                                       chngeLocDivValue = null;
//                                       chngLocDistrictVal = null;
//                                       chngLocUpazilaVal = null;
//                                       chngLocOfficeTypeVal = null;
//                                       chngLocUnionVal = null;
//                                       dialogDivision.clear();
//                                       dialogDistrict.clear();
//                                       dialogUpazila.clear();
//                                       dialogUnion.clear();
//                                       dialogOfficeTypeData.clear();
//                                       changeLocationBloc.add(ChangeLocationInitialEvent());
//                                     });
//                                     showCustomDialog();
//                                   },
//                                   child: Container(
//                                     alignment: Alignment.center,
//                                     width: 120.w,
//                                     height: 35.h,
//                                     decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.green),
//                                     child: Padding(
//                                       padding: EdgeInsets.only(left: 3.0.w, right: 3.0.w),
//                                       child: Text(
//                                         "Add New Office",
//                                         style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                             SizedBox(height: 15),
//                             //Text('Dialog Division',style: TextStyle(color: Colors.black),),
//                             ///Division District Dropdown
//                             Theme(
//                               data: Theme.of(context).copyWith(disabledColor: Colors.black),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Visibility(
//                                     visible: dialogDivision.isNotEmpty,
//                                     child: Expanded(
//                                       child: DropdownButtonFormField<String>(
//                                         isExpanded: true,
//                                         decoration: const InputDecoration(
//                                           contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                           border: OutlineInputBorder(
//                                             borderSide: BorderSide(color: Colors.black),
//                                           ),
//                                           labelText: 'Selected division',
//                                         ),
//                                         onChanged: null,
//                                         value: selectedDivision,
//                                         items: dialogDivision
//                                             .where((element) => element.divisionId.toString() == diagDivisionId)
//                                             .map<DropdownMenuItem<String>>(
//                                           (entry) {
//                                             return DropdownMenuItem<String>(
//                                               value: entry.divisionName,
//                                               child: Text(entry.divisionName ?? ""),
//                                             );
//                                           },
//                                         ).toList(),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(width: 10),
//                                   Visibility(
//                                     visible: dialogDistrict.isNotEmpty,
//                                     child: Expanded(
//                                       child: DropdownButtonFormField<String>(
//                                         isExpanded: true,
//                                         decoration: const InputDecoration(
//                                           contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                           border: OutlineInputBorder(
//                                             borderSide: BorderSide(color: Colors.black),
//                                           ),
//                                           labelText: 'Selected district',
//                                         ),
//                                         onChanged: null,
//                                         // onChanged: (newValue) {},
//                                         value: selectedDistrict,
//                                         items: dialogDistrict
//                                             .where((element) => element.districtId.toString() == diagdistrictId)
//                                             .map<DropdownMenuItem<String>>(
//                                           (entry) {
//                                             return DropdownMenuItem<String>(
//                                               value: entry.districtName,
//                                               child: Text(entry.districtName ?? ""),
//                                             );
//                                           },
//                                         ).toList(),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 10),

//                             ///Upazilla Union Dropdown
//                             Theme(
//                               data: Theme.of(context).copyWith(disabledColor: Colors.black),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Visibility(
//                                     visible: dialogUpazila.isNotEmpty,
//                                     child: Expanded(
//                                       child: DropdownButtonFormField<String>(
//                                         isExpanded: true,
//                                         decoration: const InputDecoration(
//                                           contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                           border: OutlineInputBorder(
//                                             borderSide: BorderSide(color: Colors.black),
//                                           ),
//                                           labelText: 'Selected upazila',
//                                         ),
//                                         onChanged: null,
//                                         // onChanged: (newValue) {},
//                                         value: selectedUpazila,
//                                         items: dialogUpazila
//                                             .where((element) => element.upazilaId.toString() == diagUpazilaID)
//                                             .map<DropdownMenuItem<String>>(
//                                           (entry) {
//                                             return DropdownMenuItem<String>(
//                                               value: entry.upazilaName,
//                                               child: Text(entry.upazilaName ?? ""),
//                                             );
//                                           },
//                                         ).toList(),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(width: 10),
//                                   Visibility(
//                                     visible: dialogUnion.isNotEmpty,
//                                     child: Expanded(
//                                       child: DropdownButtonFormField<String>(
//                                         isExpanded: true,
//                                         decoration: const InputDecoration(
//                                           contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                           border: OutlineInputBorder(
//                                             borderSide: BorderSide(color: Colors.black),
//                                           ),
//                                           labelText: 'Selected union',
//                                         ),
//                                         onChanged: null,
//                                         // onChanged: (newValue) {},
//                                         value: selectedUnion,
//                                         items:
//                                             dialogUnion.where((element) => element.unionId.toString() == diagUnionID).map<DropdownMenuItem<String>>(
//                                           (entry) {
//                                             return DropdownMenuItem<String>(
//                                               value: entry.unionName,
//                                               child: Text(entry.unionName ?? ""),
//                                             );
//                                           },
//                                         ).toList(),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             //here
//                             const SizedBox(height: 10),
//                             // TextFormField(
//                             //   decoration: InputDecoration(
//                             //     border: OutlineInputBorder(),
//                             //     labelText: 'Visit Purposes',
//                             //     enabledBorder: OutlineInputBorder(
//                             //       borderSide: BorderSide(width: 1, color: Colors.black),
//                             //     ),
//                             //     focusedBorder: OutlineInputBorder(
//                             //       borderSide: BorderSide(width: 1, color: Colors.black),
//                             //     ),
//                             //     // hintText: 'Visit Purposes',
//                             //     contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                             //     floatingLabelBehavior: FloatingLabelBehavior.always,
//                             //   ),
//                             //   controller: visitPurposeController,
//                             //   maxLines: 3,
//                             //   validator: (value) {
//                             //     if (value!.length > 255) {
//                             //       return 'please enter less than 256 characters';
//                             //     } else if (value.isEmpty) {
//                             //       return 'Please Enter Visit Purposes';
//                             //     }
//                             //     return null;
//                             //   },
//                             // ),

//                             SizedBox(height: 15),
//                             const Text("Filed Photo (You can add up to 3 image only)"),
//                             const SizedBox(height: 6),
//                             Wrap(
//                               alignment: WrapAlignment.start,
//                               runAlignment: WrapAlignment.start,
//                               children: [
//                                 singleImage(
//                                   img: img1,
//                                   function: () async {
//                                     CameraDataModel? camModel = await Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => CameraScreen(),
//                                         ));
//                                     if (camModel != null || camModel is CameraDataModel) {
//                                       final img = camModel.xpictureFile;
//                                       if (img != null) {
//                                         final compressedFile1 = await imageProcessing(imgFile: img!);
//                                         final byte = compressedFile1!.readAsBytesSync();
//                                         setState(() {
//                                           img1 = byte;
//                                           img1Path = compressedFile1.path;
//                                         });
//                                         log('image 1 path $img1Path');
//                                       } else {
//                                         return;
//                                       }
//                                     }
//                                   },
//                                   imgStep: '1',
//                                 ),
//                                 singleImage(
//                                   img: img2,
//                                   function: () async {
//                                     CameraDataModel? camModel = await Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => CameraScreen(),
//                                         ));
//                                     if (camModel != null || camModel is CameraDataModel) {
//                                       final img = camModel.xpictureFile;
//                                       if (img != null) {
//                                         final compressedFile1 = await imageProcessing(imgFile: img);
//                                         final byte = compressedFile1!.readAsBytesSync();
//                                         setState(() {
//                                           img2 = byte;
//                                           img2Path = compressedFile1.path;
//                                         });
//                                         log('image 2 path $img2Path');
//                                       } else {
//                                         return;
//                                       }
//                                     }
//                                   },
//                                   imgStep: '2',
//                                 ),
//                                 singleImage(
//                                   img: img3,
//                                   function: () async {
//                                     CameraDataModel? camModel = await Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => CameraScreen(),
//                                         ));
//                                     if (camModel != null || camModel is CameraDataModel) {
//                                       final img = camModel.xpictureFile;
//                                       if (img != null) {
//                                         final compressedFile1 = await imageProcessing(imgFile: img!);
//                                         final byte = compressedFile1!.readAsBytesSync();
//                                         setState(() {
//                                           img3 = byte;
//                                           img3Path = compressedFile1.path;
//                                         });
//                                         log('image 2 path $img2Path');
//                                       } else {
//                                         return;
//                                       }
//                                     }
//                                   },
//                                   imgStep: '3',
//                                 ),
//                               ],
//                             ),
//                             // GridView.builder(
//                             //   physics: const NeverScrollableScrollPhysics(),
//                             //   shrinkWrap: true,
//                             //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                             //     crossAxisCount: 3,
//                             //     crossAxisSpacing: 10,
//                             //     mainAxisSpacing: 10,
//                             //     // childAspectRatio: 1.2
//                             //   ),
//                             //   itemBuilder: (_, index) {
//                             //     if (index == 0) {
//                             //       return Material(
//                             //         color: Colors.white,
//                             //         borderRadius: BorderRadius.circular(3),
//                             //         child: InkWell(
//                             //           borderRadius: BorderRadius.circular(3),
//                             //           onTap: galleryImages!.length < 3
//                             //               ? () {
//                             //                   pickGalleryImageFromCamera().then((value) {
//                             //                     // Navigator.of(context).pop();
//                             //                   });
//                             //                 }
//                             //               : () {
//                             //                   Utils.errorSnackBar(context, "You can't add more then 3 images");
//                             //                 },
//                             //           child: Container(
//                             //             padding: const EdgeInsets.all(8),
//                             //             decoration: BoxDecoration(
//                             //               borderRadius: BorderRadius.circular(3),
//                             //               border: Border.all(color: Colors.grey.shade400),
//                             //             ),
//                             //             child: Center(
//                             //               child: Column(
//                             //                 mainAxisAlignment: MainAxisAlignment.center,
//                             //                 children: [
//                             //                   const Icon(
//                             //                     Icons.add_a_photo,
//                             //                     size: 40,
//                             //                     color: Color(0xFF3F51B5),
//                             //                   ),
//                             //                   const SizedBox(height: 5),
//                             //                   Text("${galleryImages!.length}/3")
//                             //                 ],
//                             //               ),
//                             //             ),
//                             //           ),
//                             //         ),
//                             //       );
//                             //     } else {
//                             //       return ClipRRect(
//                             //         borderRadius: BorderRadius.circular(3),
//                             //         child: Stack(
//                             //           clipBehavior: Clip.none,
//                             //           fit: StackFit.expand,
//                             //           children: [
//                             //             Container(
//                             //               decoration:
//                             //                   BoxDecoration(color: Color(0xff989eb1).withOpacity(0.4), borderRadius: BorderRadius.circular(3)),
//                             //               child: GestureDetector(
//                             //                 onTap: () {
//                             //                   Navigator.push(
//                             //                     context,
//                             //                     MaterialPageRoute(
//                             //                       builder: (context) => ShowSingleImage(imageUrl: galleryImages![index - 1].path),
//                             //                     ),
//                             //                   );
//                             //                 },
//                             //                 child: Image(
//                             //                   image: FileImage(File(galleryImages![index - 1].path)),
//                             //                   fit: BoxFit.cover,
//                             //                 ),
//                             //               ),
//                             //             ),
//                             //             Positioned(
//                             //                 right: 5,
//                             //                 top: 5,
//                             //                 child: GestureDetector(
//                             //                     onTap: () {
//                             //                       setState(() {
//                             //                         galleryImages!.removeAt(index - 1);
//                             //                       });
//                             //                     },
//                             //                     child: Container(
//                             //                       decoration: BoxDecoration(
//                             //                           shape: BoxShape.rectangle, color: Colors.red, borderRadius: BorderRadius.circular(2)),
//                             //                       child: Icon(
//                             //                         Icons.close,
//                             //                         size: 18,
//                             //                         color: Colors.white,
//                             //                       ),
//                             //                     )))
//                             //           ],
//                             //         ),
//                             //       );
//                             //     }
//                             //   },
//                             //   itemCount: galleryImages!.length + 1,
//                             // ),
//                             SizedBox(height: 10),
//                             // ElevatedButton(
//                             //     onPressed: () {
//                             //       log('tst field submit union $unionID');
//                             //       log('tst field submit dialog $dialogCloseValue');
//                             //     },
//                             //     child: Text('Tst')),
//                             // ElevatedButton(
//                             //     onPressed: () {
//                             //       log(' union ID from submit  $diagUnionID');
//                             //       log('District ID from submit  $diagdistrictId');
//                             //       log('Division ID  from submit  $diagDivisionId');
//                             //       log('loc matched tst field submit upazillaiD $diagUpazilaID');
//                             //     },
//                             //     child: Text('Tst')),
//                             ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(7.0.r),
//                                 ),
//                                 backgroundColor: Colors.green,
//                               ),
//                               onPressed: () {
//                                 log('union select from submit $unionID');
//                                 if (img1Path != null || img2Path != null || img3Path != null) {
//                                   submitFieldVisit(dialogclose: 1, officeTitle: '');
//                                 } else {
//                                   AllService().tost('Please Upload at least 1 Image (up to 3) ');
//                                 }
//                               },
//                               child: _isLoading
//                                   ? Center(child: AllService.LoadingToast())
//                                   : const Row(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         Text(
//                                           'Submit',
//                                           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                                         ),
//                                       ],
//                                     ),
//                             ),
//                             SizedBox(height: 15),
//                           ],
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           }
//           return SizedBox.shrink();
//         },
//       ),
//     );
//     // });
//   }

//   String? galleryImage;
//   String? gallerySingleImage;
//   List<File>? galleryImages = [];
//   File? fieldImage1;
//   File? fieldImage2;
//   File? fieldImage3;

//   pickGalleryImageFromCamera() async {
//     await Utils.pickSingleImageFromCamera().then((value) async {
//       if (value != null) {
//         galleryImage = value;
//         File? file = File(galleryImage!);
//         gallerySingleImage = file.path;
//         galleryImages?.add(file);
//       }
//     });
//     setState(() {});
//   }

//   Future<File?> imageProcessing({required XFile imgFile}) async {
//     final file2 = File(imgFile.path);
//     final lastIndex = file2.absolute.path.lastIndexOf(new RegExp(r'.jp'));
//     final splitted = file2.absolute.path.substring(0, (lastIndex));
//     final outPath2 = "${splitted}_out${file2.absolute.path.substring(lastIndex)}";
//     final compressedFile2 = await Utils().compressImgAndGetFile(file2, outPath2);
//     return compressedFile2;
//   }
//   //  pickGalleryImageFromCamera({required int imgNumber}) async {
//   //   final imgPath = await await Utils.pickSingleImageFromCamera();
//   //   if (imgPath != null) {
//   //     final appDir = await getApplicationDocumentsDirectory();

//   //     File? file = File(imgPath);
//   //     if (file != null) {
//   //        if (imgNumber == 1) {
//   //       fieldImage1 = file.path as File?;
//   //     }
//   //     }

//   //   }
//   //   // .then((value) async {
//   //   //   if (value != null) {
//   //   //     imgPath = value;

//   //   //     if (file != null) {
//   //   //       gallerySingleImage = file.path;
//   //   //       galleryImages?.add(file);
//   //   //     }
//   //   //   }
//   //   // });
//   //   setState(() {});
//   // }

//   showCustomDialog() {
//     officeTitleCtrl.clear();
//     remarkController.clear();

//     return showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       isDismissible: false,
//       builder: (context) {
//         log('diag unioniD $unionID');
//         log('diag upaID $upazilaId');
//         return PopScope(
//           canPop: false,
//           child: Padding(
//             padding: MediaQuery.of(context).viewInsets,
//             child: StatefulBuilder(
//               builder: (context, setState) {
//                 return Form(
//                   key: _chngLocformKeyVisitReport,
//                   child: Wrap(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
//                         padding: const EdgeInsets.all(20),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               "Select Other Office",
//                               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                             ),

//                             ///Office Dropdown

//                             SizedBox(height: 10),

//                             BlocConsumer<ChangeLocationBloc, ChangeLocationState>(
//                                 bloc: changeLocationBloc,
//                                 //listenWhen: (previous, current) => current is ChangeLocationSuccessState,
//                                 //buildWhen: (previous, current) => current is ChangeLocationSuccessState,
//                                 listener: (context, state) {
//                                   // TODO: implement listener
//                                 },
//                                 builder: (context, state) {
//                                   if (state is ChangeLocationLoadingState) {
//                                     return Container(
//                                       child: Center(child: CircularProgressIndicator()),
//                                     );
//                                   } else if (state is ChangeLocationSuccessState) {
//                                     dialogUnion = state.union;
//                                     dialogUpazila = state.upazila;
//                                     dialogDistrict = state.district;
//                                     dialogDivision = state.division;
//                                     dialogOfficeTypeData = state.officeTypeList;

//                                     return Column(
//                                       children: [
//                                         DropdownButtonFormField<OfficeTypeData>(
//                                           isExpanded: true,
//                                           decoration: const InputDecoration(
//                                               contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                               border: OutlineInputBorder(
//                                                 borderSide: BorderSide(color: Colors.black),
//                                               ),
//                                               labelText: 'Select Office',
//                                               hintText: "Select Office"),
//                                           value: chngLocOfficeTypeVal,
//                                           items: state.officeTypeList.map<DropdownMenuItem<OfficeTypeData>>((item) {
//                                             return DropdownMenuItem<OfficeTypeData>(
//                                               value: item,
//                                               onTap: () {
//                                                 log('selected office ID ${item.id}');
//                                               },
//                                               child: Text("${item.name}"),
//                                             );
//                                           }).toList(),
//                                           onChanged: (newValue) {
//                                             setState(() {
//                                               chngLocOfficeTypeVal = newValue;
//                                               selectedOffice = newValue!.name.toString();
//                                               diagOfficeTypeID = newValue.id!.toString();
//                                             });
//                                             log('Selected Office from dialog $selectedOffice');
//                                           },
//                                           validator: (value) {
//                                             if (value == null) {
//                                               return 'Please select office';
//                                             }
//                                             return null;
//                                           },
//                                         ),

//                                         /// Office Title
//                                         Visibility(
//                                           visible: selectedOffice == "Other Office",
//                                           child: Column(
//                                             children: [
//                                               SizedBox(height: 10),
//                                               TextFormField(
//                                                 controller: officeTitleCtrl,
//                                                 maxLines: 1,
//                                                 decoration: InputDecoration(
//                                                   border: OutlineInputBorder(),
//                                                   labelText: "Office title",
//                                                   contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                                 ),
//                                                 validator: (value) {
//                                                   if (value!.isEmpty) {
//                                                     return 'Please enter office title';
//                                                   }
//                                                   return null;
//                                                 },
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         SizedBox(height: 10),

//                                         ///Division Dropdown
//                                         DropdownButtonFormField<Division>(
//                                           isExpanded: true,
//                                           validator: (value) {
//                                             if (value == null) {
//                                               return 'Division is required';
//                                             }
//                                             return null;
//                                           },
//                                           decoration: const InputDecoration(
//                                             contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                             border: OutlineInputBorder(
//                                               borderSide: BorderSide(color: Colors.black),
//                                             ),
//                                             labelText: 'Select Division',
//                                           ),
//                                           value: chngeLocDivValue,
//                                           //value: state.division.isEmpty ? null : state.division[0],
//                                           onTap: () {
//                                             // setState(() {
//                                             //   state.district.clear();
//                                             //   state.upazila.clear();
//                                             //   state.union.clear();
//                                             // });
//                                           },
//                                           items: state.division.map<DropdownMenuItem<Division>>(
//                                             (entry) {
//                                               return DropdownMenuItem<Division>(
//                                                 value: entry,
//                                                 child: Text(entry.divisionName ?? ""),
//                                               );
//                                             },
//                                           ).toList(),
//                                           onChanged: (newValue) {
//                                             // state.district.clear();
//                                             // state.upazila.clear();
//                                             // state.union.clear();

//                                             setState(() {
//                                               chngLocDistrictVal = null;
//                                               chngLocUpazilaVal = null;
//                                               chngLocUnionVal = null;
//                                               chngeLocDivValue = newValue;
//                                               selectedDivision = newValue!.divisionName!;
//                                               selectedDistrict = null;

//                                               diagDivisionId = newValue.divisionId.toString();
//                                               changeLocationBloc.add(DistrictClickEvent(id: newValue.id));
//                                             });
//                                             // for (Division entry in state.division) {
//                                             //   if (selectedDivision == entry.nameEn) {
//                                             //     //divisionId = entry.divisionId.toString();
//                                             //     divisionId = entry.id.toString();
//                                             //     diagDivisionId = entry.id.toString();
//                                             //     changeLocationBloc.add(DistrictClickEvent(id: entry.id));
//                                             //   }
//                                             // }
//                                           },
//                                         ),
//                                         SizedBox(height: 10),

//                                         ///District Dropdown
//                                         Visibility(
//                                           visible: selectedOffice == 'UNO Office' ||
//                                               selectedOffice == 'DC/DDLG Office' ||
//                                               selectedOffice == 'UP Office' ||
//                                               selectedOffice == 'Other Office',
//                                           child: Column(
//                                             children: [
//                                               DropdownButtonFormField<District>(
//                                                 isExpanded: true,
//                                                 value: chngLocDistrictVal,
//                                                 //value: state.district.isEmpty ? null : state.district[0], // selectedDistrict,
//                                                 validator: (selectedOffice == 'UNO Office' ||
//                                                         selectedOffice == 'DC/DDLG Office' ||
//                                                         selectedOffice == 'UP Office')
//                                                     ? (value) {
//                                                         if (value == null) {
//                                                           return 'District is required';
//                                                         }
//                                                         return null;
//                                                       }
//                                                     : null,
//                                                 onChanged: state.district.isEmpty
//                                                     ? null
//                                                     : (entry) {
//                                                         // state.upazila.clear();
//                                                         // state.union.clear();
//                                                         setState(() {
//                                                           chngLocUpazilaVal = null;
//                                                           chngLocUnionVal = null;
//                                                           chngLocDistrictVal = entry;
//                                                           selectedDistrict = entry!.districtName;
//                                                           selectedUpazila = null;
//                                                           // for (District entry in state.district) {
//                                                           // if (selectedDistrict == entry.nameEn) {

//                                                           diagdistrictId = entry.districtId.toString();
//                                                         });
//                                                         changeLocationBloc.add(UpazilaClickEvent(id: entry?.districtId));
//                                                         // }
//                                                         //  }
//                                                       },
//                                                 items: state.district.map<DropdownMenuItem<District>>(
//                                                   (entry) {
//                                                     return DropdownMenuItem<District>(
//                                                       value: entry,
//                                                       child: Text(entry.districtName ?? ""),
//                                                     );
//                                                   },
//                                                 ).toList(),
//                                                 decoration: const InputDecoration(
//                                                   contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                                   border: OutlineInputBorder(
//                                                     borderSide: BorderSide(color: Colors.black),
//                                                   ),
//                                                   labelText: 'Select District',
//                                                 ),
//                                               ),
//                                               SizedBox(height: 10),
//                                             ],
//                                           ),
//                                         ),

//                                         ///Upazilla Dropdown
//                                         Visibility(
//                                           visible:
//                                               selectedOffice == 'UNO Office' || selectedOffice == 'Other Office' || selectedOffice == 'UP Office',
//                                           child: Column(
//                                             children: [
//                                               DropdownButtonFormField<Upazila>(
//                                                 isExpanded: true,
//                                                 value: chngLocUpazilaVal,
//                                                 //  value: state.upazila.isEmpty ? null : state.upazila[0], //selectedUpazila,
//                                                 validator: (selectedOffice == 'UNO Office' || selectedOffice == 'UP Office')
//                                                     ? (value) {
//                                                         if (value == null) {
//                                                           return 'Upazilla is required';
//                                                         }
//                                                         return null;
//                                                       }
//                                                     : null,
//                                                 onChanged: state.upazila.isEmpty
//                                                     ? null
//                                                     : (newValue) {
//                                                         setState(() {
//                                                           // chngLocDistrictVal = null;
//                                                           // chngLocUpazilaVal = null;
//                                                           chngLocUnionVal = null;
//                                                           chngLocUpazilaVal = newValue;
//                                                           selectedUpazila = newValue!.upazilaName;
//                                                           selectedUnion = null;

//                                                           diagUpazilaID = newValue!.upazilaId.toString();

//                                                           // for (Upazila entry in state.upazila) {
//                                                           //   if (selectedUpazila == entry.nameEn) {
//                                                           //     upazilaId = entry.id.toString();
//                                                           //     diagUpazilaID = entry.id.toString();
//                                                           //     changeLocationBloc.add(UnionClickEvent(id: entry.id));
//                                                           //   }
//                                                           // }
//                                                         });
//                                                         changeLocationBloc.add(UnionClickEvent(id: newValue!.upazilaId));
//                                                       },
//                                                 items: state.upazila.map<DropdownMenuItem<Upazila>>((item) {
//                                                   return DropdownMenuItem<Upazila>(
//                                                     value: item,
//                                                     child: Text(item.upazilaName ?? ""),
//                                                   );
//                                                 }).toList(),
//                                                 decoration: const InputDecoration(
//                                                   contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                                   border: OutlineInputBorder(
//                                                     borderSide: BorderSide(color: Colors.black),
//                                                   ),
//                                                   labelText: 'Select Upazila',
//                                                 ),
//                                               ),
//                                               SizedBox(height: 10),
//                                             ],
//                                           ),
//                                         ),

//                                         ///Union Dropdown
//                                         Visibility(
//                                           visible: selectedOffice == 'UP Office' || selectedOffice == 'Other Office',
//                                           child: Column(
//                                             children: [
//                                               DropdownButtonFormField<Union>(
//                                                 isExpanded: true,
//                                                 value: chngLocUnionVal,
//                                                 // value: state.union.isEmpty ? null : state.union[0], //selectedUnion,
//                                                 validator: (selectedOffice == 'UP Office')
//                                                     ? (value) {
//                                                         if (value == null) {
//                                                           return 'Union is required';
//                                                         }
//                                                         return null;
//                                                       }
//                                                     : null,
//                                                 onChanged: state.union.isEmpty
//                                                     ? null
//                                                     : (newValue) {
//                                                         setState(() {
//                                                           chngLocUnionVal = newValue;
//                                                           selectedUnion = newValue!.unionName;
//                                                           diagUnionID = newValue.unionId.toString();
//                                                           // for (Union entry in state.union) {
//                                                           //   if (selectedUnion == entry.nameEn) {
//                                                           //     unionID = entry.id.toString();
//                                                           //     diagUnionID = entry.id.toString();
//                                                           //   }
//                                                           // }
//                                                         });
//                                                         log('union from dialog $unionID');
//                                                       },
//                                                 items: state.union.map<DropdownMenuItem<Union>>((item) {
//                                                   return DropdownMenuItem<Union>(
//                                                     value: item,
//                                                     child: Text(item.unionName ?? ""),
//                                                   );
//                                                 }).toList(),
//                                                 decoration: const InputDecoration(
//                                                   contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                                   border: OutlineInputBorder(
//                                                     borderSide: BorderSide(color: Colors.black),
//                                                   ),
//                                                   labelText: 'Select Union',
//                                                 ),
//                                               ),
//                                               SizedBox(height: 10),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     );
//                                   }
//                                   return Container();
//                                 }),

//                             TextFormField(
//                               controller: remarkController,
//                               maxLines: 1,
//                               decoration: InputDecoration(
//                                 border: OutlineInputBorder(),
//                                 labelText: "Remark",
//                                 contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                               ),
//                               // validator: null,
//                               validator: (value) {
//                                 if (value!.isEmpty) {
//                                   return 'Please enter remark';
//                                 }
//                                 return null;
//                               },
//                             ),

//                             const SizedBox(
//                               height: 20,
//                             ),

//                             /// Button Section
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 // TextButton(
//                                 //     onPressed: () {
//                                 //       log('chnage location dialog diagDivisionID ${diagDivisionId.toString()}');
//                                 //       log('chnage location dialog diagDistrictID ${diagdistrictId.toString()}');
//                                 //       log('chnage location dialog diagUpazilaID ${diagUpazilaID.toString()}');
//                                 //       log('chnage location dialog diagunionID ${diagUnionID.toString()}');
//                                 //       log('chnage location dialog selectOfficeID ${diagOfficeTypeID.toString()}');
//                                 //       log('chnage location dialog officeTitle  ${officeTitleCtrl.text.toString()}');
//                                 //       log('chnage location dialog officeTitle  ${remarkController.text.toString()}');

//                                 //       //  division_id: diagDivisionId.toString(), //divisionId.toString(),
//                                 //       //         district_id: diagdistrictId.toString(),
//                                 //       //         upazila_id: diagUpazilaID.toString(),
//                                 //       //         union_id: diagUnionID.toString(),
//                                 //       //         latitude: targetLatitude.toString(),
//                                 //       //         longitude: targetLongitude.toString(),
//                                 //       //         remark: remarkController.text,
//                                 //       //         office_type_id: ,
//                                 //       //         office_title: officeTitleCtrl.text,
//                                 //     },
//                                 //     child: Text('Test')),
//                                 TextButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       diagOfficeTypeID = null;
//                                       chngeLocDivValue = null;
//                                       chngLocDistrictVal = null;
//                                       chngLocUpazilaVal = null;
//                                       chngLocUnionVal = null;
//                                       chngLocOfficeTypeVal = null;
//                                       dialogUnion.clear();
//                                       dialogUpazila.clear();
//                                       dialogDivision.clear();
//                                       dialogDistrict.clear();
//                                       changeLocationBloc.add(ChangeLocationInitialEvent());
//                                     });

//                                     dialogCloseValue = 0;
//                                     // setState(() {
//                                     //   unionID = unionID.toString();
//                                     //   divisionId = divisionId.toString();
//                                     //   districtId = districtId.toString();
//                                     //   upazilaId = upazilaId.toString();
//                                     // });
//                                     Navigator.of(context).pop(dialogCloseValue);
//                                   },
//                                   style: TextButton.styleFrom(
//                                       backgroundColor: Colors.red,
//                                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//                                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0)),
//                                   child: const Text(
//                                     'Cancel',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(width: 20),
//                                 TextButton(
//                                   onPressed: () async {
//                                     print("00000000000000000000000000000000000000000000");
//                                     final connectivityResult = await (Connectivity().checkConnectivity());
//                                     if (connectivityResult.contains(ConnectivityResult.mobile) ||
//                                         connectivityResult.contains(ConnectivityResult.wifi) ||
//                                         connectivityResult.contains(ConnectivityResult.ethernet)) {
//                                       if (_chngLocformKeyVisitReport.currentState!.validate()) {
//                                         setState(() {
//                                           isSubmitLoading = true;
//                                         });

//                                         print('111111111111000000000000000000000000000000');

//                                         await Repositores()
//                                             .addChangeLocation(
//                                           division_id: diagDivisionId.toString(), //divisionId.toString(),
//                                           district_id: diagdistrictId == null ? '' : diagdistrictId.toString(),
//                                           upazila_id: diagUpazilaID == null ? '' : diagUpazilaID.toString(),
//                                           union_id: diagUnionID == null ? '' : diagUnionID.toString(),
//                                           latitude: targetLatitude.toString(),
//                                           longitude: targetLongitude.toString(),
//                                           remark: remarkController.text,
//                                           office_type_id: diagOfficeTypeID == null ? '' : diagOfficeTypeID!,
//                                           office_title: officeTitleCtrl.text,
//                                         )
//                                             .then((value) async {
//                                           if (value.message == 'success') {
//                                             setState(
//                                               () {
//                                                 changeLocationID = value.changeLocationId;

//                                                 // diagOfficeTypeID = null;
//                                                 // chngeLocDivValue = null;
//                                                 // chngLocDistrictVal = null;
//                                                 // chngLocUpazilaVal = null;
//                                                 // chngLocUnionVal = null;
//                                               },
//                                             );
//                                             log('change location id from add new office API $changeLocationID');
//                                             log('select add new office division $selectedDivision');
//                                             log('select add new office district $selectedDistrict');
//                                             log('select add new office upazila $selectedUpazila');
//                                             log('select add new union division $selectedUnion');

//                                             // districtId = districtId.toString();
//                                             // upazilaId = upazilaId.toString();
//                                             log('diag cls val 1 $unionID');
//                                             await QuickAlert.show(
//                                               context: context,
//                                               type: QuickAlertType.success,
//                                               text: "New Visit Report Added successfully",
//                                             );
//                                             dialogCloseValue = 1;
//                                             Navigator.of(context).pop(dialogCloseValue);

//                                             setState(() {
//                                               isSubmitLoading = false;
//                                             });
//                                           } else if (value.status == 422) {
//                                             await QuickAlert.show(
//                                               context: context,
//                                               type: QuickAlertType.error,
//                                               text: value.message,
//                                             );
//                                             setState(() {
//                                               isSubmitLoading = false;
//                                             });
//                                           } else {
//                                             await QuickAlert.show(
//                                               context: context,
//                                               type: QuickAlertType.error,
//                                               text: "New Visit Report Add Failed",
//                                             );
//                                             setState(() {
//                                               isSubmitLoading = false;
//                                             });
//                                           }
//                                         });
//                                       }
//                                     } else {
//                                       AllService().internetCheckDialog(context);
//                                     }
//                                   },
//                                   style: TextButton.styleFrom(
//                                       backgroundColor: Colors.green,
//                                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//                                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0)),
//                                   child: isSubmitLoading
//                                       ? Center(
//                                           child: CircularProgressIndicator(),
//                                         )
//                                       : const Text(
//                                           'Submit',
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     ).then((value) {
//       print("asdlfkjaksd2 ${value}");
//       setState(() {});
//     });
//   }

//   singleImage({Uint8List? img, required VoidCallback function, required String imgStep}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
//       child: SizedBox(
//         height: 90,
//         width: 100,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(3),
//           child: Stack(
//             clipBehavior: Clip.none,
//             fit: StackFit.expand,
//             children: [
//               img != null
//                   ? Container(
//                       decoration: BoxDecoration(color: Color(0xff989eb1).withOpacity(0.4), borderRadius: BorderRadius.circular(3)),
//                       child: GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ShowSingleImage(
//                                 img: img,
//                                 isImgUrl: false,
//                               ),
//                             ),
//                           );
//                         },
//                         child: Image(
//                           image: MemoryImage(img),
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     )
//                   : GestureDetector(
//                       onTap: function,
//                       child: Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(3),
//                           border: Border.all(color: Colors.grey.shade400),
//                         ),
//                         child: Center(
//                           child: Icon(
//                             Icons.add_a_photo,
//                             color: Color(0xFF3F51B5),
//                             size: 40,
//                           ),
//                         ),
//                       ),
//                     ),
//               img != null
//                   ? Positioned(
//                       right: 5,
//                       top: 5,
//                       child: GestureDetector(
//                           onTap: () {
//                             if (imgStep == '1') {
//                               setState(() {
//                                 img1 = null;
//                                 img1Path = null;
//                               });
//                             } else if (imgStep == '2') {
//                               setState(() {
//                                 img2 = null;
//                                 img2Path = null;
//                               });
//                             } else if (imgStep == '3') {
//                               setState(() {
//                                 img3 = null;
//                                 img3Path = null;
//                               });
//                             }
//                           },
//                           child: Container(
//                             decoration: BoxDecoration(shape: BoxShape.rectangle, color: Colors.red, borderRadius: BorderRadius.circular(2)),
//                             child: Icon(
//                               Icons.close,
//                               size: 18,
//                               color: Colors.white,
//                             ),
//                           )))
//                   : SizedBox.shrink(),
//               img != null
//                   ? Positioned(
//                       left: 5,
//                       top: 5,
//                       child: GestureDetector(
//                           onTap: function,
//                           child: Container(
//                             decoration: BoxDecoration(shape: BoxShape.rectangle, color: Colors.green, borderRadius: BorderRadius.circular(2)),
//                             child: Icon(
//                               Icons.add,
//                               size: 18,
//                               color: Colors.white,
//                             ),
//                           )))
//                   : SizedBox.shrink()
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   submitFieldVisit({required int dialogclose, String officeTitle = ''}) async {
//     final connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult.contains(ConnectivityResult.mobile) ||
//         connectivityResult.contains(ConnectivityResult.wifi) ||
//         connectivityResult.contains(ConnectivityResult.ethernet)) {
//       if (_formKeyVisitReport.currentState!.validate()) {
//         if (targetLatitude == 0.0 && targetLongitude == 0.0) {
//           return AllService().tost("Select Current Location");
//         }

//         //  else if (visitPurposeController.text.isEmpty) {
//         //   return AllService().tost("Visit Purpose Input Required");
//         // }

//         // else if (galleryImages!.length == 0) {
//         //   return AllService().tost("Please Upload Image");
//         // }

//         List<String> imgPath = [];
//         if (img1Path != null) {
//           imgPath.add(img1Path!);
//         }
//         if (img2Path != null) {
//           imgPath.add(img2Path!);
//         }
//         if (img3Path != null) {
//           imgPath.add(img3Path!);
//         }
//         log('field submit union $unionID');
//         setState(() {
//           _isLoading = true;
//         });
//         if (dialogCloseValue == 0) {
//           // dialog is closed that means location is matched if dialogclose value is one that means user selected ADD NEW OFFICE Button
//           //if location is matched then user will upload it to the db.
//           await Repositores()
//               .uploadDataAndImage(
//                   division_id: divisionId.toString(),
//                   district_id: districtId.toString(),
//                   upazila_id: upazilaId.toString(),
//                   union_id: unionID.toString(), //selectedUnion != unionID ? selectedUnion.toString() : unionID.toString(),//unionID.toString(),
//                   latitude: targetLatitude.toString(),
//                   longitude: targetLongitude.toString(),
//                   //isit_purpose: visitPurposeController.text,
//                   office_type: selectedOfficeId!,
//                   office_title: selectedOfficeId == '4' ? officeTitle : '',
//                   location_match: '1', //locationMatched.toString(),
//                   locationID: locationID,
//                   changeLocationID: null,
//                   imageFile: null,
//                   imagesPath: imgPath
//                   //imageFile: galleryImages ?? [],
//                   )
//               .then((value) async {
//             if (value == "success") {
//               setState(() {
//                 divisionId = '';
//                 upazilaId = '';
//                 unionID = '';
//                 districtId = '';
//                 img1Path = null;
//                 img2Path = null;
//                 img3Path = null;
//                 selectedOfficeId = null;
//               });
//               //THis is a simple alert dialog to show it to the user that visit Report is added successfully

//               await QuickAlert.show(
//                 context: context,
//                 type: QuickAlertType.success,
//                 text: "Visit Report Added successfully",
//               );
//               // .then((value) {
//               // //   AllCountBloc countBloc = AllCountBloc();
//               // // countBloc.add(AllCountInitialEvent());
//               // });
//               //Popping Navigator from context
//               Navigator.pop(context);
//               // await Navigator.of(context).pushReplacement(
//               //   MaterialPageRoute(
//               //     builder: (context) {
//               //       return FieldFindingCreatePage(
//               //         id: dataResponse['data']['id'].toString(),
//               //       );
//               //     },
//               //   ),
//               // );
//               setState(() {
//                 _isLoading = false;
//               });
//             } else {
//               await QuickAlert.show(
//                 context: context,
//                 type: QuickAlertType.error,
//                 text: "Visit Report Add Failed",
//               );
//               setState(() {
//                 _isLoading = false;
//               });
//             }
//           });
//         } else {
//           //If dialogCloseValue is 1 that means user selected new office from dialog and then location match value is '1'

//           await Repositores()
//               .uploadDataAndImage(
//             division_id: diagDivisionId == null ? '' : diagDivisionId.toString(),
//             district_id: diagdistrictId == null ? '' : diagdistrictId.toString(),
//             upazila_id: diagUpazilaID == null ? '' : diagUpazilaID.toString(),
//             union_id: diagUnionID == null ? '' : diagUnionID.toString(),
//             latitude: targetLatitude.toString(),
//             longitude: targetLongitude.toString(),
//             //isit_purpose: visitPurposeController.text,
//             office_type: diagOfficeTypeID == null ? '' : diagOfficeTypeID!,
//             office_title: officeTitleCtrl.text,
//             changeLocationID: changeLocationID,
//             location_match: '0', //locationMatched.toString(),
//             imagesPath: imgPath ?? [],
//           )
//               .then((value) async {
//             if (value == "success") {
//               setState(() {
//                 diagDivisionId = '';
//                 diagUpazilaID = '';
//                 diagUnionID = '';
//                 diagdistrictId = '';
//                 diagOfficeTypeID = null;
//                 img1Path = null;
//                 img2Path = null;
//                 img3Path = null;
//               });
//               await QuickAlert.show(
//                 context: context,
//                 type: QuickAlertType.success,
//                 text: "Visit Report Added successfully",
//               );
//               Navigator.pop(context);
//               // await Navigator.of(context).pushReplacement(
//               //   MaterialPageRoute(
//               //     builder: (context) {
//               //       return FieldFindingCreatePage(
//               //         id: dataResponse['data']['id'].toString(),
//               //       );
//               //     },
//               //   ),
//               // );
//               setState(() {
//                 _isLoading = false;
//               });
//             } else {
//               await QuickAlert.show(
//                 context: context,
//                 type: QuickAlertType.error,
//                 text: "Visit Report Add Failed",
//               );
//               setState(() {
//                 _isLoading = false;
//               });
//             }
//           });
//         }
//       }
//     } else {
//       AllService().internetCheckDialog(context);
//     }
//   }
// }

// class AddChangeLocationSubmitDiagModel {
//   final String? divisionID;
//   final String? districtID;
//   final String? upazilaID;
//   final String? unionID;
//   final String? remark;
//   final String? officeTypeID;
//   final String? officeTitle;
//   final String changeLocationID;
//   final int dialogCloseValue;

//   AddChangeLocationSubmitDiagModel({
//     this.divisionID,
//     this.districtID,
//     this.upazilaID,
//     this.unionID,
//     this.remark,
//     this.officeTypeID,
//     this.officeTitle,
//     required this.changeLocationID,
//     required this.dialogCloseValue,
//   });
// }
