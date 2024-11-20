import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/ActivityDetailsForEditModel.dart';
import 'package:village_court_gems/util/colors.dart';
import 'package:village_court_gems/view/activity/activity_Edit_update.dart';
import 'package:village_court_gems/widget/custom_appbar.dart';

class ActivityListShow extends StatefulWidget {
  String? id;
  static const pageName = 'activity_list_show';
  ActivityListShow({super.key, this.id});

  @override
  State<ActivityListShow> createState() => _ActivityListShowState();
}

class _ActivityListShowState extends State<ActivityListShow> {
  List<ActivityDetailsData> posts = [];
  int currentPage = 1;
  bool isLoading = false;
  ActivityDetailsForEditModel? activityDetailsForEditModel;
  TextEditingController searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _fetchPosts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _fetchPosts();
      }
    });

    super.initState();
  }

  Future<void> _fetchPosts() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    activityDetailsForEditModel = await Repositores().ActivityDetailsForEditApi(widget.id.toString(), currentPage.toString());

    setState(() {
      if (activityDetailsForEditModel!.data.isNotEmpty) {
        posts.addAll(activityDetailsForEditModel!.data);
      }

      print("activity list ");

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
    return Scaffold(
      appBar: CustomAppbar(
        title: "Activity Details",
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
              shrinkWrap: true,
              controller: _scrollController,
              itemCount: posts.length + 1,
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
                                borderRadius: BorderRadius.circular(12,),
                                border: Border.all(color: MyColors.customGrey)
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "Venue Name",
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Text("${post.venue}",
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          )),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "Location level",
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Text("${post.locationLevel}",
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          )),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "Total Male",
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Text("${post.totalMale}",
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          )),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "Total Female",
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Text("${post.totalFemale}",
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          )),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "Total Participant",
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                      child: Text(
                                        ":",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Text("${post.totalParticipant}",
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          )),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0.h,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                        ],
                      ),
                      Positioned(
                          top: 5,
                          right: 5,
                          child: GestureDetector(
                            onTap: () async {
                              print(post.id);
                              // print(post.id);
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ActivityEditUpdatePage(
                                      id: post.id.toString(),
                                    );
                                  },
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(5), // Adjust padding as needed
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: MyColors.secondaryColor,
                              ),
                              child: Icon(
                                Icons.edit,
                                size: 18,
                                color: Colors.white, // Set the color of the icon as needed
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
