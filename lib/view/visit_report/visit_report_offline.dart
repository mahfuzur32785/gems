// import 'dart:async';
// import 'package:dartx/dartx.dart';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';
// import 'dart:developer' as dev;
// import 'dart:typed_data';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:quickalert/models/quickalert_type.dart';
// import 'package:quickalert/widgets/quickalert_dialog.dart';
// import 'package:village_court_gems/bloc/Change_Location_bloc/change_location_bloc.dart';
// import 'package:village_court_gems/bloc/Location_Bloc/location_bloc.dart';
// import 'package:village_court_gems/camera_widget/camera_model.dart';
// import 'package:village_court_gems/camera_widget/camera_widget.dart';
// import 'package:village_court_gems/controller/Local_store_controller/local_store.dart';
// import 'package:village_court_gems/controller/repository/repository.dart';
// import 'package:village_court_gems/models/Local_store_model/field_submit_local.dart';
// import 'package:village_court_gems/models/Local_store_model/save_field_visit_model.dart';
// // import 'package:village_court_gems/models/activityDetailsModel.dart';
// import 'package:village_court_gems/models/area_model/all_district_model.dart';
// import 'package:village_court_gems/models/area_model/all_location_data.dart';
// import 'package:village_court_gems/models/locationModel.dart';
// import 'package:village_court_gems/provider/connectivity_provider.dart';
// import 'package:village_court_gems/services/all_services/all_services.dart';
// import 'package:village_court_gems/services/database/localDatabaseService.dart';
// import 'package:village_court_gems/util/constant.dart';
// import 'package:village_court_gems/util/utils.dart';
// import 'package:village_court_gems/view/visit_report/show_image.dart';
// import 'package:village_court_gems/view/visit_report/visit_report_online.dart';

// class VisitReportOffline extends StatefulWidget {
//   const VisitReportOffline({super.key});

//   @override
//   State<VisitReportOffline> createState() => _VisitReportOfflineState();
// }

// class _VisitReportOfflineState extends State<VisitReportOffline> {
//   final GlobalKey<FormState> _formKeyVisitReport = GlobalKey<FormState>();
//   final officeTitleCtrl = TextEditingController();
//   final dateController = TextEditingController();
//   String? selectedOffice;
//   int dialogCloseValue = 0;
//   final GlobalKey<FormState> _localChngeLocation = GlobalKey<FormState>();
//   List<Division> storeDivisionData = [];
//   List<Division> dropdownDivisionData = [];
//   Division? division;
//   String? selectedDivision;
//   String? selectedDivisionId;

//   List<District> storeDistrictData = [];
//   List<District> dropdownDistrictData = [];
//   District? district;
//   String? selectedDistrict;
//   String? selectedDistrictId;

//   List<Upazila> storeUpazilaData = [];
//   List<Upazila> dropdownUpazilaData = [];
//   Upazila? upazila;
//   String? selectedUpazila;
//   String? selectedUpazilaId;
//   final ChangeLocationBloc changeLocationBloc = ChangeLocationBloc();
//   List<Union> storeUnionData = [];
//   List<Union> dropdownUnionData = [];
//   Union? union;
//   String? selectedUnion;
//   String? selectedUnionId;

//   String? divisionId = '';
//   String? districtId = '';
//   String? upazilaId = '';
//   String? unionID = '';
//   List<Division> uniqueDivisionData = [];
//   List<District> uniqueDistrictData = [];
//   List<Upazila> uniqueUpazilaData = [];
//   List<Union> uniqueUnionData = [];

//   List<Division> nearestDivisionData = [];
//   List<District> nearestDistrictData = [];
//   List<Upazila> nearestUpazilaData = [];
//   List<Union> nearestUnionData = [];

//   List<AllLocationData> lDivisionData = [];
//   List<AllLocationData> lDistrictData = [];
//   List<AllLocationData> lUpazillaData = [];
//   List<AllLocationData> lUnionData = [];

//   Uint8List? img1;
//   Uint8List? img2;
//   Uint8List? img3;
//   String? img1Path;
//   String? img2Path;
//   String? img3Path;
//   // late GoogleMapController mapController;
//   // LocationData? currentLocation;
//   // Location location = Location();
//   Completer<GoogleMapController> mapControllerCompleter = Completer();
//   TextEditingController remarkController = TextEditingController();
//   bool isLoading = false;
//   bool isSubmitBtnLoading = false;
//   bool isOfficeAddFromDialog = false;
//   bool isLocationMatched = false;
//   String? locationMatchedValue;

//   double targetLatitude = 0.0;
//   double targetLongitude = 0.0;
//   String currentAddress = "";
//   LocalStore localStore = LocalStore();

//   @override
//   void initState() {
//     getCachedData();
//     changeLocationBloc.add(ChangeLocationInitialEvent());

//     super.initState();
//     //networkChange();
//     //backupData();
//   }

//   // networkChange() async {
//   //   final cp = Provider.of<ConnectivityProvider>(context, listen: false);
//   //   cp.networkChange(context: context);
//   // }

//   getCachedData() async {
//     dateController.text = Utils.formatDate(DateTime.now());
//     // storeDivisionData = await Helper().getDivisionData();
//     // storeDistrictData = await Helper().getDistrictData();
//     // storeUpazilaData = await Helper().getUpazilaData();
//     // storeUnionData = await Helper().getUnionData();
//     LocalStore loc = LocalStore();
//     var alllist = loc.allLocationBox.values.toList();
//     var allDivisionData = alllist.where((element) => element.districtId == null && element.upazilaId == null && element.unionId == null);
//     lDivisionData = allDivisionData.toList();
//     // allDivisionData.forEach((element) {
//     //   dropdownDivisionData.add(Division(id: element.id, divisionName: element.nameEn, divisionId: element.divisionId));
//     // });

//     var districtList =
//         alllist.where((element) => element.upazilaId == null && element.unionId == null && element.divisionId != null && element.districtId != null);
//     lDistrictData = districtList.toList();
//     // districtList.forEach((element) {
//     //   dropdownDistrictData.add(District(id: element.id, districtName: element.nameEn, districtId: element.divisionId));
//     // });
//     var upazillaList = alllist.where((element) => element.unionId == null);
//     lUpazillaData = upazillaList.toList();
//     // upazillaList.forEach((element) {
//     //   dropdownUpazilaData.add(Upazila(id: element.id, upazilaName: element.nameEn, upazilaId: element.upazilaId));
//     // });
//     var unionList =
//         alllist.where((element) => element.divisionId != null && element.districtId != null && element.upazilaId != null && element.unionId != null);
//     lUnionData = unionList.toList();
//     // unionList.forEach((element) {
//     //   dropdownUnionData.add(Union(id: element.id, unionId: element.unionId, unionName: element.nameEn));
//     // });
//   }

//   cancelconsub() {
//     Provider.of<ConnectivityProvider>(context, listen: false).clearConnectivitySubscription();
//   }

//   backupData() async {
//     //final connectivityProvider = Provider.of<ConnectivityProvider>(context);
//     //if (connectivityProvider.isConnected) {
//     print('network check success isconnected');

//    // await Provider.of<ConnectivityProvider>(context, listen: true).changeLocationAutoSync(context: context);
//    // await Provider.of<ConnectivityProvider>(context, listen: true).fieldSubmitAutoSync(context: context);
//     //} else {
//     // print('network check success is not connected');
//     //}
//   }

//   @override
//   void dispose() {
//     //cancelconsub();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("askdfhjdasf ${isLocationMatched}");
//     print("askdfhjdasf ${isOfficeAddFromDialog}");
//     // print('network check from UI ${Provider.of<ConnectivityProvider>(
//     //   context,
//     // ).isConnected}');
//     // backupData();
//    // return Consumer<ConnectivityProvider>(builder: (context, cp, child) {
//       return Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               icon: const Icon(Icons.arrow_back)),
//           centerTitle: true,
//           title: Text(
//             "New Field Visit Track Offline",
//             style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
//           ),
//         ),
//         body: 
//         // cp.backUpFieldSubmitProcessing
//         //     ? Center(
//         //         child: Column(
//         //           mainAxisAlignment: MainAxisAlignment.center,
//         //           crossAxisAlignment: CrossAxisAlignment.center,
//         //           children: [
//         //             //AnimatedIcon(icon: AnimatedIcons.list_view, progress: progress)
//         //             SizedBox(
//         //                 height: 70,
//         //                 width: 70,
//         //                 child: CircularProgressIndicator(
//         //                   color: Colors.green,
//         //                   strokeWidth: 10,
//         //                 )),
//         //             Text(
//         //               " Data is synchronizing, please wait!",
//         //               style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
//         //             ),
//         //           ],
//         //         ),
//         //       )
//         //     : cp.isConnected
//         //         ? Center(
//         //             child: Column(
//         //               children: [
//         //                 Text('You are currently Online'),
//         //                 ElevatedButton(
//         //                     style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
//         //                     onPressed: () async {
//         //                       await backupData();
//         //                     },
//         //                     child: Text('Data  Sync')),
//         //                 SizedBox(
//         //                   height: 10,
//         //                 ),
//         //                 ElevatedButton(
//         //                     style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
//         //                     onPressed: () async {
//         //                       Navigator.pushReplacement(
//         //                           context,
//         //                           MaterialPageRoute(
//         //                             builder: (context) => VisitReportOnline(),
//         //                           ));
//         //                     },
//         //                     child: Text('Online Page'))
//         //               ],
//         //             ),
//         //           )
//         //         : 
//                 SingleChildScrollView(
//                     child: Form(
//                       key: _formKeyVisitReport,
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             ///Find Button Section
//                             Center(
//                               child: SizedBox(
//                                 width: 330.w,
//                                 height: 40.h,
//                                 child: ElevatedButton(
//                                     style: ElevatedButton.styleFrom(
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(7.0.r),
//                                       ),
//                                       backgroundColor: Colors.green,
//                                     ),
//                                     onPressed: () async {
//                                       setState(() {
//                                         isOfficeAddFromDialog = false;
//                                         isLocationMatched = false;
//                                         dialogCloseValue = 0;
//                                         locationMatchedValue = '0';
//                                       });
//                                       // setState(() {
//                                       //   isOfficeAddFromDialog = false;
//                                       //   isLocationMatched = false;
//                                       //   selectedDistrict = null;
//                                       //   districtId = null;
//                                       //   divisionId = null;
//                                       //   unionID = null;
//                                       //   selectedOffice = null;
//                                       //   upazilaId = null;
//                                       //   selectedDivision = null;
//                                       //   selectedUpazila = null;
//                                       //   selectedUnion = null;
//                                       // });
//                                       // await initLocation();
//                                       _getCurrentLocation();
//                                       // if (!isLocationMatched) {
//                                       //   showCustomDialog();
//                                       // }
//                                     },
//                                     child: isLoading
//                                         ? CircularProgressIndicator(
//                                             color: Colors.white,
//                                           ) // Show the indicator when loading
//                                         : Row(
//                                             mainAxisAlignment: MainAxisAlignment.center,
//                                             children: [
//                                               const Text(
//                                                 "Find Nearby Office",
//                                                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                                               ),
//                                             ],
//                                           )),
//                               ),
//                             ),
//                             SizedBox(height: 10),
//                             Text(
//                               "My Location ",
//                               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
//                             ),
//                             Text(
//                               'Latitude: ${targetLatitude}, Longitude: ${targetLongitude}',
//                               style: TextStyle(fontSize: 15.0),
//                             ),
//                             SizedBox(height: 10),

