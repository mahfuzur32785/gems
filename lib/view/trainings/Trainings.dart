import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:village_court_gems/bloc/Training_show_Bloc/training_show_bloc.dart';
import 'package:village_court_gems/util/colors.dart';
import 'package:village_court_gems/view/Trainings/Trainings_info_Details.dart';
import 'package:village_court_gems/view/trainings/training_add.dart';
import 'package:village_court_gems/widget/custom_appbar.dart';

class TrainingsPage extends StatefulWidget {
  static const pageName = 'Trainings_page';
  const TrainingsPage({super.key});

  @override
  State<TrainingsPage> createState() => _TrainingsPageState();
}

class _TrainingsPageState extends State<TrainingsPage> {

  final TrainingShowBloc trainingShowBloc = TrainingShowBloc();
  @override
  void initState() {
    super.initState();
    trainingShowBloc.add(TrainingShowInitialEvent());
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: "Training",
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Training Info Settings",
              style: TextStyle(fontSize: 14.0.sp, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          BlocConsumer<TrainingShowBloc, TrainingShowState>(
              bloc: trainingShowBloc,
              listenWhen: (previous, current) => current is TrainingShowActionState,
              buildWhen: (previous, current) => current is! TrainingShowActionState,
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                if (state is TrainingShowLoadingState) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                } else if (state is TrainingShowSuccessState) {
                  print("yyyyyyyyyyyyyyyyyyyyyyyyy");
                  //Training? trainingData;
                  //state.data = trainingData;
                  // Training trainingData1111 = state.data;
                  // print(state.data);
                  return Expanded(
                    child: ListView.separated(
                      itemCount: state.data.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 10,);
                      },
                      itemBuilder: (context, index) {
                        print(state.data[index]);
                        return GestureDetector(
                            onTap: () async {
                              await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                return TrainingsInfoDetails(
                                  id: state.data[index].id.toString(),
                                  allTraining: state.data,
                                );
                              }));
                            },
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                      color: MyColors.white,
                                      borderRadius: BorderRadius.circular(12,),
                                      border: Border.all(color: MyColors.customGrey)
                                  // color: color,
                                  // color: const Color.fromARGB(255, 235, 229, 229),
                                  // borderRadius: BorderRadius.circular(5),
                                  // borderRadius: BorderRadius.only(
                                  //   bottomLeft: Radius.circular(8.r),
                                  //   bottomRight: Radius.circular(8.r),
                                  //   topLeft: Radius.circular(8.r),
                                  //   topRight: Radius.circular(8.r),
                                  // ),
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //       color: color,
                                  //       offset: Offset(1, 2), //(x,y)
                                  //       blurRadius: 3.0,
                                  //       spreadRadius: 0.2,
                                  //   ),
                                  // ],
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.0.h),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Text(
                                              "Training Name",
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                            child: Text(
                                              ":",
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 9,
                                            child: Text("${state.data[index].title}",
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
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
                                        right: 10.w,
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Text(
                                              "Component",
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                            child: Text(":",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                )),
                                          ),
                                          Expanded(
                                            flex: 9,
                                            child: Text("${state.data[index].component.name}",
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 10.w,
                                        right: 10.w,
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Text(
                                              "Total Count",
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                            child: Text(":",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                )),
                                          ),
                                          Expanded(
                                            flex: 9,
                                            child: Text("${state.data[index].count}",
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
                return Container();
              })
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed(TrainingDataPage.pageName);
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
