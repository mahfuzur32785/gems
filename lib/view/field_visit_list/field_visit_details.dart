import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:village_court_gems/bloc/FieldFindingCreateBloc/field_finding_create_bloc.dart';
import 'package:village_court_gems/bloc/FieldFindingUpdate_Bloc/field_finding_update_bloc.dart';
import 'package:village_court_gems/bloc/FieldVisitDetails_Bloc/field_visit_details_bloc.dart';
import 'package:village_court_gems/camera_widget/camera_model.dart';
import 'package:village_court_gems/camera_widget/camera_widget.dart';
import 'package:village_court_gems/controller/api_services/api_client.dart';
import 'package:village_court_gems/models/field_visit_model/FieldFindingCreateModel.dart';
import 'package:village_court_gems/models/field_visit_model/fieldVisitUpdateModel.dart';
import 'package:village_court_gems/services/all_services/all_services.dart';
import 'package:village_court_gems/util/colors.dart';
import 'package:village_court_gems/view/visit_report/show_image.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/provider/connectivity_provider.dart';
import 'package:village_court_gems/util/utils.dart';
import 'package:village_court_gems/view/field_visit_list/field-finding-create.dart';
import 'package:village_court_gems/view/field_visit_list/field_visit_edit.dart';
import 'package:village_court_gems/widget/custom_appbar.dart';

class FieldVisitDetailsPage extends StatefulWidget {
  String? id;
  final String fieldVisitDate;
  final String officeType;
  final String officeTitle;
  FieldVisitDetailsPage({super.key, this.id, required this.fieldVisitDate, required this.officeType, required this.officeTitle});

  @override
  State<FieldVisitDetailsPage> createState() => _FieldVisitDetailsPageState();
}

class _FieldVisitDetailsPageState extends State<FieldVisitDetailsPage> {
  late GoogleMapController mapController;

  List<List<TextEditingController>> fieldVisitDetailsController = [];

  final FieldVisitDetailsBloc fieldVisitDetailsBloc = FieldVisitDetailsBloc();
  final FieldFindingCreateBloc fieldFindingCreateBloc = FieldFindingCreateBloc();

  @override
  void initState() {
    fieldVisitDetailsBloc.add(FieldVisitDetailsInitialEvent(id: int.parse(widget.id.toString())));
    fieldFindingUpdateBloc.add(FieldFindingUpdateInitialEvent(id: widget.id.toString()));
    fieldFindingCreateBloc.add(FieldFindingCreateInitialEvent(id: widget.id.toString()));

    super.initState();
  }

  String? galleryImage;
  String? gallerySingleImage;
  List<String> galleryImages = [];

  // pickImageFromGallery() async {
  //   await Utils.pickSingleImageFromGallery().then((value) async {
  //     if (value != null) {
  //       galleryImage = value;
  //       File file = File(galleryImage!);
  //       if (file != null) {
  //         gallerySingleImage = file.path;
  //         galleryImages?.add(file);
  //         // List<int> imageBytes = await file.readAsBytes();
  //         // base64gallerySingleImage =
  //         // 'data:image/${file.path.split('.').last};base64,${base64Encode(imageBytes)}';
  //         //
  //         // print("feature image is: ${base64gallerySingleImage}");
  //         // // context.read<AdEditProfileCubit>().base64Image = base64Image!;
  //         // base64Images.add(base64gallerySingleImage.toString());
  //       }
  //     }
  //   });
  //   setState(() {});
  //   return galleryImages;
  //   // return base64gallerySingleImage;
  // }
  //
  // pickImageFromCamera() async {
  //   await Utils.pickSingleImageFromCamera().then((value) async {
  //     if (value != null) {
  //       galleryImage = value;
  //       File file = File(galleryImage!);
  //       if (file != null) {
  //         gallerySingleImage = file.path;
  //         galleryImages?.add(file);
  //         // List<int> imageBytes = await file.readAsBytes();
  //         // base64gallerySingleImage =
  //         // 'data:image/${file.path.split('.').last};base64,${base64Encode(imageBytes)}';
  //         //
  //         // print("feature image is: ${base64gallerySingleImage}");
  //         // // context.read<AdEditProfileCubit>().base64Image = base64Image!;
  //         // base64Images.add(base64gallerySingleImage.toString());
  //       }
  //     }
  //   });
  //   setState(() {});
  //   return galleryImages;
  //   // return base64gallerySingleImage;
  // }
  //
  bool hideBtn = false;

  String imgUrl1 = "";
  String imgUrl2 = "";
  String imgUrl3 = "";


  ///Update
  final FieldFindingUpdateBloc fieldFindingUpdateBloc = FieldFindingUpdateBloc();
  List<Question> text = [];
  List all_text_id = [];
  int globalvalue = 0;
  bool _isLoading = false;
  List<List<TextEditingController>> textController = [];

  ///careate
  int globalStoreValue = 0;
  int globalStoreValue11 = 0;
  List<FieldCreateData> textCreate = [];
  List<FieldCreateData> radio = [];
  List<FieldCreateData> checkbox = [];
  List<FieldCreateData> dropdown = [];
  List<FieldCreateData> number = [];

  List<List<TextEditingController>> textconroller = [];
  List<List<TextEditingController>> numberconroller = [];
  List<String>? selectedValue;
  List<List<bool>> isChecked = [];
  Map selectedDropdownValues = {};

