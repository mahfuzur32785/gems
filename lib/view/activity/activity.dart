import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:village_court_gems/bloc/activity_bloc/activity_bloc.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/util/colors.dart';

import 'package:village_court_gems/view/activity/activity_List_Details.dart';
import 'package:village_court_gems/view/activity/activity_add.dart';
import 'package:village_court_gems/widget/custom_appbar.dart';

class ActivityShow extends StatefulWidget {
  static const pageName = 'activity_Show';
  const ActivityShow({super.key});

  @override
  State<ActivityShow> createState() => _ActivityShowState();
}

class _ActivityShowState extends State<ActivityShow> {
  // Activity? activityModel;
  // var activity;
  // Future<void> _fetchActivity() async {
  //   activity = await Repositores().ActivityApi();
  //   activityModel = activity;
  // }

  final ActivityBloc activityBloc = ActivityBloc();
  @override
  void initState() {
    // _fetchActivity();
    activityBloc.add(ActivityInitialEvent());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
          title: "Activities"
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          Row(
            children: [
              Expanded(
                flex: 6,
                child: Text(
                  "Activity Info Settings",
                  style: TextStyle(fontSize: 14.0.sp, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(flex: 1, child: SizedBox.shrink()),
              // Expanded(
              //   flex: 5,
              //   child: Padding(
              //     padding: EdgeInsets.only(right: 15.0.w),
              //     child: ElevatedButton(
              //         style: ElevatedButton.styleFrom(
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(7.0.r),
              //           ),
              //           backgroundColor: Color.fromRGBO(50, 122, 163, 1),
              //         ),
              //         onPressed: () async {
              //           await Navigator.of(context).pushNamed(ActivityListShow.pageName);
              //         },
              //         child: Text(
              //           'Activity Details',
              //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11.0.sp),
              //         )),
              //   ),
              // ),
            ],
          ),
          SizedBox(
            height: 10.0.h,
          ),
          BlocConsumer<ActivityBloc, ActivityState>(
              bloc: activityBloc,
              listenWhen: (previous, current) => current is ActivityActionState,
              buildWhen: (previous, current) => current is! ActivityActionState,
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                if (state is ActivityLoadingState) {
                  return Container(
                    child: const Center(child: CircularProgressIndicator()),
                  );
                } else if (state is ActivitySuccessState) {
                  print("all activity");

                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.data.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                              return ActivityListShow(
                                id: state.data[index].id.toString(),
                              );
                            }));
                          },
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: MyColors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: MyColors.customGrey)
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            "Activity Name",
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Text(":",
                                              style: TextStyle(
                                                color: Colors.black,
                                              )),
                                        ),
                                        Expanded(
                                          flex: 8,
                                          child: Text("${state.data[index].name}",
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                              )),
                                        )
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            "Total Count",
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Text(":",
                                              style: TextStyle(
                                                color: Colors.black,
                                              )),
                                        ),
                                        Expanded(
                                          flex: 8,
                                          child: Text("${state.data[index].count}",
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                              )),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              )
                            ],
                          ),
                        );

                        //  Column(
                        //   children: [
                        //     Padding(
                        //       padding: EdgeInsets.only(left: 10.0.w, right: 10.0.w),
                        //       child: Card(
                        //         margin: EdgeInsets.only(top: 3.h),
                        //         color: Color(0xFF0C617E),
                        //         shadowColor: Colors.blueGrey,
                        //         elevation: 3,
                        //         child: Column(
                        //           children: <Widget>[
                        //             ListTile(
                        //               leading: Icon(
                        //                 Icons.storage,
                        //                 color: Colors.white,
                        //                 size: 35,
                        //               ),
                        //               title: Column(
                        //                 crossAxisAlignment: CrossAxisAlignment.start,
                        //                 children: [
                        //                   Text(
                        //                     'Activity Name : ${state.data[index].name}',
                        //                     style: TextStyle(fontSize: 15.sp, color: Colors.white),
                        //                   ),
                        //                   // Text(
                        //                   //   'Location Lavel : ${activityModel!.data[index]..}',
                        //                   //   style: TextStyle(fontSize: 12.sp, color: Colors.white),
                        //                   // ),
                        //                   // Row(
                        //                   //   children: [
                        //                   //     Text(
                        //                   //       'component Name : ${state.data[index].component.name}',
                        //                   //       style: TextStyle(fontSize: 12.sp, color: Colors.white),
                        //                   //     ),
                        //                   //     SizedBox(
                        //                   //       width: 5.w,
                        //                   //     ),
                        //                   //   ],
                        //                   // ),
                        //                 ],
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       height: 10.0.h,
                        //     )
                        //   ],
                        // );
                      },
                    ),
                  );
                }
                return Container();
              }),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed(ActivityUpdate.pageName);
        },
        backgroundColor: MyColors.secondaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
