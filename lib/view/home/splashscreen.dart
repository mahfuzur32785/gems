import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:village_court_gems/controller/Local_store_controller/local_store.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/area_model/office_type_model.dart';
import 'package:village_court_gems/models/footprint_model.dart';
import 'package:village_court_gems/models/locationModel.dart';
import 'package:village_court_gems/provider/connectivity_provider.dart';
import 'package:village_court_gems/services/backgroundService/wm_service.dart';
import 'package:village_court_gems/services/database/localDatabaseService.dart';
import 'package:village_court_gems/view/auth/login_page.dart';
import 'package:village_court_gems/view/home/homepage.dart';
import 'package:village_court_gems/util/custom_image.dart';
import 'package:village_court_gems/view/home/public_page.dart';

class SPScreen extends StatefulWidget {
  static const pageName = 'sp';
  const SPScreen({super.key});

  @override
  State<SPScreen> createState() => _SPScreenState();
}

class _SPScreenState extends State<SPScreen> {
  // Future<void> storeLocationBg() async {
  //   LocalStore local = LocalStore();
  //   RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
  //   var locationData = await compute(backgroundLocationFetch, rootIsolateToken);
  //   if (locationData != null) {
  //     local.storeAllLocationDataToLocal(locationData.data!);
  //   } else {
  //     return;
  //   }
  // }

  // Future<void> storeAllLocation() async {
  //   LocalStore local = LocalStore();

  //   //final cp = Provider.of<ConnectivityProvider>(context, listen: false);
  //   //if (cp.isConnected) {
  //   final checkNetwork = await ConnectivityProvider().rcheckInternetConnection();
  //   if (checkNetwork) {
  //     //local.allLocationBox.clear();
  //     final locationsData = await Repositores().allLocation();
  //     if (locationsData != null) {
  //       Helper().allLocationDataInsert(allLocationData: locationsData.data!);
  //       //  local.storeAllLocationDataToLocal(locationsData.data!);
  //     //  var alllist = local.allLocationBox.values.toList();
  //       debugPrint('All location Stored in local');
  //     } else {
  //       return;
  //     }
  //   }

  //   print('local data clear ${local.allLocationBox.length}');

  //   // } else {
  //   //   // AllService().tost('No Network Connection');
  //   // }
  // }

  // 01614863299
  Future<void> allLocation() async {
    // List<Division> storeDivisionData = await Helper().getDivisionData();
    // List<District> storeDistrictData = await Helper().getDistrictData();
    // List<Upazila> storeUpazilaData = await Helper().getUpazilaData();
    // List<Union> storeUnionData = await Helper().getUnionData();
    List<OfficeTypeData> OfficeTypeDataList = await Helper().getOfficeTypeData();
    //await storeLocationBg();
    //await storeAllLocation();

    final token = await Helper().getUserToken();
    if (token != null) {
      if(Platform.isIOS){
        iosperiodicLocationFetch();
      }else{
        periodicallLocationFetch();
      }

      fetchOtherOffice();
    }

    if (OfficeTypeDataList.isEmpty) {
      final officeTypeData = await Repositores().getOfficeTypeApi();
      if (officeTypeData?.data != null) {
        Helper().officeTypeDataInsert(officeTypeData!.data!);
      } else {
        Helper().officeTypeDataInsert([]);
      }
    }

    Future.delayed(Duration(seconds: 2), () async {
      if (token == null) {
        // await Navigator.of(context).push(MaterialPageRoute(builder: (context) => PublicPage()));
        // Platform.isIOS
        //     ? await Navigator.of(context).push(MaterialPageRoute(builder: (context) => PublicPage()))
        //     : Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
        
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginPage()));

      } else {
        await Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Homepage()), (Route<dynamic> route) => false);
      }

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 15.0.w, right: 15.0.w),
          child: Column(
            children: [
              SizedBox(
                height: 120.0.h,
              ),
              SizedBox(height: 80, child: Image.asset("assets/icons/logo.png")),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 35, right: 20),
                child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      "GPS Based E-Monitoring System (GEMS)\nfor \nActivating Village Courts in Bangladesh\n(Phase III) Project",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ),
              SizedBox(
                height: 20.0.h,
              ),
              CustomImage(
                path: 'assets/icons/Rectangle 1.png',
                //  width: 30,
                height: 200,
              ),
              SizedBox(
                height: 20.0.h,
              ),
              CircularProgressIndicator(
                color: Colors.green,
              ),
              SizedBox(
                height: 20.0.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      "Design & Developed By:",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Image.asset(
                    'assets/icons/Dream71_logo 1 1.png',
                    height: 20,
                    //  width: 30,
                  ),
                ],
              ),
              SizedBox(
                height: 30.0.h,
              ),
              SizedBox(
                height: 30.0.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