//                             ///Map View Section
//                             Container(
//                               height: 150,
//                               child: GoogleMap(
//                                   onMapCreated: (GoogleMapController controller) {
//                                     mapControllerCompleter.complete(controller);
//                                   },
//                                   initialCameraPosition: CameraPosition(
//                                     target: LatLng(
//                                       targetLatitude,
//                                       targetLongitude,
//                                     ),
//                                     zoom: 14.0,
//                                   ),
//                                   markers: {
//                                     Marker(
//                                       markerId: MarkerId("MyLocation"),
//                                       position: LatLng(
//                                         targetLatitude,
//                                         targetLongitude,
//                                       ),
//                                       infoWindow: InfoWindow(title: "My Location"),
//                                     ),
//                                   }),
//                             ),
//                             SizedBox(height: 10),

//                             ///After New Field Added. Location not matched
//                             // if (isOfficeAddFromDialog)
//                             //   Column(
//                             //     children: [
//                             //       ///Selected Office
//                             //       SizedBox(
//                             //         child: Theme(
//                             //           data: Theme.of(context).copyWith(disabledColor: Colors.black),
//                             //           child: DropdownButtonFormField<String>(
//                             //             isExpanded: true,
//                             //             value: selectedOffice,
//                             //             onChanged: null,
//                             //             // onChanged: (newValue) {},
//                             //             items: officeList.where((element) => element["name"] == selectedOffice).map<DropdownMenuItem<String>>((item) {
//                             //               return DropdownMenuItem<String>(
//                             //                 value: item["name"],
//                             //                 child: Text("${item["name"]}"),
//                             //               );
//                             //             }).toList(),
//                             //             decoration: const InputDecoration(
//                             //               contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//                             //               border: OutlineInputBorder(
//                             //                 borderSide: BorderSide(color: Colors.black),
//                             //               ),
//                             //               labelText: 'Select Office',
//                             //             ),
//                             //             validator: (value) {
//                             //               if (value == null || value.isEmpty) {
//                             //                 return 'Please Select Office';
//                             //               }
//                             //               return null;
//                             //             },
//                             //           ),
//                             //         ),
//                             //       ),

//                             //       ///Office Title
//                             //       Visibility(
//                             //         visible: selectedOffice == "Other Office",
//                             //         child: Column(
//                             //           children: [
//                             //             SizedBox(height: 10),
//                             //             TextFormField(
//                             //               controller: officeTitleCtrl,
//                             //               maxLines: 1,
//                             //               decoration: InputDecoration(
//                             //                 border: OutlineInputBorder(),
//                             //                 labelText: "Office title",
//                             //                 contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                             //               ),
//                             //               readOnly: true,
//                             //               validator: (value) {
//                             //                 if (value!.isEmpty) {
//                             //                   return 'Please enter office title';
//                             //                 }
//                             //                 return null;
//                             //               },
//                             //             ),
//                             //           ],
//                             //         ),
//                             //       ),
//                             //       const SizedBox(height: 10),

//                             //       ///Date Controller
//                             //       SizedBox(
//                             //         height: 50.0.h,
//                             //         child: GestureDetector(
//                             //           child: TextField(
//                             //             readOnly: true,
//                             //             controller: dateController,
//                             //             decoration: const InputDecoration(
//                             //               enabledBorder: OutlineInputBorder(
//                             //                 borderSide: BorderSide(width: 1, color: Colors.black),
//                             //               ),
//                             //               focusedBorder: OutlineInputBorder(
//                             //                 borderSide: BorderSide(width: 1, color: Colors.black),
//                             //               ),
//                             //               contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                             //               labelText: "Visit Date",
//                             //               hintText: "Visit Date",
//                             //               suffixIcon: Icon(Icons.calendar_today),
//                             //             ),
//                             //           ),
//                             //         ),
//                             //       ),
//                             //       SizedBox(height: 10),

//                             //       ///Add New Button
//                             //       Row(
//                             //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             //         children: [
//                             //           const Text(
//                             //             "",
//                             //             style: TextStyle(fontWeight: FontWeight.bold),
//                             //           ),
//                             //           GestureDetector(
//                             //             onTap: () async {
//                             //               showCustomDialog();
//                             //             },
//                             //             child: Container(
//                             //               alignment: Alignment.center,
//                             //               width: 120.w,
//                             //               height: 35.h,
//                             //               decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.green),
//                             //               child: Padding(
//                             //                 padding: EdgeInsets.only(left: 3.0.w, right: 3.0.w),
//                             //                 child: Text(
//                             //                   "Add New Office",
//                             //                   style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//                             //                 ),
//                             //               ),
//                             //             ),
//                             //           )
//                             //         ],
//                             //       ),
//                             //       SizedBox(height: 15),

//                             //       ///Division District Dropdown
//                             //       //Text('${jsonEncode(uniqueDivisionData)}'),
//                             //       Theme(
//                             //         data: Theme.of(context).copyWith(disabledColor: Colors.black),
//                             //         child: Row(
//                             //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             //           children: [
//                             //             Visibility(
//                             //               visible: uniqueDivisionData.isNotEmpty,
//                             //               child: Expanded(
//                             //                 child: DropdownButtonFormField<String>(
//                             //                   isExpanded: true,
//                             //                   decoration: const InputDecoration(
//                             //                     contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                             //                     border: OutlineInputBorder(
//                             //                       borderSide: BorderSide(color: Colors.black),
//                             //                     ),
//                             //                     labelText: 'Selected division',
//                             //                   ),
//                             //                   onChanged: (value) {},
//                             //                   value: selectedDivision,
//                             //                   items: uniqueDivisionData
//                             //                       .map((e) => DropdownMenuItem(
//                             //                           value: selectedDivision,
//                             //                           child: Text(
//                             //                             e.divisionName!,
//                             //                             style: TextStyle(color: Colors.black),
//                             //                           )))
//                             //                       .toList(),
//                             //                   // items: dropdownDivisionData
//                             //                   //     .where((element) =>
//                             //                   //         element.id.toString() ==
//                             //                   //         selectedDivisionId)
//                             //                   //     .map<DropdownMenuItem<String>>(
//                             //                   //   (entry) {
//                             //                   //     return DropdownMenuItem<String>(
//                             //                   //       value: entry.nameEn,
//                             //                   //       child: Text(entry.nameEn ?? ""),
//                             //                   //     );
//                             //                   //   },
//                             //                   //).toList(),
//                             //                 ),
//                             //               ),
//                             //             ),
//                             //             SizedBox(width: 10),
//                             //             Visibility(
//                             //               visible: dropdownDistrictData.isNotEmpty,
//                             //               child: Expanded(
//                             //                 child: DropdownButtonFormField<String>(
//                             //                   isExpanded: true,
//                             //                   decoration: const InputDecoration(
//                             //                     contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                             //                     border: OutlineInputBorder(
//                             //                       borderSide: BorderSide(color: Colors.black),
//                             //                     ),
//                             //                     labelText: 'Selected district',
//                             //                   ),
//                             //                   onChanged: null,
//                             //                   // onChanged: (newValue) {},
//                             //                   value: selectedDistrict,
//                             //                   items: dropdownDistrictData
//                             //                       .where((element) => element.id.toString() == selectedDistrictId)
//                             //                       .map<DropdownMenuItem<String>>(
//                             //                     (entry) {
//                             //                       return DropdownMenuItem<String>(
//                             //                         value: entry.nameEn,
//                             //                         child: Text(entry.nameEn ?? ""),
//                             //                       );
//                             //                     },
//                             //                   ).toList(),
//                             //                 ),
//                             //               ),
//                             //             ),
//                             //           ],
//                             //         ),
//                             //       ),
//                             //       const SizedBox(height: 10),

//                             //       ///Upazilla Union Dropdown
//                             //       Theme(
//                             //         data: Theme.of(context).copyWith(disabledColor: Colors.black),
//                             //         child: Row(
//                             //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             //           children: [
//                             //             Visibility(
//                             //               visible: dropdownUpazilaData.isNotEmpty,
//                             //               child: Expanded(
//                             //                 child: DropdownButtonFormField<String>(
//                             //                   isExpanded: true,
//                             //                   decoration: const InputDecoration(
//                             //                     contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                             //                     border: OutlineInputBorder(
//                             //                       borderSide: BorderSide(color: Colors.black),
//                             //                     ),
//                             //                     labelText: 'Selected upazila',
//                             //                   ),
//                             //                   onChanged: null,
//                             //                   // onChanged: (newValue) {},
//                             //                   value: selectedUpazila,
//                             //                   items: dropdownUpazilaData
//                             //                       .where((element) => element.id.toString() == selectedUpazilaId)
//                             //                       .map<DropdownMenuItem<String>>(
//                             //                     (entry) {
//                             //                       return DropdownMenuItem<String>(
//                             //                         value: entry.nameEn,
//                             //                         child: Text(entry.nameEn ?? ""),
//                             //                       );
//                             //                     },
//                             //                   ).toList(),
//                             //                 ),
//                             //               ),
//                             //             ),
//                             //             SizedBox(width: 10),
//                             //             Visibility(
//                             //               visible: dropdownUnionData.isNotEmpty,
//                             //               child: Expanded(
//                             //                 child: DropdownButtonFormField<String>(
//                             //                   isExpanded: true,
//                             //                   decoration: const InputDecoration(
//                             //                     contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                             //                     border: OutlineInputBorder(
//                             //                       borderSide: BorderSide(color: Colors.black),
//                             //                     ),
//                             //                     labelText: 'Selected union',
//                             //                   ),
//                             //                   onChanged: null,
//                             //                   // onChanged: (newValue) {},
//                             //                   value: selectedUnion,
//                             //                   items: dropdownUnionData
//                             //                       .where((element) => element.id.toString() == selectedUnionId)
//                             //                       .map<DropdownMenuItem<String>>(
//                             //                     (entry) {
//                             //                       return DropdownMenuItem<String>(
//                             //                         value: entry.nameEn,
//                             //                         child: Text(entry.nameEn ?? ""),
//                             //                       );
//                             //                     },
//                             //                   ).toList(),
//                             //                 ),
//                             //               ),
//                             //             ),
//                             //           ],
//                             //         ),
//                             //       ),
//                             //     ],
//                             //   ),

