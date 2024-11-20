import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:village_court_gems/bloc/Change_Location_bloc/change_location_bloc.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/aacoListModel.dart';
import 'package:village_court_gems/models/aaco_model/aaco_nav_model.dart';
import 'package:village_court_gems/models/area_model/all_location_data.dart';
import 'package:village_court_gems/models/locationModel.dart';
import 'package:village_court_gems/services/all_services/all_services.dart';
import 'package:village_court_gems/services/database/localDatabaseService.dart';
import 'package:village_court_gems/util/colors.dart';
import 'package:village_court_gems/view/AACO/aaco_info_add.dart';
import 'package:village_court_gems/view/AACO/aaco_info_edit.dart';
import 'package:village_court_gems/view/AACO/new_aaco_edit_page.dart';
import 'package:village_court_gems/view/home/homepage.dart';
import 'package:village_court_gems/widget/custom_appbar.dart';


class AACO_Info extends StatefulWidget {
  static const pageName = 'AACO_Info';
  const AACO_Info({super.key});

  @override
  State<AACO_Info> createState() => _AACO_InfoState();
}

class _AACO_InfoState extends State<AACO_Info> {
  List<AacoData> posts = [];
  List<AacoResult> aacoNonComletionReasonList = [];
  List<AacoResult> aacoNonavDataList = [];
  int currentPage = 1;
  bool isLoading = false;
  bool isSearchLoading = false;
  AacoListModel? aacoListModel;
  String Recuitment_Status = '';
  String Availabillity_Status = '';
  TextEditingController searchController = TextEditingController();
  String? _selectedSearch;

  ScrollController _scrollController = ScrollController();

  List<AllLocationData> data = [];

  dataList() async {
    data = await Helper().getAllLocationData();
    setState(() {
      print("skldhfjkdasg ${data.length}");
    });
  }

