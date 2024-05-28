import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mystory_flutter/services/firebase_service.dart';
import 'package:mystory_flutter/services/util_service.dart';

import 'package:mystory_flutter/utils/routes.dart';
import 'package:relative_scale/relative_scale.dart';
import '../services/navigation_service.dart';
import '../utils/service_locator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgetPasswordScreen extends StatefulWidget {
  ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  NavigationService? _navigationService = locator<NavigationService>();
  UtilService? _util = locator<UtilService>();
  FirebaseService? _firebaseService = locator<FirebaseService>();

  var navigationService = locator<NavigationService>();
  TextEditingController emailController = TextEditingController();
  var isLoadingProgress = false;
  @override
  void initState() {
    super.initState();
    // analyticService!.setCurrentScreen('ForgetPasswordScreen');
  }

  @override
  void dispose() {
    _navigationService!.closeScreen();
    super.dispose();
  }

  // ignore: unused_field
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      //BoxConstraints(
      //    maxWidth: MediaQuery.of(context).size.width,
      //    maxHeight: MediaQuery.of(context).size.height),
      designSize: Size(360, 690),
      //orientation: Orientation.portrait
    );
    return RelativeBuilder(
      builder: (context, height, width, sy, sx) {
        return Stack(children: [
          Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  onPressed: () {
                    navigationService.navigateTo(LoginScreenRoute);
                  },
                  icon: Icon(Icons.arrow_back),
                  color: Colors.black,
                ),
              ),
              body: SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  // height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.only(left: 30.w, right: 30.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50.h,
                          ),
                          Center(
                            child: Container(
                              // height: sy(100),
                              // width: sy(100),
                              child: Image.asset(
                                'assets/images/logo.png',
                                // scale: 1,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 30.h),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              "Forgot Password",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp,
                              ),
                            ),
                          ),
                          SizedBox(height: 30.h),
                          Container(
                            width: sx(500),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              autocorrect: true,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15.0,
                                  // horizontal: 20,
                                ),
                                hintText: 'Email Address',
                                hintStyle: TextStyle(
                                  color: HexColor("#A1ACCC"),
                                  fontSize: sy(11),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).indicatorColor),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Center(
                            child: Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.065,
                              width: MediaQuery.of(context).size.width * 0.90,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color.fromRGBO(227, 230, 250, 1),
                                        spreadRadius: -4,
                                        blurRadius: 7,
                                        offset: Offset(6, 19))
                                  ]),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.065,
                                width: MediaQuery.of(context).size.width * 0.90,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    gradient: LinearGradient(
                                        colors: [
                                          Color.fromRGBO(91, 121, 229, 1),
                                          Color.fromRGBO(129, 109, 224, 1)
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: [0.0, 0.99])),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (emailController.text == "") {
                                      _util!.showToast("Email cannot be empty",context);
                                    } else if (!emailController.text
                                        .contains("@")) {
                                      _util!.showToast(
                                          "Email format is incorrect.",context);
                                    } else {
                                      setState(() {
                                        isLoadingProgress = true;
                                      });
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      await _firebaseService!
                                          .forgotPassword(emailController.text,context);
                                      setState(() {
                                        isLoadingProgress = false;
                                      });
                                    }
                                  },
                                  style: ButtonStyle(
                                    elevation:
                                        MaterialStateProperty.resolveWith(
                                            (states) => 0),
                                    backgroundColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Colors.transparent),
                                  ),
                                  child: Container(
                                      padding:
                                          EdgeInsets.only(left: 5, right: 10),
                                      child: new Text(
                                        "Recover Password",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Text(
                            "An email will be sent to your email address with further instruction",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.grey, fontSize: 16.sp),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
          if (isLoadingProgress)
            Positioned.fill(
                child: Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )),
        ]);
      },
    );
  }
}
