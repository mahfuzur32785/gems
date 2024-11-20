import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:upgrader/upgrader.dart';
import 'package:village_court_gems/bloc/All_Count_Bloc/all_count_bloc.dart';
import 'package:village_court_gems/bloc/Connectivity_bloc/new_connectivity_cubit.dart';
import 'package:village_court_gems/controller/Local_store_controller/local_store.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/helper/location_helper.dart';
import 'package:village_court_gems/main.dart';
import 'package:village_court_gems/models/footprint_model.dart';
import 'package:village_court_gems/provider/connectivity_provider.dart';

import 'package:village_court_gems/services/all_services/all_services.dart';
import 'package:village_court_gems/services/backgroundService/wm_service.dart';
import 'package:village_court_gems/services/database/localDatabaseService.dart';
import 'package:village_court_gems/util/colors.dart';
import 'package:village_court_gems/util/constant.dart';
import 'package:village_court_gems/util/utils.dart';

import 'package:village_court_gems/view/Profile/profile.dart';
import 'package:village_court_gems/view/Trainings/Trainings.dart';

import 'package:village_court_gems/view/activity/progress_report.dart';
import 'package:village_court_gems/view/auth/login_page.dart';
import 'package:village_court_gems/view/field_visit_list/field_visit_list.dart';
import 'package:village_court_gems/view/AACO/aaco_Info.dart';
import 'package:village_court_gems/view/trainings/training_add.dart';
import 'package:village_court_gems/view/visit_report/offline_sync_page.dart';
import 'package:village_court_gems/view/visit_report/rev_field_visit_screen.dart';

ValueNotifier<List<Map<String, dynamic>>> localFieldVisitDataListNotifier =
    ValueNotifier<List<Map<String, dynamic>>>([]);
class Homepage extends StatefulWidget {
  static const pageName = 'home';
  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool status = false;
  bool _isLoadingLogout = false;
  LocationHelper locationHelper = LocationHelper();
  bool isSync = true;

  late GoogleMapController mapController;
  final LatLng _southwest = LatLng(20.670883287, 88.0283);
  final LatLng _northeast = LatLng(26.6345120194, 92.673667);

  Position? currentLocation;

  Completer<GoogleMapController> mapControllerCompleter = Completer();

   getData() async {
    List<Map<String, dynamic>> localFldData = [];
    List<Map<String, dynamic>> localaddChngData = [];
    List<Map<String, dynamic>> syncedFvData = [];
    List<Map<String, dynamic>> syncedaddChngFvData = [];

    final localFieldVisitData = await prefs.getStringList(fieldVisitSubmitKey);
    final addchngData = await prefs.getStringList(addNewLocSubmitKey);

    log('fieldVisitSubmitKey syncedData 1 ${jsonEncode(localFieldVisitData)}');
    log('addNewLocSubmitKey syncedData 2 ${jsonEncode(addchngData)}');


    if (localFieldVisitData != null) {
      localFieldVisitData.forEach((element) {
        localFldData.add(jsonDecode(element));
      });
      syncedFvData = localFldData
          .where((e) =>
              e['sync'] == '0' || e['sync'] == '400' || e['sync'] == '422')
          .toList();
      log('field visit local syncedData 1 ${syncedFvData.length}');
    }

    if (addchngData != null) {
      addchngData.forEach((element) {
        localaddChngData.add(jsonDecode(element));
      });
      syncedaddChngFvData =
          localaddChngData.where((e) => e['sync'] == '0').toList();
      log('change location local syncedData 2 ${syncedaddChngFvData.length}');
    }

    localFieldVisitDataListNotifier.value = syncedFvData + syncedaddChngFvData;
    log('change location local syncedData 3 ${localFieldVisitDataListNotifier.value.length}');

  }

  checkSyncEdData() async{
    List<Map<String, dynamic>> localFldData = [];
    final data =await prefs.getStringList(fieldVisitSubmitKey);
    if (data != null) {
      data.forEach((element) {
        localFldData.add(jsonDecode(element));
      });
      if (localFldData.any((e) => e['sync'] == '0')) {
        setState(() {
          isSync = false;
        });
      } else {
        setState(() {
          isSync = true;
        });
      }
    }
  }

