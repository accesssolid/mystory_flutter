

import 'package:flutter/material.dart';
import 'package:animated_check/animated_check.dart';

import '../services/navigation_service.dart';
import '../utils/service_locator.dart';

class ChangePasswordSuccessfullyScreen extends StatefulWidget {
  final title;
  final routeName;
  ChangePasswordSuccessfullyScreen({this.routeName, this.title});
  @override
  _ChangePasswordSuccessfullyScreenState createState() =>
      _ChangePasswordSuccessfullyScreenState();
}

class _ChangePasswordSuccessfullyScreenState
    extends State<ChangePasswordSuccessfullyScreen>
    with SingleTickerProviderStateMixin {
  var navigationService = locator<NavigationService>();
  AnimationController? _animationController;
  Animation<double>? _animation;
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    _animation = new Tween<double>(begin: 0, end: 1).animate(
        new CurvedAnimation(
            parent: _animationController!, curve: Curves.easeInOutCirc));
    setState(() {
      _animationController!.forward();
    });
  }

  var height;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    return AlertDialog(
      // contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 10.0),
      content: Container(
        height: height * 0.5,
        width: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  'Success!',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: height * 0.05),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: height * 0.01),
                Container(
                    margin: EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 3,
                          color: Theme.of(context).backgroundColor,
                          style: BorderStyle.solid,
                        ),
                        shape: BoxShape.circle),
                    child: Center(
                      child: AnimatedCheck(
                        color: Theme.of(context).backgroundColor,
                        progress: _animation!,
                        size: height * 0.2,
                      ),
                    )),
                SizedBox(height: height * 0.03),
                Text(
                  widget.title,
                  style: TextStyle(
                      fontWeight: FontWeight.w500, fontSize: height * 0.02),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Container(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    navigationService.navigateTo(widget.routeName);
                  });
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  textStyle: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.03,
                      fontWeight: FontWeight.w600),
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.55,
                      MediaQuery.of(context).size.height * 0.060),
                  backgroundColor: Theme.of(context).backgroundColor,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(50.0),
                      side: BorderSide(
                          width: 1, color: Theme.of(context).backgroundColor)),
                ),
                child: Container(
                    padding: EdgeInsets.only(left: 5, right: 10),
                    child: new Text(
                      "Done",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
    // Scaffold(
    //     appBar: AppBar(
    //       title: Text("Animated Check Example"),
    //     ),
    //     body: Center(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: <Widget>[
    //           Container(
    //               child: AnimatedCheck(
    //             progress: _animation,
    //             size: 200,
    //           )),
    //           TextButton(
    //               child: Text("Check"),
    //               onPressed: _animationController.forward),
    //           TextButton(
    //               child: Text("Reset"), onPressed: _animationController.reset)
    //         ],
    //       ),
    //     ));
  }
}