//                             ///IF Location Matched
//                             if (isLocationMatched)
//                               // Text('offline location matched true'),
//                               Column(
//                                 children: [
//                                   ///Selected Office
//                                   // Text('offline location matched true'),
//                                   SizedBox(
//                                     child: Theme(
//                                       data: Theme.of(context).copyWith(disabledColor: Colors.black),
//                                       child: DropdownButtonFormField<String>(
//                                         isExpanded: true,
//                                         value: selectedOffice,
//                                         onChanged: (value) {},
//                                         items: officeList.where((element) => element["name"] == selectedOffice).map<DropdownMenuItem<String>>((item) {
//                                           return DropdownMenuItem<String>(
//                                             value: item["name"],
//                                             child: Text("${item["name"]}"),
//                                           );
//                                         }).toList(),
//                                         decoration: const InputDecoration(
//                                           contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//                                           border: OutlineInputBorder(
//                                             borderSide: BorderSide(color: Colors.black),
//                                           ),
//                                           labelText: 'Select Office',
//                                         ),
//                                         validator: (value) {
//                                           if (value == null || value.isEmpty) {
//                                             return 'Please Select Office';
//                                           }
//                                           return null;
//                                         },
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 10),

//                                   ///Date Controller
//                                   SizedBox(
//                                     height: 50.0.h,
//                                     child: GestureDetector(
//                                       child: TextField(
//                                         readOnly: true,
//                                         controller: dateController,
//                                         decoration: const InputDecoration(
//                                           enabledBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(width: 1, color: Colors.black),
//                                           ),
//                                           focusedBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(width: 1, color: Colors.black),
//                                           ),
//                                           contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                           labelText: "Visit Date",
//                                           hintText: "Visit Date",
//                                           suffixIcon: Icon(Icons.calendar_today),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(height: 10),

