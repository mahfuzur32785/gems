import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:village_court_gems/bloc/AACO_info_add_bloc/aaco_info_add_bloc.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/aacoListModel.dart';
import 'package:village_court_gems/models/aaco_model/aaco_district_model.dart';
import 'package:village_court_gems/models/aaco_model/aaco_nav_model.dart';
import 'package:village_court_gems/models/aaco_model/aaco_options_dropdown.dart';
import 'package:village_court_gems/models/activityDetailsModel.dart';
import 'package:village_court_gems/models/locationModel.dart';
import 'package:village_court_gems/provider/connectivity_provider.dart';
import 'package:village_court_gems/services/all_services/all_services.dart';
import 'package:village_court_gems/util/colors.dart';
import 'package:village_court_gems/view/home/homepage.dart';
import 'package:village_court_gems/widget/custom_appbar.dart';

class AACO_Info_Add extends StatefulWidget {
  static const pageName = 'AACO_Info_Add';
  const AACO_Info_Add({super.key});

  @override
  State<AACO_Info_Add> createState() => _AACO_Info_AddState();
}

class _AACO_Info_AddState extends State<AACO_Info_Add> {
  final AacoInfoAddBloc aacoInfoAddBloc = AacoInfoAddBloc();
  @override
  // ignore: override_on_non_overriding_member
  String district_id = '';
  String union_id = '';
  String upazila_id = '';
  District? chngDistrictVal;
  Upazila? chngUpazilaVal;
  Union? chngUnionVal;
  String recruitment_statusID = '';
  String acco_availiablity_status = '';
  String apointment_date = '';
  String? selectedDivision;
  String? selectedDistrict;
  String? selectedrecruitmentStatus;
  String? selectedAvailabilitySts;
  String? selectedUpazila;
  String? selectedUion;
  String? selectedRsnFrNonAvofAacName;
  int? selectedRsnFrNonAvofAacID;
  int? selectedRsnFrNonCmplofRecID;
  int? recruitmentStsID;
  int? selectedRsnFrNonCmplofRec;
  String? selectedRsnFrNonCmplofRecName;
  bool isYesCheckedR = false;
  bool isNoCheckedR = true;
  bool isYesCheckedA = false;
  bool isNoCheckedA = true;
  bool _isLoading = false;
  DateTime? fromSelectedDate;
  List<AacoResult> aacoNonavDataList = [];
  List<AacoResult> aacoNonComletionReasonList = [];
  TextEditingController dateofRecruitmentController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  final recAvyesNameController = TextEditingController();
  final recAvyesEmailController = TextEditingController();
  final recAvyesMobileController = TextEditingController();
  final recAvNoRsnNonAvlAacoRsnOtherController = TextEditingController();
  final recNoRsnNonCmplAacoRsnOtherController = TextEditingController();
  final GlobalKey<FormState> _formAACOKey = GlobalKey<FormState>();
  AacoOptionsDropdown? recruitMentStsVal;
  AacoOptionsDropdown? aacoAvStsVal;
  AacoOptionsDropdown? recAvyesGenderVal;
  AacoResult? rsnFrNonAvofAacVal;
  AacoResult? rsnFrNonCmplofRecVal;

