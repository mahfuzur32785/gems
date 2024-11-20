import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:village_court_gems/controller/api_services/api_client.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/progress_report_model.dart';
import 'package:village_court_gems/services/database/localDatabaseService.dart';
import 'package:village_court_gems/util/colors.dart';
import 'package:village_court_gems/util/utils.dart';
import 'package:village_court_gems/widget/custom_appbar.dart';
import 'package:http/http.dart' as http;

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  bool isLoading = false;
  ProgressReportModel activityProgressReport = ProgressReportModel();
  fetchProgressReport() async {
    isLoading = true;
    activityProgressReport = await Repositores().progressReportApi();
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    fetchProgressReport();

    // TODO: implement initState
    super.initState();
  }

  Future<void> checkAndRequestPermissions() async {
    var status = await Permission.storage.status;
    int apiLevel = 0;
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final androidInfo = await deviceInfoPlugin.androidInfo;
    apiLevel = androidInfo.version.sdkInt;

    if (status.isDenied) {
      if (!(apiLevel >= 33)) {
        await Permission.storage.request();
        print("askdhfkjdsafh ${apiLevel}");
      } else {
        print("askdhfkjdsafh No ${apiLevel}");
      }
    }
  }

  Future<String> downloadFile(String url, String name) async {
    Utils.loadingDialog(context);
    String token = await Helper().getUserToken();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final uri = Uri.parse(url);
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final File file;
      String files = name.split('/').last;
      String fileName = files.split('.').last;
      // String fileExtension = files.replaceAll('$fileName.', '');

      if (Platform.isAndroid) {
        await checkAndRequestPermissions();

        Directory? directory;
        directory = await getExternalStorageDirectory();
        directory = await getApplicationDocumentsDirectory();
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        if (await File('/storage/emulated/0/download/$files').exists()) {
          int i = 1;
          while (await File('/storage/emulated/0/download/$fileName($i).pdf')
              .exists()) {
            i++;
          }
          file = File('/storage/emulated/0/download/$fileName($i).pdf');
        } else {
          file = File('/storage/emulated/0/download/$files.pdf');
        }
        await file.writeAsBytes(response.bodyBytes);

        return file.path;
      } else if (Platform.isIOS) {
        Directory? directory;
        directory = await getDownloadsDirectory();
        directory = await getLibraryDirectory();
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        if (await directory.exists()) {
          int i = 1;
          while (await File('${directory.path}$fileName($i).pdf').exists()) {
            i++;
          }
          file = File('${directory.path}$fileName($i).pdf');
        } else {
          file = File('${directory.path}$files.pdf');
        }
        await file.writeAsBytes(response.bodyBytes);

        return file.path;
      }
    }
    throw Exception('Failed to download video');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Progress Reports"),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: MyColors.secondaryColor,
            ))
          : Container(
              padding: EdgeInsets.all(16),
              child: activityProgressReport.data?.data?.length == 0
                  ? Center(
                      child: Text("No Data Found",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)))
                  : ListView.separated(
                      itemCount: activityProgressReport.data!.data!.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: MyColors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: MyColors.customGrey)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          "User Name",
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(":",
                                            style: TextStyle(
                                              color: Colors.black,
                                            )),
                                      ),
                                      Expanded(
                                        flex: 8,
                                        child: Text(
                                            activityProgressReport.data
                                                    ?.data?[index].user?.name ??
                                                "",
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            )),
                                      )
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          "District",
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(":",
                                            style: TextStyle(
                                              color: Colors.black,
                                            )),
                                      ),
                                      Expanded(
                                        flex: 8,
                                        child: Text(
                                            activityProgressReport
                                                    .data
                                                    ?.data?[index]
                                                    .district
                                                    ?.nameEn ??
                                                "",
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            )),
                                      )
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          "Upazila",
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(":",
                                            style: TextStyle(
                                              color: Colors.black,
                                            )),
                                      ),
                                      Expanded(
                                        flex: 8,
                                        child: Text(
                                            activityProgressReport
                                                    .data
                                                    ?.data?[index]
                                                    .upazila
                                                    ?.nameEn ??
                                                "",
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            )),
                                      )
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          "Report Date",
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(":",
                                            style: TextStyle(
                                              color: Colors.black,
                                            )),
                                      ),
                                      Expanded(
                                        flex: 8,
                                        child: Text(
                                            activityProgressReport.data?.data?[index].reportDate ?? "",
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            )),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 10,
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      Utils.capitalizeFirst("${activityProgressReport.data!.data![index].status}"),
                                      style: TextStyle(
                                          color: activityProgressReport.data!
                                                      .data![index].status == //300
                                                  "Approved"
                                              ? MyColors.secondaryColor
                                              : activityProgressReport
                                                          .data!
                                                          .data![index]
                                                          .status ==
                                                      "Draft"
                                                  ? MyColors.submit
                                                  : MyColors.resubmit,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  GestureDetector(
                                    onTap: () {
                                      downloadFile(
                                              "${APIClients.BASE_URL}api/progress-reports/${activityProgressReport.data!.data![index].id}",
                                              "${activityProgressReport.data!.data![index].id}")
                                          .then(
                                        (value) {
                                          Utils.closeDialog(context);
                                          print("skjhdsjkgh ${value}");
                                          Utils.showSnackBar(context, "File Downloaded Successfully");
                                          // Utils.showSnackBarWithAction(
                                          //   context,
                                          //   "File Downloaded Successfully",
                                          //   () async {
                                          //     OpenFile.open(value);
                                          //   },
                                          // );
                                        },
                                      );
                                    },
                                    child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: MyColors.status,
                                        ),
                                        child: Icon(Icons.download)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
    );
  }
}
