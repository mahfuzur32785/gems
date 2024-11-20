import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/area_model/office_type_model.dart';
import 'package:village_court_gems/models/field_visit_model/field_visit_list_model.dart';
import 'package:village_court_gems/services/database/localDatabaseService.dart';
import 'package:village_court_gems/util/colors.dart';
import 'package:village_court_gems/view/field_visit_list/field_visit_details.dart';
import 'package:village_court_gems/widget/cstm_dvider.dart';
import 'package:village_court_gems/widget/cstm_txt_fld.dart';
import 'package:village_court_gems/widget/custom_appbar.dart';

class FieldVisitListPage extends StatefulWidget {
  const FieldVisitListPage({super.key});

  @override
  State<FieldVisitListPage> createState() => _FieldVisitListPageState();
}

class _FieldVisitListPageState extends State<FieldVisitListPage> {
  List<FieldVisitData> posts = [];
  int currentPage = 1;
  bool isLoading = false;
  bool isLoadingMore = false;
  FieldVisitListModel? fieldVisitListModel;
  final searchController = TextEditingController();
  final dateController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    getOfficeTypeData();
    _fetchPosts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchPostsMore();
      }
    });

    super.initState();
  }

  List<OfficeTypeData> officeTypeList = [];
  OfficeTypeData? chngLocOfficeTypeVal;
  String? diagOfficeTypeID = '';
  String selectedStatus = '';
  String selectedStatusValue = '';
  String formDate = '';
  String toDate = '';

  getOfficeTypeData() async {
    List<OfficeTypeData> OfficeTypeDataList =
        await Helper().getOfficeTypeData();
    officeTypeList = OfficeTypeDataList;
  }

  Future<void> _fetchPosts() async {
    if (isLoading) return;
    isLoading = true;

    fieldVisitListModel = await Repositores().fieldVisitListApi(
      current_page: currentPage.toString(),
      location: searchController.text.trim(),
      formDate: formDate.trim(),
      toDate: toDate.trim(),
      officeType: diagOfficeTypeID.toString(),
      status: selectedStatusValue,
    );

    if (fieldVisitListModel!.data.isNotEmpty) {
      print("activity list ${fieldVisitListModel!.data.length}");
      posts = fieldVisitListModel!.data;
    } else {
      posts.clear();
    }

    print("activity list ");
    isLoading = false;
    setState(() {});
  }

  Future<void> _fetchPostsMore() async {
    currentPage++;
    if (isLoadingMore) return;
    isLoadingMore = true;

    fieldVisitListModel = await Repositores().fieldVisitListApi(
      current_page: currentPage.toString(),
      location: searchController.text.trim(),
      formDate: formDate.trim(),
      toDate: toDate.trim(),
      officeType: diagOfficeTypeID.toString(),
      status: selectedStatusValue,
    );

    if (fieldVisitListModel!.data.isNotEmpty) {
      print("activity list ${fieldVisitListModel!.data.length}");
      posts.addAll(fieldVisitListModel!.data);
    }

    print("activity list ");
    isLoadingMore = false;
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool isFilterClick = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: "Field Visit List",
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  isFilterClick = !isFilterClick;
                  setState(() {});
                },
                child: Container(
                  width: 100,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: isFilterClick ? Colors.red : MyColors.secondaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(isFilterClick ? Icons.close : Icons.filter_list_alt,
                          color: Colors.white, size: 18),
                      SizedBox(width: 5),
                      Text(
                        isFilterClick ? "Close" : "Filter",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            ///Search and Filtering area
            Visibility(
              visible: isFilterClick,
              child: Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: const BoxDecoration(color: Color(0XFFF7E7F3)),
                child: Container(
                    // decoration: BoxDecoration(
                    //     border: Border.all(color: Colors.black12, width: 8),
                    //     borderRadius: BorderRadius.circular(8)),
                    child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: 48,
                      width: double.infinity,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<OfficeTypeData>(
                          isExpanded: true,
                          hint: Text("Select OfficeType",
                              style: TextStyle(color: Colors.grey.shade400)),
                          value: chngLocOfficeTypeVal,
                          items: officeTypeList
                              .map<DropdownMenuItem<OfficeTypeData>>((item) {
                            return DropdownMenuItem<OfficeTypeData>(
                              value: item,
                              onTap: () {
                                log('selected office ID ${item.id}');
                              },
                              child: Text("${item.name}"),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            chngLocOfficeTypeVal = newValue;
                            diagOfficeTypeID = newValue?.id!.toString();
                            setState(() {});
                            log('Selected Office from dialog $diagOfficeTypeID');
                          },
                        ),
                      ),
                    ),
                    CustomDivider(),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: 48,
                      width: double.infinity,
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                        hint: Text('Select Status',
                            style: TextStyle(color: Colors.grey.shade400)),
                        isDense: true,
                        value: selectedStatus == "" ? null : selectedStatus,
                        items: ['Approved', "Pending"]
                            .map<DropdownMenuItem<String>>((e) {
                          return DropdownMenuItem<String>(
                            value: "$e",
                            child: Text(e),
                          );
                        }).toList(),
                        onChanged: (value) {
                          selectedStatus = value ?? "";
                          selectedStatusValue = value == 'Approved' ? '1' : '0';
                          setState(() {});
                        },
                      )),
                    ),
                    CustomTextField(
                      controller: dateController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      isObsecure: false,
                      enabled: true,
                      isRead: true,
                      hintext: "Select Date Range",
                      borderRadius: BorderRadius.circular(0),
                      suffixIcon: IconButton(
                          onPressed: () {
                            selectDateRange(context);
                          },
                          icon: Icon(Icons.calendar_month_outlined)),
                    ),
                    CustomTextField(
                      controller: searchController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      isObsecure: false,
                      borderRadius: BorderRadius.circular(0),
                      enabled: true,
                      hintext: "Search Location...",
                    ),
                    SizedBox(
                      height: 48,
                      // width: Get.width,
                      child: Row(
                        children: [
                          Flexible(
                            child: SizedBox(
                              height: 48,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  chngLocOfficeTypeVal = null;
                                  diagOfficeTypeID = '';
                                  selectedStatus = '';
                                  selectedStatusValue = '';
                                  formDate = '';
                                  toDate = '';
                                  dateController.clear();
                                  searchController.clear();
                                  print("jashfjds $selectedStatus");
                                  _fetchPosts();
                                  setState(() {});
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero),
                                    backgroundColor: Colors.red),
                                child: const Text(
                                  "Clear",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            child: SizedBox(
                              height: 48,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  currentPage = 1;
                                  FocusScope.of(context).unfocus();
                                  _fetchPosts();
                                  setState(() {});
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero),
                                  backgroundColor: MyColors.secondaryColor,
                                ),
                                child: const Text(
                                  "Filter",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
              ),
            ),

            isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: posts.length == 0
                        ? Center(
                            child: Text(
                              "Field Visit Not Found",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            controller: _scrollController,
                            itemCount: posts.length + 1,
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 10);
                            },
                            itemBuilder: (context, index) {
                              if (index < posts.length) {
                                final post = posts[index];
                                return Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return FieldVisitDetailsPage(
                                                id: post.id.toString(),
                                                fieldVisitDate:
                                                    post.visitDate ?? "",
                                                officeType:
                                                    post.officeType ?? "",
                                                officeTitle:
                                                    post.officeTitle ?? "",
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                            color: MyColors.white,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                                color: MyColors.customGrey)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Expanded(
                                                  flex: 4,
                                                  child: Text(
                                                    'Visit Date',
                                                    style: TextStyle(
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                //Spacer(),
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    ':',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 10,
                                                  child:
                                                      Text(post.visitDate ?? '',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors.black,
                                                          )),
                                                )
                                              ],
                                            ),
                                            //SizedBox(height: 8,),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 4,
                                                    child: Text(
                                                      'Office Type',
                                                      style: TextStyle(
                                                        fontSize: 13.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                      ':',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 10,
                                                    child: Text(
                                                        post.officeType ?? '',
                                                        style: TextStyle(
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                        )),
                                                  )
                                                ],
                                              ),
                                            ),

                                            Visibility(
                                              visible: post.officeTitle != null,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 4,
                                                    child: Text(
                                                      'Office Title',
                                                      style: TextStyle(
                                                        fontSize: 13.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                      ':',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 10,
                                                    child: Text(
                                                        post.officeTitle ?? '',
                                                        style: TextStyle(
                                                          fontSize: 13.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                        )),
                                                  )
                                                ],
                                              ),
                                            ),
                                            //  Divider(),
                                            // SizedBox(
                                            //   height: 8,
                                            // ),

                                            Wrap(
                                              runAlignment:
                                                  WrapAlignment.spaceBetween,
                                              alignment: WrapAlignment.start,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              // runSpacing: 10,
                                              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                breadcrumTile(
                                                    post.division ?? ''),
                                                brDividerWidget(),
                                                breadcrumTile(
                                                    post.district ?? ''),
                                                post.upazila!.isEmpty
                                                    ? SizedBox.shrink()
                                                    : brDividerWidget(),
                                                breadcrumTile(
                                                    post.upazila ?? ''),
                                                post.union!.isEmpty
                                                    ? SizedBox.shrink()
                                                    : brDividerWidget(),
                                                breadcrumTile(post.union ?? ''),
                                                // Text(
                                                //   'Area :',
                                                //   style: TextStyle(
                                                //     fontSize: 13.sp,
                                                //     fontWeight: FontWeight.w500,
                                                //     color: Colors.black,
                                                //   ),
                                                // ),
                                                // Expanded(
                                                //   child: breadcrumTile(post.division ?? '',
                                                //       isEnd: post.district != null
                                                //           ? post.district!.isEmpty
                                                //               ? true
                                                //               : false
                                                //           : true),
                                                // ),
                                                //    breadcrumTile(post.district ?? '',
                                                //     isEnd: post.upazila != null
                                                //         ? post.upazila!.isEmpty
                                                //             ? true
                                                //             : false
                                                //         : true),
                                                // breadcrumTile(post.upazila ?? '',
                                                //     isEnd: post.union != null
                                                //         ? post.union!.isEmpty
                                                //             ? true
                                                //             : false
                                                //         : true),
                                                // breadcrumTile(post.district ?? '',
                                                //     isEnd: post.upazila != null
                                                //         ? post.upazila!.isEmpty
                                                //             ? true
                                                //             : false
                                                //         : true),
                                                //  breadcrumTile('${post.union}' ?? '', isEnd: true),

                                                // breadcrumTile()
                                                //  Expanded(
                                                //    // flex: 6,
                                                //     child: Text("",
                                                //         style: TextStyle(
                                                //           fontSize: 13.sp,
                                                //           fontWeight: FontWeight.w400,
                                                //           color: Colors.black,
                                                //         )),
                                                //   )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 5,
                                      right: 10,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 3, horizontal: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          posts[index].status == 1
                                              ? "Approved"
                                              : "Pending",
                                          style: TextStyle(
                                              color: posts[index].status == 1
                                                  ? MyColors.secondaryColor
                                                  : MyColors.submit,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else if (isLoading) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                //return SizedBox(height: 20, child: Center(child: Text("no data")));
                                return SizedBox.shrink();
                              }
                            },
                          )),
          ],
        ),
      ),
    );
  }

  Padding brDividerWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 2),
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
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 3, vertical: 8),
            child: Text(
              '${name}',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          );
  }

  DateTimeRange? previouslySelectedRange;

  Future<void> selectDateRange(BuildContext context) async {
    // Set dynamic first and last dates.
    DateTime currentDate = DateTime.now();
    DateTime firstDate =
        currentDate.subtract(Duration(days: 30000)); // 3000000 days before today
    DateTime lastDate =
        currentDate.add(Duration(days: 3650000)); // 365000000 year from today

    final DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDateRange: previouslySelectedRange ??
          null, // Set previously selected or leave null
    );

    if (pickedRange != null) {
      previouslySelectedRange =
          pickedRange; // Save the selected range for future use
      formDate = DateFormat("yyyy-MM-dd").format(pickedRange.start);
      toDate = DateFormat("yyyy-MM-dd").format(pickedRange.end);
      print('Selected range: ${pickedRange.start} to ${pickedRange.end}');
      dateController.text = DateFormat("dd/MM/yyyy").format(pickedRange.start) +
          " — " +
          DateFormat("dd/MM/yyyy").format(pickedRange.end);
    } else {
      print('No range selected');
    }
  }
}
