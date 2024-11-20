import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/footprint_model.dart';
import 'package:village_court_gems/models/frontend_model.dart';
import 'package:village_court_gems/services/database/localDatabaseService.dart';
import 'package:village_court_gems/util/colors.dart';
import 'package:village_court_gems/view/auth/login_page.dart';
import 'package:village_court_gems/view/home/homepage.dart';

class PublicPage extends StatefulWidget {
  const PublicPage({super.key});

  @override
  State<PublicPage> createState() => _PublicPageState();
}

class _PublicPageState extends State<PublicPage> {

  late final token;

  getToken() async {
    token = await Helper().getUserToken();
  }

  late GoogleMapController mapController;
  final LatLng _southwest = LatLng(20.670883287, 88.0283); // Southwest of Bangladesh
  final LatLng _northeast = LatLng(26.6345120194, 92.673667); // Northeast of Bangladesh

  FrontendModel frontEdData = FrontendModel();

  bool isLoading = false;

  initFrontEndData() async {
    isLoading = true;
    frontEdData = await Repositores().getFrontendApi()?.then((value) {
      activity = value.activityCount?.toDouble()??0;
      training = value.trainingCount?.toDouble()??0;
      fieldVisit = value.fieldVisitCount?.toDouble()??0;
      aAco = value.accoCount?.toDouble()??0;
      chartDataFieldVisit = generateData(value.fieldVisitPieCharts!);
      chartDataTraining = generateDataTraining(value.trainingPieCharts!);
      //
      // if (chartDataFieldVisit.isNotEmpty) {
      //   chartDataFieldVisit.forEach((element) {
      //     _totalAmount += element.value ?? 0.0;
      //   });
      // }
      // if (chartDataTraining.isNotEmpty) {
      //   chartDataTraining.forEach((element) {
      //     _totalAmount += element.value ?? 0.0;
      //   });
      // }
      setState(() {
        isLoading = false;
      });
      print("activity $activity");
      print("fieldVisit $fieldVisit");
      print("training $training");
      print("aAco $aAco");
    },)??frontEdData;
  }

  @override
  void initState() {
    initFootPrintCommon();
    getToken();
    initFrontEndData();

    // TODO: implement initState
    super.initState();
  }

  List<DonutPieChartData> chartDataFieldVisit = [];
  List<DonutPieChartData> chartDataTraining = [];

  double centerRadius = 60;

  double activity = 0.0;
  double training = 0.0;
  double fieldVisit = 0.0;
  double aAco = 0.0;

  double _totalAmount = 0.0;

  List officeName = ["Dc Office", "Uno Office", "Up Office", "Other Office", "Total Count"];
  List trainingName = ["Male", "Female", "Participant", "Minority Male", "Minority Female", "Minority Participant"];


  List<FootprintResponseModel> footprintResponseModel = [];

  initFootPrintCommon() async {
    footprintResponseModel = await Repositores().getFootprintsApiOpen()?.then((value) {
      _markers.addAll(List.generate(value!.length, (index) {
        return Marker(
          markerId: MarkerId("${value[index].id}"),
          position: LatLng(double.parse("${value[index].latitude}"), double.parse("${value[index].longitude}")),
          infoWindow: InfoWindow(
            title: '${value[index].user?.userType?.name}',
            snippet: '${value[index].officeType?.name}',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            value[index].user!.userType!.name == "DM"
                ? BitmapDescriptor.hueOrange :
            value[index].user!.userType!.name == "UC"
                ? BitmapDescriptor.hueMagenta
                : BitmapDescriptor.hueRed,
          ),
        );
      },));

    },)??[];
    setState(() {
      print("_markers ${_markers.length}");
    });
  }

