import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/services/storage_service.dart';
import 'package:mystory_flutter/services/util_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:mystory_flutter/widgets/android_button.dart';
import 'package:mystory_flutter/widgets/column_scroll_view.dart';
import 'package:mystory_flutter/widgets/ios_button.dart';
import 'package:mystory_flutter/widgets/web_view_screen.dart';
import 'package:provider/provider.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _sel = false;
  bool _showPassword = false;
  bool _confrmPassword = false;
  var isLoadingProgress = false;
  var navigationService = locator<NavigationService>();
  UtilService? utilService = locator<UtilService>();

  @override
  // ignore: override_on_non_overriding_member
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  TextEditingController dateFromController = TextEditingController();
  DateTime? selectedFromDate = DateTime.now();

  String getInitials(String name) => name.isNotEmpty
      ? name.trim().split(' ').map((l) => l[0]).take(1).join()
      : '';

  Future<Null> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: Theme.of(context).primaryColor,
                onSurface: Colors.black,
              ),
              buttonTheme: ButtonThemeData(
                colorScheme: ColorScheme.light(
                  primary: Theme.of(context).primaryColor,
                ),
              ),
            ),
            child: child!,
          );
        },
        context: context,
        initialDate: selectedFromDate!,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(1920),
        lastDate: DateTime.now());
    if (picked != null)
      setState(() {
        selectedFromDate = picked;
        dateFromController.text = DateFormat.yMMMMd().format(selectedFromDate!);
      });
  }

  String validateemail(String? value) {
    RegExp regex = new RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (!regex.hasMatch(value!))
      return 'Enter valid email';
    else
      return '';
  }

  Widget build(BuildContext context) {
    return RelativeBuilder(
      builder: (context, height, width, sy, sx) {
        return WillPopScope(
            onWillPop: () => navigationService
                .navigateTo(LoginScreenRoute)
                .then((value) => value as bool),
            child: AbsorbPointer(
              absorbing: isLoadingProgress,
              child: Stack(children: [
                Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 25.h,
                      ),
                      onPressed: () {
                        navigationService.navigateTo(LoginScreenRoute);
                      },
                    ),
                  ),
                  body: ColumnScrollView(
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: 5.w,
                            right: 5.w,
                            top: 10.h,
                            bottom: 30.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 13.0),
                                child: Text(
                                  "Sign up",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: sy(20),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: sy(10),
                              ),
                              Form(
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 14.0, right: 12.0),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        width: sx(500),
                                        child: TextFormField(
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          controller: emailController,
                                          validator: validateemail,
                                          autocorrect: true,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              horizontal: 3.0.w,
                                              vertical: 14.0.h,
                                              // horizontal: 20,
                                            ),
                                            hintText: 'Your Email',
                                            hintStyle: TextStyle(
                                              color: Color.fromRGBO(
                                                  117, 124, 142, 1),
                                              fontSize: sy(11),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .indicatorColor),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: sy(10),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: sx(215),
                                            child: TextFormField(
                                              controller: firstNameController,
                                              autocorrect: true,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                  horizontal: 3.0.w,
                                                  vertical: 14.0.h,
                                                  // horizontal: 20,
                                                ),
                                                hintText: 'First Name',
                                                hintStyle: TextStyle(
                                                  color: Color.fromRGBO(
                                                      117, 124, 142, 1),
                                                  fontSize: sy(11),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white,
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .indicatorColor),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: sy(20),
                                          ),
                                          Container(
                                            width: sx(220),
                                            child: TextFormField(
                                              controller: lastNameController,
                                              autocorrect: true,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                  horizontal: 3.0.w,
                                                  vertical: 14.0.h,
                                                  // horizontal: 20,
                                                ),
                                                hintText: 'Last Name',
                                                hintStyle: TextStyle(
                                                  color: Color.fromRGBO(
                                                      117, 124, 142, 1),
                                                  fontSize: sy(11),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white,
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .indicatorColor),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: sy(10),
                                      ),
                                      Container(
                                        child: TextFormField(
                                          readOnly: true,
                                          onTap: () {
                                            _selectFromDate(context);
                                          },
                                          style: TextStyle(
                                            fontSize: sy(11),
                                            color: Colors.grey,
                                          ),
                                          controller: dateFromController,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              horizontal: 3.0.w,
                                              vertical: 14.0.h,
                                              // horizontal: 20,
                                            ),
                                            hintText: 'Date of Birth',
                                            hintStyle: TextStyle(
                                              color: Color.fromRGBO(
                                                  117, 124, 142, 1),
                                              fontSize: sy(11),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .indicatorColor),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: sy(10),
                                      ),
                                      Container(
                                        width: sx(500),
                                        child: TextFormField(
                                          keyboardType: TextInputType.text,
                                          controller: passController,
                                          obscureText: !_showPassword,
                                          autocorrect: true,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            suffixIcon: _showPassword
                                                ? IconButton(
                                                    padding: EdgeInsets.only(
                                                        right: 0),
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
                                                    padding: EdgeInsets.only(
                                                        right: 0),
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
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              horizontal: 3.0.w,
                                              vertical: 14.0.h,
                                              // horizontal: 20,
                                            ),
                                            hintText: 'Password',
                                            hintStyle: TextStyle(
                                              color: Color.fromRGBO(
                                                  117, 124, 142, 1),
                                              fontSize: sy(11),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .indicatorColor,
                                              ),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: sy(10),
                                      ),
                                      Container(
                                        width: sx(500),
                                        child: TextFormField(
                                          keyboardType: TextInputType.text,
                                          controller: confirmPasswordController,
                                          obscureText: !_confrmPassword,
                                          autocorrect: true,
                                          textInputAction: TextInputAction.next,
                                          decoration: InputDecoration(
                                            suffixIcon: _confrmPassword
                                                ? IconButton(
                                                    padding: EdgeInsets.only(
                                                        right: 0),
                                                    icon: Icon(
                                                      Icons.visibility,
                                                      size: sy(12),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        _confrmPassword = false;
                                                      });
                                                    },
                                                  )
                                                : IconButton(
                                                    padding: EdgeInsets.only(
                                                        right: 0),
                                                    icon: Icon(
                                                      Icons.visibility_off,
                                                      size: sy(14),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        _confrmPassword = true;
                                                      });
                                                    },
                                                  ),
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              horizontal: 3.0.w,
                                              vertical: 14.0.h,
                                              // horizontal: 20,
                                            ),
                                            hintText: 'Confirm Password',
                                            hintStyle: TextStyle(
                                              color: Color.fromRGBO(
                                                  117, 124, 142, 1),
                                              fontSize: sy(11),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .indicatorColor),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: sy(5),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Theme(
                                    data: ThemeData(),
                                    child: Checkbox(
                                      side: BorderSide(
                                          width: 1, color: Colors.grey),
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                      value: _sel,
                                      onChanged: (bool? resp) async {
                                        setState(() {
                                          _sel = resp!;
                                        });
                                        await Provider.of<AuthProviderr>(context,
                                                listen: false)
                                            .setIsRemeber(resp!);
                                      },
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(top: 5),
                                      width: 250.w,
                                      child: RichText(
                                        text: TextSpan(
                                          text:
                                              'By Signing up you agree to our  ',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          children: [
                                            TextSpan(
                                                text: 'Terms of Use',
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (builder) =>
                                                                    WebViewScreen(
                                                                        url:
                                                                            "https://www.termsfeed.com/live/b79d3d1b-8187-40e9-ae1f-3891892a0314")));
                                                      },
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.orange)),
                                            TextSpan(
                                              text: ' and',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            TextSpan(
                                              text: ' Privacy Policy',
                                              recognizer:
                                              TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (builder) =>
                                                              WebViewScreen(
                                                                  url:
                                                                  "https://www.termsfeed.com/live/d3af7fa2-2ef0-4487-b5d7-c37196a4006e")));
                                                },
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.orange),
                                            ),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: sy(15),
                              ),
                              Center(
                                child: Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.065,
                                  width:
                                      MediaQuery.of(context).size.width * 0.90,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color.fromRGBO(
                                                227, 230, 250, 1),
                                            spreadRadius: -4,
                                            blurRadius: 7,
                                            offset: Offset(6, 19))
                                      ]),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.065,
                                    width: MediaQuery.of(context).size.width *
                                        0.90,
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
                                        if (firstNameController.text == "" ||
                                            lastNameController.text == "" ||
                                            emailController.text == "" ||
                                            passController.text == "" ||
                                            confirmPasswordController.text ==
                                                "") {
                                          utilService!.showToast(
                                              "Please fill all fields",
                                              context);
                                        } else if (!emailController.text
                                            .contains('@')) {
                                          utilService!.showToast(
                                              "Please Enter a valid Email",
                                              context);
                                        } else if (!emailController.text
                                            .contains('@')) {
                                          utilService!.showToast(
                                              "Please Enter a valid Email",
                                              context);
                                        } else if (passController.text !=
                                            confirmPasswordController.text) {
                                          utilService!.showToast(
                                              "Password not match", context);
                                        } else if (_sel == false) {
                                          utilService!.showToast(
                                              "Kindly agree to our Terms of Conditions and Privacy Policy",
                                              context);
                                          //  "Please mark the checkbox of Trems of Use and Privacy Policy");
                                        } else if (passController.text.length <
                                            8) {
                                          utilService!.showToast(
                                              ' Password must be of 8 characters',
                                              context);
                                        } else {
                                          setState(() {
                                            isLoadingProgress = true;
                                          });

                                          try {
                                            // String searchKey = getInitials(
                                            //     firstNameController.text);
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                            await Provider.of<AuthProviderr>(
                                                    context,
                                                    listen: false)
                                                .createUserWithEmailPassword(
                                              context: context,
                                              email: emailController.text,
                                              password: passController.text,
                                              firstName:
                                                  firstNameController.text,
                                              lastName: lastNameController.text,
                                              date: dateFromController.text,
                                              // searchKey: searchKey,
                                            );
                                            setState(() {
                                              isLoadingProgress = false;
                                            });
                                          } catch (e) {
                                            utilService!.showToast(
                                                e.toString(), context);
                                            setState(() {
                                              isLoadingProgress = false;
                                            });
                                          }
                                        }
                                      },
                                      style: ButtonStyle(
                                          elevation:
                                              MaterialStateProperty.resolveWith(
                                                  (states) => 0),
                                          backgroundColor:
                                              MaterialStateColor.resolveWith(
                                                  (states) =>
                                                      Colors.transparent)),
                                      child: Container(
                                          padding: EdgeInsets.only(
                                              left: 5, right: 10),
                                          child: new Text(
                                            "Sign up",
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
                                height: sy(20),
                              ),
                              // Column(
                              //   children: [
                              //     Center(
                              //       child: Text(
                              //         'Or Sign up with social account',
                              //         style: TextStyle(
                              //           color: Colors.black,
                              //           fontSize: sy(10),
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // SizedBox(
                              //   height: sy(20),
                              // ),
                              // Platform.isIOS ? IosButton() : AndroidButton(),
                              // SizedBox(
                              //   height: sy(10),
                              // ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: sy(11),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    navigationService
                                        .navigateTo(LoginScreenRoute);
                                  },
                                  child: Text(
                                    ' Log in',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: sy(11),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     GestureDetector(
                            //       onTap: () {
                            //         Navigator.push(
                            //             context,
                            //             MaterialPageRoute(
                            //                 builder: (builder) => WebViewScreen(
                            //                     url:
                            //                         "https://www.mystoryforlife.com/faq")));
                            //       },
                            //       child: Text(
                            //         "FAQ",
                            //         style: TextStyle(
                            //             color: Colors.grey.shade400,
                            //             fontSize: 14.sp),
                            //       ),
                            //     ),
                            //     SizedBox(
                            //       width: 5,
                            //     ),
                            //     Icon(
                            //       Icons.contact_support_outlined,
                            //       color: Colors.grey.shade400,
                            //       size: 18.h,
                            //     )
                            //   ],
                            // ),             // commented by chetu on 21 nov by client suggestion.
                            SizedBox(
                              height: 15.h,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (isLoadingProgress)
                  Positioned.fill(
                      child: Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  )),
              ]),
            ));
      },
    );
  }
}
