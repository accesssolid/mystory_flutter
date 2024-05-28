import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mystory_flutter/constant/enum.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/services/storage_service.dart';
import 'package:mystory_flutter/services/util_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:mystory_flutter/widgets/android_button.dart';
import 'package:mystory_flutter/widgets/column_scroll_view.dart';
import 'package:mystory_flutter/widgets/exit_alert_dialog.dart';
import 'package:mystory_flutter/widgets/ios_button.dart';
import 'package:mystory_flutter/widgets/web_view_screen.dart';
import 'package:provider/provider.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool _sel = false;
  bool touchId = false;
  bool? _hasBiometricSenson = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  var navigationService = locator<NavigationService>();
  var storageService = locator<StorageService>();
  var dataIsremember = false;
  LocalAuthentication authentication = LocalAuthentication();

  Future<void> _checkForBiometric() async {
    bool? hasBiometric;
    try {
      hasBiometric = await authentication.isDeviceSupported();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _hasBiometricSenson = hasBiometric;
    });
  }

  void authenticate() async {
    final canCheck = await authentication.canCheckBiometrics;

    if (canCheck) {
      List<BiometricType> availableBiometrics =
          await authentication.getAvailableBiometrics();

      if (Platform.isAndroid) {
        if (availableBiometrics.contains(BiometricType.face)) {
          // Face ID.
          // final authenticated = await authentication.authenticateWithBiometrics(
          //     localizedReason: 'Enable Face ID to sign in more easily');
          // if (authenticated) {
          //   final userStoredEmail = await storage.read(key: 'email');
          //   final userStoredPassword = await storage.read(key: 'password');

          //   _signIn(em: userStoredEmail, pw: userStoredPassword);
          // }
        } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
          // Touch ID.
        }
      }
    } else {
      print('cant check');
    }
  }

  @override
  void dispose() {
    navigationService.closeScreen();
    super.dispose();
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => ExitAlertDialog(),
    ).then((value) => value as bool);
  }

  String validateemail(String? value) {
    RegExp regex = new RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (!regex.hasMatch(value!))
      return 'Enter valid email';
    else
      return '';
  }

  String validatePassword(String? value) {
    if (value!.length < 8) {
      return 'Password must be of 8 characters';
    } else
      return "";
  }

  TextEditingController passController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool _showPassword = false;
  var isLoadingProgress = false;
  var utilService = locator<UtilService>();
  var data;

  loadData() async {
    data =
        await Provider.of<AuthProviderr>(context, listen: false).getIsRemember();
    if (data) {
      String? email = await this.storageService.getData("userEmail");
      String? password = await this.storageService.getData("password");
      passController.text = password ?? "";
      emailController.text = email ?? "";
      setState(() {
        _sel = true;
      });
    }
  }

  @override
  void initState() {
    authenticate();
    loadData();
    _checkForBiometric();

    super.initState();
  }

  callback(bool data) {
    setState(() {
      isLoadingProgress = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(
      builder: (context, height, width, sy, sx) {
        return WillPopScope(
          onWillPop: _onBackPressed,
          child: Stack(children: [
            Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                toolbarHeight: 50.h,
                backgroundColor: Colors.white,
                elevation: 0,
                // leading: IconButton(
                //   icon: Icon(
                //     Icons.arrow_back,
                //     color: Colors.black,
                //     size: 24.h,
                //   ),
                //   onPressed: () {
                //     // navigationService.navigateTo(SelectAccountScreenRoute);
                //   },
                // ),
              ),
              body: ColumnScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        left: 5.w,
                        right: 5.w,
                        //top: 5.h,
                        bottom: 0.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 12.0),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: sy(20),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: sy(20),
                          ),
                          Form(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 14.0, right: 8.0),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    width: sx(500),
                                    child: TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      controller: emailController,
                                      autocorrect: true,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 15.0,
                                          // horizontal: 20,
                                        ),
                                        hintText: 'Your Email',
                                        hintStyle: TextStyle(
                                          color:
                                              Color.fromRGBO(117, 124, 142, 1),
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
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 15.0,
                                          // horizontal: 20,
                                        ),
                                        hintText: 'Password',
                                        hintStyle: TextStyle(
                                          color:
                                              Color.fromRGBO(117, 124, 142, 1),
                                          fontSize: sy(11),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        suffixIcon: !_showPassword
                                            ? IconButton(
                                                icon: Icon(
                                                  Icons.visibility_off,
                                                  size: sy(15),
                                                  color: Colors.grey.shade400,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _showPassword = true;
                                                  });
                                                },
                                              )
                                            : IconButton(
                                                icon: Icon(
                                                  Icons.visibility,
                                                  size: sy(15),
                                                  color: Colors.grey.shade400,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _showPassword = false;
                                                  });
                                                },
                                              ),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Theme(
                                    data: ThemeData(),
                                    child: Checkbox(
                                      side: BorderSide(
                                          width: 1,
                                          color:
                                              Color.fromRGBO(117, 124, 142, 1)),
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
                                  Text(
                                    'Remember Me',
                                    style: TextStyle(
                                        color: Color.fromRGBO(117, 124, 142, 1),
                                        fontSize: sy(10),
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),

                              // ignore: deprecated_member_use
                              // code change by chetu
                              // change text button to text button
                              TextButton(
                                onPressed: () {
                                  navigationService
                                      .navigateTo(ForgetPasswordScreenRoute);
                                },
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    color: Color.fromRGBO(117, 124, 142, 1),
                                    fontSize: sy(10),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: sy(30),
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
                                    // navigationService
                                    //     .navigateTo(MaindeshboardRoute);
                                    try {
                                      setState(() {
                                        isLoadingProgress = true;
                                      });

                                      if (emailController.text == '' ||
                                          passController.text == '') {
                                        utilService.showToast(
                                            "Please fill all fields", context);
                                        setState(() {
                                          isLoadingProgress = false;
                                        });
                                        return;
                                      } else if (!emailController.text
                                              .contains("@")
                                          //     ||
                                          // !emailController.text
                                          //     .contains(".com")
                                          ) {
                                        utilService.showToast(
                                            "Invalid email", context);

                                        setState(() {
                                          isLoadingProgress = false;
                                        });
                                        return;
                                      } else {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        print("SDF SDF SDF SDF SDF === SDF SDF ");
                                        await Provider.of<AuthProviderr>(context,
                                                listen: false)
                                            .signinWithEmailAndPassword(
                                                context: context,
                                                email: emailController.text,
                                                password: passController.text);

                                        setState(() {
                                          isLoadingProgress = false;
                                        });
                                      }
                                      return;
                                    } catch (er) {
                                      setState(() {
                                        isLoadingProgress = false;
                                      });
                                      print(er.toString());
                                      // utilService!.showToast(er.toString());
                                    }
                                  },
                                  style: ButtonStyle(
                                      elevation:
                                          MaterialStateProperty.resolveWith(
                                              (states) => 0),
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Colors.transparent)),
                                  child: Container(
                                      padding:
                                          EdgeInsets.only(left: 5, right: 10),
                                      child: new Text(
                                        "Login",
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
                          // SizedBox(
                          //   height: sy(20),
                          // ),

                          // Column(
                          //   children: [
                          //     Center(
                          //       child: Text(
                          //         'Or sign in with social account',
                          //         style: TextStyle(
                          //             color: Color.fromRGBO(37, 36, 41, 1),
                          //             fontSize: sy(10),
                          //             fontWeight: FontWeight.w400),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(
                          //   height: sy(20),
                          // ),
                          // Platform.isIOS
                          //     ? IosButton()
                          //     : AndroidButton(
                          //         callback: callback,
                          //       ),
                          // SizedBox(
                          //   height: sy(20),
                          // ),   //  commented by chetu

                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //   children: [
                          //     if (Platform.isAndroid)
                          //       Column(
                          //         children: [
                          //           GestureDetector(
                          //             onTap: () async {
                          //               if(data){
                          //                 setState(() {
                          //                   isLoadingProgress = true;
                          //                 });
                          //                 await Provider.of<AuthProviderr>(
                          //                     context,
                          //                     listen: false)
                          //                     .localAuth(context: context);

                          //                 setState(() {
                          //                   isLoadingProgress = false;
                          //                 });
                          //               }

                          //               else {
                          //                 utilService.showToast(
                          //                     // "Please first enable touch id from settings",
                          //                   "You need to log in for the first time and save credentials using remember me.",
                          //                     context);
                          //               }
                          //             },
                          //             child: Center(
                          //               child: Image.asset(
                          //                 "assets/images/FINGER-PRINT.png",
                          //                 scale: 5,
                          //               ),
                          //             ),
                          //           ),
                          //           Center(
                          //             child: Text('Touch ID Login',
                          //                 style: TextStyle(
                          //                   color: Colors.grey,
                          //                   fontSize: sy(11),
                          //                   fontWeight: FontWeight.w600,
                          //                 )),
                          //           ),
                          //         ],
                          //       ),
                          //     if (Platform.isIOS)
                          //       Column(
                          //         children: [
                          //           GestureDetector(
                          //             onTap: () async {
                          //               if(data){
                          //                 setState(() {
                          //                   isLoadingProgress = true;
                          //                 });
                          //                 await Provider.of<AuthProviderr>(
                          //                     context,
                          //                     listen: false)
                          //                     .localAuth(context: context);

                          //                 setState(() {
                          //                   isLoadingProgress = false;
                          //                 });
                          //               }

                          //               else {
                          //                 utilService.showToast(
                          //                     "You need to log in for the first time and save credentials using remember me.",
                          //                     context);
                          //               }
                          //             },
                          //             child: Center(
                          //               child: Image.asset(
                          //                 "assets/images/abc.png",
                          //                 scale: 3.8,
                          //               ),
                          //             ),
                          //           ),
                          //           SizedBox(height: 10.h),
                          //           Center(
                          //             child: Text('Face ID Login',
                          //                 style: TextStyle(
                          //                   color: Colors.grey,
                          //                   fontSize: sy(11),
                          //                   fontWeight: FontWeight.w600,
                          //                 )),
                          //           ),
                          //         ],
                          //       ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                    // TextButton(
                    //   onPressed: () {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (builder) => WebViewScreen(
                    //                 url:
                    //                     "https://www.termsfeed.com/live/96c8c3dc-4565-4d9a-a1ad-9299eb9e72b0")));
                    //   },
                    //   child: Text(
                    //     'Terms and Conditions',
                    //     style: TextStyle(
                    //       color: Theme.of(context).primaryColor,
                    //       decoration: TextDecoration.underline,
                    //       fontSize: sy(7),
                    //     ),
                    //   ),
                    // ),    // implemented by chetu
                    SizedBox(height: 0),
                    Container(
                      padding: EdgeInsets.only(bottom: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                              color: Color.fromRGBO(37, 36, 41, 1),
                              fontSize: sy(11),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              navigationService.navigateTo(SignUpScreenRoute);
                            },
                            child: Text(
                              ' Register Here',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: sy(11),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isLoadingProgress)
              Positioned.fill(
                  child: Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).backgroundColor,
                      )))
          ]),
        );
      },
    );
  }

