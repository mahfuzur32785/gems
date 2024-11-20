import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/TraningsInfoDetailsModel.dart';
import 'package:village_court_gems/models/new_TraningModel.dart';
import 'package:village_court_gems/util/colors.dart';
import 'package:village_court_gems/view/trainings/training_edit.dart';
import 'package:village_court_gems/widget/custom_appbar.dart';

class TrainingsInfoDetails extends StatefulWidget {
  TrainingsInfoDetails(
      {super.key, required this.id, required this.allTraining});

  final String id;
  final List<AllTrainingData> allTraining;

  @override
  State<TrainingsInfoDetails> createState() => _TrainingsInfoDetailsState();
}

class _TrainingsInfoDetailsState extends State<TrainingsInfoDetails> {
  List<TrainingDetailsData> posts = [];
  int currentPage = 1;
  bool isLoading = false;
  TrainingInfoDetailsModel? trainingInfoDetailsModel;
  TextEditingController searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchPosts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchPosts();
      }
    });
  }

  Future<void> _fetchPosts() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    var a = await Repositores().TrainingsInfoDetailsApi(currentPage, widget.id);
    trainingInfoDetailsModel = a;
    setState(() {
      if (trainingInfoDetailsModel!.data.isNotEmpty) {
        posts.addAll(trainingInfoDetailsModel!.data);
      }

      print("accinfo list ");

      currentPage++;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("hghhhhhhhhhhhhhhhhhhh");
    print(widget.id);
    return Scaffold(
      appBar: CustomAppbar(
        title: "Training Details",
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : posts.length == 0
                ? Center(
                    child: Text(
                      "Training Not Found",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                          child: ListView.separated(
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemCount: posts.length + 1,
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 10,
                          );
                        },
                        itemBuilder: (context, index) {
                          if (index < posts.length) {
                            final post = posts[index];

                            return Stack(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: MyColors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                              color: MyColors.customGrey)),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 10.w,
                                                right: 10.w,
                                                top: 10.h),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 4,
                                                  child: Text(
                                                    "Training Venue",
                                                    style: TextStyle(
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  child: Text(
                                                    ":",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 8,
                                                  child: Text(
                                                      "${post.trainingVenue}",
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
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 10.w,
                                                right: 10.w,
                                                top: 10.h),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 4,
                                                  child: Text(
                                                    "Location level",
                                                    style: TextStyle(
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10),
                                                    child: Text(
                                                      ":",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    )),
                                                Expanded(
                                                  flex: 8,
                                                  child: Text(
                                                      "${post.locationLevel}",
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
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 10.w,
                                                right: 10.w,
                                                top: 10.h),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 4,
                                                  child: Text(
                                                    "Total Male",
                                                    style: TextStyle(
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10),
                                                    child: Text(
                                                      ":",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    )),
                                                Expanded(
                                                  flex: 8,
                                                  child:
                                                      Text("${post.totalMale}",
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
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 10.w,
                                                right: 10.w,
                                                top: 10.h),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 4,
                                                  child: Text(
                                                    "Total Female",
                                                    style: TextStyle(
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10),
                                                    child: Text(
                                                      ":",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    )),
                                                Expanded(
                                                  flex: 8,
                                                  child: Text(
                                                      "${post.totalFemale}",
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
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 10.w,
                                                right: 10.w,
                                                top: 10.h),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  flex: 4,
                                                  child: Text(
                                                    "Total Participant",
                                                    style: TextStyle(
                                                      fontSize: 13.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10),
                                                    child: Text(
                                                      ":",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    )),
                                                Expanded(
                                                  flex: 8,
                                                  child: Text(
                                                      "${post.totalParticipant}",
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
                                          SizedBox(
                                            height: 10.0.h,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                    top: 5,
                                    right: 5,
                                    child: GestureDetector(
                                      onTap: () async {
                                        // print(post.id);
                                        await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TrainingEditPage(
                                              id: post.id,
                                              allTraining: widget.allTraining,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(
                                            5), // Adjust padding as needed
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: MyColors.secondaryColor
                                              .withOpacity(0.8),
                                        ),
                                        child: Icon(
                                          Icons.edit,
                                          color: MyColors.white,
                                          size: 18,
                                        ),
                                      ),
                                    )),
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
                      ))
                    ],
                  ),
      ),
    );
  }
}
