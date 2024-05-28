import 'dart:async';

import 'package:flutter/material.dart';

// import 'package:animated_check/animated_check.dart';
import '../services/navigation_service.dart';
import '../utils/routes.dart';
import '../utils/service_locator.dart';
import 'package:relative_scale/relative_scale.dart';

class ResetPasswordSuccessfullyScreen extends StatefulWidget {
  @override
  _ResetPasswordSuccessfullyScreenState createState() =>
      _ResetPasswordSuccessfullyScreenState();
}

class _ResetPasswordSuccessfullyScreenState
    extends State<ResetPasswordSuccessfullyScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  var navigationService = locator<NavigationService>();

  @override
  void didChangeDependencies() {
    Timer(Duration(seconds: 2),
        () => navigationService.navigateTo(HomeScreenRoute));
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    _animation = new Tween<double>(begin: 0, end: 1).animate(
        new CurvedAnimation(
            parent: _animationController, curve: Curves.easeInOutCirc));

    Timer(Duration(seconds: 1), () {
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    AnimationController(vsync: this, duration: Duration(seconds: 10));
    return RelativeBuilder(builder: (context, height, width, sy, sx) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/change_password_back.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: (Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(alignment: Alignment.center, children: <Widget>[
                  // Icon(Icons.check,color: Colors.greenAccent,size: ScreenUtil().setSp(200),),
                  Container(
                    width: sy(60),
                    height: sy(60),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        shape: BoxShape.circle),
                  ),
                  // Positioned.fill(
                  //   child: Align(
                  //     alignment: Alignment.center,
                  //     child: AnimatedCheck(
                  //       progress: _animation,
                  //       size: sy(100),
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  // ),

                  // FlatButton(
                  //     child: Text("",style: TextStyle(color: Colors.white),),
                  //     onPressed: _animationController.forward),
                ]),
                SizedBox(height: sy(20)),
                Text(
                  'CHANGED PASSWORD',
                  style: TextStyle(
                    fontSize: sy(15),
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Successfully!',
                  style: TextStyle(
                    fontSize: sy(35),
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ])),
        ),
      );
    });
  }
}