  //store variable
  List text_ = [];
  List number_ = [];
  List radio_ = [];
  List dropdown_ = [];
  List check_box_ = [];
  List textID = [];
  //
  List<String> textData = [];
  List<String> numberData = [];
  List<String> checkboxData = [];
  List<String> dropdownData = [];
  // List<List<String>> radio_1 = [];
  List<String>? dropdownDataList = [];
  List<String> try12 = [];
  final GlobalKey<FormState> _fieldformKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    double targetLatitude = 23.8128157;
    double targetLongitude = 90.4288459;
    return Scaffold(
      appBar: CustomAppbar(
        title: "Field Visit Details",
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocConsumer<FieldVisitDetailsBloc, FieldVisitDetailsState>(
                  bloc: fieldVisitDetailsBloc,
                  listenWhen: (previous, current) => current is FieldVisitDetailsnActionState,
                  buildWhen: (previous, current) => current is! FieldVisitDetailsnActionState,
                  listener: (context, state) {
                    // TODO: implement listener
                  },
                  builder: (context, state) {
                    if (state is FieldVisitDetailsLoadingState) {
                      return Container(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }else if(state is FieldVisitDetailsFailureState){
                      if (state.statusCode == 500) {
                         return Center(
                        child: Text('Internal Server Error'),
                      );
                      }
                    } else if (state is FieldVisitDetailsSuccessState) {

                      if(state.visit[0].photo!.length == 3){
                        hideBtn = true;
                      }

                      if(state.visit[0].photo!=null){
                        if(state.visit[0].photo!.length == 1){
                          imgUrl1 = APIClients.BASE_URL + state.visit[0].photo![0].photo.toString();
                          imgUrl2 = "";
                          imgUrl3 = "";
                        }
                        if(state.visit[0].photo!.length == 2){
                          imgUrl1 = APIClients.BASE_URL + state.visit[0].photo![0].photo.toString();
                          imgUrl2 = APIClients.BASE_URL + state.visit[0].photo![1].photo.toString();
                          imgUrl3 = "";
                        }
                        if(state.visit[0].photo!.length == 3){
                          imgUrl1 = APIClients.BASE_URL + state.visit[0].photo![0].photo.toString();
                          imgUrl2 = APIClients.BASE_URL + state.visit[0].photo![1].photo.toString();
                          imgUrl3 = APIClients.BASE_URL + state.visit[0].photo![2].photo.toString();
                        }

                      }

                      for (int i = 0; i < state.fieldFindings!.length; i++) {
                        List<TextEditingController> maleControllersForParticipant = [];
                        List<TextEditingController> femaleControllersForParticipant = [];

                        for (int j = 0; j < state.fieldFindings![i].questionAnswer!.length; j++) {
                          // Check if the participant level has data before adding controllers
                          if (state.fieldFindings![i].questionAnswer![j].answer != null) {
                            // Add male controller
                            maleControllersForParticipant.add(TextEditingController(
                              text: state.fieldFindings![i].questionAnswer![j].answer.toString(),
                            ));
                          }
                        }

                        fieldVisitDetailsController.add(maleControllersForParticipant);
                      }
                      return Column(
                        children: [
                          // Text(
                          //   state.visit[0].id.toString(),
                          // ),
                          // GestureDetector(
                          //   onTap: () async {
                          //     await Navigator.of(context).push(
                          //       MaterialPageRoute(
                          //         builder: (context) {
                          //           return FieldFindingCreatePage(
                          //             id: state.visit[0].id.toString(),
                          //           );
                          //         },
                          //       ),
                          //     );
                          //   },
                          //   child: Container(
                          //     padding: EdgeInsets.all(8),
                          //     decoration: BoxDecoration(
                          //       shape: BoxShape.circle,
                          //       color: Colors.white,
                          //     ),
                          //     child: Icon(
                          //       Icons.create_new_folder,
                          //       color: Colors.black,
                          //     ),
                          //   ),
                          // ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            'Visit Date',
                                            style: TextStyle(fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            ':',
                                            style: TextStyle(fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Expanded(flex: 8, child: Text('${widget.fieldVisitDate}'))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            'Office Type',
                                            style: TextStyle(fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            ':',
                                            style: TextStyle(fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Expanded(flex: 8, child: Text('${widget.officeType}'))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            'Office Title',
                                            style: TextStyle(fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            ':',
                                            style: TextStyle(fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Expanded(flex: 8, child: Text('${widget.officeTitle}'))
                                      ],
                                    ),
                                    Divider(),
                                    Row(
                                      //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                  flex: 4,
                                                  child: Text(
                                                    'Division',
                                                    style: TextStyle(
                                                      fontSize: 15.sp,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                  )),
                                              Expanded(child: Text(':', style: TextStyle(fontWeight: FontWeight.bold))),
                                              Expanded(flex: 4, child: Text('${state.visit[0].division}' ?? '')),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                  flex: 4,
                                                  child: Text(
                                                    'District',
                                                    style: TextStyle(
                                                      fontSize: 15.sp,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                  )),
                                              Expanded(flex: 1,child: Text(':', style: TextStyle(fontWeight: FontWeight.bold))),
                                              Expanded(flex: 4, child: Padding(
                                                padding: const EdgeInsets.only(right: 4.0),
                                                child: Text('${state.visit[0].district}' ?? ''),
                                              )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8,),
                                    Row(
                                      //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        state.visit[0].upazila!.isEmpty
                                            ? SizedBox.shrink()
                                            : Expanded(
                                                child: Row(
                                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                        flex: 4,
                                                        child: Text(
                                                          'Upazilla',
                                                          style: TextStyle(
                                                            fontSize: 15.sp,
                                                            fontWeight: FontWeight.w500,
                                                            color: Colors.black,
                                                          ),
                                                        )),
                                                    Expanded(child: Text(':', style: TextStyle(fontWeight: FontWeight.bold))),
                                                    Expanded(flex: 4, child: Text('${state.visit[0].upazila}' ?? '')),
                                                  ],
                                                ),
                                              ),
                                        state.visit[0].union!.isEmpty
                                            ? Expanded(child: SizedBox())
                                            : Expanded(
                                                child: Row(
                                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                        flex: 4,
                                                        child: Text(
                                                          'Union',
                                                          style: TextStyle(
                                                            fontSize: 15.sp,
                                                            fontWeight: FontWeight.w500,
                                                            color: Colors.black,
                                                          ),
                                                        )),
                                                    Expanded(
                                                        child: Text(
                                                      ':',
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    )),
                                                    Expanded(flex: 4, child: Text('${state.visit[0].union}' ?? '')),
                                                  ],
                                                ),
                                              ),
                                      ],
                                    ),

                                    //  Divider(),

                                    SizedBox(height: 15),
                                    Text(
                                      'GPS Coordination',
                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                                    ),
                                    // Padding(
                                    //   padding: EdgeInsets.only(left: 10),
                                    //   child: Container(
                                    //     alignment: Alignment.centerLeft,
                                    //     child: Text(
                                    //       'Latitude: ${state.visit[0].latitude}, Longitude: ${state.visit[0].longitude}',
                                    //       style: TextStyle(fontSize: 13.0.sp, fontWeight: FontWeight.w500),
                                    //     ),
                                    //   ),
                                    // ),
                                    SizedBox(height: 10),

                                    Stack(
                                      // alignment: Alignment.topLeft,
                                      children: [
                                        Container(
                                          height: 150,
                                          child: GoogleMap(
                                            onMapCreated: (controller) {
                                              setState(() {
                                                mapController = controller;
                                              });
                                              mapController.animateCamera(
                                                CameraUpdate.newCameraPosition(
                                                  CameraPosition(
                                                    target: LatLng(
                                                      double.parse(state.visit[0].latitude ?? ''),
                                                      double.parse(state.visit[0].longitude ?? ''),
                                                    ),
                                                    zoom: 14.0,
                                                  ),
                                                ),
                                              );
                                            },
                                            initialCameraPosition: CameraPosition(
                                              target: LatLng(
                                                double.parse(state.visit[0].latitude ?? ''),
                                                double.parse(state.visit[0].longitude ?? ''),
                                              ),
                                              zoom: 14.0,
                                            ),
                                            markers: {
                                              Marker(
                                                markerId: MarkerId('target_location'),
                                                position: LatLng(
                                                  double.parse(state.visit[0].latitude ?? ''),
                                                  double.parse(state.visit[0].longitude ?? ''),
                                                ),
                                                infoWindow: InfoWindow(title: 'Target Location'),
                                              ),
                                            },
                                          ),
                                        ),
                                        Positioned(
                                            top: 0,
                                            left: 0,
                                            child: Container(
                                              color: Colors.white,
                                              child: Text(
                                                'Latitude :${state.visit[0].latitude}',
                                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 10),
                                              ),
                                            )),
                                        Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Container(
                                              color: Colors.white,
                                              child: Text(
                                                'Longitude :${state.visit[0].longitude}',
                                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 10),
                                              ),
                                            )),
                                      ],
                                    ),

                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            "Photos :",
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        // Expanded(
                                        //     flex: 1,
                                        //     child: Text(
                                        //       ":",
                                        //       style: TextStyle(
                                        //         fontWeight: FontWeight.bold,
                                        //         color: Colors.black,
                                        //       ),
                                        //     )),
                                        // Expanded(
                                        //     flex: 6,
                                        //     child: GestureDetector(
                                        //       onTap: () {
                                        //       state.visit[0].photo != null ?  _showImageDialog(
                                        //             context, "http://118.179.149.36:83/${state.visit[0].photo}") : null;
                                        //       },
                                        //       child: Padding(
                                        //         padding: EdgeInsets.only(right: 120),
                                        //         child: state.visit[0].photo != null ? SizedBox(
                                        //             height: 80,
                                        //             child:
                                        //                 Image.network("http://118.179.149.36:83/${state.visit[0].photo}")) : SizedBox.shrink(),
                                        //       ),
                                        //     )

                                        //     //     CachedNetworkImage(
                                        //     //   imageUrl: 'http://118.179.149.36:83/${state.visit[0].photo}',

                                        //     //   progressIndicatorBuilder: (context, url, downloadProgress) =>
                                        //     //       Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                        //     //   //  errorWidget: (context, url, error) => const Image(image: AssetImage("assets/images/default_image.png")),
                                        //     // )
                                        //     )
                                      ],
                                    ),

                                    // Visibility(
                                    //   visible: state.visit[0].photo!.isNotEmpty,
                                    //   // visible: true,
                                    //   child: GridView.builder(
                                    //     padding: const EdgeInsets.symmetric(vertical: 5),
                                    //     physics: const NeverScrollableScrollPhysics(),
                                    //     shrinkWrap: true,
                                    //     itemCount: state.visit[0].photo!.length,
                                    //     gridDelegate:
                                    //     const SliverGridDelegateWithFixedCrossAxisCount(
                                    //       crossAxisCount: 3,
                                    //       crossAxisSpacing: 10,
                                    //       mainAxisSpacing: 10,
                                    //     ),
                                    //     itemBuilder: (_, index) {
                                    //       return ClipRRect(
                                    //         borderRadius: BorderRadius.circular(3),
                                    //         child: Container(
                                    //           height: double.infinity,
                                    //           width: double.infinity,
                                    //           padding: const EdgeInsets.all(0),
                                    //           decoration: BoxDecoration(
                                    //               color: MyColors.secondaryColor.withOpacity(0.4),
                                    //               borderRadius: BorderRadius.circular(3)),
                                    //           child: CustomImage(
                                    //             path:
                                    //             "${APIClients.BASE_URL}${state.visit[0].photo![index].photo}",
                                    //             fit: BoxFit.cover,
                                    //           ),
                                    //         ),
                                    //       );
                                    //     },
                                    //   ),
                                    // ),
                                    // Visibility(
                                    //   visible: !hideBtn,
                                    //   child: GridView.builder(
                                    //     physics: const NeverScrollableScrollPhysics(),
                                    //     shrinkWrap: true,
                                    //     itemCount: galleryImages!.length + 1,
                                    //     gridDelegate:
                                    //     const SliverGridDelegateWithFixedCrossAxisCount(
                                    //       crossAxisCount: 3,
                                    //       crossAxisSpacing: 10,
                                    //       mainAxisSpacing: 10,
                                    //     ),
                                    //     itemBuilder: (_, index) {
                                    //       if (index == 0) {
                                    //         return Material(
                                    //           color: Colors.white,
                                    //           borderRadius: BorderRadius.circular(3),
                                    //           child: InkWell(
                                    //             borderRadius: BorderRadius.circular(3),
                                    //             onTap: galleryImages!.length + state.visit[0].photo!.length < 3
                                    //                 ? () {
                                    //               Utils.showCustomDialog(context,
                                    //                   child: Wrap(
                                    //                     children: [
                                    //                       Container(
                                    //                         decoration: BoxDecoration(
                                    //                             color: Colors.white,
                                    //                             borderRadius:
                                    //                             BorderRadius.circular(5)),
                                    //                         padding: const EdgeInsets.all(20),
                                    //                         child: Column(
                                    //                           crossAxisAlignment:
                                    //                           CrossAxisAlignment.start,
                                    //                           children: [
                                    //                             const Text(
                                    //                               "Select Image Source",
                                    //                               style: TextStyle(
                                    //                                   fontSize: 18,
                                    //                                   fontWeight:
                                    //                                   FontWeight.bold),
                                    //                             ),
                                    //                             const SizedBox(
                                    //                               height: 30,
                                    //                             ),
                                    //                             Row(
                                    //                               children: [
                                    //                                 Expanded(
                                    //                                   flex: 5,
                                    //                                   child: GestureDetector(
                                    //                                     onTap: () {
                                    //                                       pickImageFromCamera().then((value) {
                                    //                                         Navigator.of(context).pop();
                                    //                                       });
                                    //                                     },
                                    //                                     child: Container(
                                    //                                         alignment:
                                    //                                         Alignment
                                    //                                             .center,
                                    //                                         color: const Color(
                                    //                                             0xFFDAD9D9),
                                    //                                         height: MediaQuery.of(
                                    //                                             context)
                                    //                                             .size
                                    //                                             .height *
                                    //                                             0.1,
                                    //                                         width: MediaQuery.of(
                                    //                                             context)
                                    //                                             .size
                                    //                                             .width *
                                    //                                             0.5,
                                    //                                         child:
                                    //                                         const Column(
                                    //                                           mainAxisAlignment:
                                    //                                           MainAxisAlignment
                                    //                                               .spaceEvenly,
                                    //                                           children: [
                                    //                                             Icon(Icons
                                    //                                                 .camera_alt),
                                    //                                             Text('Camera')
                                    //                                           ],
                                    //                                         )),
                                    //                                   ),
                                    //                                 ),
                                    //                                 Expanded(
                                    //                                   flex: 1,
                                    //                                   child: Container(
                                    //                                     height: 2,
                                    //                                   ),
                                    //                                 ),
                                    //                                 Expanded(
                                    //                                   flex: 5,
                                    //                                   child: GestureDetector(
                                    //                                     onTap: () {
                                    //                                       pickImageFromGallery().then((value) {
                                    //                                         Navigator.of(context).pop();
                                    //                                       });
                                    //                                     },
                                    //                                     child: Container(
                                    //                                         alignment:
                                    //                                         Alignment
                                    //                                             .center,
                                    //                                         color: const Color(
                                    //                                             0xFFDAD9D9),
                                    //                                         height: MediaQuery.of(
                                    //                                             context)
                                    //                                             .size
                                    //                                             .height *
                                    //                                             0.1,
                                    //                                         width: MediaQuery.of(
                                    //                                             context)
                                    //                                             .size
                                    //                                             .width *
                                    //                                             0.5,
                                    //                                         child:
                                    //                                         const Column(
                                    //                                           mainAxisAlignment:
                                    //                                           MainAxisAlignment
                                    //                                               .spaceEvenly,
                                    //                                           children: [
                                    //                                             Icon(Icons
                                    //                                                 .photo),
                                    //                                             Text(
                                    //                                                 'Gallery')
                                    //                                           ],
                                    //                                         )),
                                    //                                   ),
                                    //                                 ),
                                    //                               ],
                                    //                             ),
                                    //                             const SizedBox(
                                    //                               height: 20,
                                    //                             ),
                                    //                             Align(
                                    //                               alignment:
                                    //                               Alignment.centerRight,
                                    //                               child: TextButton(
                                    //                                 onPressed: () {
                                    //                                   Navigator.of(context)
                                    //                                       .pop();
                                    //                                 },
                                    //                                 style: TextButton.styleFrom(
                                    //                                     backgroundColor: Colors
                                    //                                         .red,
                                    //                                     shape: RoundedRectangleBorder(
                                    //                                         borderRadius:
                                    //                                         BorderRadius
                                    //                                             .circular(
                                    //                                             5)),
                                    //                                     padding:
                                    //                                     const EdgeInsets
                                    //                                         .symmetric(
                                    //                                         horizontal:
                                    //                                         10,
                                    //                                         vertical: 1)),
                                    //                                 child: const Text(
                                    //                                   'Cancel',
                                    //                                   style: TextStyle(
                                    //                                     color: Colors.white,
                                    //                                   ),
                                    //                                 ),
                                    //                               ),
                                    //                             )
                                    //                           ],
                                    //                         ),
                                    //                       )
                                    //                     ],
                                    //                   ));
                                    //             } : () {
                                    //               Utils.errorSnackBar(context,
                                    //                   "You can't upload more then 3 images");
                                    //             },
                                    //             child: Container(
                                    //               padding: const EdgeInsets.all(8),
                                    //               decoration: BoxDecoration(
                                    //                 borderRadius: BorderRadius.circular(3),
                                    //                 border: Border.all(color: MyColors.secondaryColor),
                                    //               ),
                                    //               child: Center(
                                    //                 child: Column(
                                    //                   mainAxisAlignment: MainAxisAlignment.center,
                                    //                   children: [
                                    //                     const Icon(
                                    //                       Icons.add_circle_outlined,
                                    //                       color: MyColors.secondaryColor,
                                    //                     ),
                                    //                     const SizedBox(height: 5),
                                    //                     Text(
                                    //                         "${galleryImages!.length + state.visit[0].photo!.length}/3")
                                    //                   ],
                                    //                 ),
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         );
                                    //       }
                                    //       return ClipRRect(
                                    //         borderRadius: BorderRadius.circular(3),
                                    //         child: Stack(
                                    //           clipBehavior: Clip.none,
                                    //           fit: StackFit.expand,
                                    //           children: [
                                    //             Container(
                                    //               padding: const EdgeInsets.all(0),
                                    //               decoration: BoxDecoration(
                                    //                   color: MyColors.secondaryColor.withOpacity(0.4),
                                    //                   borderRadius: BorderRadius.circular(3)),
                                    //               child: Image(
                                    //                 // image: FileImage(File(controller.images2![index].path))
                                    //                 image: FileImage(
                                    //                     File(galleryImages![index - 1].path)),
                                    //                 fit: BoxFit.cover,
                                    //               ),
                                    //             ),
                                    //             Positioned(
                                    //                 right: 0,
                                    //                 child: GestureDetector(
                                    //                     onTap: () {
                                    //                       setState(() {
                                    //                         galleryImages!.removeAt(index - 1);
                                    //                         // postAdBloc.state.images
                                    //                         //     .removeAt(index - 1);
                                    //                       });
                                    //                     },
                                    //                     child: Icon(
                                    //                       Icons.close,
                                    //                       size: 18,
                                    //                       color: Colors.red.shade900,
                                    //                     )))
                                    //           ],
                                    //         ),
                                    //       );
                                    //     },
                                    //   ),
                                    // ),
                                    //
                                    // Visibility(
                                    //   visible: !hideBtn,
                                    //   child: GestureDetector(onTap: () {
                                    //     submitFieldImage(id: state.visit[0].id.toString());
                                    //   }, child: Container(
                                    //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                    //     margin: EdgeInsets.only(top: 10),decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.circular(5),
                                    //     color: MyColors.secondaryColor
                                    //   ),
                                    //     child: Text("Submit",style: TextStyle(color: Colors.white),),
                                    //
                                    //   ),),
                                    // ),

                                    imageSelectWidget(context, imgUrl1, imgUrl2, imgUrl3),
                                    SizedBox(height: 10),

                                    Visibility(
                                      visible: (galleryImages.length!=0 || !hideBtn),
                                      child: GestureDetector(onTap: () async {

                                        // if(img1Path!=null){
                                        //   galleryImages.add(img1Path!);
                                        // }
                                        // if(img2Path!=null){
                                        //   galleryImages.add(img2Path!);
                                        // }
                                        // if(img3Path!=null){
                                        //   galleryImages.add(img2Path!);
                                        // }

                                        print("kafjdkasfkdjf ${galleryImages}");
                                        if(galleryImages.length==0){
                                          await QuickAlert.show(
                                            context: context,
                                            type: QuickAlertType.error,
                                            text: "Please Upload Image",
                                          );
                                        }else {
                                          submitFieldImage(id: state.visit[0].id.toString());
                                        }
                                      }, child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                        margin: EdgeInsets.only(top: 10),decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: MyColors.secondaryColor
                                      ),
                                        child: Text("Photo Submit",style: TextStyle(color: Colors.white),),

                                      ),),
                                    ),

