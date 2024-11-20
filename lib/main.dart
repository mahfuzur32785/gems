import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:village_court_gems/bloc/Connectivity_bloc/connectivity_bloc_bloc.dart';
import 'package:village_court_gems/bloc/Connectivity_bloc/new_connectivity_cubit.dart';
import 'package:village_court_gems/controller/Local_store_controller/local_store.dart';
import 'package:village_court_gems/models/Local_store_model/field_submit_local.dart';
import 'package:village_court_gems/models/Local_store_model/local_image_model.dart';
import 'package:village_court_gems/models/Local_store_model/save_field_visit_model.dart';
import 'package:village_court_gems/models/area_model/all_location_data.dart';
import 'package:village_court_gems/services/backgroundService/wm_service.dart';
import 'package:village_court_gems/services/route/page_route.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workmanager/workmanager.dart';

late final SharedPreferencesAsync prefs;
late LocalStore localStore;
 
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  prefs =  SharedPreferencesAsync();
  Workmanager().initialize(callBackDispacher,isInDebugMode: false);
  await Hive.initFlutter();
  Hive.registerAdapter(AllLocationDataAdapter());
  Hive.registerAdapter(LocalImageModelAdapter());
  Hive.registerAdapter(SaveLocalFieldModelAdapter());
  Hive.registerAdapter(FieldSubmitLocalAdapter());
  await Hive.openBox<AllLocationData>('alllocation');
  await Hive.openBox<LocalImageModel>('locfldimg');
  await Hive.openBox<SaveLocalFieldModel>('savelocfield');
  await Hive.openBox<FieldSubmitLocal>('fieldsubmit');
 
  await EasyLocalization.ensureInitialized();
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  //await initializeService('Test BG');
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('bn'), Locale('es')],
      path: 'assets/language',
      saveLocale: false,
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      //child: MyApp(),
      child: MultiBlocProvider(providers: [
        BlocProvider(create: (context) => ConnectivityCubit(Connectivity()),)

      ], child:  MyApp()),
      // child: BlocProvider(
      //     create: (context) => ConnectivityBloc()
      //       ..add(
      //         ConnectivityObserve(),
      //       ),
      //     child: MyApp()),
      // child: MultiProvider(
      //   // providers: [
      //   //   ChangeNotifierProvider(create: (context) => ConnectivityProvider()),
      //   // ],
      //   child: MyApp(),
      // ),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  // networkChange() async {
  //   final cp = Provider.of<ConnectivityProvider>(context, listen: false);
  //   cp.networkChange(context: context);
  // }

  @override
  void initState() {
    localStore = LocalStore();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
   // _connectivitySubscription= Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    //networkChange();
    // localStore.networkChange();
    //LocalStore().networkChange();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
   // _connectivitySubscription.cancel();
    // LocalStore().connectivitySubscription.cancel();
    super.dispose();
  }
  // Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
  //   setState(() {
  //     connectionStatus = result;
  //   });
  //   // ignore: avoid_print
  //   print('Connectivity changed: $connectionStatus');
  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.hidden:
        print('App Life cycle is Hidden');
        break;
      case AppLifecycleState.resumed:
        print("app in resumed");
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    //networkChange();
    return ScreenUtilInit(
        designSize: const Size(360, 700),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: MaterialApp(
                navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                 // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                  useMaterial3: true,
                ),
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                routes: pageRoute(context)),
          );
        });
  }
}
