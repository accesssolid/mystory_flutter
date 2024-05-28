import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/models/appuser.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/services/util_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:provider/provider.dart';

import '../services/navigation_service.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:relative_scale/relative_scale.dart';
import '../utils/service_locator.dart';

class ResetPasswordScreen extends StatefulWidget {
  ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  var navigationService = locator<NavigationService>();
  final GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  AppUser? user;
  var utilService = locator<UtilService>();
  var isLoadingProgress = false;
  bool _showOldPassword = false;
  bool _showPassword = false;
  bool _confirmShowPassword = false;

  String validatePassword(String? value) {
    if (value!.length < 8) {
      return '     Password must be of 8 characters';
    } else
      return '';
  }

  String validateConfirmPassword(String? value) {
    if (value != passwordController.text) {
      return '     Password do not match';
    } else
      return '';
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      //BoxConstraints(
      //    maxWidth: MediaQuery.of(context).size.width,
      //    maxHeight: MediaQuery.of(context).size.height),
      designSize: Size(360, 690),
      //orientation: Orientation.portrait
    );
    return RelativeBuilder(builder: (context, height, width, sy, sx) {
      return Stack(children: [
        Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  // navigationService.navigateTo(LoginScreenRoute);
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
                color: Colors.black,
              ),
            ),
            body: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 30.w, right: 30.w),
                            child: Column(
                              children: [
                                Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(top: 50.h),
                                    child: Image(
                                      image:
                                          AssetImage('assets/images/logo.png'),
                                      height: 80.h,
                                      fit: BoxFit.fill,
                                    )),
                                SizedBox(
                                  height: 40.h,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
                                  child: Text("Reset Password",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18.sp)),
                                ),
                                SizedBox(height: 30.h),
                                Container(
                                  // padding: EdgeInsets.only(right: 50, left: 50),
                                  child: TextField(
                                    controller: oldPasswordController,
                                    textInputAction: TextInputAction.next,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                    obscureText: _showOldPassword,
                                    decoration: new InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: const BorderSide(
                                            color: Color.fromRGBO(
                                                242, 243, 245, 1),
                                            width: 0.0),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .indicatorColor),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      filled: true,
                                      hintStyle: new TextStyle(
                                          color: Colors.grey, fontSize: 12.sp),
                                      hintText: "Old Password",
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.all(15.h),
                                      suffixIcon: !_showOldPassword
                                          ? IconButton(
                                              icon: Icon(Icons.visibility_off,
                                                  size: 15.h,
                                                  color: Colors.grey),
                                              onPressed: () {
                                                setState(() {
                                                  _showOldPassword = true;
                                                });
                                              },
                                            )
                                          : IconButton(
                                              icon: Icon(Icons.visibility,
                                                  size: 15.h,
                                                  color: Colors.grey),
                                              onPressed: () {
                                                setState(() {
                                                  _showOldPassword = false;
                                                });
                                              },
                                            ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                Container(
                                  // padding: EdgeInsets.only(right: 50, left: 50),
                                  child: TextField(
                                    controller: passwordController,
                                    textInputAction: TextInputAction.next,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                    obscureText: _showPassword,
                                    decoration: new InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: const BorderSide(
                                            color: Color.fromRGBO(
                                                242, 243, 245, 1),
                                            width: 0.0),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .indicatorColor),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      filled: true,
                                      hintStyle: new TextStyle(
                                          color: Colors.grey, fontSize: 12.sp),
                                      hintText: "New Password",
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.all(15.h),
                                      suffixIcon: _showPassword
                                          ? IconButton(
                                              padding:
                                                  EdgeInsets.only(right: 0),
                                              icon: Icon(
                                                Icons.visibility,
                                                size: sy(12),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _showPassword = false;
                                                });
                                              },
                                            )
                                          : IconButton(
                                              padding:
                                                  EdgeInsets.only(right: 0),
                                              icon: Icon(
                                                Icons.visibility_off,
                                                size: sy(14),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _showPassword = true;
                                                });
                                              },
                                            ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                Container(
                                  // padding: EdgeInsets.only(right: 50, left: 50),
                                  child: TextField(
                                    controller: confirmPasswordController,
                                    textInputAction: TextInputAction.next,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                    obscureText: _confirmShowPassword,
                                    decoration: new InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: const BorderSide(
                                            color: Color.fromRGBO(
                                                242, 243, 245, 1),
                                            width: 0.0),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context)
                                                .indicatorColor),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintStyle: new TextStyle(
                                          color: Colors.grey, fontSize: 12.sp),
                                      hintText: "Confirm Password",
                                      contentPadding: EdgeInsets.all(15.h),
                                      suffixIcon: !_confirmShowPassword
                                          ? IconButton(
                                              icon: Icon(Icons.visibility_off,
                                                  size: 15.h,
                                                  color: Colors.grey),
                                              onPressed: () {
                                                setState(() {
                                                  _confirmShowPassword = true;
                                                });
                                              },
                                            )
                                          : IconButton(
                                              icon: Icon(Icons.visibility,
                                                  size: 15.h,
                                                  color: Colors.grey),
                                              onPressed: () {
                                                setState(() {
                                                  _confirmShowPassword = false;
                                                });
                                              },
                                            ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(4),
                                  child: Container(
                                    // ignore: deprecated_member_use
                                    // code change by chetu
                                    // change raisedbutton to elevatedbutton
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                      elevation: 3.0,
                                       padding: EdgeInsets.all(0.0),
                                       shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          sx(40.0),
                                        ),
                                      ),
                                      ),
                                    //  highlightElevation: 3.0,
                                      onPressed: () async {
                                        if (oldPasswordController.text == '' ||
                                            passwordController.text == '' ||
                                            confirmPasswordController.text ==
                                                '') {
                                          utilService.showToast(
                                              'Please fill all fields',context);
                                          setState(() {
                                            isLoadingProgress = false;
                                          });
                                          return;
                                        } else if (passwordController.text !=
                                            confirmPasswordController.text) {
                                          utilService.showToast(
                                              "New password and Confirm Password are not match",context);
                                        } else if (oldPasswordController.text ==
                                            passwordController.text) {
                                          utilService.showToast(
                                              "Old password and new password are same. Enter the correct new password",context);
                                        } else if (passwordController
                                                .text.length <
                                            8) {
                                          utilService.showToast(
                                              ' Password must be of 8 characters',context);
                                        } else {
                                          setState(() {
                                            isLoadingProgress = true;
                                          });
                                          await Provider.of<AuthProviderr>(
                                                  context,
                                                  listen: false)
                                              .changePassword(
                                                  context: context,
                                                  oldPassword:
                                                      oldPasswordController
                                                          .text,
                                                  newPassword:
                                                      confirmPasswordController
                                                          .text);
                                          setState(() {
                                            isLoadingProgress = false;
                                          });
                                        }
                                      },
                                      // shape: RoundedRectangleBorder(
                                      //   borderRadius: BorderRadius.circular(
                                      //     sx(40.0),
                                      //   ),
                                      // ),
                                      // padding: EdgeInsets.all(0.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: BorderRadius.circular(
                                            30.0,
                                          ),
                                        ),
                                        constraints: BoxConstraints(
                                          maxWidth: sy(
                                            300,
                                          ),
                                          minHeight: sy(
                                            40,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Reset Password",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: sy(
                                              11,
                                            ),
                                            fontWeight: FontWeight.bold,
                                            color: HexColor(
                                              '#eae3f1',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // child2
                    ],
                  ),
                ))),
        if (isLoadingProgress)
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                  // color: HexColor("#3BE6AF"),
                  ),
            ),
          ),
      ]);
    });
  }
}