  @override
  void initState() {
    super.initState();
    dataList();

    getNonCompletionAaco();
    getNonAvailablityStatusForNoList();
    _fetchPosts("");

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _fetchPosts("");
      }
    });
  }



  Future<void> _fetchPosts(String searchText) async {
    if (isLoading) return;
      isLoading = true;

    if(searchText.isNotEmpty){
      currentPage = 1;
      posts.clear();
    }

    var res = await Repositores().acooListApi(currentPage, searchText);
    if (res != null) {
       aacoListModel = res;
    // List response =aacoListModel;
    // print(a['data']['data']);
        if (aacoListModel!.data!.isNotEmpty) {
          posts.addAll(aacoListModel!.data!);
        }
        print("accinfo list ");
        currentPage++;
        isLoading = false;
       setState(() {

      });

    }
   
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
  
  getNonAvailablityStatusForNoList() async {
    aacoNonavDataList = [];

    var accoNonAvData = await Repositores().getNonAvailabilityData();
    if (accoNonAvData != null) {
      setState(() {
        aacoNonavDataList = accoNonAvData.result ?? [];
      });
    } else {
      // setState(() {
      aacoNonavDataList = [];
      // });
    }
    // setState(() {
    //   _isLoading = false;
    // });
  }

  final ChangeLocationBloc changeLocationBloc = ChangeLocationBloc();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: "AACO Informations",
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            // Container(
            //     width: double.infinity,
            //     child: Row(children: <Widget>[
            //       Expanded(
            //         child: TextField(
            //           // textInputAction: TextInputAction.next,
            //           textAlignVertical: TextAlignVertical.center,
            //           controller: searchController,
            //           textInputAction: TextInputAction.search,
            //           onChanged: (value) {
            //             _fetchPosts(searchController.text.trim());
            //           },
            //           decoration: InputDecoration(
            //             isDense: true,
            //             enabledBorder: OutlineInputBorder(
            //               borderSide: BorderSide(width: 1, color: Colors.black),
            //             ),
            //             focusedBorder: OutlineInputBorder(
            //               borderSide: BorderSide(width: 1, color: Colors.black),
            //             ),
            //             hintText: 'Search',
            //             contentPadding: const EdgeInsets.all(10), //Imp Line
            //             suffixIcon: GestureDetector(
            //               onTap: () async {
            //                 _fetchPosts(searchController.text.trim());
            //               },
            //               child: Icon(Icons.search,size: 25,),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ]),
            // ),

            ///

            TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                  onChanged: (value){
                    if (value == '') {
                      _selectedSearch = '';
                    }
                  },
                  controller: searchController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.black),
                    ),
                    hintText: 'Search',
                    contentPadding: const EdgeInsets.all(10),
                    suffix: _selectedSearch == '' ? null : GestureDetector(
                      onTap: () {
                        setState(() {
                          searchController.text = '';
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3),
                        child: Icon(Icons.close,size: 14,),
                      ),
                    ),
                  )
              ),
              suggestionsCallback: (pattern) async {
                await dataList();
                return data
                    .where((element) => element.nameEn!
                    .toLowerCase()
                    .contains(pattern.toString().toLowerCase()))
                    .take(10)
                    .toList();
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title:
                  Text(suggestion.nameEn.toString().trim()),
                );
              },
              noItemsFoundBuilder: (context) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: const Text("Location not found!",textAlign: TextAlign.center,style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),),
                );
              },

              transitionBuilder:
                  (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              onSuggestionSelected: (AllLocationData suggestion) async {
                searchController.text = suggestion.nameEn.toString().trim();
                _fetchPosts(searchController.text);
              },
              onSaved: (value) {},
            ),


            SizedBox(
              height: 10,
            ),
            isLoading
                ? Center(child: CircularProgressIndicator(),)
                : posts.length != 0
                ? Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: posts.length + 1,
                itemBuilder: (context, index) {
                  if (index < posts.length) {
                    final post = posts[index];
                    if (post.recruitmentStatus == 1) {
                      Recuitment_Status = "YES";
                    } else {
                      Recuitment_Status = "NO";
                    }
                    if (post.accoAvailiablityStatus == 1) {
                      Availabillity_Status = "Yes";
                    } else {
                      Availabillity_Status = "NO";
                    }
                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            print("ttttttttttttttttt");
                          },
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: MyColors.white,
                                    borderRadius: BorderRadius.circular(12,),
                                    border: Border.all(color: MyColors.customGrey)
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        // IconButton(
                                        //   onPressed: () async {
                                        //     Map deleteResponse = await Repositores().AACOInfoDeleteAPi(post.id.toString());
                                        //     if (deleteResponse['status'] == 200) {
                                        //       setState(() {});
                                        //       await QuickAlert.show(
                                        //         context: context,
                                        //         type: QuickAlertType.success,
                                        //         text: "AACO Info Deleted Successfully!",
                                        //       );
                                        //       await Navigator.of(context).pushAndRemoveUntil(
                                        //           MaterialPageRoute(builder: (context) => AACO_Info()),
                                        //           (Route<dynamic> route) => false);
                                        //     } else {
                                        //       await QuickAlert.show(
                                        //         context: context,
                                        //         type: QuickAlertType.error,
                                        //         text: "Something went wrong please try again later",
                                        //       );
                                        //     }
                                        //   },
                                        //   icon: Container(
                                        //     padding: EdgeInsets.all(8), // Adjust padding as needed
                                        //     decoration: BoxDecoration(
                                        //         shape: BoxShape.circle, color: const Color.fromARGB(255, 243, 207, 207)),
                                        //     child: Icon(
                                        //       Icons.close_rounded,
                                        //       color: Colors.black, // Set the color of the icon as needed
                                        //     ),
                                        //   ),
                                        // ),

                                        // IconButton(
                                        //   onPressed: () async {
                                        //     await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                        //       return AACOInfoEditPage(
                                        //         id: post.id,
                                        //       );
                                        //     }));
                                        //   },
                                        //   icon: Container(
                                        //     padding: EdgeInsets.all(8), // Adjust padding as needed
                                        //     decoration: BoxDecoration(
                                        //       shape: BoxShape.circle,
                                        //       color: Colors.white,
                                        //     ),
                                        //     child: Icon(
                                        //       Icons.edit,
                                        //       color: Colors.black, // Set the color of the icon as needed
                                        //     ),
                                        //   ),
                                        // )
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 10.w,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Text(
                                              "District",
                                              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: Colors.black),
                                            ),
                                          ),
                                          Expanded(flex: 1, child: Text(":")),
                                          Expanded(
                                            flex: 7,
                                            child: Text("${post.district}",
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFF1D2746),
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 10.w,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Text(
                                              "Upazila",
                                              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: Colors.black),
                                            ),
                                          ),
                                          Expanded(flex: 1, child: Text(":")),
                                          Expanded(
                                            flex: 7,
                                            child: Text("${post.upazila}",
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFF1D2746),
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 10.w,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Text(
                                              "Union",
                                              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: Colors.black),
                                            ),
                                          ),
                                          Expanded(flex: 1, child: Text(":")),
                                          Expanded(
                                            flex: 7,
                                            child: Text("${post.union}",
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFF1D2746),
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 10.w,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Text(
                                              "Recuitment Status",
                                              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: Colors.black),
                                            ),
                                          ),
                                          Expanded(flex: 1, child: Text(":")),
                                          Expanded(
                                            flex: 7,
                                            child: Text("${Recuitment_Status}",
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFF1D2746),
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 10.w,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Text(
                                              "Availability Status",
                                              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: Colors.black),
                                            ),
                                          ),
                                          Expanded(flex: 1, child: Text(":")),
                                          Expanded(
                                            flex: 7,
                                            child: Text("${Availabillity_Status}",
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFF1D2746),
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                  post.apointmentDate == null ? SizedBox.shrink():  Padding(
                                      padding: EdgeInsets.only(
                                        left: 10.w,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Text(
                                              "Appointment Date",
                                              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: Colors.black),
                                            ),
                                          ),
                                          Expanded(flex: 1, child: Text(":")),
                                          Expanded(
                                            flex: 7,
                                            child: Text("${post.apointmentDate}",
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFF1D2746),
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        ),
                        Positioned(
                            top: 5,
                            right: 5,
                            child: GestureDetector(
                              onTap: () async {
                                await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                   return NewAacoInfoEditScreen(
                                    id: post.id,
                                    aacoNonComletionReasonList: aacoNonComletionReasonList,
                                    aacoNonavDataList: aacoNonavDataList,
                                  );
                                  // return AACOInfoEditPage(
                                  //   id: post.id,
                                  // );
                                }));
                              },
                              child: Container(
                                padding: EdgeInsets.all(5), // Adjust padding as needed
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: MyColors.secondaryColor.withOpacity(0.8),
                                ),
                                // child: Text("${index+1}"),
                                child: Icon(
                                  Icons.edit,
                                  color: MyColors.white,
                                  size: 18,
                                ),
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
                    return SizedBox.shrink();
                  }
                },
              ),
            )
                : Visibility(child: Column(
              children: [
                SizedBox(height: 50,),
                Text("AACO Data Found!")
              ],
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.secondaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        onPressed: () async {
          await Navigator.of(context).pushNamed(AACO_Info_Add.pageName);
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