  String? recAvyesSelectedGender;
  Future<void> _fromSelectDate(BuildContext context, String formType) async {
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
        if (formType == 'DoRecruitment') {
          dateofRecruitmentController.text = DateFormat('dd/MM/yyyy').format(fromSelectedDate!);
        } else if (formType == 'DoApprCOmplRecruitment') {
          remarksController.text = DateFormat('dd/MM/yyyy').format(fromSelectedDate!);
        }
      });
    }
  }

  void initState() {
    super.initState();
    aacoInfoAddBloc.add(AacoInfoAddInitialEvent());
    getNonAvailabilityStatusForNoList();
    getNonCompletionAaco();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: "Add AACO Informations",
      ),
      body: BlocConsumer<AacoInfoAddBloc, AacoInfoAddState>(
        bloc: aacoInfoAddBloc,
        buildWhen: (previous, current) => previous != current,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is AacoInfoAddLoadingState) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (state is AacoInfoAddSuccessState) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "AACO Location Area :",
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formAACOKey,
                      child: Column(
                        children: [

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 50.0.h,
                                width: 160.0.w,
                                child: DropdownButtonFormField<String?>(
                                  isExpanded: true,
                                  value: selectedDistrict,
                                  onChanged: (newValue) {
                                    setState(() {
                                      chngUpazilaVal = null;
                                      chngUnionVal = null;

                                      selectedDistrict = newValue!;

                                      for (var entry in state.district) {
                                        if (selectedDistrict == entry.nameEn) {
                                          district_id = entry.id.toString();
                                          aacoInfoAddBloc.add(AacoUpazilaClickEvent(id: entry.id));
                                        }
                                      }
                                    });
                                  },
                                  items: state.district.map<DropdownMenuItem<String>>((item) {
                                    return DropdownMenuItem<String>(
                                      value: item.nameEn,
                                      child: Text(item.nameEn!),
                                    );
                                  }).toList(),
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                    labelText: 'Select District',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select District';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 50.0.h,
                                width: 160.0.w,
                                child: DropdownButtonFormField<Upazila>(
                                  isExpanded: true,
                                  value: chngUpazilaVal,
                                  onChanged: (newValue) {
                                    setState(() {
                                      chngUnionVal = null;
                                      chngUpazilaVal = newValue!;
                                      upazila_id = chngUpazilaVal!.id.toString();

                                      // print(entry['name_en']);
                                      // print("selectedUpazilaaaaaaaaaaaa ${entry['id']}");

                                      aacoInfoAddBloc.add(AacoUnionClickEvent(id: newValue.id));

                                      //selectedUion = null;
                                    });
                                  },
                                  items: (state.upazila ?? []).map<DropdownMenuItem<Upazila>>((item) {
                                    return DropdownMenuItem<Upazila>(
                                      value: item,
                                      child: Text(item.nameEn!),
                                    );
                                  }).toList(),
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                    labelText: 'Select Upazila',
                                  ),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select Upazila';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 50.0.h,
                                width: 160.0.w,
                                child: DropdownButtonFormField<Union>(
                                  isExpanded: true,
                                  value: chngUnionVal,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  onChanged: (newValue) {
                                    setState(() {
                                      chngUnionVal = newValue!;

                                      union_id = chngUnionVal!.id.toString();

                                      // union = entry['id'].toString();
                                    });
                                  },
                                  items: (state.union ?? []).map<DropdownMenuItem<Union>>((item) {
                                    return DropdownMenuItem<Union>(
                                      value: item,
                                      onTap: () {
                                        // setState(() {
                                        //   union_id = item['id'].toString();
                                        // });
                                      },
                                      child: Text(item.nameEn ?? ''),
                                    );
                                  }).toList(),
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                    labelText: 'Select Union',
                                  ),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select Union';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 50.0.h,
                                width: 160.0.w,
                                child: DropdownButtonFormField<AacoOptionsDropdown>(
                                  isExpanded: true,
                                  value: recruitMentStsVal,
                                  onChanged: (newValue) {
                                    setState(() {
                                      recruitMentStsVal = newValue;
                                      selectedrecruitmentStatus = newValue!.optionName;
                                    });
                                  },
                                  items: recruitmentDropdown.map<DropdownMenuItem<AacoOptionsDropdown>>((item) {
                                    return DropdownMenuItem<AacoOptionsDropdown>(
                                      value: item,
                                      child: Text(item.optionName!),
                                    );
                                  }).toList(),
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                    labelText: 'Recruitment Status',
                                  ),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select Recruitment Status';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // BlocConsumer<AacoInfoAddBloc, AacoInfoAddState>(
                    //     bloc: aacoInfoAddBloc,
                    //     //listenWhen: (previous, current) => current is AacoInfoAddActionState,
                    //     buildWhen: (previous, current) => previous != current,
                    //     listener: (context, state) {},
                    //     builder: (context, state) {
                    //
                    //       if (state is AacoInfoAddSuccessState) {
                    //         return ;
                    //       }
                    //       return Container();
                    //     }),
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     // Container(
                    //     //   alignment: Alignment.centerLeft,
                    //     //   child: Text(
                    //     //     "Appointment Date :",
                    //     //     style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0.sp),
                    //     //   ),
                    //     // ),
                    //     // SizedBox(
                    //     //   height: 10.0.h,
                    //     // ),
                    //     // SizedBox(
                    //     //   height: 50.0.h,
                    //     //   child: GestureDetector(
                    //     //     onTap: () => _fromSelectDate(context),
                    //     //     child: AbsorbPointer(
                    //     //       child: TextFormField(
                    //     //           readOnly: true,
                    //     //           controller: dateController,
                    //     //           decoration: const InputDecoration(
                    //     //             enabledBorder: OutlineInputBorder(
                    //     //               borderSide: BorderSide(width: 1, color: Colors.black),
                    //     //             ),
                    //     //             hintText: "dd/mm/yyyy",
                    //     //             suffixIcon: Icon(Icons.calendar_today),
                    //     //           ),
                    //     //           validator: (value) {
                    //     //             if (value!.isEmpty) {
                    //     //               return 'Please Select Date';
                    //     //             }
                    //     //             return null;
                    //     //           }),
                    //     //     ),
                    //     //   ),
                    //     // ),
                    //     // SizedBox(
                    //     //   height: 15.0.h,
                    //     // ),
                    //     // Padding(
                    //     //   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                    //     //   child: Text(
                    //     //     "Recuitment Status",
                    //     //     style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0.sp),
                    //     //   ),
                    //     // ),
                    //     DropdownButtonFormField<AacoOptionsDropdown>(
                    //       isExpanded: true,
                    //       value: recruitMentStsVal,
                    //       onChanged: (newValue) {
                    //         setState(() {
                    //           recruitMentStsVal = newValue;
                    //           selectedrecruitmentStatus = newValue!.optionName;
                    //         });
                    //       },
                    //       items: recruitmentDropdown.map<DropdownMenuItem<AacoOptionsDropdown>>((item) {
                    //         return DropdownMenuItem<AacoOptionsDropdown>(
                    //           value: item,
                    //           child: Text(item.optionName!),
                    //         );
                    //       }).toList(),
                    //       decoration: const InputDecoration(
                    //         contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    //         border: OutlineInputBorder(
                    //           borderSide: BorderSide(color: Colors.black),
                    //         ),
                    //         labelText: 'Recruitment Status',
                    //       ),
                    //       validator: (value) {
                    //         if (value == null) {
                    //           return 'Please select Recruitment Status';
                    //         }
                    //         return null;
                    //       },
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    Visibility(
                      visible: selectedrecruitmentStatus == 'Yes',
                      child: Container(
                        //height: 200,
                        // padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                        // margin: const EdgeInsets.symmetric(vertical: 9),
                        //decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    // height: 50.0.h,
                                    // width: 160.0.w,
                                    child: GestureDetector(
                                      onTap: () => _fromSelectDate(context, 'DoRecruitment'),
                                      child: AbsorbPointer(
                                        child: TextFormField(
                                          readOnly: true,
                                          controller: dateofRecruitmentController,
                                          decoration: InputDecoration(
                                            label: Text(
                                              'Date of Recruitment',
                                              maxLines: 2,
                                            ),
                                            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                            border: OutlineInputBorder(),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(width: 1, color: Colors.black),
                                            ),
                                            hintText: "dd/mm/yyyy",

                                            //labelText: 'Date of Recruitment',

                                            suffixIcon: Icon(Icons.calendar_today),
                                          ),
                                          validator: (selectedrecruitmentStatus == 'Yes')
                                              ? (value) {
                                            if (value == null || value!.isEmpty) {
                                              return 'Please Select Date';
                                            }
                                            return null;
                                          }
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: SizedBox(
                                    //height: 60.h,
                                    child: DropdownButtonFormField<AacoOptionsDropdown>(
                                      isExpanded: true,
                                      value: aacoAvStsVal,
                                      onChanged: (newValue) {
                                        setState(() {
                                          aacoAvStsVal = newValue;
                                          selectedAvailabilitySts = newValue?.optionName;
                                          //acco_availiablity_status = newValue.optionID;
                                        });
                                      },
                                      items: aacoAvailabilityStatusDropdownList.map<DropdownMenuItem<AacoOptionsDropdown>>((item) {
                                        return DropdownMenuItem<AacoOptionsDropdown>(
                                          value: item,
                                          child: Text(item.optionName!),
                                        );
                                      }).toList(),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            borderSide: BorderSide(color: Colors.red, width: 1)),
                                        label: Text(
                                          'AACO Availability Status',
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                          ),
                                        ),

                                        //labelText: 'AACO Availability Status',
                                      ),
                                      validator: (selectedrecruitmentStatus == 'Yes')
                                          ? (value) {
                                        if (value == null) {
                                          return 'Please select AV Status';
                                        }
                                        return null;
                                      }
                                          : null,
                                    ),
                                  ),
                                )
                              ],
                            ),

                            Visibility(
                              visible: selectedAvailabilitySts == 'No',
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10),
                                  DropdownButtonFormField<AacoResult>(
                                    isExpanded: true,
                                    value: rsnFrNonAvofAacVal,
                                    onChanged: (newValue) {
                                      setState(() {
                                        rsnFrNonAvofAacVal = newValue;
                                        selectedRsnFrNonAvofAacName = newValue!.name;
                                        selectedRsnFrNonAvofAacID = newValue.id;
                                      });
                                    },
                                    items: aacoNonavDataList.map<DropdownMenuItem<AacoResult>>((item) {
                                      return DropdownMenuItem<AacoResult>(
                                        value: item,
                                        child: Text(item.name ?? ''),
                                      );
                                    }).toList(),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                      ),
                                      label: Text(
                                        'Reason for non Availability of AACO *',
                                        maxLines: 2,
                                        style: TextStyle(),
                                      ),
                                    ),
                                    validator: (selectedrecruitmentStatus == 'Yes' && selectedAvailabilitySts == 'No')
                                        ? (value) {
                                      if (value == null) {
                                        return 'Please select Recruitment Status';
                                      }
                                      return null;
                                    }
                                        : null,
                                  ),
                                  Visibility(
                                    visible: selectedRsnFrNonAvofAacName == 'Other',
                                    child: TextFormField(
                                      controller: recAvNoRsnNonAvlAacoRsnOtherController,
                                      onChanged: (value) {},
                                      decoration: InputDecoration(
                                        label: FittedBox(child: Text('Reason For Other')),
                                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                        border: OutlineInputBorder(),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 1, color: Colors.black),
                                        ),
                                        hintText: "Enter Reason For Other",

                                        //labelText: 'Date of Recruitment',

                                        // suffixIcon: Icon(Icons.calendar_today),
                                      ),
                                      validator: (selectedrecruitmentStatus == 'Yes' &&
                                          selectedAvailabilitySts == 'No' &&
                                          selectedRsnFrNonAvofAacName == 'Other')
                                          ? (value) {
                                        if (value == null) {
                                          return 'Please Enter Reason For Other';
                                        }
                                        return null;
                                      }
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: selectedAvailabilitySts == 'Yes',
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10),
                                  TextFormField(
                                    controller: recAvyesNameController,
                                    onChanged: (value) {},
                                    decoration: InputDecoration(
                                      label: FittedBox(child: Text('Name')),
                                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                      border: OutlineInputBorder(),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1, color: Colors.black),
                                      ),
                                      hintText: "Enter Name",

                                      //labelText: 'Date of Recruitment',

                                      // suffixIcon: Icon(Icons.calendar_today),
                                    ),
                                    validator: (selectedrecruitmentStatus == 'Yes' && selectedAvailabilitySts == 'Yes')
                                        ? (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Name';
                                      }
                                      return null;
                                    }
                                        : null,
                                  ),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    controller: recAvyesEmailController,
                                    onChanged: (value) {},
                                    validator: (selectedrecruitmentStatus == 'Yes' && selectedAvailabilitySts == 'Yes')
                                        ? (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Email ';
                                      }
                                      return null;
                                    }
                                        : null,
                                    decoration: InputDecoration(
                                      label: FittedBox(child: Text('Email')),
                                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                      border: OutlineInputBorder(),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1, color: Colors.black),
                                      ),
                                      hintText: "Enter Email",

                                      //labelText: 'Date of Recruitment',

                                      //suffixIcon: Icon(Icons.calendar_today),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    controller: recAvyesMobileController,
                                    onChanged: (value) {},
                                    decoration: InputDecoration(
                                      label: FittedBox(child: Text('Mobile')),
                                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                      border: OutlineInputBorder(),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 1, color: Colors.black),
                                      ),
                                      hintText: "Enter Mobile ",

                                      //labelText: 'Date of Recruitment',

                                      // suffixIcon: Icon(Icons.calendar_today),
                                    ),
                                    validator: (selectedrecruitmentStatus == 'Yes' && selectedAvailabilitySts == 'Yes')
                                        ? (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Mobile ';
                                      }
                                      return null;
                                    }
                                        : null,
                                  ),
                                  // Text(
                                  //   'Reason for non Availability of AACO *',
                                  //   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0.sp),
                                  // ),
                                  SizedBox(height: 10),
                                  DropdownButtonFormField<AacoOptionsDropdown>(
                                    isExpanded: true,
                                    value: recAvyesGenderVal,
                                    onChanged: (newValue) {
                                      setState(() {
                                        recAvyesGenderVal = newValue;
                                        recAvyesSelectedGender = newValue!.optionName;
                                      });
                                    },
                                    items: recAvyesGenderList.map<DropdownMenuItem<AacoOptionsDropdown>>((item) {
                                      return DropdownMenuItem<AacoOptionsDropdown>(
                                        value: item,
                                        child: Text(item.optionName!),
                                      );
                                    }).toList(),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                      ),
                                      labelText: 'Select Gender*',
                                    ),
                                    validator: (selectedrecruitmentStatus == 'Yes' && selectedAvailabilitySts == 'Yes')
                                        ? (value) {
                                      if (value == null) {
                                        return 'Please select Gender';
                                      }
                                      return null;
                                    }
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: selectedrecruitmentStatus == 'No',
                      child: Column(
                        children: [
                          DropdownButtonFormField<AacoResult>(
                            isExpanded: true,
                            value: rsnFrNonCmplofRecVal,
                            onChanged: (newValue) {
                              setState(() {
                                rsnFrNonCmplofRecVal = newValue;
                                selectedRsnFrNonCmplofRecID = newValue?.id;
                                selectedRsnFrNonCmplofRecName = newValue?.name;
                              });
                            },
                            items: aacoNonComletionReasonList.map<DropdownMenuItem<AacoResult>>((item) {
                              return DropdownMenuItem<AacoResult>(
                                value: item,
                                child: Text(item.name ?? ''),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              label: Text(
                                'Reason for non completion of recruitment *',
                                maxLines: 2,
                              ),
                            ),
                            validator: selectedrecruitmentStatus == 'No'
                                ? (value) {
                              if (value == null) {
                                return 'Please select Reason for non completion of recruitment';
                              }
                              return null;
                            }
                                : null,
                          ),
                          Visibility(
                            visible: selectedRsnFrNonCmplofRecName == 'Other',
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                TextFormField(
                                  controller: recNoRsnNonCmplAacoRsnOtherController,
                                  onChanged: (value) {},
                                  decoration: InputDecoration(
                                    label: FittedBox(child: Text('Reason for Other')),
                                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 1, color: Colors.black),
                                    ),
                                    hintText: "Enter Reason for Other ",

                                    //labelText: 'Date of Recruitment',

                                    // suffixIcon: Icon(Icons.calendar_today),
                                  ),
                                  validator: (selectedrecruitmentStatus == 'No' && selectedRsnFrNonCmplofRecName == 'Other')
                                      ? (value) {
                                    if (value == null) {
                                      return 'Please Enter Reason ';
                                    }
                                    return null;
                                  }
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: selectedrecruitmentStatus == 'Processing',
                      child: SizedBox(
                        // height: 50.0.h,
                        // width: 160.0.w,
                        child: GestureDetector(
                          child: TextFormField(
                            readOnly: false,
                            controller: remarksController,
                            decoration: InputDecoration(
                              label: Text(
                                'Remarks *',
                                maxLines: 2,
                                style: TextStyle(),
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: Colors.black),
                              ),
                              hintText: "Enter your opinion",
                            ),
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Please Select Date';
                            //   }
                            //   return null;
                            // },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0.h,
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
                              borderRadius: BorderRadius.circular(5),
                            ),
                            backgroundColor: MyColors.secondaryColor,
                          ),
                          onPressed: () async {
                            final connectivityResult = await ConnectivityProvider().rcheckInternetConnection();
                            if (connectivityResult) {
                              if (_formAACOKey.currentState!.validate()) {
                                log('Data is validated');
                                Map aacoBody = {};

                                // setState(() {
                                //   _isLoading = true;
                                // });
                                if (recruitMentStsVal!.optionID == 1 && aacoAvStsVal!.optionID == 1) {
                                  aacoBody = {
                                    "district_id": district_id,
                                    "upazila_id": upazila_id,
                                    "union_id": union_id,
                                    "recruitment_status": recruitMentStsVal!.optionID,
                                    "apointment_date": dateofRecruitmentController.text,
                                    "acco_availiablity_status": aacoAvStsVal!.optionID,
                                    "name": recAvyesNameController.text,
                                    "email": recAvyesEmailController.text,
                                    "mobile": recAvyesMobileController.text,
                                    "gender": recAvyesGenderVal!.optionID
                                  };
                                } else if (recruitMentStsVal!.optionID == 1 && aacoAvStsVal!.optionID == 0) {
                                  aacoBody = {
                                    "district_id": district_id,
                                    "upazila_id": upazila_id,
                                    "union_id": union_id,
                                    "recruitment_status": recruitMentStsVal!.optionID,
                                    "apointment_date": dateofRecruitmentController.text,
                                    "acco_availiablity_status": aacoAvStsVal!.optionID,
                                    "aaco_reason_id": selectedRsnFrNonAvofAacID,
                                    "non_availability_other":
                                    selectedRsnFrNonAvofAacName == 'Other' ? recAvNoRsnNonAvlAacoRsnOtherController.text : null
                                  };
                                } else if (recruitMentStsVal!.optionID == 0) {
                                  aacoBody = {
                                    "district_id": district_id,
                                    "upazila_id": upazila_id,
                                    "union_id": union_id,
                                    "recruitment_status": recruitMentStsVal!.optionID,
                                    "aaco_reason_id": rsnFrNonCmplofRecVal!.id,
                                    "non_completion_other":
                                    rsnFrNonCmplofRecVal!.name == 'Other' ? recNoRsnNonCmplAacoRsnOtherController.text : null
                                  };
                                } else if (recruitMentStsVal!.optionID == 2) {
                                  aacoBody = {
                                    "district_id": district_id,
                                    "upazila_id": upazila_id,
                                    "union_id": union_id,
                                    "recruitment_status": recruitMentStsVal!.optionID,
                                    "processing_text": remarksController.text
                                  };
                                }
                                Map aacoinfoSubmitResponse = await Repositores().AACOInfoSubmitAPi(
                                  jsonEncode(aacoBody),
                                );
                                if (aacoinfoSubmitResponse['status'] == 200) {
                                  await QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.success,
                                    text: "AACO Info Add Successfully!",
                                  );
                                  Navigator.pop(context);
                                  // await Navigator.of(context)
                                  //     .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Homepage()), (Route<dynamic> route) => false);
                                  setState(() {
                                    _isLoading = false;
                                  });
                                } else if (aacoinfoSubmitResponse['status'] == 422) {
                                  await QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.error,
                                    text: aacoinfoSubmitResponse['message'],
                                  );
                                  setState(() {
                                    _isLoading = false;
                                  });
                                } else {
                                  await QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.error,
                                    text: aacoinfoSubmitResponse['message'],
                                  );
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              }
                            }
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Submit',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return SizedBox();
        },
      ),
    );
  }

  getNonAvailabilityStatusForNoList() async {
    aacoNonavDataList = [];

    var accoNonAvData = await Repositores().getNonAvailabilityData();
    if (accoNonAvData != null) {
      setState(() {
        aacoNonavDataList = accoNonAvData.result ?? [];
      });
    } else {
      // setState(() {
      aacoNonComletionReasonList = [];
      // });
    }
    // setState(() {
    //   _isLoading = false;
    // });
  }

  getNonCompletionAaco() async {
    aacoNonComletionReasonList = [];
    // if (_isLoading) return;
    // setState(() {
    //   _isLoading = true;
    // });

    var aacoReasonForNonCompletionData = await Repositores().getrsnNonCompletionAaco();
    if (aacoReasonForNonCompletionData != null) {
      setState(() {
        aacoNonComletionReasonList = aacoReasonForNonCompletionData.result ?? [];
      });
    } else {
      // setState(() {
      aacoNonComletionReasonList = [];
      // });
    }
    // setState(() {
    //   _isLoading = false;
    // });
  }
}

List<AacoOptionsDropdown> recruitmentDropdown = [
  AacoOptionsDropdown(optionID: 1, optionName: 'Yes'),
  AacoOptionsDropdown(optionID: 0, optionName: 'No'),
  AacoOptionsDropdown(optionID: 2, optionName: 'Processing'),
];
List<AacoOptionsDropdown> aacoAvailabilityStatusDropdownList = [
  AacoOptionsDropdown(optionID: 1, optionName: 'Yes'),
  AacoOptionsDropdown(optionID: 0, optionName: 'No'),
];
List<AacoOptionsDropdown> reasonForNonavForaacoList = [
  AacoOptionsDropdown(optionID: 1, optionName: 'Training'),
  AacoOptionsDropdown(optionID: 0, optionName: 'No'),
];
List<AacoOptionsDropdown> recAvyesGenderList = [
  AacoOptionsDropdown(optionID: 1, optionName: 'Male'),
  AacoOptionsDropdown(optionID: 2, optionName: 'Female'),
  AacoOptionsDropdown(optionID: 3, optionName: 'Others'),
];