// buildAvailability(BuildContext context) async {
//   final isAvailable = await LocalAuthApi.hasBiometrics();
//   final biometrics = await LocalAuthApi.getBiometrics();

//   // final hasFingerprint = biometrics.contains(BiometricType.fingerprint);
//   return showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: Text('Availability'),
//       content: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             margin: EdgeInsets.symmetric(vertical: 8),
//             child: Row(
//               children: [
//                 isAvailable
//                     ? Icon(Icons.check, color: Colors.green, size: 24)
//                     : Icon(Icons.close, color: Colors.red, size: 24),
//                 const SizedBox(width: 12),
//                 Text('Biometrics', style: TextStyle(fontSize: 24)),
//               ],
//             ),
//           ),
//           // buildText('Biometrics', isAvailable),
//           Container(
//             child: Row(
//               children: [
//                 hasFingerprint
//                     ? Icon(Icons.check, color: Colors.green, size: 24)
//                     : Icon(Icons.close, color: Colors.red, size: 24),
//                 const SizedBox(width: 12),
//                 Text("Fingerprint", style: TextStyle(fontSize: 24)),
//               ],
//             ),
//           )
//         ],
//       ),
//     ),
//   );
// }

// Widget buildText(String text, bool checked) => Container(
//       margin: EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           checked
//               ? Icon(Icons.check, color: Colors.green, size: 24)
//               : Icon(Icons.close, color: Colors.red, size: 24),
//           const SizedBox(width: 12),
//           Text(text, style: TextStyle(fontSize: 24)),
//         ],
//       ),
//     );

// Widget buildAuthenticate(BuildContext context) => buildButton(
//       text: 'Authenticate',
//       icon: Icons.lock_open,
//       onClicked: () async {
//         final isAuthenticated = await LocalAuthApi.authenticate();

//         // if (isAuthenticated) {
//         //   Navigator.of(context).pushReplacement(
//         //     MaterialPageRoute(builder: (context) => HomePage()),
//         //   );
//         // }
//       },
//     );

// Widget buildButton({
//   String? text,
//   IconData? icon,
//   VoidCallback? onClicked,
// }) =>
//     ElevatedButton.icon(
//       style: ElevatedButton.styleFrom(
//         minimumSize: Size.fromHeight(50),
//       ),
//       icon: Icon(icon, size: 26),
//       label: Text(
//         text!,
//         style: TextStyle(fontSize: 20),
//       ),
//       onPressed: onClicked,
//     );
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
