import 'dart:convert';
import 'dart:developer';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:village_court_gems/main.dart';
import 'package:village_court_gems/provider/connectivity_provider.dart';
import 'package:village_court_gems/util/constant.dart';
import 'package:village_court_gems/widget/custom_appbar.dart';

class OfflineSyncPage extends StatefulWidget {
  final bool isOfflineView;
  const OfflineSyncPage({super.key, this.isOfflineView = false});

  @override
  State<OfflineSyncPage> createState() => _OfflineSyncPageState();
}

class _OfflineSyncPageState extends State<OfflineSyncPage> {
  List<Map<String, dynamic>> localFieldVisitDataList = [];
  bool isSyncing = false;
  //final SharedPreferencesAsync prefs = SharedPreferencesAsync();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    foregroundSync();
    getData();
  }

  getData() async {
    List<Map<String, dynamic>> localFldData = [];
    List<Map<String, dynamic>> localaddChngData = [];
    List<Map<String, dynamic>> syncedFvData = [];
    List<Map<String, dynamic>> syncedaddChngFvData = [];

    //prefs.reload();
    final localFieldVisitData = await prefs.getStringList(fieldVisitSubmitKey);
    final addchngData = await prefs.getStringList(addNewLocSubmitKey);

    if (localFieldVisitData != null) {
      localFieldVisitData.forEach((element) {
        localFldData.add(jsonDecode(element));
      });
      syncedFvData = localFldData.where((e) => e['sync'] == '0' || e['sync'] == '400' || e['sync'] == '422').toList();
      // setState(() {
      //   localFieldVisitDataList = syncedFvData;
      // });
      log('local 1 syncedData ${syncedFvData.length}');
    }
    if (addchngData != null) {
      addchngData.forEach((element) {
        localaddChngData.add(jsonDecode(element));
      });
      syncedaddChngFvData = localaddChngData.where((e) => e['sync'] == '0').toList();
      //setState(() {
      //  localFieldVisitDataList = syncedFvData;
      //});
      log('local 2 syncedData ${syncedaddChngFvData.length}');
    }
    localFieldVisitDataList = syncedaddChngFvData + syncedFvData;
    setState(() {});
  }

  foregroundSync() async {
    if (widget.isOfflineView) {
      return;
    } else {
      setState(() {
        isSyncing = true;
      });
      //await Future.delayed(Duration(seconds: 3), () {});
      await ConnectivityProvider().fieldSubmitAutoSync();
      await ConnectivityProvider().changeLocationAutoSync();

      ConnectivityProvider().clearLocaladdNewLocData();
      ConnectivityProvider().clearLocalFvData();
      await getData();
      setState(() {
        isSyncing = false;
      });
    }

    //clearLocaladdNewLocData();
    //clearLocalFvData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: 'Sync Your Data'
          //backgroundColor: Colors.green,
          //iconTheme: IconThemeData(color: Colors.white),
          ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            localFieldVisitDataList.isEmpty
                ? Expanded(child: Center(child: Text('No Data to sync')))
                : Expanded(
                    child: ListView.builder(
                      itemCount: localFieldVisitDataList.length,
                      itemBuilder: (context, index) {
                        var item = localFieldVisitDataList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4),
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                            color: (Colors.white),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${item['office_type']}',
                                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                                      ),
                                      item['office_title'].toString().isEmpty
                                          ? SizedBox.shrink()
                                          : Text(
                                              '${item['office_title']}',
                                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                                            ),
                                      // Row(
                                      //   children: [
                                      //     Text('${item['Division']}'),
                                      //      Text('${item['District']}'),
                                      //       Text('${item['Upazilla']}')
                                      //   ],
                                      // ),
                                      Row(
                                        children: [
                                          Text(
                                            'Created at :',
                                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                          ),
                                          Text('${item['datetime']}')
                                        ],
                                      )
                                    ],
                                  ),
                                  Text('Not Synced'),
                                ],
                              ),
                            ),
                            // child: ListTile(
                            //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                            //   subtitle: Text('${item['datetime']}'),
                            //   title: Text('${item['office_type']}'),
                            //   trailing: Text('Not Synced'),
                            // ),
                          ),
                        );
                      },
                    ),
                  ),
            isSyncing
                ? Container(
                    height: 60,
                    width: double.infinity,
                    color: Colors.green,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Data is Syncing...',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 17),
                        )
                      ],
                    ),
                  )
                : SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}


Future<List<Map<String, dynamic>>> getlocalData()async{
  
    List<Map<String, dynamic>> localFldData = [];
    List<Map<String, dynamic>> localaddChngData = [];
    List<Map<String, dynamic>> syncedFvData = [];
    List<Map<String, dynamic>> syncedaddChngFvData = [];

    //prefs.reload();
    final localFieldVisitData = await prefs.getStringList(fieldVisitSubmitKey);
    final addchngData = await prefs.getStringList(addNewLocSubmitKey);
    if (localFieldVisitData != null) {
      localFieldVisitData.forEach((element) {
        localFldData.add(jsonDecode(element));
      });
      syncedFvData = localFldData.where((e) => e['sync'] == '0' || e['sync'] == '400' || e['sync'] == '422').toList();
      // setState(() {
      //   localFieldVisitDataList = syncedFvData;
      // });
      log('local syncedData ${syncedFvData.length}');
    }
    if (addchngData != null) {
      addchngData.forEach((element) {
        localaddChngData.add(jsonDecode(element));
      });
      syncedaddChngFvData = localaddChngData.where((e) => e['sync'] == '0').toList();
      //setState(() {
      //  localFieldVisitDataList = syncedFvData;
      //});
      log('local syncedData ${syncedFvData.length}');
    }
    
     var localFieldVisitDataList = syncedaddChngFvData + syncedFvData;
    print("localData length ${localFieldVisitDataList.length}");
    return localFieldVisitDataList;
  
}
