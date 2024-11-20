import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:village_court_gems/bloc/AACO_Info_Edit_bloc/aaco_info_edit_bloc.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/aaco_model/aaco_nav_model.dart';
import 'package:village_court_gems/models/aaco_model/aaco_options_dropdown.dart';
import 'package:village_court_gems/services/all_services/all_services.dart';
import 'package:village_court_gems/util/colors.dart';
import 'package:village_court_gems/view/AACO/aaco_Info.dart';
import 'package:village_court_gems/view/AACO/aaco_info_add.dart';
import 'package:village_court_gems/view/home/homepage.dart';
import 'package:village_court_gems/widget/custom_appbar.dart';

class NewAacoInfoEditScreen extends StatefulWidget {
  final int? id;
  final List<AacoResult> aacoNonComletionReasonList;
  final List<AacoResult> aacoNonavDataList;
  static const pageName = 'AACO_Info_Edit';
  const NewAacoInfoEditScreen({super.key, this.id, required this.aacoNonComletionReasonList, required this.aacoNonavDataList});

  @override
  State<NewAacoInfoEditScreen> createState() => _NewAacoInfoEditScreenState();
}

class _NewAacoInfoEditScreenState extends State<NewAacoInfoEditScreen> {
  // List<AacoResult> aacoNonavDataList = [];
  bool _isLoading = false;
  //List<AacoResult> aacoNonComletionReasonList = [];
  TextEditingController dateofRecruitmentController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  TextEditingController recAvyesNameController = TextEditingController();
  TextEditingController recAvyesEmailController = TextEditingController();
  TextEditingController recAvyesMobileController = TextEditingController();
  TextEditingController recNoRsnNonCmplAacoRsnOtherController = TextEditingController();
  TextEditingController recAvNoRsnNonAvlAacoRsnOtherController = TextEditingController();
  DateTime? fromSelectedDate;
  List<AacoOptionsDropdown> erecruitmentDropdown = [
    AacoOptionsDropdown(optionID: 1, optionName: 'Yes'),
    AacoOptionsDropdown(optionID: 0, optionName: 'No'),
    AacoOptionsDropdown(optionID: 2, optionName: 'Processing'),
  ];
  // List<AacoOptionsDropdown> aacoAvailabilityStatusDropdownList = [
  //   AacoOptionsDropdown(optionID: 1, optionName: 'Yes'),
  //   AacoOptionsDropdown(optionID: 0, optionName: 'No'),
  // ];
  // List<AacoOptionsDropdown> reasonForNonavForaacoList = [
  //   AacoOptionsDropdown(optionID: 1, optionName: 'Training'),
  //   AacoOptionsDropdown(optionID: 0, optionName: 'No'),
  // ];
  // List<AacoOptionsDropdown> recAvyesGenderList = [
  //   AacoOptionsDropdown(optionID: 1, optionName: 'Male'),
  //   AacoOptionsDropdown(optionID: 2, optionName: 'Female'),
  //   AacoOptionsDropdown(optionID: 3, optionName: 'Others'),
  // ];
  AacoOptionsDropdown? recruitMentStsVal;
  AacoOptionsDropdown? aacoAvStsVal;
  AacoOptionsDropdown? recAvyesGenderVal;
  AacoResult? rsnFrNonAvofAacVal;
  AacoResult? rsnFrNonCmplofRecVal;
  final AacoInfoEditBloc aacoInfoEditBloc = AacoInfoEditBloc();
  @override
  void initState() {
    // getNonAvailablityStatusForNoList();
    // getNonCompletionAaco();

    super.initState();
    aacoInfoEditBloc.add(AacoInfoEditInitialEvent(id: widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: 'Aaco Information Edit',
      ),
      body: BlocConsumer<AacoInfoEditBloc, AacoInfoEditState>(
        bloc: aacoInfoEditBloc,
        //listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          setState(() {
            recruitMentStsVal = null;
            if (state is AacoInfoDetailsDataState) {
              recruitMentStsVal = state.aacoInfData.recruitmentStatus != null
                  ? AacoOptionsDropdown(
                      optionID: state.aacoInfData.recruitmentStatus,
                      optionName: state.aacoInfData.recruitmentStatus == 1
                          ? "Yes"
                          : state.aacoInfData.recruitmentStatus == 0
                              ? "No"
                              : state.aacoInfData.recruitmentStatus == 2
                                  ? "Processing"
                                  : null)
                  : null;
              rsnFrNonCmplofRecVal = state.aacoInfData.aacoReasonId != null
                  ? AacoResult(
                      id: state.aacoInfData.aacoReasonId,
                      name: widget.aacoNonComletionReasonList.firstWhere((e) => e.id == state.aacoInfData.aacoReasonId,orElse: () => AacoResult(id: null,name: null),).name,
                    )
                  : null;
              rsnFrNonAvofAacVal = state.aacoInfData.aacoReasonId != null ? AacoResult(
                id:  state.aacoInfData.aacoReasonId,
                name: widget.aacoNonavDataList.firstWhere((e) => e.id == state.aacoInfData.aacoReasonId, orElse: () => AacoResult(id: null,name: null)).name
              ) : null;

              aacoAvStsVal = state.aacoInfData.accoAvailiablityStatus != null
                  ? AacoOptionsDropdown(
                      optionID: state.aacoInfData.accoAvailiablityStatus,
                      optionName: state.aacoInfData.accoAvailiablityStatus == 1
                          ? "Yes"
                          : state.aacoInfData.accoAvailiablityStatus == 0
                              ? "No"
                              : null)
                  : null;
              dateofRecruitmentController.text = state.aacoInfData.apointmentDate != null ? state.aacoInfData.apointmentDate! : '';
              recAvyesNameController.text = state.aacoInfData.accoAvailiablityStatus != null
                  ? state.aacoInfData.accoAvailiablityStatus! == 1
                      ? state.aacoInfData.name ?? ''
                      : ''
                  : '';
              recAvyesEmailController.text = state.aacoInfData.accoAvailiablityStatus != null
                  ? state.aacoInfData.accoAvailiablityStatus! == 1
                      ? state.aacoInfData.email ?? ''
                      : ''
                  : '';
              recAvyesMobileController.text = state.aacoInfData.accoAvailiablityStatus != null
                  ? state.aacoInfData.accoAvailiablityStatus! == 1
                      ? state.aacoInfData.mobile ?? ''
                      : ''
                  : '';
              recAvyesGenderVal = state.aacoInfData.gender != null
                  ? AacoOptionsDropdown(
                      optionID: state.aacoInfData.gender,
                      optionName: state.aacoInfData.gender == 1
                          ? "Male"
                          : state.aacoInfData.recruitmentStatus == 2
                              ? "Female"
                              : state.aacoInfData.recruitmentStatus == 3
                                  ? "Others"
                                  : null)
                  : null;

              recNoRsnNonCmplAacoRsnOtherController.text = state.aacoInfData.nonCompletionOther??"";
              remarksController.text = state.aacoInfData.processingText??"";
            }
          });
          // if (state is AacoInfoDetailsDataState) {
          //   if ( state.aacoInfData.recruitmentStatus != null) {
          //      recruitMentStsVal = AacoOptionsDropdown(
          //     optionID: state.aacoInfData.recruitmentStatus!,
          //     optionName: state.aacoInfData.recruitmentStatus! == 0
          //         ? 'No'
          //         : state.aacoInfData.recruitmentStatus! == 1
          //             ? 'Yes'
          //             : state.aacoInfData.recruitmentStatus! == 2
          //                 ? 'Processing'
          //                 : 'Yes',
          //   );
          //   }else{
          //     recruitMentStsVal = null;
          //   }
          // }
        },
        builder: (context, state) {
          if (state is AacoInfoEditLoadingState) {
            return Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is AacoInfoDetailsDataState) {
            //aacoAvStsVal = AacoOptionsDropdown(optionID: state.aacoInfData.accoAvailiablityStatus != null ? state.aacoInfData.accoAvailiablityStatus : null,optionName: state.aacoInfData.accoAvailiablityStatus != null ? state.aacoInfData.accoAvailiablityStatus == 1 ? 'Yes' : 'No' : null,);

            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16),
                // color: Colors.red,
                child: Column(
                  children: [
                    //Text('d ${state.aacoInfData.recruitmentStatus}'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: viewAreaTextField(areaData: state.aacoInfData.district!, label: 'District'),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: viewAreaTextField(areaData: state.aacoInfData.upazila!, label: 'Upazila'),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: viewAreaTextField(areaData: state.aacoInfData.union!, label: 'Union'),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<AacoOptionsDropdown>(
                            // isExpanded: true,
                            value: null, //state.recruitmentSts,
                            onChanged: (newValue) {
                              setState(() {
                                recruitMentStsVal = newValue;
                                //selectedrecruitmentStatus = newValue!.optionName;
                              });
                            },
                            hint: Text(
                                '${state.aacoInfData.recruitmentStatus == 1
                                    ? 'Yes' : state.aacoInfData.recruitmentStatus == 0
                                    ? 'No' : state.aacoInfData.recruitmentStatus == 2
                                    ? 'Processing' : 'Enter'}'),
                            items: erecruitmentDropdown.map((item) {
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
                    Visibility(
                      visible: recruitMentStsVal != null
                          ? recruitMentStsVal!.optionID == 1
                              ? true
                              : false
                          : false,
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
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
                                          hintText: state.aacoInfData.apointmentDate != null ? state.aacoInfData.apointmentDate : "dd/mm/yyyy",

                                          //labelText: 'Date of Recruitment',

                                          suffixIcon: Icon(Icons.calendar_today),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please Select Date';
                                          }
                                          return null;
                                        }),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: DropdownButtonFormField<AacoOptionsDropdown>(
                                    // isExpanded: true,
                                    value: null,
                                    onChanged: (newValue) {
                                      setState(() {
                                        aacoAvStsVal = newValue;
                                        //selectedAvailabilitySts = newValue?.optionName;
                                        //acco_availiablity_status = newValue.optionID;
                                      });
                                    },
                                    hint: state.aacoInfData.accoAvailiablityStatus != null
                                        ? state.aacoInfData.accoAvailiablityStatus == 1
                                            ? Text('Yes')
                                            : Text('No')
                                        : Text('Select'),
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
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)), borderSide: BorderSide(color: Colors.red, width: 1)),
                                      label: Text(
                                        'AACO Availability Status',
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      //labelText: 'AACO Availability Status',
                                    ),
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please select AV Status';
                                      }
                                      return null;
                                    }),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),

                    Visibility(
                      visible: aacoAvStsVal?.optionID != null
                          ? aacoAvStsVal?.optionID == 0
                              ? true
                              : false
                          : false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          DropdownButtonFormField<AacoResult>(
                            isExpanded: true,
                            value: null,
                            onChanged: (newValue) {
                              setState(() {
                                rsnFrNonAvofAacVal = newValue;
                                // selectedRsnFrNonAvofAacName = newValue!.name;
                                // selectedRsnFrNonAvofAacID = newValue.id;
                              });
                            },
                               hint: rsnFrNonAvofAacVal?.name != null
                                ? Text('${rsnFrNonAvofAacVal?.name}')
                                : Text('Select Non Availability'),
                            items: widget.aacoNonavDataList.map<DropdownMenuItem<AacoResult>>((item) {
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
                            // validator: (selectedrecruitmentStatus == 'Yes' && selectedAvailabilitySts == 'No')
                            //     ? (value) {
                            //         if (value == null) {
                            //           return 'Please select Recruitment Status';
                            //         }
                            //         return null;
                            //       }
                            //     : null,
                          ),
                          Visibility(
                            visible: rsnFrNonAvofAacVal?.name == 'Other',
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                TextFormField(
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
                                  // validator: (selectedrecruitmentStatus == 'Yes' &&
                                  //         selectedAvailabilitySts == 'No' &&
                                  //         selectedRsnFrNonAvofAacName == 'Other')
                                  //     ? (value) {
                                  //         if (value == null) {
                                  //           return 'Please Enter Reason For Other';
                                  //         }
                                  //         return null;
                                  //       }
                                  //     : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                
                    Visibility(
                      visible: recruitMentStsVal != null
                          ? recruitMentStsVal!.optionID == 1 && aacoAvStsVal?.optionID == 1
                              ? true
                              : false
                          : false,
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter Name';
                                }
                                return null;
                              }),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: recAvyesEmailController,
                            onChanged: (value) {},
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Email ';
                              }
                              return null;
                            },
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter Mobile ';
                                }
                                return null;
                              }),
                          // Text(
                          //   'Reason for non Availability of AACO *',
                          //   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0.sp),
                          // ),
                          SizedBox(height: 10),
                          DropdownButtonFormField<AacoOptionsDropdown>(
                              isExpanded: true,
                              value: null,
                              // value: recAvyesGenderVal,
                              onChanged: (newValue) {
                                setState(() {
                                  recAvyesGenderVal = newValue;
                                  // recAvyesSelectedGender = newValue!.optionName;
                                });
                              },
                              items: recAvyesGenderList.map<DropdownMenuItem<AacoOptionsDropdown>>((item) {
                                return DropdownMenuItem<AacoOptionsDropdown>(
                                  value: item,
                                  child: Text(item.optionName!),
                                );
                              }).toList(),
                              hint: state.aacoInfData.gender != null
                                  ? state.aacoInfData.gender == 1
                                      ? Text('Male')
                                      : state.aacoInfData.gender == 2
                                          ? Text('Female')
                                          : state.aacoInfData.gender == 3
                                              ? Text('Others')
                                              : Text('Select Gender')
                                  : Text('Select Gender'),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                labelText: 'Select Gender*',
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select Gender';
                                }
                                return null;
                              }),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: recruitMentStsVal != null
                          ? recruitMentStsVal!.optionID == 0
                              ? true
                              : false
                          : false,
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          DropdownButtonFormField<AacoResult>(
                            isExpanded: true,
                            value: null,
                            onChanged: (newValue) {
                              setState(() {
                                rsnFrNonCmplofRecVal = newValue;
                                //selectedRsnFrNonCmplofRecID = newValue?.id;
                                //selectedRsnFrNonCmplofRecName = newValue?.name;
                              });
                            },
                            items: widget.aacoNonComletionReasonList.map<DropdownMenuItem<AacoResult>>((item) {
                              return DropdownMenuItem<AacoResult>(
                                value: item,
                                child: Text(item.name ?? ''),
                              );
                            }).toList(),
                            hint: rsnFrNonCmplofRecVal?.name != null
                                ? Text('${rsnFrNonCmplofRecVal?.name}')
                                : Text('Select Reason for non completion of recruitment'),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              label: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  'Reason for non completion of recruitment *',
                                  maxLines: 2,
                                ),
                              ),
                            ),
                            // validator: selectedrecruitmentStatus == 'No'
                            //     ? (value) {
                            //         if (value == null) {
                            //           return 'Please select Reason for non completion of recruitment';
                            //         }
                            //         return null;
                            //       }
                            //     : null,
                          ),
                          Visibility(
                            visible: rsnFrNonCmplofRecVal != null
                                ? rsnFrNonCmplofRecVal!.name == 'Other'
                                    ? true
                                    : false
                                : false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: TextFormField(
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
                                // validator: (selectedrecruitmentStatus == 'No' && selectedRsnFrNonCmplofRecName == 'Other')
                                //     ? (value) {
                                //         if (value == null) {
                                //           return 'Please Enter Reason ';
                                //         }
                                //         return null;
                                //       }
                                //     : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: recruitMentStsVal!.optionID == 2,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: remarksController,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              label: FittedBox(child: Text('Remarks')),
                              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: Colors.black),
                              ),
                              hintText: "Enter your opinion",

                            ),
                          )
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: _isLoading
                          ? AllService.LoadingToast()
                          : SizedBox(
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
                                  Map aacoBody = {};
                
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  if (recruitMentStsVal!.optionID == 1 && aacoAvStsVal!.optionID == 1) {
                                    aacoBody = {
                                      "district_id": state.aacoInfData.districtId,
                                      "upazila_id": state.aacoInfData.upazilaId,
                                      "union_id": state.aacoInfData.unionId,
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
                                      "district_id": state.aacoInfData.districtId,
                                      "upazila_id": state.aacoInfData.upazilaId,
                                      "union_id": state.aacoInfData.unionId,
                                      "recruitment_status": recruitMentStsVal!.optionID,
                                      "apointment_date": dateofRecruitmentController.text,
                                      "acco_availiablity_status": aacoAvStsVal!.optionID,
                                      "aaco_reason_id": rsnFrNonAvofAacVal?.id,
                                      "non_availability_other": rsnFrNonAvofAacVal?.name == 'Other' ? recAvNoRsnNonAvlAacoRsnOtherController.text : null
                                    };
                                  } else if (recruitMentStsVal!.optionID == 0) {
                                    aacoBody = {
                                      "district_id": state.aacoInfData.districtId,
                                      "upazila_id": state.aacoInfData.upazilaId,
                                      "union_id": state.aacoInfData.unionId,
                                      "recruitment_status": recruitMentStsVal!.optionID,
                                      "aaco_reason_id": rsnFrNonCmplofRecVal!.id,
                                      "non_completion_other": rsnFrNonCmplofRecVal!.name == 'Other' ? recNoRsnNonCmplAacoRsnOtherController.text : null
                                    };
                                  } else if (recruitMentStsVal!.optionID == 2) {
                                    aacoBody = {
                                      "district_id": state.aacoInfData.districtId,
                                      "upazila_id": state.aacoInfData.upazilaId,
                                      "union_id": state.aacoInfData.unionId,
                                      "recruitment_status": recruitMentStsVal!.optionID,
                                      "processing_text": remarksController.text
                                    };
                                  }
                                  Map aacoinfoSubmitResponse = await Repositores()
                                      .AACOInfoEditDataSubmitAPi(EditDataaacoInfoBody: jsonEncode(aacoBody), id: state.aacoInfData.id.toString());
                                  if (aacoinfoSubmitResponse['status'] == 200) {
                                    await QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.success,
                                      text: "AACO Info Add Successfully!",
                                    );
                                    Navigator.pop(context);
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
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'UPDATE',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }

  viewAreaTextField({required String areaData, required String label}) {
    return AbsorbPointer(
      child: TextFormField(
        readOnly: true,
        controller: TextEditingController(text: areaData),
        decoration: InputDecoration(
          label: Text(
            label,
            maxLines: 2,
            style: TextStyle(),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          //border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.black),
          ),

          // labelText: 'Approximate Date of Completion Recruitment *',

          //suffixIcon: Icon(Icons.calendar_today),
        ),
      ),
    );
  }

  // getNonAvailablityStatusForNoList() async {
  //   aacoNonavDataList = [];

  //   var accoNonAvData = await Repositores().getNonAvailabilityData();
  //   if (accoNonAvData != null) {
  //     setState(() {
  //       aacoNonavDataList = accoNonAvData.result ?? [];
  //     });
  //   } else {
  //     // setState(() {
  //     aacoNonComletionReasonList = [];
  //     // });
  //   }
  //   // setState(() {
  //   //   _isLoading = false;
  //   // });
  // }

  // getNonCompletionAaco() async {
  //   aacoNonComletionReasonList = [];
  //   // if (_isLoading) return;
  //   // setState(() {
  //   //   _isLoading = true;
  //   // });

  //   var aacoReasonForNonCompletionData = await Repositores().getrsnNonCompletionAaco();
  //   if (aacoReasonForNonCompletionData != null) {
  //     setState(() {
  //       aacoNonComletionReasonList = aacoReasonForNonCompletionData.result ?? [];
  //     });
  //   } else {
  //     // setState(() {
  //     aacoNonComletionReasonList = [];
  //     // });
  //   }
  //   // setState(() {
  //   //   _isLoading = false;
  //   // });
  // }

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
}
