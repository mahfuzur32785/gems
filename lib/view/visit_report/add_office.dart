// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
//
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:quickalert/models/quickalert_type.dart';
// import 'package:quickalert/widgets/quickalert_dialog.dart';
// import 'package:village_court_gems/bloc/Change_Location_bloc/change_location_bloc.dart';
// import 'package:village_court_gems/bloc/Location_Bloc/location_bloc.dart';
// import 'package:village_court_gems/controller/repository/repository.dart';
// import 'package:village_court_gems/services/all_services/all_services.dart';
//
// import 'package:village_court_gems/view/home/homepage.dart';
//
// class AddNewOffice extends StatefulWidget {
//
//   const AddNewOffice({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<AddNewOffice> createState() => _AddNewOfficeState();
// }
//
// class _AddNewOfficeState extends State<AddNewOffice> {
//   DateTime? selectedDate;
//   Map locationdata = {};
//   bool data = false;
//   String? selectedDivision;
//   String? selectedDistrict;
//   String? selectedUpazila;
//   String? selectedUion;
//   String? divisionId = '';
//   String? districtId = '';
//   String? upazilaId = '';
//   String? unionID = '';
//
//   TextEditingController dateController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(DateTime.now().toLocal()));
//   TextEditingController officeTitleCtrl = TextEditingController();
//   final GlobalKey<FormState> _formKeychangeVisitReport = GlobalKey<FormState>();
//
//   String? selectedOffice;
//
//   final officeList = [
//     'DC/DDLG Office',
//     'UNO Office',
//     'UP Office',
//     'Other Office',
//   ];
//
//   late GoogleMapController mapController;
//   LocationData? currentLocation;
//   Location location = Location();
//   Completer<GoogleMapController> mapControllerCompleter = Completer();
//   final double mallLatitude = 23.8127951;
//   final double mallLongitude = 90.4288529;
//   double targetLatitude = 0.0;
//   double targetLongitude = 0.0;
//   bool isLoading = false; // Add this line to your state
//   bool isWithin2km = false;
//   bool _isLoading = false;
//
//   final ChangeLocationBloc changeLocationBloc = ChangeLocationBloc();
//
//   Future<void> initLocation() async {
//
//     bool _serviceEnabled;
//     PermissionStatus _permissionGranted;
//
//     _serviceEnabled = await location.serviceEnabled();
//     if (!_serviceEnabled) {
//       _serviceEnabled = await location.requestService();
//       if (!_serviceEnabled) {
//         return;
//       }
//     }
//
//     _permissionGranted = await location.hasPermission();
//     if (_permissionGranted == PermissionStatus.denied) {
//       _permissionGranted = await location.requestPermission();
//       if (_permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }
//
//     try {
//       setState(() {
//         isLoading = true;
//       });
//       var userLocation = await location.getLocation();
//       setState(() {
//         currentLocation = userLocation;
//         updateMap();
//       });
//     } catch (e) {
//       print("Error: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   void updateMap() async {
//     if (mapControllerCompleter.isCompleted && currentLocation != null) {
//       mapControllerCompleter.future.then((controller) {
//         controller.animateCamera(
//           CameraUpdate.newCameraPosition(
//             CameraPosition(
//               target: LatLng(
//                 currentLocation!.latitude!,
//                 currentLocation!.longitude!,
//               ),
//               zoom: 14.0,
//             ),
//           ),
//         );
//       });
//
//         targetLatitude = currentLocation!.latitude!;
//         targetLongitude = currentLocation!.longitude!;
//         isLoading = false;
//
//
//       print('Latitude: ${targetLatitude}, Longitude: ${targetLongitude}');
//       // Additional logic here
//
//       changeLocationBloc.add(ChangeLocationInitialEvent());
//     } else {
//       print('Map controller is not completed');
//     }
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     initLocation();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: const Icon(Icons.arrow_back)),
//         centerTitle: true,
//         title: Text(
//           "Add New Office",
//           style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: isLoading
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
//                 child: Form(
//                   key: _formKeychangeVisitReport,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Center(
//                       //   child: SizedBox(
//                       //     width: 330.w,
//                       //     height: 40.h,
//                       //     child: ElevatedButton(
//                       //         style: ElevatedButton.styleFrom(
//                       //           shape: RoundedRectangleBorder(
//                       //             borderRadius: BorderRadius.circular(7.0.r),
//                       //           ),
//                       //           backgroundColor: const Color.fromARGB(255, 14, 87, 109),
//                       //         ),
//                       //         onPressed: () async {
//                       //           // final connectivityResult = await (Connectivity().checkConnectivity());
//                       //           // if (connectivityResult == ConnectivityResult.mobile ||
//                       //           //     connectivityResult == ConnectivityResult.wifi ||
//                       //           //     connectivityResult == ConnectivityResult.ethernet) {
//                       //           setState(() {
//                       //             isLoading = true;
//                       //           });
//                       //
//                       //           // Initialize location
//                       //           await initLocation();
//                       //           updateMap();
//                       //           setState(() {
//                       //             isLoading = false;
//                       //           });
//                       //           // } else {
//                       //           //   AllService().internetCheckDialog(context);
//                       //           // }
//                       //         },
//                       //         child: isLoading
//                       //             ? CircularProgressIndicator() // Show the indicator when loading
//                       //             : Row(
//                       //                 mainAxisAlignment: MainAxisAlignment.center,
//                       //                 children: [
//                       //                   IconButton(
//                       //                       onPressed: () {},
//                       //                       icon: const Icon(
//                       //                         Icons.location_disabled_sharp,
//                       //                         color: Colors.white,
//                       //                       )),
//                       //                   const Text(
//                       //                     "Detect Current Location",
//                       //                     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                       //                   ),
//                       //                 ],
//                       //               )),
//                       //   ),
//                       // ),
//                       // SizedBox(
//                       //   height: 10,
//                       // ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Text(
//                             "My Location ",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 15.0),
//                           ),
//                           Text(
//                             'Latitude: ${targetLatitude}, Longitude: ${targetLongitude}',
//                             style: TextStyle(fontSize: 15.0),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Container(
//                         height: 150,
//                         child: GoogleMap(
//                           onMapCreated: (GoogleMapController controller) {
//                             mapControllerCompleter.complete(controller);
//                           },
//                           initialCameraPosition: CameraPosition(
//                             target: LatLng(
//                               targetLatitude,
//                               targetLongitude,
//                             ),
//                             zoom: 14.0,
//                           ),
//                           markers: currentLocation != null
//                               ? {
//                                   Marker(
//                                     markerId: MarkerId("MyLocation"),
//                                     position: LatLng(
//                                       targetLatitude,
//                                       targetLongitude,
//                                     ),
//                                     infoWindow:
//                                         InfoWindow(title: "My Location"),
//                                   ),
//                                 }
//                               : {},
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         "Add New Office",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(
//                         height: 10.0.h,
//                       ),
//                     //   Text("Office Type"),
//                     // SizedBox(height: 6,),
//                       SizedBox(
//                         child: DropdownButtonFormField<String>(
//                           isExpanded: true,
//                           value: selectedOffice,
//                           onChanged: (newValue) {
//                             setState(() {
//                               selectedOffice = newValue;
//                               print(selectedOffice);
//                             });
//                           },
//                           items: officeList.map<DropdownMenuItem<String>>((item) {
//                             return DropdownMenuItem<String>(
//                               value: item,
//                               child: Text(item),
//                             );
//                           }).toList(),
//                           decoration: const InputDecoration(
//                             contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide(color: Colors.black),
//                             ),
//                             labelText: 'Select Office',
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please select office';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                       SizedBox(
//                         height: 15.0.h,
//                       ),
//                       TextFormField(
//                         controller: officeTitleCtrl,
//                         maxLines: 1,
//                         decoration: InputDecoration(
//                           border: OutlineInputBorder(),
//                           labelText: "Office title",
//                           contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter office title';
//                           }
//                           return null;
//                         },
//                       ),
//                       SizedBox(
//                         height: 10.0.h,
//                       ),
//
//                       Column(
//                         children: [
//                           BlocConsumer<ChangeLocationBloc, ChangeLocationState>(
//                               bloc: changeLocationBloc,
//                               listenWhen: (previous, current) =>
//                                   current is LocationActionState,
//                               buildWhen: (previous, current) =>
//                                   current is! LocationActionState,
//                               listener: (context, state) {
//                                 // TODO: implement listener
//                               },
//                               builder: (context, state) {
//                                 if (state is ChangeLocationLoadingState) {
//                                   return Container(
//                                     child: Center(
//                                         child: CircularProgressIndicator()),
//                                   );
//                                 } else if (state
//                                     is ChangeLocationSuccessState) {
//                                   print("successssssssssss");
//
//                                   log('data: ${state.division}');
//                                   return Column(
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           SizedBox(
//                                             height: 55.0.h,
//                                             width: 160.0.w,
//                                             child:
//                                                 DropdownButtonFormField<String>(
//                                               isExpanded: true,
//                                               value: selectedDivision,
//                                               onChanged: (newValue) {
//                                                 setState(() {
//                                                   selectedDivision = newValue!;
//
//                                                   print(
//                                                       "selectedDivision  $selectedDivision");
//                                                   selectedDistrict = null;
//
//                                                   for (var entry
//                                                       in state.division) {
//                                                     if (selectedDivision ==
//                                                         entry['name_en']) {
//                                                       print(
//                                                           "divisionId ${entry['id']}");
//                                                       divisionId = entry['id']
//                                                           .toString();
//                                                       changeLocationBloc.add(
//                                                           DistrictClickEvent(
//                                                               id: entry['id']));
//                                                     }
//                                                   }
//                                                 });
//                                               },
//                                               items: (state.division ?? []).map<
//                                                       DropdownMenuItem<String>>(
//                                                   (item) {
//                                                 return DropdownMenuItem<String>(
//                                                   value: item['name_en'],
//                                                   child: Text(item['name_en']),
//                                                 );
//                                               }).toList(),
//                                               decoration: const InputDecoration(
//                                                 contentPadding:
//                                                     EdgeInsets.symmetric(
//                                                         horizontal: 10,
//                                                         vertical: 10),
//                                                 border: OutlineInputBorder(
//                                                   borderSide: BorderSide(
//                                                       color: Colors.black),
//                                                 ),
//                                                 labelText: 'Select Division',
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: 55.0.h,
//                                             width: 160.0.w,
//                                             child:
//                                                 DropdownButtonFormField<String>(
//                                               isExpanded: true,
//                                               value: selectedDistrict,
//                                               onChanged: (newValue) {
//                                                 setState(() {
//                                                   selectedDistrict = newValue!;
//                                                   selectedUpazila = null;
//                                                   for (var entry
//                                                       in state.district) {
//                                                     // print(entry['name_en']);
//                                                     // print("selectedUpazilaaaaaaaaaaaa ${entry['id']}");
//                                                     if (selectedDistrict ==
//                                                         entry['name_en']) {
//                                                       print(
//                                                           "selectedUpazilaaaaaaaaaaaa ${entry['id']}");
//                                                       districtId = entry['id']
//                                                           .toString();
//                                                       changeLocationBloc.add(
//                                                           UpazilaClickEvent(
//                                                               id: entry['id']));
//                                                     }
//                                                   }
//                                                 });
//                                               },
//                                               items: (state.district ?? []).map<
//                                                       DropdownMenuItem<String>>(
//                                                   (item) {
//                                                 return DropdownMenuItem<String>(
//                                                   value: item['name_en'],
//                                                   child: Text(item['name_en']),
//                                                 );
//                                               }).toList(),
//                                               decoration: const InputDecoration(
//                                                 contentPadding:
//                                                     EdgeInsets.symmetric(
//                                                         horizontal: 10,
//                                                         vertical: 10),
//                                                 border: OutlineInputBorder(
//                                                   borderSide: BorderSide(
//                                                       color: Colors.black),
//                                                 ),
//                                                 labelText: 'Select District',
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       SizedBox(
//                                         height: 10,
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           SizedBox(
//                                             height: 55.0.h,
//                                             width: 160.0.w,
//                                             child:
//                                                 DropdownButtonFormField<String>(
//                                               isExpanded: true,
//                                               value: selectedUpazila,
//                                               onChanged: (newValue) {
//                                                 setState(() {
//                                                   selectedUpazila = newValue!;
//                                                   selectedUion = null;
//                                                   for (var entry
//                                                       in state.upazila) {
//                                                     print(entry);
//
//                                                     if (selectedUpazila ==
//                                                         entry['name_en']) {
//                                                       print(
//                                                           "selectedUpazilaaaaaaaaaaaa ${entry['id']}");
//                                                       upazilaId = entry['id']
//                                                           .toString();
//                                                       changeLocationBloc.add(
//                                                           UnionClickEvent(
//                                                               id: entry['id']));
//                                                     }
//                                                   }
//                                                 });
//                                               },
//                                               items: (state.upazila ?? []).map<
//                                                       DropdownMenuItem<String>>(
//                                                   (item) {
//                                                 return DropdownMenuItem<String>(
//                                                   value: item['name_en'],
//                                                   child: Text(item['name_en']),
//                                                 );
//                                               }).toList(),
//                                               decoration: const InputDecoration(
//                                                 contentPadding:
//                                                     EdgeInsets.symmetric(
//                                                         horizontal: 10,
//                                                         vertical: 10),
//                                                 border: OutlineInputBorder(
//                                                   borderSide: BorderSide(
//                                                       color: Colors.black),
//                                                 ),
//                                                 labelText: 'Select Upazila',
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: 55.0.h,
//                                             width: 160.0.w,
//                                             child:
//                                                 DropdownButtonFormField<String>(
//                                               isExpanded: true,
//                                               value: selectedUion,
//                                               onChanged: (newValue) {
//                                                 setState(() {
//                                                   selectedUion = newValue!;
//
//                                                   for (var entry
//                                                       in state.union) {
//                                                     if (selectedUion ==
//                                                         entry['name_en']) {
//                                                       unionID = entry['id']
//                                                           .toString();
//                                                       print(
//                                                           "selected union ${entry['id']}");
//                                                       // union = entry['id'].toString();
//                                                     }
//                                                   }
//                                                 });
//                                               },
//                                               items: state.union.map<
//                                                       DropdownMenuItem<String>>(
//                                                   (item) {
//                                                 return DropdownMenuItem<String>(
//                                                   value: item['name_en'],
//                                                   child: Text(item['name_en']),
//                                                 );
//                                               }).toList(),
//                                               decoration: const InputDecoration(
//                                                 contentPadding:
//                                                     EdgeInsets.symmetric(
//                                                         horizontal: 10,
//                                                         vertical: 10),
//                                                 border: OutlineInputBorder(
//                                                   borderSide: BorderSide(
//                                                       color: Colors.black),
//                                                 ),
//                                                 labelText: 'Select Union',
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       )
//                                     ],
//                                   );
//                                 }
//                                 return Container();
//                               }),
//                         ],
//                       ),
//
//                       SizedBox(
//                         height: 15.0.h,
//                       ),
//                       // ElevatedButton(
//                       //     onPressed: () async {
//                       //       // print(OfflineDivision().divisionData);
//                       //       List storeDivisonData = await Helper().getDivisionData();
//                       //       print(storeDivisonData);
//                       // List<Map<String, dynamic>> updates = [
//                       //   {
//                       //     'id': 1,
//                       //     'name_bn': 'Updated Name 1',
//                       //     'name_en': 'Updated English Name 1',
//                       //     'bbs_code': null,
//                       //     'latitude': null,
//                       //     'longitude': null,
//                       //     'url': null,
//                       //     'created_at': '2023-12-10T17:04:22.000000Z',
//                       //     'updated_at': '2023-12-10T17:04:22.000000Z',
//                       //   },
//                       //   {
//                       //     'id': 2,
//                       //     'name_bn': 'noting',
//                       //     'name_en': "aaaaa",
//                       //     'bbs_code': null,
//                       //     'latitude': null,
//                       //     'longitude': null,
//                       //     'url': null,
//                       //     'created_at': '2023-12-10T17:04:22.000000Z',
//                       //     'updated_at': '2023-12-10T17:04:22.000000Z',
//                       //   },
//
//                       //   // Add more updates as needed
//                       // ];
//                       // await Helper().updateDivisionData(updates);
//                       // },
//                       // child: Text("dataaaa")),
//                       _isLoading
//                           ? Center(child: AllService.LoadingToast())
//                           : Center(
//                               child: SizedBox(
//                                 width: 330.w,
//                                 height: 50.h,
//                                 child: ElevatedButton(
//                                     style: ElevatedButton.styleFrom(
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(7.0.r),
//                                         ),
//                                         backgroundColor: Color(0xFF69930C)),
//                                     onPressed: () async {
//                                       final connectivityResult =
//                                           await (Connectivity()
//                                               .checkConnectivity());
//                                       if (connectivityResult ==
//                                               ConnectivityResult.mobile ||
//                                           connectivityResult ==
//                                               ConnectivityResult.wifi ||
//                                           connectivityResult ==
//                                               ConnectivityResult.ethernet) {
//                                         if (_formKeychangeVisitReport
//                                             .currentState!
//                                             .validate()) {
//                                           setState(() {
//                                             _isLoading = true;
//                                           });
//                                           Map changeLocationData = {
//                                             "division_id": divisionId,
//                                             "district_id": districtId,
//                                             "upazila_id": upazilaId,
//                                             "union_id": unionID,
//                                             "latitude": targetLatitude,
//                                             "longitude": targetLongitude,
//                                             "remark":
//                                                 officeTitleCtrl
//                                                     .text
//                                           };
//                                           print(changeLocationData);
//                                           Map changeLocationApiResponse =
//                                               await Repositores()
//                                                   .ChangeLocationSubmitApi(
//                                                       jsonEncode(
//                                                           changeLocationData));
//                                           if (changeLocationApiResponse[
//                                                   'status'] ==
//                                               200) {
//                                             await QuickAlert.show(
//                                               context: context,
//                                               type: QuickAlertType.success,
//                                               text: "Location Change Success",
//                                             );
//                                             await Navigator.of(context)
//                                                 .pushAndRemoveUntil(
//                                                     MaterialPageRoute(
//                                                         builder: (context) =>
//                                                             Homepage()),
//                                                     (Route<dynamic> route) =>
//                                                         false);
//                                             setState(() {
//                                               _isLoading = false;
//                                             });
//                                           } else {
//                                             await QuickAlert.show(
//                                               context: context,
//                                               type: QuickAlertType.error,
//                                               text:
//                                                   "Something went wrong please try again later",
//                                             );
//                                             setState(() {
//                                               _isLoading = false;
//                                             });
//                                           }
//                                         }
//                                       } else {
//                                         AllService().internetCheckDialog(context);
//                                         setState(() {
//                                           _isLoading = false;
//                                         });
//                                       }
//                                     },
//                                     child: const Row(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         Text(
//                                           'Submit',
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                       ],
//                                     )),
//                               ),
//                             ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }
// }
