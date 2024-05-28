import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mystory_flutter/services/util_service.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../services/navigation_service.dart';
import '../../utils/routes.dart';
import '../../utils/service_locator.dart';

class EmailVerificationScreen extends StatefulWidget {
  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  var email;
  var navigationService = locator<NavigationService>();
  UtilService? utilService = locator<UtilService>();
  bool isLinkEnable = false;
  int count = 70;
  Timer? linkTimer;
  void timerActive() {
    count = 70;
    linkTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      print('object');

      setState(() {
        count--;
      });
      if (count == 0) {
        isLinkEnable = true;
        linkTimer!.cancel();
      }
    });
  }

  @override
  void initState() {
    timerActive();

    var userData = Provider.of<AuthProviderr>(context, listen: false).user;
    setState(() {
      email = userData!.email;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          // backgroundColor: Colors.greenAccent,
          body: Stack(
              // fit: StackFit.expand,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/blue-bacakground.png'),
                        fit: BoxFit.cover),
                  ),
                ),
                Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.check,
                            size: 60,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 25),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 300,
                          child: Text(
                            'A Verification Link has been sent to $email. Kindly verify your email and login to continue.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Greyfel',
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        GestureDetector(
                          onTap: () async {
                            if (isLinkEnable == true) {
                              isLinkEnable = false;
                              await Provider.of<AuthProviderr>(context,
                                      listen: false)
                                  .resendVerificationEmail(context);
                              timerActive();
                              print(isLinkEnable);
                            } else {
                              utilService!.showToast(
                                  "You cannnot resend untile the timer is over",context);
                              print(isLinkEnable);
                            }
                          },
                          child: Text(
                            'RESEND LINK',
                            style: TextStyle(
                              fontFamily: 'Greyfel',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          count.toString(),
                          style: TextStyle(
                            fontFamily: 'Greyfel',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ]),
                ),

                Positioned(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: SizedBox(
                        width: 280,
                        height: 40,
                        // code change by chetu
                        // change raisedbutton to elevated button 
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 8.0,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))
                          ),
                          //highlightElevation: 10.0, 
                         // elevation: 8.0,
                          //highlightColor: Colors.white,
                          //color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 11.0),
                            child: Text(
                              "LOGIN NOW",
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: "Greyfel",
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          onPressed: () {
                            navigationService.navigateTo(LoginScreenRoute);
                          },
                          // code change by chetu
                          // put this code the elevatedButton.styleFrom.
                         // shape: RoundedRectangleBorder(
                           //   borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                    ),
                  ),
                ),
                // ),
                // ),
              ]),
        ));
  }
}
