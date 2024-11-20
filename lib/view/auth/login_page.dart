import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:village_court_gems/controller/global.dart';
import 'package:village_court_gems/controller/repository/repository.dart';
import 'package:village_court_gems/models/area_model/office_type_model.dart';
import 'package:village_court_gems/services/all_services/all_services.dart';
import 'package:village_court_gems/services/backgroundService/wm_service.dart';
import 'package:village_court_gems/services/database/localDatabaseService.dart';
import 'package:village_court_gems/util/colors.dart';

import 'package:village_court_gems/view/home/homepage.dart';
class LoginPage extends StatefulWidget {
  static const pageName = 'login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  var phoneController =
      TextEditingController(text: ""); //01794139939
  var passwordController =
      TextEditingController(text: ""); //1234567890

  bool _isLoading = false;
  bool isCheckbox = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 15.0.w, right: 15.0.w),
          child: Column(
            children: [
              SizedBox(height: 100.h),
              SizedBox(height: 80, child: Image.asset("assets/icons/logo.png")),
              SizedBox(height: 10),
              const Text(
                "GPS Based E-Monitoring System (GEMS)\nfor\nActivating Village Courts in Bangladesh\n(Phase III) Project",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 50.h),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                          helperText: '',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1, color: Colors.black),
                          ),
                          hintText: "Phone Number"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter phone';
                        }
                        if (value.length <= 10) {
                          return 'Please enter a valid phone';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 10),
                    TextFormField(
                      obscureText: _obscureText,
                      controller: passwordController,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        prefixIcon: Icon(Icons.lock),
                        hintText: "Password",
                        border: OutlineInputBorder(),
                        suffixIcon: _obscureText
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureText = false;
                                  });
                                },
                                icon: const Icon(
                                  Icons.visibility_off,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                              )
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureText = true;
                                  });
                                },
                                icon: const Icon(
                                  Icons.remove_red_eye,
                                  size: 20,
                                  color: Colors.black,
                                ),
                              ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Checkbox(
                          value: isCheckbox,
                          onChanged: (bool? newValue) {
                            setState(() {
                              isCheckbox = newValue!;
                            });
                          },
                        ),

                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Remember me",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 4, 58, 53),
                              ),
                            ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 30),
              _isLoading
                  ? AllService.LoadingToast()
                  : Center(
                      child: SizedBox(
                        height: 40.h,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              backgroundColor: MyColors.secondaryColor,
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final connectivityResult =
                                    await (Connectivity().checkConnectivity());
                                if (connectivityResult
                                        .contains(ConnectivityResult.mobile) ||
                                    connectivityResult
                                        .contains(ConnectivityResult.wifi) ||
                                    connectivityResult.contains(
                                        ConnectivityResult.ethernet)) {
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  Map login_api = await Repositores().loginAPi(
                                      phoneController.text,
                                      passwordController.text);

                                  if (login_api['message'].toString() ==
                                      "OTP Verification") {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    return _showModalBottomSheet(context);
                                  }
                                  if (login_api['message'].toString() ==
                                      'Login Successfully') {
                                    print("login success");
                                    print("internet on");
                                    g_Token = login_api['data']['access_token'];
                                    await Helper().userToken(login_api['data']
                                            ['access_token']
                                        .toString());
                                    locationFetchedOnLogin(token: g_Token);
                                    //periodicCallLocationFetch();
                                    fetchOtherOffice();
                                    List<OfficeTypeData> OfficeTypeDataList =
                                        await Helper().getOfficeTypeData();
                                    if (OfficeTypeDataList.isEmpty) {
                                      final officeTypeData = await Repositores()
                                          .getOfficeTypeApi();
                                      if (officeTypeData?.data != null) {
                                        Helper().officeTypeDataInsert(
                                            officeTypeData!.data!);
                                      } else {
                                        Helper().officeTypeDataInsert([]);
                                      }
                                    }

                                    await Navigator.of(context)
                                        .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Homepage()),
                                            (Route<dynamic> route) => false);
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  } else {
                                    await QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.error,
                                      text: login_api['message'],
                                    );
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                } else {
                                  AllService().internetCheckDialog(context);
                                }
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                      ),
                    ),
              SizedBox(height: 30.0.h),
              Text(
                "Forgot Password?",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0.r),
                topRight: Radius.circular(25.0.r),
              ),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0.h,
                    ),
                    Text(
                      "Email Verification",
                      style:
                          TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    const Text(
                      "6 Digit OTP Code has been sent to\nYour Mobile No.",
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15.0.w, right: 15.0.w),
                      child: Pinput(
                        // defaultPinTheme: defaultPinTheme,
                        // focusedPinTheme: focusedPinTheme,
                        // submittedPinTheme: submittedPinTheme,
                        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                        showCursor: true,
                        length: 6,
                        autofillHints: const [AutofillHints.oneTimeCode],
                        onCompleted: (pin) async{
                          print("Completed: " + pin);
                          Map otp = await Repositores().otp_Verification(pin);
                          if (otp['message'].toString() ==
                              'OTP successfully Verified') {
                            g_Token = otp['data']['access_token'];
                            await Helper()
                                .userToken(otp['data']['access_token'].toString());

                            await QuickAlert.show(
                              context: context,
                              type: QuickAlertType.success,
                              text: "Account login Successful!",
                            );
                            await Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => Homepage()),
                                    (Route<dynamic> route) => false);
                          } else {
                            await QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              text: "OTP Credential Wrong",
                            );
                          }
                        },
                      ),
                      // child: OtpTextField(
                      //   numberOfFields: 6,
                      //   fieldWidth: 40,
                      //   showFieldAsBox: true,
                      //   borderColor: Colors.black,
                      //   onSubmit: (pin) async {
                      //     print("Completed: " + pin);
                      //     Map otp = await Repositores().otp_Verification(pin);
                      //     if (otp['message'].toString() ==
                      //         'OTP successfully Verified') {
                      //       g_Token = otp['data']['access_token'];
                      //       await Helper()
                      //           .userToken(otp['data']['access_token'].toString());
                      //
                      //       await QuickAlert.show(
                      //         context: context,
                      //         type: QuickAlertType.success,
                      //         text: "Account login Successful!",
                      //       );
                      //       await Navigator.of(context).pushAndRemoveUntil(
                      //           MaterialPageRoute(builder: (context) => Homepage()),
                      //           (Route<dynamic> route) => false);
                      //     } else {
                      //       await QuickAlert.show(
                      //         context: context,
                      //         type: QuickAlertType.error,
                      //         text: "OTP Credential Wrong",
                      //       );
                      //     }
                      //   },
                      // ),
                    ),
                    // SizedBox(
                    //   height: 10.h,
                    // ),
                    // SizedBox(
                    //   width: 330.w,
                    //   height: 50.h,
                    //   child: ElevatedButton(
                    //       style: ElevatedButton.styleFrom(
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(7.0.r),
                    //         ),
                    //         backgroundColor: Color(0xFF00A651),
                    //       ),
                    //       onPressed: () {
                    //         Navigator.of(context).pushNamed(Homepage.pageName);
                    //       },
                    //       child: const Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Text(
                    //             "Verify",
                    //             style: TextStyle(
                    //                 color: Colors.white,
                    //                 fontWeight: FontWeight.bold),
                    //           ),
                    //         ],
                    //       )),
                    // ),
                    ///
                    SizedBox(
                      height: 30.0.h,
                    ),
                  ],
                ),
                Positioned(top: 10,right: 10,child: GestureDetector(onTap:() {
                  Navigator.pop(context);
                },child: Icon(Icons.close)))
              ],
            ),
          ),
        );
      },
    );
  }
}