  void initLocation() async {
    try {
      var userLocation = await locationHelper.determinePosition();
      setState(() {
        currentLocation = userLocation;
        print(currentLocation!.latitude);
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  final AllCountBloc countBloc = AllCountBloc();

  Set<Marker> _markers = <Marker>{};

  List<FootprintResponseModel> footprintResponseModel = [];

  ///Marker data for api
  initFootPrint() async {
    footprintResponseModel = await Repositores().getFootprintsApi()??[];
  }

  @override
  void initState() {
    initLocation();
    initFootPrint();
    mapControllerCompleter.future.then((controller) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              currentLocation?.latitude ?? 0.0,
              currentLocation?.longitude ?? 0.0,
            ),
            zoom: 14.0,
          ),
        ),
      );
    });
    super.initState();

    countBloc.add(AllCountInitialEvent());
  }

  bool isgetLocLoading = false;

  @override
  Widget build(BuildContext context) {
    getData();
    ///lat long add for marker
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _markers.addAll(List.generate(footprintResponseModel.length, (index) {
        return Marker(
          markerId: MarkerId("${footprintResponseModel[index].id}"),
          position: LatLng(double.parse("${footprintResponseModel[index].latitude}"), double.parse("${footprintResponseModel[index].longitude}")),
          infoWindow: InfoWindow(
            title: '${footprintResponseModel[index].user?.name} - ${footprintResponseModel[index].user?.userType?.name}',
            snippet: '${footprintResponseModel[index].officeType?.name} - ${Utils.formatDate(footprintResponseModel[index].visitDate)}',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            footprintResponseModel[index].user!.userType!.name == "DM"
                ? BitmapDescriptor.hueOrange :
            footprintResponseModel[index].user!.userType!.name == "UC"
                ? BitmapDescriptor.hueMagenta
                : BitmapDescriptor.hueRed,
          ),
        );
      },));
    });

    return Scaffold(
      appBar: AppBar(
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
          Visibility(
            visible: false,
            child: IconButton(
                onPressed: () async {},
                icon: Image.asset(
                  'assets/icons/Frame 5.png',
                  width: 30,
                  height: 24,
                )),
          ),
          IconButton(
            onPressed: () async {
              final connectivityResult = await (Connectivity().checkConnectivity());
              if (connectivityResult.contains(ConnectivityResult.mobile) ||
                  connectivityResult.contains(ConnectivityResult.wifi) ||
                  connectivityResult.contains(ConnectivityResult.ethernet)) {
                await Navigator.of(context).pushNamed(ProfilePage.pageName);
              } else {
                AllService().internetCheckDialog(context);
              }
            },
            icon: Icon(Icons.person),
          ),
          _isLoadingLogout
              ? Center(
                  child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    backgroundColor: Color(0xFF078669),
                    strokeWidth: 6,
                  ),
                ))
              : IconButton(
                  onPressed: () async {
                    final connectivityResult = await (Connectivity().checkConnectivity());
                    if (connectivityResult.contains(ConnectivityResult.mobile) ||
                        connectivityResult.contains(ConnectivityResult.wifi) ||
                        connectivityResult.contains(ConnectivityResult.ethernet)) {
                      setState(() {
                        _isLoadingLogout = true;
                      });
                      Map logoutResponse = await Repositores().LogoutAPi();
                      print(logoutResponse);

                      if (logoutResponse['status'] == 200) {
                        await Helper().deleteToken();
                        await ConnectivityProvider().removeAllUserData();
                        await Navigator.of(context)
                            .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginPage()), (Route<dynamic> route) => false);
                        setState(() {
                          _isLoadingLogout = false;
                        });
                      }
                    } else {
                      AllService().internetCheckDialog(context);
                      setState(() {
                        _isLoadingLogout = false;
                      });
                    }
                  },
                  icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: UpgradeAlert(
        child: RefreshIndicator(
          onRefresh: () async {
            countBloc.add(AllCountInitialEvent());
          },
          child: Container(
            padding: EdgeInsets.all(16),
            child: Stack(
              children: [
                ListView(),
                Column(
                  children: [
                    BlocConsumer<ConnectivityCubit, ConnectivityState>(
                      listenWhen: (previous, current) => previous != current,
                      listener: (context, netState) {
                        if (netState == ConnectivityState.connected) {
                          log('You Network is AVailable now');
                          backgroundSync();
                        } else {
                          log('You are now in Offline');
                        }
                      },
                      builder: (context, netstate) {
                        if (netstate == ConnectivityState.disconnected) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Dashboard",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    margin: const EdgeInsets.symmetric(horizontal: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'Offline',
                                      style: TextStyle(fontSize: 13, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => OfflineSyncPage(isOfflineView: true,)));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: MyColors.secondaryColor.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Stored Data',
                                        style: TextStyle(fontSize: 14, color: MyColors.white),
                                      ),
                                    ),
                                  ),
                                  Positioned(top: -10, right: 0,child: Container(
                                    width: 18,
                                    height: 18,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red,
                                    ),
                                    child: Center(child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                                      valueListenable: localFieldVisitDataListNotifier,
                                      builder: (context, localFieldVisitDataList, _) {
                                        if(localFieldVisitDataList.length > 9){
                                          return Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: '9',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                  ), // Base text size
                                                ),
                                                WidgetSpan(
                                                  child: Transform.translate(
                                                    offset: Offset(-1, -5), // Shift the + upwards
                                                    child: Text(
                                                      '+',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            textAlign: TextAlign.center,
                                          );
                                        }
                                        else{
                                          return Text("${localFieldVisitDataList.length}",style: TextStyle(fontSize: 14, color: Colors.white),);
                                        }
                                      },
                                    ),),
                                  ))
                                ],
                              ),
                            ],
                          );
                        } else if (netstate == ConnectivityState.connected) {
                          localFieldVisitDataListNotifier.value.clear();
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Dashboard",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 5),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'Online',
                                      style: TextStyle(fontSize: 12, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => OfflineSyncPage(isOfflineView: false,)));
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: MyColors.secondaryColor.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Sync Data',
                                    style: TextStyle(fontSize: 14, color: MyColors.white),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BlocConsumer<AllCountBloc, AllCountState>(
                        bloc: countBloc,
                        listener: (context, state) {
                          // TODO: implement listener
                        },
                        builder: (context, state) {
                          if (state is AllCountLoadingState) {
                            return Container(
                                child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 10,
                                      child: GestureDetector(
                                        onTap: () async {
                                          final connectivityResult = await (Connectivity().checkConnectivity());
                                          if (connectivityResult.contains(ConnectivityResult.mobile) ||
                                              connectivityResult.contains(ConnectivityResult.wifi) ||
                                              connectivityResult.contains(ConnectivityResult.ethernet)) {
                                            await Navigator.of(context).push(MaterialPageRoute(builder: (context) => ActivityScreen(),));
                                          } else {
                                            AllService().internetCheckDialog(context);
                                          }
                                        },
                                        child: Container(
                                          // width: 190,
                                          height: 70,
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
                                                        style: TextStyle(color: Colors.white, fontSize: 12.sp),
                                                      ),
                                                      Text(
                                                        "",
                                                        style: TextStyle(color: Colors.white, fontSize: 18.sp),
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
                                    ),
                                    const Expanded(flex: 1, child: SizedBox.shrink()),
                                    Expanded(
                                      flex: 10,
                                      child: GestureDetector(
                                        onTap: () async {
                                          final connectivityResult = await (Connectivity().checkConnectivity());
                                          if (connectivityResult.contains(ConnectivityResult.mobile) ||
                                              connectivityResult.contains(ConnectivityResult.wifi) ||
                                              connectivityResult.contains(ConnectivityResult.ethernet)) {
                                            await Navigator.of(context).pushNamed(TrainingsPage.pageName);
                                          } else {
                                            AllService().internetCheckDialog(context);
                                          }
                                        },
                                        child: Container(
                                          // width: 190,
                                          height: 70,
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
                                                        style: TextStyle(color: Colors.white, fontSize: 12.0.sp),
                                                      ),
                                                      Text(
                                                        "",
                                                        style: TextStyle(color: Colors.white, fontSize: 18.0.sp),
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
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 10,
                                      child: GestureDetector(
                                        onTap: () async {
                                          log('Field visit checked');
                                          final connectivityResult = await (Connectivity().checkConnectivity());
                                          if (connectivityResult.contains(ConnectivityResult.mobile) ||
                                              connectivityResult.contains(ConnectivityResult.wifi) ||
                                              connectivityResult.contains(ConnectivityResult.ethernet)) {
                                          await Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return FieldVisitListPage();
                                              },
                                            ),
                                          );
                                          } else {
                                            AllService().internetCheckDialog(context);
                                          }
                                        },
                                        child: Container(
                                          // width: 190,
                                          height: 70,
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
                                                        style: TextStyle(color: Colors.white, fontSize: 12.0.sp),
                                                      ),
                                                      Text(
                                                        "",
                                                        style: TextStyle(color: Colors.white, fontSize: 18.0.sp),
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
                                    ),
                                    const Expanded(flex: 1, child: SizedBox.shrink()),
                                    Expanded(
                                      flex: 10,
                                      child: GestureDetector(
                                        onTap: () async {
                                          final connectivityResult = await (Connectivity().checkConnectivity());
                                          if (connectivityResult.contains(ConnectivityResult.mobile) ||
                                              connectivityResult.contains(ConnectivityResult.wifi) ||
                                              connectivityResult.contains(ConnectivityResult.ethernet)) {
                                            await Navigator.of(context).pushNamed(AACO_Info.pageName);
                                          } else {
                                            AllService().internetCheckDialog(context);
                                          }
                                        },
                                        child: Container(
                                          // width: 190,
                                          height: 70,
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
                                                        style: TextStyle(color: Colors.white, fontSize: 12.0.sp),
                                                      ),
                                                      Text(
                                                        "",
                                                        style: TextStyle(color: Colors.white, fontSize: 18.0.sp),
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
                                    ),
                                  ],
                                ),
                              ],
                            ));
                          }
                          else if (state is AllCountSuccessState) {
                            print(state.countModel!.accoInfoCount);
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 10,
                                      child: GestureDetector(
                                        onTap: () async {
                                          final connectivityResult = await (Connectivity().checkConnectivity());
                                          if (connectivityResult.contains(ConnectivityResult.mobile) ||
                                              connectivityResult.contains(ConnectivityResult.wifi) ||
                                              connectivityResult.contains(ConnectivityResult.ethernet)) {
                                            await Navigator.of(context).push(MaterialPageRoute(builder: (context) => ActivityScreen(),));
                                          } else {
                                            AllService().internetCheckDialog(context);
                                          }
                                        },
                                        child: Container(
                                          // width: 190,
                                          height: 70,
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
                                                        style: TextStyle(color: Colors.white, fontSize: 12.sp),
                                                      ),
                                                      Text(
                                                        state.countModel!.activityInfoCount.toString(),
                                                        style: TextStyle(color: Colors.white, fontSize: 18.sp),
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
                                    ),
                                    const Expanded(flex: 1, child: SizedBox.shrink()),
                                    Expanded(
                                      flex: 10,
                                      child: GestureDetector(
                                        onTap: () async {
                                          final connectivityResult = await (Connectivity().checkConnectivity());
                                          if (connectivityResult.contains(ConnectivityResult.mobile) ||
                                              connectivityResult.contains(ConnectivityResult.wifi)) {
                                            await Navigator.of(context).pushNamed(TrainingsPage.pageName);
                                          } else {
                                            AllService().internetCheckDialog(context);
                                          }
                                        },
                                        child: Container(
                                          // width: 190,
                                          height: 70,
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
                                                        style: TextStyle(color: Colors.white, fontSize: 12.0.sp),
                                                      ),
                                                      Text(
                                                        state.countModel!.trainingInfoCount.toString(),
                                                        style: TextStyle(color: Colors.white, fontSize: 18.0.sp),
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
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 10,
                                      child: GestureDetector(
                                        onTap: () async {
                                          final connectivityResult = await (Connectivity().checkConnectivity());
                                          if (connectivityResult.contains(ConnectivityResult.mobile) ||
                                              connectivityResult.contains(ConnectivityResult.wifi) ||
                                              connectivityResult.contains(ConnectivityResult.ethernet)) {
                                            await Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return FieldVisitListPage();
                                                },
                                              ),
                                            );
                                          } else {
                                            AllService().internetCheckDialog(context);
                                          }
                                        },
                                        child: Container(
                                          // width: 190,
                                          height: 70,
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
                                                        style: TextStyle(color: Colors.white, fontSize: 12.0.sp),
                                                      ),
                                                      Text(
                                                        state.countModel!.fieldVisitCount.toString(),
                                                        style: TextStyle(color: Colors.white, fontSize: 18.0.sp),
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
                                    ),
                                    const Expanded(flex: 1, child: SizedBox.shrink()),
                                    Expanded(
                                      flex: 10,
                                      child: GestureDetector(
                                        onTap: () async {
                                          final connectivityResult = await (Connectivity().checkConnectivity());
                                          if (connectivityResult.contains(ConnectivityResult.mobile) ||
                                              connectivityResult.contains(ConnectivityResult.wifi) ||
                                              connectivityResult.contains(ConnectivityResult.ethernet)) {
                                            await Navigator.of(context).pushNamed(AACO_Info.pageName);
                                          } else {
                                            AllService().internetCheckDialog(context);
                                          }
                                        },
                                        child: Container(
                                          // width: 190,
                                          height: 70,
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
                                                        style: TextStyle(color: Colors.white, fontSize: 12.0.sp),
                                                      ),
                                                      Text(
                                                        state.countModel!.accoInfoCount.toString(),
                                                        style: TextStyle(color: Colors.white, fontSize: 18.0.sp),
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
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }
                          return Container();
                        }),

                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 10,
                          child: GestureDetector(
                            onTap: () async {
                              final connectivityResult = await (Connectivity().checkConnectivity());
                              if (connectivityResult.contains(ConnectivityResult.wifi) || connectivityResult.contains(ConnectivityResult.mobile)) {
                                print("internet on");
                                await Navigator.of(context).pushNamed(TrainingDataPage.pageName);
                              } else {
                                AllService().internetCheckDialog(context);
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              // width: 190,
                              height: 70,
                              color: Color(0xFF00A651),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 8,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 5.0.w),
                                      child: Text(
                                        "Training Report",
                                        style: TextStyle(color: Colors.white, fontSize: 12.0.sp),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10.w, top: 10.0.h),
                                      child: Image.asset(
                                        'assets/icons/5317268-200.png',
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
                          child: GestureDetector(
                            onTap: () async {
                              final connectivityResult = await (Connectivity().checkConnectivity());
                              if (connectivityResult.contains(ConnectivityResult.mobile) ||
                                  connectivityResult.contains(ConnectivityResult.wifi) ||
                                  connectivityResult.contains(ConnectivityResult.ethernet)) {
                                getSettingApi();
                                await Navigator.of(context).pushNamed(NewFieldVisit.pageName).then((value) {
                                  countBloc.add(AllCountInitialEvent());
                                });
                              } else {
                                await Navigator.of(context).pushNamed(NewFieldVisit.pageName).then((value) {
                                });
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              // width: 190,
                              height: 70,
                              color: Color(0xFF00A651),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 8,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 5.0.w),
                                      child: Text(
                                        "Field Visit Report",
                                        style: TextStyle(color: Colors.white, fontSize: 12.0.sp),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10.w, top: 10.0.h),
                                      child: Image.asset(
                                        'assets/icons/3860158-200.png',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "My Visits",
                              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.orange
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text("DM"),
                                SizedBox(width: 10),
                                Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.purple
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text("UC"),
                              ],
                            )
                          ],
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      flex: 5,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  backgroundSync() async {
    var token = await prefs.getString('token');
    locationFetchedOnLogin(token: token);
    fieldVisitSubmitTask();
    changeFieldVisitLocationOnce();
    fetchOtherOffice();
    clearDataInBg();
    getSettingApi();
    countBloc.add(AllCountInitialEvent());

    //await ConnectivityProvider().fieldSubmitAutoSync();
    //await ConnectivityProvider().changeLocationAutoSync(context: context);
   // countBloc.add(AllCountInitialEvent());
  }

  getSettingApi() async {
    final distance = await Repositores().settingApi();
    if (distance != '') {
      Helper().allSettingCashed(distance: distance);
    } else {
      return;
    }
  }

  foregroundSync() async {
    await ConnectivityProvider().fieldSubmitAutoSync();
    await ConnectivityProvider().changeLocationAutoSync();
    //clearLocaladdNewLocData();
    //clearLocalFvData();
  }

  // clearLocaladdNewLocData() {
  //   prefs.reload();
  //   List<Map<String, dynamic>> localFldData = [];
  //   final localFieldVisitData = prefs.getStringList(addNewLocSubmitKey);
  //   if (localFieldVisitData != null) {
  //     localFieldVisitData.forEach((element) {
  //       localFldData.add(jsonDecode(element));
  //     });
  //     final syncedData = localFldData.where((e) => e['sync'] == '1').toList();
  //     log('local syncedData ${syncedData.length}');
  //     List<String> aprocessedData = [];
  //     // if (cart == null) cart = [];
  //     if (syncedData.isNotEmpty) {
  //       syncedData.forEach((element) {
  //         aprocessedData.add(jsonEncode(element));
  //       });
  //       prefs.setStringList(addNewLocSubmitKey, aprocessedData);
  //     }
  //   }
  // }

  // clearLocalFvData() {
  //   List<String> fvprocessedData = [];
  //   List<Map<String, dynamic>> localFldData = [];
  //   final localFieldVisitData = prefs.getStringList(fieldVisitSubmitKey);
  //   if (localFieldVisitData != null) {
  //     localFieldVisitData.forEach((element) {
  //       localFldData.add(jsonDecode(element));
  //     });
  //     final syncedData = localFldData.where((e) => e['sync'] == '1').toList();
  //     log('local syncedData ${syncedData.length}');
  //     if (syncedData.isNotEmpty) {
  //       syncedData.forEach((element) {
  //         fvprocessedData.add(jsonEncode(element));
  //       });
  //       prefs.setStringList(fieldVisitSubmitKey, fvprocessedData);
  //     }
  //   }
  // }

}