//                                   ///Add New Button
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       const Text(
//                                         "",
//                                         style: TextStyle(fontWeight: FontWeight.bold),
//                                       ),
//                                       GestureDetector(
//                                         onTap: () async {
//                                           dev.log('Hello From add new office');
//                                           clearAllValue();
//                                           showCustomDialog();
//                                         },
//                                         child: Container(
//                                           alignment: Alignment.center,
//                                           width: 120.w,
//                                           height: 35.h,
//                                           decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.green),
//                                           child: Padding(
//                                             padding: EdgeInsets.only(left: 3.0.w, right: 3.0.w),
//                                             child: Text(
//                                               "Add New Office",
//                                               style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//                                             ),
//                                           ),
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                   SizedBox(height: 15),

//                                   ///Division District Dropdown
//                                   dialogCloseValue == 0
//                                       ? Column(
//                                           children: [
//                                             Row(
//                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                               children: [
//                                                 Theme(
//                                                   data: Theme.of(context).copyWith(disabledColor: Colors.black),
//                                                   child: Visibility(
//                                                     visible: uniqueDivisionData.isNotEmpty,
//                                                     child: Expanded(
//                                                       child: DropdownButtonFormField<String>(
//                                                         isExpanded: true,
//                                                         decoration: const InputDecoration(
//                                                           contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                                           border: OutlineInputBorder(
//                                                             borderSide: BorderSide(color: Colors.black),
//                                                           ),
//                                                           labelText: 'Selected division',
//                                                         ),
//                                                         // onChanged: null,
//                                                         onChanged: (value) {},
//                                                         value: uniqueDivisionData.first.divisionName,
//                                                         // value: selectedDivision,
//                                                         items: uniqueDivisionData.map<DropdownMenuItem<String>>(
//                                                           (entry) {
//                                                             return DropdownMenuItem<String>(
//                                                               onTap: () {
//                                                                 print('selected offline division ${entry.divisionId} - ${entry.divisionName}');
//                                                               },
//                                                               value: entry.divisionName,
//                                                               child: Text(entry.divisionName ?? ""),
//                                                             );
//                                                           },
//                                                         ).toList(),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 SizedBox(width: 10),
//                                                 Theme(
//                                                   data: Theme.of(context).copyWith(disabledColor: Colors.black),
//                                                   child: Visibility(
//                                                     visible: uniqueDistrictData.isNotEmpty,
//                                                     child: Expanded(
//                                                       child: DropdownButtonFormField<String>(
//                                                         isExpanded: true,
//                                                         decoration: const InputDecoration(
//                                                           contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                                           border: OutlineInputBorder(
//                                                             borderSide: BorderSide(color: Colors.black),
//                                                           ),
//                                                           disabledBorder: OutlineInputBorder(
//                                                             borderSide: BorderSide(color: Colors.black),
//                                                           ),
//                                                           labelText: 'Selected district',
//                                                         ),
//                                                         // onChanged: null,
//                                                         onChanged: (value) {},

//                                                         value: uniqueDistrictData.first.districtName,
//                                                         // value: uniqueDistrictData.isNotEmpty
//                                                         //     ? uniqueDistrictData[0].nameEn
//                                                         //     : null,
//                                                         // value: selectedDistrict,
//                                                         items: uniqueDistrictData
//                                                             .distinctBy((element) => element.districtId)
//                                                             .map<DropdownMenuItem<String>>(
//                                                           (entry) {
//                                                             return DropdownMenuItem<String>(
//                                                               onTap: () {
//                                                                 print('selected offline district ${entry.districtId} - ${entry.districtName}');
//                                                               },
//                                                               value: entry.districtName,
//                                                               child: Text(
//                                                                 entry.districtName ?? "",
//                                                                 style: TextStyle(color: Colors.black),
//                                                               ),
//                                                             );
//                                                           },
//                                                         ).toList(),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             const SizedBox(height: 10),

//                                             ///Upazilla Union Dropdown
//                                             Row(
//                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                               children: [
//                                                 uniqueUpazilaData.isNotEmpty
//                                                     ? Theme(
//                                                         data: Theme.of(context).copyWith(disabledColor: Colors.black),
//                                                         child: Visibility(
//                                                           visible: uniqueUpazilaData.isNotEmpty,
//                                                           child: Expanded(
//                                                             child: DropdownButtonFormField<String>(
//                                                               isExpanded: true,
//                                                               decoration: const InputDecoration(
//                                                                 contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                                                 border: OutlineInputBorder(
//                                                                   borderSide: BorderSide(color: Colors.black),
//                                                                 ),
//                                                                 labelText: 'Selected upazila',
//                                                               ),
//                                                               // onChanged: null,
//                                                               onChanged: (value) {},

//                                                               // value: uniqueUpazilaData.isNotEmpty
//                                                               //     ? uniqueUpazilaData[0].nameEn
//                                                               //     : null,
//                                                               value: uniqueUpazilaData.first.upazilaName,
//                                                               items: uniqueUpazilaData.toSet().toList().map<DropdownMenuItem<String>>(
//                                                                 (entry) {
//                                                                   return DropdownMenuItem<String>(
//                                                                     onTap: () {
//                                                                       print('selected offline union ${entry.upazilaId} - ${entry.upazilaName}');
//                                                                     },
//                                                                     value: entry.upazilaName,
//                                                                     child: Text(entry.upazilaName ?? ""),
//                                                                   );
//                                                                 },
//                                                               ).toList(),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       )
//                                                     : SizedBox.shrink(),
//                                                 SizedBox(width: 10),
//                                                 Visibility(
//                                                   visible: uniqueUnionData.isNotEmpty,
//                                                   child: Expanded(
//                                                     child: DropdownButtonFormField<String>(
//                                                       isExpanded: true,
//                                                       decoration: const InputDecoration(
//                                                         contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                                         border: OutlineInputBorder(
//                                                           borderSide: BorderSide(color: Colors.black),
//                                                         ),
//                                                         labelText: 'Selected union',
//                                                       ),
//                                                       // onChanged: null,
//                                                       onChanged: (newValue) {},
//                                                       //value: null,
//                                                       value: uniqueUnionData.isNotEmpty ? uniqueUnionData[0].nameEn : null,
//                                                       items: uniqueUnionData.map<DropdownMenuItem<String>>(
//                                                         (entry) {
//                                                           return DropdownMenuItem<String>(
//                                                             onTap: () {
//                                                               print('selected offline union ${entry.unionId} - ${entry.unionName}');
//                                                               setState(() {
//                                                                 unionID = entry.unionId.toString();
//                                                               });
//                                                             },
//                                                             value: entry.unionName,
//                                                             child: Text(entry.unionName ?? ""),
//                                                           );
//                                                         },
//                                                       ).toList(),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         )
//                                       : Column(
//                                           children: [
//                                             Row(
//                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                               children: [
//                                                 Expanded(
//                                                   child: Padding(
//                                                     padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8),
//                                                     child: TextField(
//                                                       controller: TextEditingController(text: '$selectedDivision'),
//                                                       readOnly: true,
//                                                       decoration: const InputDecoration(
//                                                         labelText: 'Division',
//                                                         contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 7),
//                                                         border: OutlineInputBorder(),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Expanded(
//                                                   child: Padding(
//                                                     padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8),
//                                                     child: TextField(
//                                                       controller: TextEditingController(text: '$selectedDistrict'),
//                                                       readOnly: true,
//                                                       decoration: const InputDecoration(
//                                                         labelText: 'District',
//                                                         contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 7),
//                                                         border: OutlineInputBorder(),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             Row(
//                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                               children: [
//                                                 selectedUpazila == null
//                                                     ? SizedBox.shrink()
//                                                     : Expanded(
//                                                         child: Padding(
//                                                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                                                           child: TextField(
//                                                             controller: TextEditingController(text: '$selectedUpazila'),
//                                                             readOnly: true,
//                                                             decoration: const InputDecoration(
//                                                               labelText: 'Upazilla',
//                                                               contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 7),
//                                                               border: OutlineInputBorder(),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                 selectedUnion == null
//                                                     ? SizedBox.shrink()
//                                                     : Expanded(
//                                                         child: Padding(
//                                                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                                                           child: TextField(
//                                                             controller: TextEditingController(text: '$selectedUnion'),
//                                                             readOnly: true,
//                                                             decoration: const InputDecoration(
//                                                               labelText: 'Union',
//                                                               contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 7),
//                                                               border: OutlineInputBorder(),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                 ],
//                               ),

//                             if (isOfficeAddFromDialog || isLocationMatched)
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   SizedBox(height: 15),
//                                   const Text("Filed Photo (You can add up to 3 image only)"),
//                                   const SizedBox(height: 6),
//                                   Wrap(
//                                     alignment: WrapAlignment.start,
//                                     runAlignment: WrapAlignment.start,
//                                     children: [
//                                       singleImage(
//                                         img: img1,
//                                         imgStep: '1',
//                                         function: () async {
//                                           CameraDataModel? camModel = await Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (context) => CameraScreen(),
//                                               ));
//                                           if (camModel != null || camModel is CameraDataModel) {
//                                             final img = camModel.xpictureFile;
//                                             final file = File(img!.path);
//                                             final lastIndex = file.absolute.path.lastIndexOf(new RegExp(r'.jp'));
//                                             final splitted = file.absolute.path.substring(0, (lastIndex));
//                                             final outPath = "${splitted}_out${file.absolute.path.substring(lastIndex)}";
//                                             final compressedFile1 = await Utils().compressImgAndGetFile(file, outPath);
//                                             final byte = compressedFile1!.readAsBytesSync();
//                                             setState(() {
//                                               img1 = byte;
//                                               img1Path = compressedFile1.path;
//                                             });
//                                             dev.log('image 1 path $img1Path');
//                                           }
//                                         },
//                                       ),
//                                       singleImage(
//                                           img: img2,
//                                           imgStep: '2',
//                                           function: () async {
//                                             CameraDataModel? camModel = await Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder: (context) => CameraScreen(),
//                                                 ));
//                                             if (camModel != null || camModel is CameraDataModel) {
//                                               final img = camModel.xpictureFile;
//                                               final file2 = File(img!.path);
//                                               final lastIndex = file2.absolute.path.lastIndexOf(new RegExp(r'.jp'));
//                                               final splitted = file2.absolute.path.substring(0, (lastIndex));
//                                               final outPath2 = "${splitted}_out${file2.absolute.path.substring(lastIndex)}";
//                                               final compressedFile2 = await Utils().compressImgAndGetFile(file2, outPath2);
//                                               final img2byte = compressedFile2!.readAsBytesSync();
//                                               setState(() {
//                                                 img2 = img2byte;
//                                                 img2Path = compressedFile2.path;
//                                               });
//                                               dev.log('image 2 path $img2Path');
//                                             }
//                                           }),
//                                       singleImage(
//                                           img: img3,
//                                           imgStep: '3',
//                                           function: () async {
//                                             CameraDataModel? camModel = await Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder: (context) => CameraScreen(),
//                                                 ));
//                                             if (camModel != null || camModel is CameraDataModel) {
//                                               final img = camModel.xpictureFile;
//                                               final file3 = File(img!.path);
//                                               final lastIndex = file3.absolute.path.lastIndexOf(new RegExp(r'.jp'));
//                                               final splitted = file3.absolute.path.substring(0, (lastIndex));
//                                               final outPath3 = "${splitted}_out${file3.absolute.path.substring(lastIndex)}";
//                                               final compressedFile3 = await Utils().compressImgAndGetFile(file3, outPath3);
//                                               final img3byte = compressedFile3!.readAsBytesSync();
//                                               setState(() {
//                                                 img3 = img3byte;
//                                                 img3Path = compressedFile3.path;
//                                               });
//                                               dev.log('image 3 path $img3Path');
//                                             }
//                                           }),
//                                     ],
//                                   ),
//                                   // GridView.builder(
//                                   //   physics: const NeverScrollableScrollPhysics(),
//                                   //   shrinkWrap: true,
//                                   //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                                   //     crossAxisCount: 3,
//                                   //     crossAxisSpacing: 10,
//                                   //     mainAxisSpacing: 10,
//                                   //   ),
//                                   //   itemBuilder: (_, index) {
//                                   //     if (index == 0) {
//                                   //       return Material(
//                                   //         color: Colors.white,
//                                   //         borderRadius: BorderRadius.circular(3),
//                                   //         child: InkWell(
//                                   //           borderRadius: BorderRadius.circular(3),
//                                   //           onTap: galleryImages!.length < 3
//                                   //               ? () {
//                                   //                   pickGalleryImageFromCamera().then((value) {
//                                   //                     // Navigator.of(context).pop();
//                                   //                   });
//                                   //                 }
//                                   //               : () {
//                                   //                   Utils.errorSnackBar(context, "You can't add more then 3 images");
//                                   //                 },
//                                   //           child: Container(
//                                   //             padding: const EdgeInsets.all(8),
//                                   //             decoration: BoxDecoration(
//                                   //               borderRadius: BorderRadius.circular(3),
//                                   //               border: Border.all(color: Colors.grey.shade400),
//                                   //             ),
//                                   //             child: Center(
//                                   //               child: Column(
//                                   //                 mainAxisAlignment: MainAxisAlignment.center,
//                                   //                 children: [
//                                   //                   const Icon(
//                                   //                     Icons.add_a_photo,
//                                   //                     size: 40,
//                                   //                     color: Color(0xFF3F51B5),
//                                   //                   ),
//                                   //                   const SizedBox(height: 5),
//                                   //                   Text("${galleryImages!.length}/3")
//                                   //                 ],
//                                   //               ),
//                                   //             ),
//                                   //           ),
//                                   //         ),
//                                   //       );
//                                   //     } else {
//                                   //       return ClipRRect(
//                                   //         borderRadius: BorderRadius.circular(3),
//                                   //         child: Stack(
//                                   //           clipBehavior: Clip.none,
//                                   //           fit: StackFit.expand,
//                                   //           children: [
//                                   //             Container(
//                                   //               decoration:
//                                   //                   BoxDecoration(color: Color(0xff989eb1).withOpacity(0.4), borderRadius: BorderRadius.circular(3)),
//                                   //               child: GestureDetector(
//                                   //                 onTap: () {
//                                   //                   Navigator.push(
//                                   //                     context,
//                                   //                     MaterialPageRoute(
//                                   //                       builder: (context) => ShowSingleImage(imageUrl: galleryImages![index - 1].path),
//                                   //                     ),
//                                   //                   );
//                                   //                 },
//                                   //                 child: Image(
//                                   //                   image: FileImage(File(galleryImages![index - 1].path)),
//                                   //                   fit: BoxFit.cover,
//                                   //                 ),
//                                   //               ),
//                                   //             ),
//                                   //             Positioned(
//                                   //                 right: 5,
//                                   //                 top: 5,
//                                   //                 child: GestureDetector(
//                                   //                     onTap: () {
//                                   //                       setState(() {
//                                   //                         galleryImages!.removeAt(index - 1);
//                                   //                       });
//                                   //                     },
//                                   //                     child: Container(
//                                   //                       decoration: BoxDecoration(
//                                   //                           shape: BoxShape.rectangle, color: Colors.red, borderRadius: BorderRadius.circular(2)),
//                                   //                       child: Icon(
//                                   //                         Icons.close,
//                                   //                         size: 18,
//                                   //                         color: Colors.white,
//                                   //                       ),
//                                   //                     )))
//                                   //           ],
//                                   //         ),
//                                   //       );
//                                   //     }
//                                   //   },
//                                   //   itemCount: galleryImages!.length + 1,
//                                   // ),
//                                   SizedBox(height: 10),
//                                   Center(
//                                     child: SizedBox(
//                                       width: 330.w,
//                                       height: 50.h,
//                                       child: ElevatedButton(
//                                           style: ElevatedButton.styleFrom(
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.circular(7.0.r),
//                                             ),
//                                             backgroundColor: Colors.green,
//                                           ),
//                                           onPressed: () async {
//                                             LocalStore localStore = LocalStore();
//                                             FieldSubmitLocal localFieldData = FieldSubmitLocal();
//                                             dev.log('districtID $districtId ');
//                                             dev.log('divisionID $divisionId ');
//                                             dev.log('upaID $upazilaId ');
//                                             dev.log('unionID $unionID ');

//                                             if (districtId != null && divisionId != null ||
//                                                 (unionID != null || upazilaId != null) &&
//                                                     (img1Path != null || img2Path != null || img3Path != null)) {
//                                               localFieldData = FieldSubmitLocal(
//                                                 districtID: districtId,
//                                                 divisionID: divisionId,
//                                                 unionID: unionID,
//                                                 upazillaID: upazilaId,
//                                                 latitude: targetLatitude.toString(),
//                                                 longitude: targetLongitude.toString(),
//                                                 officeTitle: selectedOffice,
//                                                 officeTypeID: selectedOffice == "DC/DDLG Office"
//                                                     ? "1"
//                                                     : selectedOffice == "UNO Office"
//                                                         ? "3"
//                                                         : selectedOffice == "UP Office"
//                                                             ? "2"
//                                                             : selectedOffice == "Other Office"
//                                                                 ? "4"
//                                                                 : "",
//                                                 locationMatch: locationMatchedValue,
//                                                 syncStatus: 'offline',
//                                                 locimg1: img1Path,
//                                                 locimg2: img2Path,
//                                                 locimg3: img3Path,
//                                               );
//                                               //}

//                                               localStore.storeFieldSubmitData(localFieldData);
//                                               await QuickAlert.show(
//                                                 context: context,
//                                                 type: QuickAlertType.success,
//                                                 text: "Visit Report Added Locally",
//                                               );
//                                               Navigator.pop(context);
//                                             } else {
//                                               await QuickAlert.show(
//                                                 context: context,
//                                                 type: QuickAlertType.error,
//                                                 text: "Please Enter Data",
//                                               );
//                                             }

//                                             // final localData = localStore.fieldSubmitBox.values.toList();
//                                             // final connectivityResult = await (Connectivity().checkConnectivity());
//                                             // if (connectivityResult == ConnectivityResult.mobile ||
//                                             //     connectivityResult == ConnectivityResult.wifi ||
//                                             //     connectivityResult == ConnectivityResult.ethernet) {
//                                             //   if (_formKeyVisitReport.currentState!.validate()) {
//                                             //     if (targetLatitude == 0.0 && targetLongitude == 0.0) {
//                                             //       return AllService().tost("Select Current Location");
//                                             //     } else if (visit_dateControler.text.isEmpty) {
//                                             //       return AllService().tost("Visit Purpose Input Required");
//                                             //     } else if (galleryImages!.length == 0) {
//                                             //       return AllService().tost("Upload Image Required");
//                                             //     }
//                                             //     setState(() {
//                                             //       _isLoading = true;
//                                             //     });
//                                             //     Map allReportData = {
//                                             //       "divistion_id": division_id,
//                                             //       "district_id": district_id,
//                                             //       "upazila_id": upazila_id,
//                                             //       "union_id": union_id,
//                                             //       "latitude": targetLatitude,
//                                             //       "longitude": targetLongitude,
//                                             //       "visit_date": dateController.text,
//                                             //       "visit_purpose": visit_dateControler.text,
//                                             //       "office_type": selectedOffice
//                                             //     };
//                                             //     // print("ooooooooooooooooooooooooooooooooooooootttttt");
//                                             //     print(allReportData);
//                                             //     // print(File(image!.path));
//                                             //     //
//                                             //     // File? compressedImage = await compressImage(image!.path);
//                                             //
//                                             //     // if (compressedImage != null) {
//                                             //     //   int compressedSize = await compressedImage.length();
//                                             //     //   print('Compressed Image Size: ${compressedSize / 1024} KB');
//                                             //     // } else {
//                                             //     //   print('Image compression failed or original image size is already within the target range.');
//                                             //     // }
//                                             //
//                                             //     Map dataResponse = await Repositores().uploadDataAndImage(
//                                             //         File(""),
//                                             //         division_id,
//                                             //         district_id,
//                                             //         upazila_id,
//                                             //         union_id,
//                                             //         targetLatitude.toString(),
//                                             //         targetLongitude.toString(),
//                                             //         dateController.text,
//                                             //         visit_dateControler.text,
//                                             //         selectedOffice.toString());
//                                             //     print("ooooooooooooooooooooooooooooooooooooootttttt");
//                                             //     print(dataResponse);
//                                             //
//                                             //     if (dataResponse['status'] == 200) {
//                                             //       await QuickAlert.show(
//                                             //         context: context,
//                                             //         type: QuickAlertType.success,
//                                             //         text: "Visit Report Added successfully",
//                                             //       );
//                                             //       await Navigator.of(context).pushReplacement(
//                                             //         MaterialPageRoute(
//                                             //           builder: (context) {
//                                             //             return FieldFindingCreatePage(
//                                             //               id: dataResponse['data']['id'].toString(),
//                                             //             );
//                                             //           },
//                                             //         ),
//                                             //       );
//                                             //       setState(() {
//                                             //         _isLoading = false;
//                                             //       });
//                                             //     } else {
//                                             //       await QuickAlert.show(
//                                             //         context: context,
//                                             //         type: QuickAlertType.error,
//                                             //         text: "Visit Report Add Faild",
//                                             //       );
//                                             //       setState(() {
//                                             //         _isLoading = false;
//                                             //       });
//                                             //     }
//                                             //   }
//                                             // } else {
//                                             //   AllService().internetCheckDialog(context);
//                                             // }
//                                           },
//                                           child: isSubmitBtnLoading
//                                               ? Center(child: AllService.LoadingToast())
//                                               : const Row(
//                                                   mainAxisAlignment: MainAxisAlignment.center,
//                                                   children: [
//                                                     Text(
//                                                       'Submit',
//                                                       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                                                     ),
//                                                   ],
//                                                 )),
//                                     ),
//                                   ),
//                                   SizedBox(height: 15),
//                                 ],
//                               )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//       );
//     //});
  
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
//                               });
//                             } else if (imgStep == '2') {
//                               setState(() {
//                                 img2 = null;
//                               });
//                             } else if (imgStep == '3') {
//                               setState(() {
//                                 img3 = null;
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

//   String? galleryImage;
//   String? gallerySingleImage;
//   List<File>? galleryImages = [];

//   ///To take gallery images
//   pickGalleryImageFromCamera() async {
//     await Utils.pickSingleImageFromCamera().then((value) async {
//       if (value != null) {
//         galleryImage = value;
//         File file = File(galleryImage!);
//         if (file != null) {
//           gallerySingleImage = file.path;
//           galleryImages?.add(file);
//         }
//       }
//     });
//     setState(() {});
//   }

//   ///Get Location initially++++++++++++++++++++++++++++++
//   // Future<void> initLocation() async {
//   //
//   //   bool _serviceEnabled;
//   //   PermissionStatus _permissionGranted;
//   //
//   //   _serviceEnabled = await location.serviceEnabled();
//   //   if (!_serviceEnabled) {
//   //     _serviceEnabled = await location.requestService();
//   //     if (!_serviceEnabled) {
//   //       return; // Location service is still not enabled, handle accordingly
//   //     }
//   //   }
//   //
//   //   _permissionGranted = await location.hasPermission();
//   //   if (_permissionGranted == PermissionStatus.denied) {
//   //     _permissionGranted = await location.requestPermission();
//   //     if (_permissionGranted != PermissionStatus.granted) {
//   //       return; // Permission not granted, handle accordingly
//   //     }
//   //   }
//   //
//   //   try {
//   //     setState(() {
//   //       isLoading = true;
//   //     });
//   //     var userLocation = await location.getLocation();
//   //     setState(() {
//   //       currentLocation = userLocation;
//   //       updateMap();
//   //       isLoading = false; // Set loading to false when location is obtained
//   //     });
//   //   } catch (e) {
//   //     print("Error: $e");
//   //     setState(() {
//   //       isLoading = false; // Set loading to false in case of an error
//   //     });
//   //   }
//   // }

//   ///Set Map Placeholder After Get Current Location++++++++++
//   // void updateMap() async {
//   //   if (mapControllerCompleter.isCompleted && currentLocation != null) {
//   //     mapControllerCompleter.future.then((controller) {
//   //       controller.animateCamera(
//   //         CameraUpdate.newCameraPosition(
//   //           CameraPosition(
//   //             target: LatLng(
//   //               currentLocation!.latitude!,
//   //               currentLocation!.longitude!,
//   //             ),
//   //             zoom: 14.0,
//   //           ),
//   //         ),
//   //       );
//   //     });
//   //
//   //     setState(() {
//   //       // targetLatitude = 24.8300822596109;
//   //       // targetLongitude = 88.570890203021;
//   //       targetLatitude = currentLocation!.latitude!;
//   //       targetLongitude = currentLocation!.longitude!;
//   //     });
//   //
//   //     print('Current Latitude: ${targetLatitude}, Current Longitude: ${targetLongitude}');
//   //     // Additional logic here
//   //
//   //     calculateAvailableOfficeInMyArea(storeDivisionData, storeDistrictData, storeUpazilaData, storeUnionData, 24.8300822596109, 88.570890203021);
//   //
//   //   } else {
//   //     print('Map controller is not completed');
//   //   }
//   // }

//   ///
//   // double targetLatitude = 0.0;
//   // double targetLongitude = 0.0;

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
//       print('Location permissions are permanently denied, we cannot request permissions.');
//       return;
//     }

//     // try {
//     setState(() {
//       isLoading = true;
//     });

//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

//     double latitude = position.latitude;
//     double longitude = position.longitude;

//     print('Latitude1: $latitude, Longitude1: $longitude');
//     final connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult.contains(ConnectivityResult.mobile) || connectivityResult.contains(ConnectivityResult.wifi)) {
//       List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
//       currentAddress = "${placemarks[0].subLocality}, ${placemarks[0].locality}";
//       print('Current Address ${currentAddress}');
//     }
//     setState(() {
//       // targetLatitude = 23.807262785837555; //23.807262785837555, 90.36841837239899
//       //targetLongitude = 90.36841837239899;
//       targetLatitude = latitude;
//       targetLongitude = longitude;

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
//       newCalculateNearByOffice(targetLatitude, targetLongitude);
//       // calculateAvailableOfficeInMyArea(storeDivisionData, storeDistrictData,
//       //     storeUpazilaData, storeUnionData, targetLatitude, targetLongitude);
//     } else {
//       print('Map controller is not completed');
//     }
//   }

//   clearAllValue() {
//     setState(() {
//       selectedDistrict = null;
//       selectedDivision = null;
//       divisionId = null;
//       districtId = null;
//       upazilaId = null;
//       unionID = null;
//     });
//   }

//   //new Calculate 25 meter distance area+++++++++++++++++++++
//   // This code is modified By monowar
//   newCalculateNearByOffice(double latitude, double longitude) {
//     LocalStore localStore = LocalStore();
//     List<AllLocationData> filteredLocationsList = [];
//     List<AllLocationData> allfilteredLocationsListDivDist = [];
//     List<Union> unions = [];
//     List<Upazila> upazilas = [];
//     List<District> districts = [];
//     List<Division> divisions = [];

//     double maxDistance = 25;
//     if (localStore.allLocationBox.values.toList().isNotEmpty) {
//       var allLocationList = localStore.allLocationBox.values.toList();

//       filteredLocationsList = allLocationList.where((allLoc) {
//         double earthRadius = 6371000; // Earth radius in meters

//         double lat1 = _degreesToRadians(latitude);
//         double lon1 = _degreesToRadians(longitude);
//         double lat2 = _degreesToRadians(double.parse(allLoc.latitude ?? '0.0'));
//         double lon2 = _degreesToRadians(double.parse(allLoc.longitude ?? '0.0'));

//         double dlat = lat2 - lat1;
//         double dlon = lon2 - lon1;

//         double a = sin(dlat / 2) * sin(dlat / 2) + cos(lat1) * cos(lat2) * sin(dlon / 2) * sin(dlon / 2);
//         double c = 2 * atan2(sqrt(a), sqrt(1 - a));

//         double distance = earthRadius * c;

//         return distance <= maxDistance;
//       }).toList();

//       //  allfilteredLocationsListDivDist = allLocationList.where((element) => element.divisionId == filteredLocationsList.firstWhere((e) => e.divisionId==element.divisionId,orElse: ()=> AllLocationData()

//       //  ).divisionId).toList();
//       dev.log('loc fil list  ${jsonEncode(filteredLocationsList)}');
//       if (filteredLocationsList.isNotEmpty) {
//         uniqueUnionData.clear();
//         uniqueUpazilaData.clear();
//         uniqueDistrictData.clear();
//         uniqueDivisionData.clear();
//         final uniqueUpazilaIds = <int>[];
//         final uniqueDistrictIds = <int>[];
//         final uniqueDivisionIds = <int>[];

//         for (var nearestLocation in filteredLocationsList) {
//           var upazila_name = allLocationList.firstWhere((element) => element.upazilaId == nearestLocation.upazilaId).nameEn ?? '';
//           var dist_name = allLocationList.firstWhere((element) => element.districtId == nearestLocation.districtId).nameEn ?? '';
//           var div_name = allLocationList.firstWhere((element) => element.divisionId == nearestLocation.divisionId).nameEn ?? '';
//           // union
//           //niqueUnionData.add(nearestUnion);

//           // upazilla
//           if (nearestLocation.divisionId != null &&
//               nearestLocation.districtId != null &&
//               nearestLocation.upazilaId != null &&
//               nearestLocation.unionId != null) {
//             uniqueUnionData.add(Union(unionId: nearestLocation.unionId, unionName: nearestLocation.nameEn, upazilaId: nearestLocation.upazilaId));

//             var upazilaId = nearestLocation.upazilaId;
//             if (!uniqueUpazilaIds.contains(upazilaId)) {
//               uniqueUpazilaData.add(Upazila(
//                 upazilaId: upazilaId,
//                 upazilaName: upazila_name,
//                 districtId: nearestLocation.districtId,
//               ));

//               uniqueUpazilaIds.add(upazilaId!);
//             }
//             var districtId = nearestLocation.districtId!;
//             if (!uniqueDistrictIds.contains(districtId)) {
//               uniqueDistrictData.add(District(
//                 districtName: dist_name,
//                 districtId: districtId,
//                 divisionId: nearestLocation.divisionId,
//               ));

//               uniqueDistrictIds.add(districtId);
//             }

//             var divisionId = nearestLocation.divisionId!;
//             if (!uniqueDivisionIds.contains(divisionId)) {
//               uniqueDivisionData.add(Division(divisionId: divisionId, divisionName: div_name));

//               uniqueDivisionIds.add(divisionId);
//             }
//           }
//           if (nearestLocation.divisionId != null &&
//               nearestLocation.districtId != null &&
//               nearestLocation.upazilaId != null &&
//               nearestLocation.unionId == null) {
//             uniqueUpazilaData
//                 .add(Upazila(upazilaId: nearestLocation.upazilaId, upazilaName: nearestLocation.nameEn, districtId: nearestLocation.districtId));

//             var districtId = nearestLocation.districtId!;
//             if (!uniqueDistrictIds.contains(districtId)) {
//               uniqueDistrictData.add(District(districtId: districtId, districtName: dist_name, divisionId: nearestLocation.divisionId));

//               uniqueDistrictIds.add(districtId);
//             }

//             var divisionId = nearestLocation.divisionId!;
//             if (!uniqueDivisionIds.contains(divisionId)) {
//               uniqueDivisionData.add(Division(divisionId: divisionId, divisionName: div_name));

//               uniqueDivisionIds.add(divisionId);
//             }
//           }
//           if (nearestLocation.divisionId != null &&
//               nearestLocation.districtId != null &&
//               nearestLocation.upazilaId == null &&
//               nearestLocation.unionId == null) {
//             uniqueDistrictData
//                 .add(District(districtName: nearestLocation.nameEn, divisionId: nearestLocation.divisionId, districtId: nearestLocation.districtId));

//             final divisionId = nearestLocation.divisionId!;
//             if (!uniqueDivisionIds.contains(divisionId)) {
//               uniqueDivisionData.add(Division(divisionId: divisionId, divisionName: div_name));

//               uniqueDivisionIds.add(divisionId);
//             }
//           }
//         }
//         dev.log('loc uniqupazila list  ${jsonEncode(uniqueUpazilaData)}');
//         dev.log('loc uniqdivisipn list  ${jsonEncode(uniqueDivisionData)}');
//         dev.log('loc union list  ${jsonEncode(uniqueUnionData)}');
//         dev.log('loc district list  ${jsonEncode(uniqueDistrictData)}');
//         setState(() {
//           divisionId = uniqueDivisionData.first.divisionId.toString();
//           districtId = uniqueDistrictData.first.districtId.toString();
//           upazilaId = uniqueUpazilaData.isNotEmpty
//               ? uniqueUpazilaData.first.upazilaId != null
//                   ? uniqueUpazilaData.first.upazilaId.toString()
//                   : null
//               : null;
//           unionID = uniqueUnionData.isNotEmpty
//               ? uniqueUnionData.first.unionId != null
//                   ? uniqueUnionData.first.unionId.toString()
//                   : null
//               : null;
//         });
//         dev.log('local division ID  $divisionId');
//         dev.log('loc district ID  $districtId');
//         dev.log('loc upazila ID  $upazilaId');
//         dev.log('loc union ID  $unionID');
//         if (uniqueUnionData.isNotEmpty || uniqueUpazilaData.isNotEmpty || uniqueDistrictData.isNotEmpty) {
//           setState(() {
//             isLocationMatched = true;
//             locationMatchedValue = '1';
//           });
//         } else {
//           setState(() {
//             isLocationMatched = false;
//             locationMatchedValue = "0";
//           });
//           showCustomDialog();
//         }
//         if (uniqueUnionData.isNotEmpty) {
//           selectedOffice = "UNO Office";
//         } else if (uniqueUpazilaData.isNotEmpty && uniqueUnionData.isEmpty) {
//           selectedOffice = "UP Office";
//         } else if (uniqueDistrictData.isNotEmpty && uniqueUpazilaData.isEmpty && uniqueUnionData.isEmpty) {
//           selectedOffice = "DC/DDLG Office";
//         } else {
//           selectedOffice = "Other Office";
//         }
//       } else {
//         setState(() {
//           isLocationMatched = false;
//           locationMatchedValue = '0';
//         });
//         showCustomDialog();
//       }
//     } else {
//       setState(() {
//         isLocationMatched = false;
//         locationMatchedValue = '0';
//       });
//       showCustomDialog();
//     }
//   }

//   chatGptLocation() {}

//   ///Calculate 25 meter distance area+++++++++++++++++++++
//   calculateAvailableOfficeInMyArea(
//     List<Division> divisions,
//     List<District> districts,
//     List<Upazila> upazilas,
//     List<Union> unions,
//     double latitude,
//     double longitude,
//   ) {
//     uniqueUnionData.clear();
//     uniqueUpazilaData.clear();
//     uniqueDistrictData.clear();
//     uniqueDivisionData.clear();

//     print("Latitude2: ${latitude}");
//     print("Longitude2: ${longitude}");

//     double maxDistance = 25; // Distance in meters

//     nearestUnionData = unions.where((uni) {
//       double earthRadius = 6371000; // Earth radius in meters

//       double lat1 = _degreesToRadians(latitude);
//       double lon1 = _degreesToRadians(longitude);
//       double lat2 = _degreesToRadians(uni.latitude!);
//       double lon2 = _degreesToRadians(uni.longitude!);

//       double dlat = lat2 - lat1;
//       double dlon = lon2 - lon1;

//       double a = sin(dlat / 2) * sin(dlat / 2) + cos(lat1) * cos(lat2) * sin(dlon / 2) * sin(dlon / 2);
//       double c = 2 * atan2(sqrt(a), sqrt(1 - a));

//       double distance = earthRadius * c;

//       return distance <= maxDistance;
//     }).toList();

//     print("union near 25 meter: ${nearestUnionData.length}");

//     if (nearestUnionData.isNotEmpty) {
//       uniqueUnionData.clear();
//       uniqueUpazilaData.clear();
//       uniqueDistrictData.clear();
//       uniqueDivisionData.clear();

//       for (Union nearestUnion in nearestUnionData) {
//         // union
//         uniqueUnionData.add(nearestUnion);

//         // upazilla
//         int? upazilaId = nearestUnion.upazilaId;
//         uniqueUpazilaData.addAll(storeUpazilaData.where((element) => element.id == upazilaId).toList());

//         // district
//         int? districtId = nearestUnion.districtId;
//         uniqueDistrictData.addAll(storeDistrictData.where((element) => element.id == districtId).toList());

//         // division
//         int? divisionId = nearestUnion.divisionId;
//         uniqueDivisionData.addAll(storeDivisionData.where((element) => element.id == divisionId).toList());
//       }
//     } else {
//       nearestUpazilaData = upazilas.where((upa) {
//         double earthRadius = 6371000;

//         double lat1 = _degreesToRadians(latitude);
//         double lon1 = _degreesToRadians(longitude);
//         double lat2 = _degreesToRadians(upa.latitude!);
//         double lon2 = _degreesToRadians(upa.longitude!);

//         double dlat = lat2 - lat1;
//         double dlon = lon2 - lon1;

//         double a = sin(dlat / 2) * sin(dlat / 2) + cos(lat1) * cos(lat2) * sin(dlon / 2) * sin(dlon / 2);
//         double c = 2 * atan2(sqrt(a), sqrt(1 - a));

//         double distance = earthRadius * c;

//         return distance <= maxDistance;
//       }).toList();
//       print("Upazilla near 25 meter: ${nearestUpazilaData.length}");

//       if (nearestUpazilaData.isNotEmpty) {
//         uniqueUpazilaData.clear();
//         uniqueDistrictData.clear();
//         uniqueDivisionData.clear();

//         for (Upazila nearestUpazilla in nearestUpazilaData) {
//           // upazilla
//           uniqueUpazilaData.add(nearestUpazilla);

//           // district
//           int? districtId = nearestUpazilla.districtId;
//           uniqueDistrictData.addAll(storeDistrictData.where((element) => element.id == districtId).toList());

//           // division
//           int? divisionId = nearestUpazilla.divisionId;
//           uniqueDivisionData.addAll(storeDivisionData.where((element) => element.id == divisionId).toList());
//         }
//       } else {
//         nearestDistrictData = districts.where((dis) {
//           double earthRadius = 6371000; // Earth radius in meters

//           double lat1 = _degreesToRadians(latitude);
//           double lon1 = _degreesToRadians(longitude);
//           double lat2 = _degreesToRadians(dis.latitude!);
//           double lon2 = _degreesToRadians(dis.longitude!);

//           double dlat = lat2 - lat1;
//           double dlon = lon2 - lon1;

//           double a = sin(dlat / 2) * sin(dlat / 2) + cos(lat1) * cos(lat2) * sin(dlon / 2) * sin(dlon / 2);
//           double c = 2 * atan2(sqrt(a), sqrt(1 - a));

//           double distance = earthRadius * c;

//           return distance <= maxDistance;
//         }).toList();
//         print("Upazilla near 25 meter: ${nearestDistrictData.length}");

//         if (nearestDistrictData.isNotEmpty) {
//           uniqueDistrictData.clear();
//           uniqueDivisionData.clear();

//           for (District nearestDistrict in nearestDistrictData) {
//             // district
//             uniqueDistrictData.add(nearestDistrict);

//             // division
//             int? divisionId = nearestDistrict.divisionId;
//             uniqueDivisionData.addAll(storeDivisionData.where((element) => element.id == divisionId).toList());
//           }
//         } else {
//           AllService().tost("Location not match");
//           showCustomDialog();
//         }
//       }
//     }

//     print("Union1: ${uniqueUnionData.length}");
//     print("Upazilla1: ${uniqueUpazilaData.length}");
//     print("District1: ${uniqueDistrictData.length}");
//     print("Division1: ${uniqueDivisionData.length}");
//     if (uniqueUnionData.isNotEmpty || uniqueUpazilaData.isNotEmpty || uniqueDistrictData.isNotEmpty) {
//       setState(() {
//         isLocationMatched = true;
//         locationMatchedValue = '1';
//       });
//     }
//     if (uniqueUnionData.isNotEmpty) {
//       selectedOffice = "UNO Office";
//     } else if (uniqueUpazilaData.isNotEmpty && uniqueUnionData.isEmpty) {
//       selectedOffice = "UP Office";
//     } else if (uniqueDistrictData.isNotEmpty && uniqueUpazilaData.isEmpty && uniqueUnionData.isEmpty) {
//       selectedOffice = "DC/DDLG Office";
//     } else {
//       selectedOffice = "Other Office";
//     }

//     print("Selected ${selectedOffice}");
//     print("Location Matched ${isLocationMatched}");
//   }

//   showCustomDialog() {
//     selectedDivision = null;
//     selectedDistrict = null;
//     selectedUpazila = null;
//     selectedUnion = null;
//     officeTitleCtrl.clear();
//     // dropdownDivisionData.clear();
//     // dropdownDistrictData.clear();
//     // dropdownUpazilaData.clear();
//     // dropdownUnionData.clear();
//     // dropdownDivisionData.addAll(storeDivisionData);
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return StatefulBuilder(
//             builder: (context, setState) {
//               return Dialog(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Form(
//                   key: _localChngeLocation,
//                   child: Wrap(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
//                         padding: const EdgeInsets.all(20),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               "Add New Office",
//                               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                             ),
//                             SizedBox(height: 20),

//                             ///Office DropDown+++++++
//                             DropdownButtonFormField<String>(
//                               isExpanded: true,
//                               decoration: const InputDecoration(
//                                   contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                   border: OutlineInputBorder(
//                                     borderSide: BorderSide(color: Colors.black),
//                                   ),
//                                   labelText: 'Select Office',
//                                   hintText: "Select Office"),
//                               value: selectedOffice,
//                               items: officeList.map<DropdownMenuItem<String>>((item) {
//                                 return DropdownMenuItem<String>(
//                                   value: item["name"],
//                                   child: Text("${item["name"]}"),
//                                 );
//                               }).toList(),
//                               onChanged: (newValue) {
//                                 setState(() {
//                                   selectedOffice = newValue.toString();
//                                 });
//                               },
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please select office';
//                                 }
//                                 return null;
//                               },
//                             ),

//                             ///Office Title++++++++++
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
//                             SizedBox(height: 10),

//                             ///Div, Dis, Upa, Uni++++++++++
//                             Column(
//                               children: [
//                                 ///Division Dropdown
//                                 BlocConsumer<ChangeLocationBloc, ChangeLocationState>(
//                                     bloc: changeLocationBloc,
//                                   //  listenWhen: (previous, current) => current is LocationActionState,
//                                    // buildWhen: (previous, current) => current is! LocationActionState,
//                                     listener: (context, state) {
//                                       // TODO: implement listener
//                                     },
//                                     builder: (context, state) {
//                                       if (state is ChangeLocationLoadingState) {
//                                         return Container(
//                                           child: Center(child: CircularProgressIndicator()),
//                                         );
//                                       } else if (state is ChangeLocationSuccessState) {
//                                         // dialogUnion = state.union;
//                                         // dialogUpazila = state.upazila;
//                                         // dialogDistrict = state.district;
//                                         // dialogDivision = state.division;

//                                         return Column(
//                                           children: [
//                                             ///Division Dropdown
//                                             DropdownButtonFormField<String>(
//                                               isExpanded: true,
//                                               validator: (value) {
//                                                 if (value == null) {
//                                                   return 'Division is required';
//                                                 }
//                                                 return null;
//                                               },
//                                               decoration: const InputDecoration(
//                                                 contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                                 border: OutlineInputBorder(
//                                                   borderSide: BorderSide(color: Colors.black),
//                                                 ),
//                                                 labelText: 'Select Division',
//                                               ),
//                                               value: selectedDivision,
//                                               items: state.division.map<DropdownMenuItem<String>>(
//                                                 (entry) {
//                                                   return DropdownMenuItem<String>(
//                                                     value: entry.nameEn,
//                                                     child: Text(entry.nameEn ?? ""),
//                                                   );
//                                                 },
//                                               ).toList(),
//                                               onChanged: (newValue) {
//                                                 setState(() {
//                                                   selectedDivision = newValue;
//                                                   selectedDistrict = null;
//                                                   for (Division entry in state.division) {
//                                                     if (selectedDivision == entry.nameEn) {
//                                                       //divisionId = entry.divisionId.toString();
//                                                       divisionId = entry.id.toString();
//                                                       changeLocationBloc.add(DistrictClickEvent(id: entry.id));
//                                                     }
//                                                   }
//                                                 });
//                                               },
//                                             ),
//                                             SizedBox(height: 10),

//                                             ///District Dropdown
//                                             Visibility(
//                                               visible: selectedOffice == 'UNO Office' ||
//                                                   selectedOffice == 'DC/DDLG Office' ||
//                                                   selectedOffice == 'UP Office' ||
//                                                   selectedOffice == 'Other Office',
//                                               child: DropdownButtonFormField<String>(
//                                                 isExpanded: true,
//                                                 value: selectedDistrict,
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
//                                                 onChanged: (newValue) {
//                                                   setState(() {
//                                                     selectedDistrict = newValue;
//                                                     selectedUpazila = null;
//                                                     for (District entry in state.district) {
//                                                       if (selectedDistrict == entry.nameEn) {
//                                                         districtId = entry.id.toString();
//                                                         changeLocationBloc.add(UpazilaClickEvent(id: entry.id));
//                                                       }
//                                                     }
//                                                   });
//                                                 },
//                                                 items: state.district.map<DropdownMenuItem<String>>(
//                                                   (entry) {
//                                                     return DropdownMenuItem<String>(
//                                                       value: entry.nameEn,
//                                                       child: Text(entry.nameEn ?? ""),
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
//                                             ),
//                                             SizedBox(height: 10),

//                                             ///Upazilla Dropdown
//                                             Visibility(
//                                               visible:
//                                                   selectedOffice == 'UNO Office' || selectedOffice == 'Other Office' || selectedOffice == 'UP Office',
//                                               child: DropdownButtonFormField<String>(
//                                                 isExpanded: true,
//                                                 value: selectedUpazila,
//                                                 validator: (selectedOffice == 'UNO Office' || selectedOffice == 'UP Office')
//                                                     ? (value) {
//                                                         if (value == null) {
//                                                           return 'Upazilla is required';
//                                                         }
//                                                         return null;
//                                                       }
//                                                     : null,
//                                                 onChanged: (newValue) {
//                                                   setState(() {
//                                                     selectedUpazila = newValue;
//                                                     selectedUnion = null;
//                                                     for (Upazila entry in state.upazila) {
//                                                       if (selectedUpazila == entry.nameEn) {
//                                                         upazilaId = entry.id.toString();
//                                                         changeLocationBloc.add(UnionClickEvent(id: entry.id));
//                                                       }
//                                                     }
//                                                   });
//                                                 },
//                                                 items: state.upazila.map<DropdownMenuItem<String>>((item) {
//                                                   return DropdownMenuItem<String>(
//                                                     value: item.nameEn,
//                                                     child: Text(item.nameEn ?? ""),
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
//                                             ),
//                                             SizedBox(height: 10),

//                                             ///Union Dropdown
//                                             Visibility(
//                                               visible: selectedOffice == 'UNO Office' || selectedOffice == 'Other Office',
//                                               child: DropdownButtonFormField<String>(
//                                                 isExpanded: true,
//                                                 value: selectedUnion,
//                                                 validator: (selectedOffice == 'UNO Office')
//                                                     ? (value) {
//                                                         if (value == null) {
//                                                           return 'Union is required';
//                                                         }
//                                                         return null;
//                                                       }
//                                                     : null,
//                                                 onChanged: (newValue) {
//                                                   setState(() {
//                                                     selectedUnion = newValue;
//                                                     for (Union entry in state.union) {
//                                                       if (selectedUnion == entry.nameEn) {
//                                                         unionID = entry.id.toString();
//                                                       }
//                                                     }
//                                                   });
//                                                 },
//                                                 items: state.union.map<DropdownMenuItem<String>>((item) {
//                                                   return DropdownMenuItem<String>(
//                                                     value: item.nameEn,
//                                                     child: Text(item.nameEn ?? ""),
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
//                                             ),

//                                             SizedBox(height: 10),
//                                           ],
//                                         );
//                                       }
//                                       return Container();
//                                     }),
//                                 TextFormField(
//                                   controller: remarkController,
//                                   maxLines: 1,
//                                   decoration: InputDecoration(
//                                     border: OutlineInputBorder(),
//                                     labelText: "Remark",
//                                     contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                   ),
//                                   validator: null,
//                                   // validator: (value) {
//                                   //   if (value!.isEmpty) {
//                                   //     return 'Please enter remark';
//                                   //   }
//                                   //   return null;
//                                   // },
//                                 ),
//                                 // DropdownButtonFormField<String>(
//                                 //   isExpanded: true,
//                                 //   decoration: const InputDecoration(
//                                 //     contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                 //     border: OutlineInputBorder(
//                                 //       borderSide: BorderSide(color: Colors.black),
//                                 //     ),
//                                 //     labelText: 'Select Division',
//                                 //   ),
//                                 //   value: selectedDivision,
//                                 //   items: lDivisionData.map<DropdownMenuItem<String>>(
//                                 //     (entry) {
//                                 //       return DropdownMenuItem<String>(
//                                 //         value: entry.nameEn,
//                                 //         onTap: () {
//                                 //           setState(() {
//                                 //             selectedDivisionId = entry.divisionId.toString();
//                                 //           });
//                                 //         },
//                                 //         child: Text(entry.nameEn ?? ""),
//                                 //       );
//                                 //     },
//                                 //   ).toList(),
//                                 //   onChanged: (newValue) {
//                                 //     setState(() {
//                                 //       selectedDivision = newValue!;
//                                 //       dropdownDistrictData.clear();
//                                 //       selectedDistrict = null;
//                                 //       selectedUpazila = null;
//                                 //       selectedUnion = null;

//                                 //       // for (Division entry in dropdownDivisionData) {
//                                 //       //   if (selectedDivision == entry.nameEn) {
//                                 //       //     selectedDivisionId = entry.id.toString();
//                                 //       //     dropdownDistrictData
//                                 //       //         .addAll(storeDistrictData.where((element) => element.divisionId.toString() == selectedDivisionId));
//                                 //       //   }
//                                 //       // }
//                                 //     });
//                                 //   },
//                                 // ),
//                                 // SizedBox(height: 10),

//                                 // ///District Dropdown
//                                 // DropdownButtonFormField<String>(
//                                 //   isExpanded: true,
//                                 //   value: selectedDistrict,
//                                 //   onChanged: (newValue) {
//                                 //     setState(() {
//                                 //       selectedDistrict = newValue!;
//                                 //       dropdownUpazilaData.clear();
//                                 //       selectedUpazila = null;
//                                 //       selectedUnion = null;
//                                 //       // for (District entry in dropdownDistrictData) {
//                                 //       //   if (selectedDistrict == entry.nameEn) {
//                                 //       //     selectedDistrictId = entry.id.toString();
//                                 //       //     dropdownUpazilaData
//                                 //       //         .addAll(storeUpazilaData.where((element) => element.districtId.toString() == selectedDistrictId));
//                                 //       //   }
//                                 //       // }
//                                 //     });
//                                 //   },
//                                 //   items: lDistrictData.where((element) => element.divisionId.toString() == selectedDivisionId).map<DropdownMenuItem<String>>(
//                                 //     (entry) {
//                                 //       return DropdownMenuItem<String>(
//                                 //         value: entry.nameEn,
//                                 //         onTap: () {
//                                 //           setState(() {
//                                 //             selectedDistrictId = entry.districtId.toString();
//                                 //           });
//                                 //         },
//                                 //         child: Text(entry.nameEn ?? ""),
//                                 //       );
//                                 //     },
//                                 //   ).toList(),
//                                 //   decoration: const InputDecoration(
//                                 //     contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                 //     border: OutlineInputBorder(
//                                 //       borderSide: BorderSide(color: Colors.black),
//                                 //     ),
//                                 //     labelText: 'Select District',
//                                 //   ),
//                                 // ),
//                                 // SizedBox(height: 10),

//                                 // ///Upazila Dropdown
//                                 // DropdownButtonFormField<String>(
//                                 //   isExpanded: true,
//                                 //   value: selectedUpazila,
//                                 //   onChanged: (newValue) {
//                                 //     setState(() {
//                                 //       selectedUpazila = newValue!;
//                                 //       dropdownUnionData.clear();
//                                 //       selectedUnion = null;
//                                 //       // for (Upazila entry in storeUpazilaData) {
//                                 //       //   if (selectedUpazila == entry.nameEn) {
//                                 //       //     selectedUpazilaId = entry.id.toString();
//                                 //       //     dropdownUnionData
//                                 //       //         .addAll(storeUnionData.where((element) => element.upazilaId.toString() == selectedUpazilaId).toList());
//                                 //       //   }
//                                 //       // }
//                                 //     });
//                                 //   },
//                                 //   items: lUpazillaData
//                                 //       .where((element) =>
//                                 //           element.districtId.toString() == selectedDistrictId && element.divisionId.toString() == selectedDivisionId)
//                                 //       .map<DropdownMenuItem<String>>((item) {
//                                 //     return DropdownMenuItem<String>(
//                                 //       value: item.nameEn,
//                                 //       onTap: () {
//                                 //         setState(() {
//                                 //           selectedUpazilaId = item.upazilaId.toString();
//                                 //         });
//                                 //       },
//                                 //       child: Text(item.nameEn ?? ""),
//                                 //     );
//                                 //   }).toList(),
//                                 //   decoration: const InputDecoration(
//                                 //     contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                 //     border: OutlineInputBorder(
//                                 //       borderSide: BorderSide(color: Colors.black),
//                                 //     ),
//                                 //     labelText: 'Select Upazila',
//                                 //   ),
//                                 // ),
//                                 // SizedBox(height: 10),

//                                 // ///Union Dropdown
//                                 // DropdownButtonFormField<String>(
//                                 //   isExpanded: true,
//                                 //   value: selectedUnion,
//                                 //   onChanged: (newValue) {
//                                 //     setState(() {
//                                 //       selectedUnion = newValue!;
//                                 //       // for (Union entry in storeUnionData) {
//                                 //       //   if (selectedUnion == entry.nameEn) {
//                                 //       //     selectedUnionId = entry.id.toString();
//                                 //       //   }
//                                 //       // }
//                                 //     });
//                                 //   },
//                                 //   items: lUnionData
//                                 //       .where((element) =>
//                                 //           element.districtId.toString() == selectedDistrictId &&
//                                 //           element.divisionId.toString() == selectedDistrictId &&
//                                 //           element.upazilaId.toString() == selectedUpazilaId)
//                                 //       .map<DropdownMenuItem<String>>((item) {
//                                 //     return DropdownMenuItem<String>(
//                                 //       value: item.nameEn,
//                                 //       child: Text(item.nameEn ?? ""),
//                                 //     );
//                                 //   }).toList(),
//                                 //   decoration: const InputDecoration(
//                                 //     contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                                 //     border: OutlineInputBorder(
//                                 //       borderSide: BorderSide(color: Colors.black),
//                                 //     ),
//                                 //     labelText: 'Select Union',
//                                 //   ),
//                                 // ),
//                               ],
//                             ),
//                             const SizedBox(
//                               height: 20,
//                             ),

//                             ///Submit Button And Cancel Button
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 TextButton(
//                                   onPressed: () {
//                                     dialogCloseValue = 0;
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
//                                   onPressed: () {
//                                     print('add off selected office $selectedDistrict');
//                                     print('add off selected unionId $unionID');
//                                     print('add off selected districtID $districtId');
//                                     print('add off selected upazilaID $upazilaId');
//                                     print('add off selected office $selectedOffice');
//                                     if (_localChngeLocation.currentState!.validate()) {
//                                       LocalStore local = LocalStore();
//                                       final saveLocalModel = SaveLocalFieldModel(
//                                         districtID: districtId,
//                                         divisionID: divisionId,
//                                         unionID: unionID,
//                                         upazillaID: upazilaId,
//                                         latitude: targetLatitude.toString(),
//                                         longitude: targetLongitude.toString(),
//                                         officeTitle: officeTitleCtrl.text,
//                                         remark: remarkController.text,
//                                         officeTypeID: selectedOffice == "DC/DDLG Office"
//                                             ? "1"
//                                             : selectedOffice == "UNO Office"
//                                                 ? "3"
//                                                 : selectedOffice == "UP Office"
//                                                     ? "2"
//                                                     : selectedOffice == "Other Office"
//                                                         ? "4"
//                                                         : "",
//                                         syncStatus: 'offline',
//                                         isChangeLocation: 'true',
//                                       );

//                                       local.storeDataForAddnewOffice(saveLocalModel);

//                                       setState(() {
//                                         // districtId = '';
//                                         // divisionId = '';
//                                         // upazilaId = '';
//                                         // unionID = '';
//                                         dialogCloseValue = 1;
//                                         isLocationMatched = true;
//                                         locationMatchedValue = '0';
//                                       });
//                                       print('Submit  dialogCLosevalue $dialogCloseValue');
//                                       print('Submit  isLocationMatched $isLocationMatched');
//                                       Navigator.of(context).pop(dialogCloseValue);
//                                     }
//                                   },
//                                   style: TextButton.styleFrom(
//                                       backgroundColor: Colors.green,
//                                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//                                       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0)),
//                                   child: const Text(
//                                     'Submit',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         }).then((value) {
//       print('add new office dialog close value $value');
//       if (value == 1 && isLocationMatched) {
//         isLocationMatched = true;
//         locationMatchedValue = '0';
//         isOfficeAddFromDialog = true;
//         dialogCloseValue = 1;
//         print('final dialogCLosevalue $dialogCloseValue');
//       } else {
//         isOfficeAddFromDialog = false;
//       }
//       setState(() {});
//     });

//     // then((value) {
//     //   print('add new office dialog close value $value');
//     //   if (value == 1 && isLocationMatched) {
//     //     isLocationMatched = true;
//     //     isOfficeAddFromDialog = true;
//     //   } else {
//     //     isOfficeAddFromDialog = false;
//     //   }
//     //   setState(() {});
//     // });
//   }

//   double _degreesToRadians(double degrees) {
//     return degrees * (pi / 180);
//   }
// }