  Set<Marker> _markers = <Marker>{};


  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   _markers.addAll(List.generate(footprintResponseModel.length, (index) {
    //     return Marker(
    //       markerId: MarkerId("${footprintResponseModel[index].id}"),
    //       position: LatLng(double.parse("${footprintResponseModel[index].latitude}"), double.parse("${footprintResponseModel[index].longitude}")),
    //       infoWindow: InfoWindow(
    //         title: '${footprintResponseModel[index].user?.userType?.name}',
    //         snippet: '${footprintResponseModel[index].officeType?.name}',
    //       ),
    //       icon: BitmapDescriptor.defaultMarkerWithHue(
    //         footprintResponseModel[index].user!.userType!.name == "DM"
    //             ? BitmapDescriptor.hueOrange :
    //         footprintResponseModel[index].user!.userType!.name == "UC"
    //             ? BitmapDescriptor.hueMagenta
    //             : BitmapDescriptor.hueRed,
    //       ),
    //     );
    //   },));
    //   print("fjahdsfkhkjdasf ${_markers.length}");
    // });

    return Scaffold(
      appBar: AppBar(
        // iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 1,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 80,
        leading: Image.asset(
          'assets/icons/logo.png',
          width: 50,
          height: 50,
        ),
        title: const Text(
          "GEMS",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          GestureDetector(
              onTap: () async {
                if (token == null) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage(),
                    ),
                  );
                } else {
                  await Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Homepage()), (Route<dynamic> route) => false);
                }
              },
              child: Container(
                margin: EdgeInsets.only(right: 15),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: MyColors.secondaryColor)
                ),
                  child: Text("LogIn",style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),),
              ),
          )
        ],
      ),
      body: isLoading? Center(child: CircularProgressIndicator()): Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 10,
                  child: Container(
                    // width: 190,
                    height: 60,
                    color: Color(0xFF146318),
                    child: Padding(
                      padding: EdgeInsets.only(top: 5, left: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Activities",
                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                ),
                                Text(
                                  "${activity.toStringAsFixed(0)}",
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.only(right: 10.w, top: 10.0.h),
                              child: Image.asset(
                                'assets/icons/Group 12.png',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Expanded(flex: 1, child: SizedBox.shrink()),
                Expanded(
                  flex: 10,
                  child: Container(
                    // width: 190,
                    height: 60,
                    color: Color(0xFF0C617E),
                    child: Padding(
                      padding: EdgeInsets.only(top: 5, left: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Trainings",
                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                ),
                                Text(
                                  "${training.toStringAsFixed(0)}",
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.only(right: 10.w, top: 10.0.h),
                              child: Image.asset(
                                'assets/icons/Trainings.png',
                                // width: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 10,
                  child: Container(
                    // width: 190,
                    height: 60,
                    color: Color(0xFF69930C),
                    child: Padding(
                      padding: EdgeInsets.only(top: 5, left: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Field Visits",
                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                ),
                                Text(
                                  "${fieldVisit.toStringAsFixed(0)}",
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.only(right: 10.w, top: 10.0.h),
                              child: Image.asset(
                                'assets/icons/1320336-200.png',
                                // width: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Expanded(flex: 1, child: SizedBox.shrink()),
                Expanded(
                  flex: 10,
                  child: Container(
                    // width: 190,
                    height: 60,
                    color: Color(0xFFE26737),
                    child: Padding(
                      padding: EdgeInsets.only(top: 5, left: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "AACO",
                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                ),
                                Text(
                                  "${aAco.toStringAsFixed(0)}",
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.only(right: 10.w, top: 10.0.h),
                              child: Image.asset(
                                'assets/icons/Vector.png',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            Expanded(
              // width: 300,
              // height: 200,
              child: SizedBox(
                // child: Row(
                //   crossAxisAlignment: CrossAxisAlignment.end,
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: <Widget>[
                //     Flexible(
                //         child: PieChart(
                //           PieChartData(
                //             pieTouchData: PieTouchData(),
                //             borderData: FlBorderData(show: true),
                //             centerSpaceRadius: 40,
                //             startDegreeOffset: 270,
                //             sections: _buildPieSlicesFieldVisit(),
                //           ),
                //         ),
                //         flex: 1),
                //     Flexible(
                //         child: PieChart(
                //           PieChartData(
                //             pieTouchData: PieTouchData(
                //
                //             ),
                //             borderData: FlBorderData(show: false),
                //             centerSpaceRadius: 40,
                //             startDegreeOffset: 270,
                //             sections: _buildPieSlicesTraining(),
                //           ),
                //         ),
                //         flex: 1),
                //
                //     //Flexible(child: _buildLegend(), flex: 1),
                //   ],
                // ),
                ///
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                        child: SfCircularChart(
                          title: ChartTitle(text: 'Field Visit'),
                          legend: Legend(isVisible: true),
                          series: <CircularSeries>[
                            PieSeries<DonutPieChartData, String>(
                              dataSource: _getChartData(),
                              xValueMapper: (DonutPieChartData data, _) => "${data.legendText}",
                              yValueMapper: (DonutPieChartData data, _) => data.value,
                              dataLabelSettings: DataLabelSettings(isVisible: true),
                            )
                          ],
                        ),
                        flex: 1),
                    Flexible(
                        child: SfCircularChart(
                          title: ChartTitle(text: 'Training'),
                          legend: Legend(isVisible: true),
                          series: <CircularSeries>[
                            PieSeries<DonutPieChartData, String>(
                              dataSource: _getChartDataTraining(),
                              xValueMapper: (DonutPieChartData data, _) => "${data.legendText}",
                              yValueMapper: (DonutPieChartData data, _) => data.value,
                              dataLabelSettings: DataLabelSettings(isVisible: true),
                            )
                          ],
                        ),
                        flex: 1),

                    //Flexible(child: _buildLegend(), flex: 1),
                  ],
                ),

              )
            ),

            Expanded(
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                  mapController.animateCamera(
                    CameraUpdate.newLatLngBounds(
                      LatLngBounds(
                        southwest: _southwest,
                        northeast: _northeast,
                      ),
                      0, // padding
                    ),
                  );
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(23.6850, 90.3563), // Center of Bangladesh
                  zoom: 6,
                ),
                markers: _markers,
                mapType: MapType.normal,
                mapToolbarEnabled: false,
                scrollGesturesEnabled: true, // Disable scrolling
                zoomGesturesEnabled: true,   // Disable zooming
                rotateGesturesEnabled: false, // Disable rotating
                tiltGesturesEnabled: false,   //
                zoomControlsEnabled: false, // Disable tilting
                myLocationButtonEnabled: false,
                myLocationEnabled: false,
              ),
            ),

          ],
        ),
      ),
    );
  }

  // List<DonutPieChartData> _getChartData() {
  //   final List<DonutPieChartData> chartData = [
  //     DonutPieChartData(value: 10, legendText: '101', color: Colors.green),
  //     DonutPieChartData(value: 20, legendText: '202', color: Colors.orange),
  //     DonutPieChartData(value: 30, legendText: '301', color: Colors.blueAccent),
  //     DonutPieChartData(value: 40, legendText: '402', color: Colors.teal),
  //     DonutPieChartData(value: 50, legendText: '501', color: Colors.yellow),
  //   ];
  //   return chartData;
  // }


  List<DonutPieChartData> _getChartData() {
    return chartDataFieldVisit.asMap().map((index, it) {
        return MapEntry(
          index,
          DonutPieChartData(
            color: it.color,
            value: it.value,
            legendText: officeName[index]
          ),
        );
      },
    ).values.toList(growable: false);
  }

  List<DonutPieChartData> _getChartDataTraining() {
    return chartDataTraining.asMap().map((index, it) {
        return MapEntry(
          index,
          DonutPieChartData(
            color: it.color,
            value: it.value,
            legendText: trainingName[index]
          ),
        );
      },
    ).values.toList(growable: false);
  }

  // List<PieChartSectionData> _buildPieSlicesTraining() {
  //   return chartDataTraining.asMap().map((index, it) {
  //       return MapEntry(
  //         index,
  //         PieChartSectionData(
  //           color: it.color,
  //           value: it.value,
  //           title: it.value.toString(),
  //           showTitle: true,
  //           radius: 50,
  //           titlePositionPercentageOffset: 0.7,
  //           titleStyle: TextStyle(
  //             fontSize: 12,
  //             fontWeight: FontWeight.bold
  //           ),
  //         ),
  //       );
  //     },
  //   )
  //       .values
  //       .toList(growable: false);
  // }

  ///
  generateData(FieldVisitPieCharts frontEndData) {
    var _pieData = <DonutPieChartData>[
      DonutPieChartData(value: frontEndData.dcDdlgOffices?.toDouble()??0, legendText: '${frontEndData.dcDdlgOffices?.toStringAsFixed(0)}', color: Colors.green),
      DonutPieChartData(value: frontEndData.unoOffices?.toDouble()??0, legendText: '${frontEndData.unoOffices?.toStringAsFixed(0)}', color: Colors.orange),
      DonutPieChartData(value: frontEndData.upOffices?.toDouble()??0, legendText: '${frontEndData.upOffices?.toStringAsFixed(0)}', color: Colors.blueAccent),
      DonutPieChartData(value: frontEndData.otherOffices?.toDouble()??0, legendText: '${frontEndData.otherOffices?.toStringAsFixed(0)}', color: Colors.teal),
      DonutPieChartData(value: frontEndData.totalCounts?.toDouble()??0, legendText: '${frontEndData.totalCounts?.toStringAsFixed(0)}', color: Colors.yellow),
    ];

    return _pieData;
  }

  generateDataTraining(TrainingPieCharts trainingData) {
    var _pieData = <DonutPieChartData>[
      DonutPieChartData(value: double.parse("${trainingData.totalMale}"), legendText: '', color: Colors.green),
      DonutPieChartData(value: double.parse("${trainingData.totalFemale}"), legendText: '', color: Colors.orange),
      DonutPieChartData(value: double.parse("${trainingData.totalParticipant}"), legendText: '', color: Colors.blueAccent),
      DonutPieChartData(value: double.parse("${trainingData.totalMinorityMale}"), legendText: '', color: Colors.teal),
      DonutPieChartData(value: double.parse("${trainingData.totalMinorityFemale}"), legendText: '', color: Colors.yellow),
      DonutPieChartData(value: double.parse("${trainingData.totalMinorityParticipant}"), legendText: '', color: Colors.grey),
    ];

    return _pieData;
  }

}

class DonutPieChartData {
  final double value;
  final String legendText;
  Color color;

  DonutPieChartData({
    required double value,
    required String legendText,
    required Color color,
  })  : value = value ?? 0.0,
        legendText = legendText ?? '',
        color = color ?? Colors.white;
}