                                    SizedBox(height: 20),

                                    // Visibility(
                                    //   visible: (state.fieldFindings != null && state.fieldFindings!.isNotEmpty),
                                    //   child: Row(
                                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //     children: [
                                    //       Text(
                                    //         'Field Findings',
                                    //         style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                                    //       ),
                                    //       GestureDetector(
                                    //         onTap: () async {
                                    //           await Navigator.of(context).push(
                                    //             MaterialPageRoute(
                                    //               builder: (context) {
                                    //                 return FieldVisitEditPage(
                                    //                   id: state.visit[0].id.toString(),
                                    //                 );
                                    //               },
                                    //             ),
                                    //           );
                                    //         },
                                    //         child: Container(
                                    //           padding: EdgeInsets.all(8),
                                    //           decoration: BoxDecoration(
                                    //               shape: BoxShape.rectangle, color: Colors.white, border: Border.all(color: Colors.black)),
                                    //           child: Icon(
                                    //             Icons.add,
                                    //             color: Colors.black,
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    // Visibility(
                                    //   visible: (state.fieldFindings == null || state.fieldFindings!.isEmpty),
                                    //   child: Row(
                                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //     children: [
                                    //       Text(
                                    //         'Field Findings',
                                    //         style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                                    //       ),
                                    //       GestureDetector(
                                    //         onTap: () async {
                                    //           await Navigator.of(context).push(
                                    //             MaterialPageRoute(
                                    //               builder: (context) {
                                    //                 return FieldFindingCreatePage(
                                    //                   id: state.visit[0].id.toString(),
                                    //                 );
                                    //               },
                                    //             ),
                                    //           );
                                    //         },
                                    //         child: Container(
                                    //           padding: EdgeInsets.all(8),
                                    //           decoration: BoxDecoration(
                                    //               shape: BoxShape.rectangle, color: Colors.white, border: Border.all(color: Colors.black)),
                                    //           child: Icon(
                                    //             Icons.add,
                                    //             color: Colors.black,
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    // SizedBox(height: 10.0.h)
                                  ],
                                ),
                              ),
                              // SizedBox(
                              //   height: 15.0.h,
                              // ),
                            ],
                          ),

                          SizedBox(
                            height: 10,
                          ),
                          // state.fieldFindings!.isEmpty
                          //     ? Container()
                          //     : Column(
                          //         children: [
                          //           ...List.generate(state.fieldFindings!.length, (index) {
                          //             return Column(
                          //               crossAxisAlignment: CrossAxisAlignment.start,
                          //               children: [
                          //                 ExpansionTile(
                          //                   initiallyExpanded: true,
                          //                   trailing: Icon(Icons.keyboard_arrow_down_outlined), // Icon for the leading position
                          //                   title: Text(
                          //                     state.fieldFindings![index].question ?? '',
                          //                     style: TextStyle(fontSize: 12),
                          //                   ),
                          //                   children: [
                          //                     ...List.generate(state.fieldFindings![index].questionAnswer!.length, (AnswerIndex) {
                          //                       return Column(
                          //                         children: [
                          //                           SizedBox(
                          //                               height: 100.0.h,
                          //                               width: double.infinity,
                          //                               child: TextField(
                          //                                 readOnly: true,
                          //                                 controller: FieldVisitDetailsController[index][AnswerIndex],
                          //                                 maxLines: 5, // Set to null for an unlimited number of lines
                          //                                 decoration: InputDecoration(
                          //                                   border: OutlineInputBorder(),
                          //                                   hintText: state.fieldFindings![index].questionAnswer![AnswerIndex].answer,
                          //                                 ),
                          //                               )),
                          //                           SizedBox(
                          //                             height: 10,
                          //                           )
                          //                         ],
                          //                       );
                          //                     }),
                          //                     SizedBox(
                          //                       height: 10.0.h,
                          //                     ),
                          //                   ],
                          //                 ),
                          //                 SizedBox(
                          //                   height: 10,
                          //                 ),
                          //                 GestureDetector(onTap: () {
                          //                   print("kafjdkasfkdjf ${galleryImages}");
                          //                   submitFieldImage(id: state.visit[0].id.toString());
                          //                 }, child: Container(
                          //                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          //                   margin: EdgeInsets.only(top: 10),decoration: BoxDecoration(
                          //                     borderRadius: BorderRadius.circular(5),
                          //                     color: MyColors.secondaryColor
                          //                 ),
                          //                   child: Text( (state.fieldFindings != null && state.fieldFindings!.isNotEmpty)
                          //                       ? "Update"
                          //                       :"Submit",
                          //                     style: TextStyle(color: Colors.white),),
                          //
                          //                 ),)
                          //               ],
                          //             );
                          //           }),
                          //         ],
                          //       ),

                          ///CREATE
                          state.fieldFindings!.isNotEmpty
                              ? Container()
                              : Form(
                            key: _fieldformKey,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  BlocConsumer<FieldFindingCreateBloc, FieldFindingCreateState>(
                                      bloc: fieldFindingCreateBloc,
                                      listenWhen: (previous, current) => current is FieldFindingCreateActionState,
                                      buildWhen: (previous, current) => current is! FieldFindingCreateActionState,
                                      listener: (context, state) {
                                        // TODO: implement listener
                                      },
                                      builder: (context, state) {
                                        if (state is FieldFindingCreateLoadingState) {
                                          return Container(
                                            child: Center(child: CircularProgressIndicator()),
                                          );
                                        } else if (state is FieldFindingCreateSuccessState) {
                                          // print("jjjjjjjjjjjjj");
                                          // print(state.fieldCreateData.length);
                                          globalvalue++;
                                          if (globalvalue == 1) {
                                            state.fieldCreateData.forEach(
                                                  (element) {
                                                if (element.type == 'text') {
                                                  textCreate.add(element);
                                                  text_.add(element.id.toString());
                                                  textData = List.generate(text.length, (textIndex) => '');
                                                } else if (element.type == 'radio') {
                                                  radio.add(element);
                                                  radio_.add(element.id.toString());
                                                  selectedValue = List.generate(radio.length, (radioIndex) => '');

                                                  // radio_1 = List.generate(radio.length, (index) => []);
                                                } else if (element.type == 'check-box') {
                                                  checkbox.add(element);
                                                  check_box_.add(element.id.toString());

                                                  // checkboxData = List.generate(checkbox.length, (checkboxIndex) => '');
                                                  // checkbox.forEach((e) {
                                                  //   checkboxData = List.generate(e.fieldSettingOptions.length, (index) => '');
                                                  // });
                                                } else if (element.type == 'drop-down') {
                                                  dropdown.add(element);
                                                  dropdown_.add(element.id.toString());
                                                  dropdownDataList = List.generate(dropdown.length, (dropdownIndex) => '');
                                                } else if (element.type == 'number') {
                                                  number.add(element);
                                                  number_.add(element.id.toString());
                                                  numberData = List.generate(number.length, (numberIndex) => '');
                                                }
                                              },
                                            );
                                          }
                                          // globalStoreValue++;
                                          // if (globalStoreValue == 1) {
                                          //   text_.add(text.first.id);
                                          //   number_.add(number.first.id);
                                          //   radio_.add(radio.first.id);
                                          //   dropdown_.add(dropdown.first.id);
                                          //   check_box_.add(checkbox.first.id);
                                          // }

                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,

                                            children: [
                                              // ElevatedButton(
                                              //     onPressed: () {
                                              //       textInputValue();
                                              //       numberInputValue();
                                              //       Map a = {
                                              //         "field_visit_id": widget.id.toString(),
                                              //         "question_id": {
                                              //           "text_": text_,
                                              //           "dropdown_": dropdown_,
                                              //           "check_box_": check_box_,
                                              //           "radio_": radio_,
                                              //           "number_": number_
                                              //         },
                                              //         "textData": textData,
                                              //         "dropdownData": dropdownDataList,
                                              //         "checkboxData": checkboxData,
                                              //         "numberData": numberData,
                                              //         "radioData": selectedValue
                                              //       };
                                              //       print(jsonEncode(a));
                                              //     },
                                              //     child: Text("data")),
                                              //   Text

                                              ...List.generate(textCreate.length, (textIndex) {
                                                textconroller.add(
                                                    List.generate(textCreate[textIndex].fieldSettingOptions.length, (index) => TextEditingController()));

                                                return ExpansionTile(
                                                  // tilePadding: EdgeInsets.zero,
                                                    initiallyExpanded: true,
                                                    leading: Text("${textIndex + 1}"),
                                                    trailing: Icon(Icons.keyboard_arrow_down_outlined), // Icon for the leading position
                                                    title: Text(
                                                      textCreate[textIndex].question,
                                                      style: TextStyle(fontSize: 12),
                                                    ),
                                                    children: List.generate(textCreate[textIndex].fieldSettingOptions.length, (textOptionIndex) {
                                                      return Padding(
                                                        padding: EdgeInsets.all(10),
                                                        child: SizedBox(
                                                            height: 100.0.h,
                                                            width: double.infinity,
                                                            child: TextFormField(
                                                              controller: textconroller[textIndex][textOptionIndex],
                                                              maxLines: 5,
                                                              decoration: InputDecoration(
                                                                  border: OutlineInputBorder(),
                                                                  labelText: textCreate[textIndex].fieldSettingOptions[textOptionIndex].optionName,
                                                                  floatingLabelBehavior: FloatingLabelBehavior.always),
                                                            )),
                                                      );
                                                    })
                                                );
                                              }),
                                              //number
                                              ...List.generate(number.length, (numberIndex) {
                                                numberconroller.add(List.generate(
                                                    number[numberIndex].fieldSettingOptions.length, (index) => TextEditingController()));

                                                return ExpansionTile(
                                                  trailing: Icon(Icons.keyboard_arrow_down_outlined), // Icon for the leading position
                                                  title: Text(
                                                    number[numberIndex].question,
                                                    style: TextStyle(fontSize: 12),
                                                  ),
                                                  children: [
                                                    ...List.generate(number[numberIndex].fieldSettingOptions.length, (numberOptionIndex) {
                                                      return Padding(
                                                        padding: EdgeInsets.all(10),
                                                        child: SizedBox(
                                                            height: 100.0.h,
                                                            width: double.infinity,
                                                            child: TextFormField(
                                                              keyboardType: TextInputType.number,
                                                              controller: numberconroller[numberIndex][numberOptionIndex],
                                                              maxLines: 300,
                                                              decoration: InputDecoration(
                                                                  border: OutlineInputBorder(),
                                                                  labelText: number[numberIndex].fieldSettingOptions[numberOptionIndex].optionName,
                                                                  floatingLabelBehavior: FloatingLabelBehavior.always),
                                                              validator: (value) {
                                                                if (value == null || value.isEmpty) {
                                                                  return 'Please enter a value';
                                                                }
                                                                // Add more custom validation rules if needed
                                                                return null; // Return null if the input is valid
                                                              },
                                                            )),
                                                      );
                                                    })
                                                  ],
                                                );
                                              }),
                                              //Radio Button
                                              ...List.generate(radio.length, (radioIndex) {
                                                return ExpansionTile(
                                                  trailing: Icon(Icons.keyboard_arrow_down_outlined),
                                                  title: Text(
                                                    radio[radioIndex].question,
                                                    style: TextStyle(fontSize: 12),
                                                  ),
                                                  children: [
                                                    ...List.generate(radio[radioIndex].fieldSettingOptions.length, (radioOptionIndex) {
                                                      return Row(
                                                        children: [
                                                          Radio(
                                                            value: radio[radioIndex].fieldSettingOptions[radioOptionIndex].slug,
                                                            groupValue: selectedValue![radioIndex],
                                                            onChanged: (value) {
                                                              setState(() {
                                                                selectedValue![radioIndex] = value.toString();

                                                                // radio[radioIndex].fieldSettingOptions.forEach((element) {
                                                                //   if (element.optionName == selectedValue![radioIndex]) {
                                                                //     print(element.id);
                                                                //     print(element.slug);

                                                                //       try12.add(element.slug);

                                                                //   }
                                                                // });
                                                                // selectedValue![radioIndex] =
                                                                //     radio[radioIndex].fieldSettingOptions[radioOptionIndex].slug;
                                                              });
                                                            },
                                                          ),
                                                          Text(radio[radioIndex].fieldSettingOptions[radioOptionIndex].optionName),
                                                        ],
                                                      );
                                                    })
                                                  ],
                                                );
                                              }),
                                              //checkbox
                                              ...List.generate(checkbox.length, (checkboxIndex) {
                                                isChecked.add(List.generate(checkbox[checkboxIndex].fieldSettingOptions.length, (index) => false));
                                                return ExpansionTile(
                                                  trailing: Icon(Icons.keyboard_arrow_down_outlined),
                                                  title: Text(
                                                    checkbox[checkboxIndex].question,
                                                    style: TextStyle(fontSize: 12),
                                                  ),
                                                  children: [
                                                    ...List.generate(checkbox[checkboxIndex].fieldSettingOptions.length, (checkboxOptionIndex) {
                                                      return Row(
                                                        children: [
                                                          Checkbox(
                                                            value: isChecked[checkboxIndex][checkboxOptionIndex],
                                                            onChanged: (value) {
                                                              setState(() {
                                                                isChecked[checkboxIndex][checkboxOptionIndex] = value!;
                                                              });
                                                              if (value!) {
                                                                // print(checkbox[checkboxIndex].fieldSettingOptions[checkboxOptionIndex].id);
                                                                // print(checkbox[checkboxIndex].fieldSettingOptions[checkboxOptionIndex].slug);
                                                                checkboxData
                                                                    .add(checkbox[checkboxIndex].fieldSettingOptions[checkboxOptionIndex].slug);
                                                              } else {
                                                                checkboxData
                                                                    .remove(checkbox[checkboxIndex].fieldSettingOptions[checkboxOptionIndex].slug);
                                                              }
                                                            },
                                                          ),
                                                          Text(checkbox[checkboxIndex].fieldSettingOptions[checkboxOptionIndex].optionName),
                                                        ],
                                                      );
                                                    })
                                                  ],
                                                );
                                              }),

                                              ...List.generate(dropdown.length, (dropdownIndex) {
                                                return ExpansionTile(
                                                  trailing: Icon(Icons.keyboard_arrow_down_outlined),
                                                  title: Text(
                                                    dropdown[dropdownIndex].question,
                                                    style: TextStyle(fontSize: 12),
                                                  ),
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.all(15),
                                                      child: DropdownButtonFormField<String>(
                                                          value: selectedDropdownValues[dropdownIndex],
                                                          items: dropdown[dropdownIndex]
                                                              .fieldSettingOptions
                                                              .map<DropdownMenuItem<String>>(
                                                                (option) => DropdownMenuItem<String>(
                                                              value: option.optionName,
                                                              child: Text(option.optionName),
                                                            ),
                                                          )
                                                              .toList(),
                                                          decoration: const InputDecoration(
                                                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                            border: OutlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.black),
                                                            ),
                                                            labelText: '--Select Dropdown--',
                                                          ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              // dropdownDataList![dropdownIndex] = value!;
                                                              dropdownDataList![dropdownIndex] =
                                                                  dropdown[dropdownIndex].fieldSettingOptions[dropdownIndex].slug;
                                                              // print(selectedDropdownValues[dropdownIndex]);
                                                            });
                                                          }),
                                                    )
                                                  ],
                                                );
                                              }),

                                              GestureDetector(
                                                      onTap: () async {
                                                        final connectivityResult = await (Connectivity().checkConnectivity());
                                                        if (connectivityResult.contains(ConnectivityResult.mobile) ||
                                                            connectivityResult.contains( ConnectivityResult.wifi))
                                                        {
                                                          if (_fieldformKey.currentState!.validate()) {
                                                            textInputValue();
                                                            numberInputValue();
                                                            Map storeBody = {
                                                              "field_visit_id": widget.id.toString(),
                                                              "question_id": {
                                                                "text_": text_,
                                                                "dropdown_": dropdown_,
                                                                "check_box_": check_box_,
                                                                "radio_": radio_,
                                                                "number_": number_
                                                              },
                                                              "textData": textData,
                                                              "dropdownData": dropdownDataList,
                                                              "checkboxData": checkboxData,
                                                              "numberData": numberData,
                                                              "radioData": selectedValue
                                                            };
                                                            print("sdkljfhgjkdshfg"+jsonEncode(storeBody));
                                                            setState(() {
                                                              _isLoading = true;
                                                            });
                                                            Map fiedFindingSubmitResponse = await Repositores().FiedFindingSubmitApi(storeBody);
                                                            if (fiedFindingSubmitResponse['status'] == 200) {
                                                              await QuickAlert.show(
                                                                context: context,
                                                                type: QuickAlertType.success,
                                                                text: "Field finding stored successfully!",
                                                              );
                                                              Navigator.pop(context);
                                                              // Navigator.pop(context);
                                                              // await Navigator.of(context).pushAndRemoveUntil(
                                                              //     MaterialPageRoute(builder: (context) => Homepage()),
                                                              //     (Route<dynamic> route) => false);

                                                              setState(() {
                                                                _isLoading = false;
                                                              });
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
                                                      child: Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                                        margin: EdgeInsets.only(top: 10),decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          color: MyColors.secondaryColor
                                                      ),
                                                        child: _isLoading
                                                            ? Center(child: AllService.LoadingToast())
                                                            : Text("Finding Submit",style: TextStyle(color: Colors.white),),

                                                      ),),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          );
                                        }
                                        return Container();
                                      })
                                ],
                              ),
                            ),
                          ),

                          ///UPDATE
                          state.fieldFindings!.isEmpty
                              ? Container()
                              : BlocConsumer<FieldFindingUpdateBloc, FieldFindingUpdateState>(
                              bloc: fieldFindingUpdateBloc,
                              listenWhen: (previous, current) => current is FieldFindingUpdateActionState,
                              buildWhen: (previous, current) => current is! FieldFindingUpdateActionState,
                              listener: (context, state) {
                                // TODO: implement listener
                              },
                              builder: (context, state) {
                                if (state is FieldFindingUpdateLoadingState) {
                                  return Container(
                                    child: Center(child: CircularProgressIndicator()),
                                  );
                                } else if (state is FieldFindingUpdateSuccessState) {
                                  globalvalue++;
                                  if (globalvalue == 1) {
                                    state.question.forEach(
                                          (element) {
                                        if (element.type == 'text') {
                                          text.add(element);
                                          all_text_id.add(element.id.toString());
                                        }
                                      },
                                    );
                                    for (int i = 0; i < text.length; i++) {
                                      List<TextEditingController> textControllerValue = [];
                                      for (int j = 0; j < text[i].fieldSettingOptions.length; j++) {
                                        textControllerValue.add(TextEditingController(
                                          text: text[i].fieldSettingOptions[j].ansValue.toString(),
                                        ));
                                      }
                                      textController.add(textControllerValue);
                                    }
                                  }

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      ...List.generate(text.length, (textIndex) {
                                        // textController
                                        //     .add(List.generate(text[textIndex].fieldSettingOptions.length, (index) => TextEditingController()));

                                        return ExpansionTile(
                                          initiallyExpanded: true,
                                          trailing: Icon(Icons.keyboard_arrow_down_outlined), // Icon for the leading position
                                          title: Text(
                                            text[textIndex].question,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          children: [
                                            ...List.generate(text[textIndex].fieldSettingOptions.length, (textAnswerIndex) {
                                              return Column(
                                                children: [
                                                  SizedBox(
                                                      height: 100.0.h,
                                                      width: double.infinity,
                                                      child: TextField(
                                                        controller: textController[textIndex][textAnswerIndex],
                                                        maxLines: 5,
                                                        decoration: InputDecoration(
                                                          border: OutlineInputBorder(),
                                                          hintText: text[textIndex].fieldSettingOptions[textAnswerIndex].optionName,
                                                        ),
                                                      )),
                                                  SizedBox(
                                                    height: 10,
                                                  )
                                                ],
                                              );
                                            }),
                                            SizedBox(
                                              height: 10.0.h,
                                            ),
                                          ],
                                        );
                                      }),
                                      // SizedBox(
                                      //   height: 10,
                                      // ),
                                      // ElevatedButton(
                                      //     onPressed: () {
                                      //       print(all_text_id);
                                      //       getTextControllerValues();
                                      //       Map storeBody = {
                                      //         "field_visit_id": widget.id.toString(),
                                      //         "question_id": {
                                      //           "text_": all_text_id,
                                      //           "dropdown_": [],
                                      //           "check_box_": [],
                                      //           "radio_": [],
                                      //           "number_": []
                                      //         },
                                      //         "textData": allTextValues,
                                      //         "dropdownData": [],
                                      //         "checkboxData": [],
                                      //         "numberData": [],
                                      //         "radioData": []
                                      //       };
                                      //       print(allTextValues.length);
                                      //       print(jsonEncode(storeBody));
                                      //     },
                                      //     child: Text("aa")),
                                      _isLoading
                                          ? Center(child: AllService.LoadingToast())
                                          : GestureDetector(
                                              onTap: () async {
                                                final connectivityResult = await (Connectivity().checkConnectivity());
                                                if (connectivityResult.contains(ConnectivityResult.mobile)  ||
                                                    connectivityResult.contains( ConnectivityResult.wifi)
                                                ) {
                                                  // numberInputValue();
                                                  getTextControllerValues();
                                                  Map storeBody = {
                                                    "field_visit_id": widget.id.toString(),
                                                    "question_id": {
                                                      "text_": all_text_id,
                                                      "dropdown_": [],
                                                      "check_box_": [],
                                                      "radio_": [],
                                                      "number_": []
                                                    },
                                                    "textData": allTextValues,
                                                    "dropdownData": [],
                                                    "checkboxData": [],
                                                    "numberData": [],
                                                    "radioData": []
                                                  };

                                                  print(jsonEncode(storeBody));

                                                  setState(() {
                                                    _isLoading = true;
                                                  });
                                                  Map fiedFindingSubmitResponse =
                                                  await Repositores().FiedFindingUpdateSubmitApi(storeBody, widget.id.toString());
                                                  if (fiedFindingSubmitResponse['status'] == 200) {
                                                    await QuickAlert.show(
                                                      context: context,
                                                      type: QuickAlertType.success,
                                                      text: "Field finding stored successfully!",
                                                    );
                                                    // await Navigator.of(context).pushReplacement(
                                                    //   MaterialPageRoute(
                                                    //       builder: (context) => FieldVisitDetailsPage(
                                                    //             id: widget.id,
                                                    //           )),
                                                    // );
                                                    // await Navigator.of(context).pushAndRemoveUntil(
                                                    //     MaterialPageRoute(builder: (context) => Homepage()),
                                                    //     (Route<dynamic> route) => false);

                                                    Navigator.pop(context);
                                                    Navigator.pop(context);


                                                    setState(() {
                                                      _isLoading = false;
                                                    });
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
                                              },
                                              child:Container(
                                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                                margin: EdgeInsets.only(top: 10),decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  color: MyColors.secondaryColor
                                              ),
                                                child: Text("Finding Update",style: TextStyle(color: Colors.white),),

                                              ),),
                                      SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  );
                                }
                                return Container();
                              })
                        ],
                      );
                    }
                    return Container();
                  }),
            ],
          ),
        ),
      ),
    );
  }

  //text input value
  List<String> allTextValues = [];
  void getTextControllerValues() {
    allTextValues.clear();
    for (int i = 0; i < text.length; i++) {
      for (int j = 0; j < text[i].fieldSettingOptions.length; j++) {
        allTextValues.add(textController[i][j].text);
      }
    }
    print(allTextValues);
  }

  areaTile({required String areaTitle, String areaName = ''}) {
    return areaName.isEmpty
        ? SizedBox.shrink()
        : Row(
            children: [
              Expanded(
                child: Text(
                  areaTitle,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  ":",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: Text("${areaName}",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    )),
              ),
            ],
          );
  }

  // void _showImageDialog(BuildContext context, String imageUrl) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Image.network(imageUrl,errorBuilder: (context, error, stackTrace) {
  //               return Image.asset("assets/icons/error.png", color: Colors.red.withOpacity(0.5),);
  //             },),
  //             // Add other widgets or buttons as needed
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  submitFieldImage({required String id}) async {

    final connectivityResult = await ConnectivityProvider().rcheckInternetConnection();
    if (connectivityResult) {
          await Repositores().uploadFieldVisitImage(imagesPath: galleryImages, id: id).then((value) async {
            if (value == "success") {
              await QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                text: "Image Upload successfully",
              );
              Navigator.pop(context);

            } else {
              await QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                text: "Visit Report Add Failed",
              );
            }
          });
    }
  }

  Wrap imageSelectWidget(BuildContext context, String imageUrl1, String imageUrl2, String imageUrl3) {
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
                final compressedFile1 = await imageProcessing(imgFile: img);
                final byte = compressedFile1!.readAsBytesSync();
                setState(() {
                  img1 = byte as Uint8List?;
                  img1Path = compressedFile1.path;
                });
                if(img1Path!=null){
                  galleryImages.add(img1Path!);
                }
                log('image 1 path $img1Path');
              } else {
                return;
              }
            }
          },
          imgStep: '1',
          imgUrl: imageUrl1,
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
                  img2 = byte as Uint8List?;
                  img2Path = compressedFile1.path;
                });
                if(img2Path!=null){
                  galleryImages.add(img2Path!);
                }
                log('image 2 path $img2Path');
              } else {
                return;
              }
            }
          },
          imgStep: '2',
          imgUrl: imageUrl2,
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
                  img3 = byte as Uint8List?;
                  img3Path = compressedFile1.path;
                });
                if(img3Path!=null){
                  galleryImages.add(img3Path!);
                }
                //log('image 2 path $img2Path');
              } else {
                return;
              }
            }
          },
          imgStep: '3',
          imgUrl: imageUrl3,
        ),
      ],
    );
  }

  singleImage({Uint8List? img, required VoidCallback function, required String imgStep, required String imgUrl}) {
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
                decoration: BoxDecoration(color: Color(0xff989eb1).withOpacity(0.4), borderRadius: BorderRadius.circular(3)),
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
                  : img == null && imgUrl !=""
                  ? Container(
                decoration: BoxDecoration(color: Color(0xff989eb1).withOpacity(0.4), borderRadius: BorderRadius.circular(3)),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowSingleImage(
                          img: img,
                          isImgUrl: false,
                          imageUrl: imgUrl,
                        ),
                      ),
                    );
                  },
                  child: Image(
                    image: NetworkImage(imgUrl),
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

              img != null && imgUrl== ""
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
                            if(galleryImages.length==1){
                              galleryImages.removeAt(0);
                            }
                        } else if (imgStep == '2') {
                          setState(() {
                            img2 = null;
                            img2Path = null;
                          });
                              galleryImages.removeAt(0);
                            // if(galleryImages.length==1){
                            //   print('fghdfhdfgh1');
                            // }
                            // if(galleryImages.length==2){
                            //   print('fghdfhdfgh2');
                            //   galleryImages.removeAt(1);
                            // }
                        } else if (imgStep == '3') {
                          setState(() {
                            img3 = null;
                            img3Path = null;
                          });
                            if(galleryImages.length==1){
                              galleryImages.removeAt(0);
                            }else{
                              galleryImages.removeAt(1);
                            }
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(shape: BoxShape.rectangle, color: Colors.red, borderRadius: BorderRadius.circular(2)),
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.white,
                        ),
                      )))
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  Future<File?> imageProcessing({required XFile imgFile}) async {
    final file2 = File(imgFile.path);
    final lastIndex = file2.absolute.path.lastIndexOf(new RegExp(r'.jp'));
    final splitted = file2.absolute.path.substring(0, (lastIndex));
    final outPath2 = "${splitted}_out${file2.absolute.path.substring(lastIndex)}";
    final compressedFile2 = await Utils().compressImgAndGetFile(file2, outPath2);
    return compressedFile2;
  }

  Uint8List? img1;
  Uint8List? img2;
  Uint8List? img3;

  String? img1Path;
  String? img2Path;
  String? img3Path;


  List<String> selectedValuesQuestion = [];
  List<List<String>> selectedValuesOptions = [];
  //text input value
  void textInputValue() {
    // List<String> TextControllerValues = [];
    // for (List<TextEditingController> venueControllers in textconroller) {
    //   for (TextEditingController controller in venueControllers) {
    //     String inputValue = controller.text.trim();
    //     String intValue = inputValue.isEmpty ? '' : inputValue;
    //     TextControllerValues.add(intValue);
    //   }
    // }
    // textData = TextControllerValues.where((value) => value.isNotEmpty).toList();
    // print("Text values: $textData");

    //  new implement
    textData.clear();
    for (int i = 0; i < textCreate.length; i++) {
      for (int j = 0; j < textCreate[i].fieldSettingOptions.length; j++) {
        textData.add(textconroller[i][j].text);
      }
    }
  }

  //number input value
  void numberInputValue() {
    List<String> numberControllerValues = [];
    for (List<TextEditingController> venueControllers in numberconroller) {
      for (TextEditingController controller in venueControllers) {
        String inputValue = controller.text.trim();
        String intValue = inputValue.isEmpty ? '' : inputValue;
        numberControllerValues.add(intValue);
      }
    }

    numberData = numberControllerValues.where((value) => value.isNotEmpty).toList();

    print("mumber values  : $textData");
  }

}
