import 'dart:io';

import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/constant/enum.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/screens/delete_account_request_screen.dart';
import 'package:mystory_flutter/services/storage_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/widgets/column_scroll_view.dart';
import 'package:mystory_flutter/widgets/drawer/drawer_item.dart';
import 'package:mystory_flutter/widgets/drawer/drawerlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/navigation_service.dart';
import '../utils/service_locator.dart';

class MainDrawerWidget extends StatefulWidget {
  @override
  _MainDrawerWidgetState createState() => _MainDrawerWidgetState();
}

class _MainDrawerWidgetState extends State<MainDrawerWidget> {
  bool isSwitched = false;
  bool isTouched = false;
  bool? isFSwitched = false;
  bool? isFTouched = false;

  // var touchIdDAta;
  StorageService? storageService = locator<StorageService>();
  List<Map<String, dynamic>> drawerlist = [
    {"id": "1", "title": "Storybook", "img": "assets/images/Primary.png"},
    {"id": "2", "title": "Journal", "img": "assets/images/Vector.png"},
    {"id": "3", "title": "Media Gallery", "img": "assets/images/Image.png"},
    {"id": "4", "title": "Chat", "img": "assets/images/Group 1067.png"},
  ];
  List<Map<String, dynamic>> drawerItem = [
    {"id": "1", "title": "Privacy", "img": "assets/images/Group 33605.png"},
    {"id": "2", "title": "Terms of use", "img": "assets/images/Info Square.png"},
    {"id": "3", "title": "FAQ", "img": "assets/images/Group 1067.png"},
    {"id": "4", "title": "Logout", "img": "assets/images/Group 33606.png"},
    // implemented by chetu
  ];
  String tagId = ' ';

  void active(
    dynamic val,
  ) {
    setState(() {
      tagId = val;
      tagId1 = "";
    });
  }

  String tagId1 = ' ';

  void actived(
    dynamic val,
  ) {
    setState(() {
      tagId1 = val;
      tagId = "";
    });
  }

  callback(bool data) {
    setState(() {
      isLoadingProgress = data;
    });
  }

  bool? isactive = false;
  bool isLoadingProgress = false;
  var navigationService = locator<NavigationService>();
  var height;
  var width;

  // ignore: unused_field
  bool _notificationSwitchValue = false;

  @override
  void initState() {
    touchData();
    super.initState();
  }

  touchData() async {
    isTouched =
        await this.storageService!.getBoolData(StorageKeys.touchID.toString());

    isSwitched = isTouched;

    isFTouched =
        await this.storageService!.getBoolData(StorageKeys.faceID.toString());
    setState(() {
      isFSwitched = isFTouched;
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Stack(children: [
      Container(
        width: MediaQuery.of(context).size.width / 1.2,
        child: Drawer(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: height * 0.20,
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        scale: 1.2,
                        image: AssetImage(
                          "assets/images/logo.png",
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ColumnScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(),
                            shrinkWrap: true,
                            itemCount: drawerlist.length,
                            itemBuilder: (ctx, i) {
                              return DrawerList(
                                callback: callback,
                                data: drawerlist[i],
                                tag: drawerlist[i]['id'],
                                action: active,
                                active:
                                    tagId == drawerlist[i]['id'] ? true : false,
                              );
                            }),
                        SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          child: Padding(
                            padding: EdgeInsets.only(left: 12.0, right: 48),
                            child: Container(
                                decoration: BoxDecoration(
                                    gradient: isactive!
                                        ? LinearGradient(
                                            colors: [
                                              Color.fromRGBO(91, 121, 229, 1),
                                              Color.fromRGBO(129, 109, 224, 1)
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            stops: [0.0, 0.99])
                                        : LinearGradient(
                                            colors: [
                                              Colors.white,
                                              Colors.white,
                                            ],
                                          ),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 8.0,
                                      top: 9.0,
                                      bottom: 9.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image(
                                            image: AssetImage(
                                                "assets/images/Setting.png"),
                                            color: isactive!
                                                ? Colors.white
                                                : Colors.black,
                                            height: 15,
                                          ),
                                          Text(
                                            "   Settings",
                                            style: TextStyle(
                                              color: isactive!
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      isactive!
                                          ? Icon(
                                              Icons.keyboard_arrow_down,
                                              color: isactive!
                                                  ? Colors.white
                                                  : Colors.black,
                                            )
                                          : Icon(
                                              Icons.keyboard_arrow_right,
                                              color: isactive!
                                                  ? Colors.white
                                                  : Colors.black,
                                            )
                                    ],
                                  ),
                                )),
                          ),
                          onTap: () {
                            setState(() {
                              isactive = !isactive!;
                            });
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        isactive!
                            ? Column(
                                children: [
                                  // Container(
                                  //   decoration: BoxDecoration(
                                  //     color: Colors.white,
                                  //     borderRadius: BorderRadius.circular(50),
                                  //   ),
                                  //   margin:
                                  //       EdgeInsets.only(left: 12, right: 50),
                                  //   child: Padding(
                                  //     padding: EdgeInsets.only(
                                  //         left: 14.0,
                                  //         top: 9.0,
                                  //         bottom: 20.0,
                                  //         right: 8.0),
                                  //     child: Row(
                                  //       // mainAxisAlignment:
                                  //       //     MainAxisAlignment.spaceBetween,
                                  //       children: [
                                  //         GestureDetector(
                                  //           onTap: () {
                                  //             navigationService.navigateTo(
                                  //                 settingScreenRoute);
                                  //           },
                                  //           child: Row(
                                  //             children: [
                                  //               SizedBox(
                                  //                 width: 10,
                                  //               ),
                                  //               Icon(Icons.circle,
                                  //                   size: 8,
                                  //                   color:
                                  //                       Colors.grey.shade500),
                                  //               SizedBox(
                                  //                 width: 15,
                                  //               ),
                                  //               Text(
                                  //                 "Notification",
                                  //                 style: TextStyle(
                                  //                     fontSize: 13,
                                  //                     fontWeight:
                                  //                         FontWeight.w600,
                                  //                     color:
                                  //                         Colors.grey.shade600),
                                  //               ),
                                  //             ],
                                  //           ),
                                  //         ),
                                  //
                                  //         // Icon(Icons.keyboard_arrow_right),
                                  //         // Row(
                                  //         //   children: [
                                  //         //     Container(
                                  //         //       height: 18,
                                  //         //       width: 30,
                                  //         //       decoration: BoxDecoration(
                                  //         //         borderRadius:
                                  //         //             BorderRadius.circular(5),
                                  //         //         color: Colors.blue,
                                  //         //       ),
                                  //         //       child: Center(
                                  //         //           child: Text(
                                  //         //         "New",
                                  //         //         style: TextStyle(
                                  //         //             color: Colors.white,
                                  //         //             fontSize: 10),
                                  //         //       )),
                                  //         //     ),
                                  //         //     SizedBox(
                                  //         //       width: 10,
                                  //         //     ),
                                  //         //     Icon(Icons.keyboard_arrow_right),
                                  //         //   ],
                                  //         // ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),      // commented by chetu..
                                  InkWell(
                                    onTap: () {
                                      navigationService
                                          .navigateTo(ResetPasswordScreenRoute);
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(left: 12, right: 50),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 14.0,
                                            top: 0.0,
                                            bottom: 20.0,
                                            right: 8.0),
                                        child: Row(
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Icon(Icons.circle,
                                                    size: 8,
                                                    color:
                                                        Colors.grey.shade500),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Text(
                                                  "Reset Password",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          Colors.grey.shade600),
                                                ),
                                              ],
                                            ),
                                            // Icon(Icons.keyboard_arrow_right),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Container(
                                  //   margin:
                                  //       EdgeInsets.only(left: 12, right: 50),
                                  //   child: Padding(
                                  //     padding: EdgeInsets.only(
                                  //         left: 14.0,
                                  //         top: 0.0,
                                  //         bottom: 9.0,
                                  //         right: 8.0),
                                  //     child: Row(
                                  //       // mainAxisAlignment:
                                  //       //     MainAxisAlignment.spaceBetween,
                                  //       children: [
                                  //         Row(
                                  //           children: [
                                  //             SizedBox(
                                  //               width: 10,
                                  //             ),
                                  //             Icon(Icons.circle,
                                  //                 size: 8,
                                  //                 color: Colors.grey.shade500),
                                  //             SizedBox(
                                  //               width: 15,
                                  //             ),
                                  //             Text(
                                  //               "Account",
                                  //               style: TextStyle(
                                  //                   fontSize: 13,
                                  //                   fontWeight: FontWeight.w600,
                                  //                   color:
                                  //                       Colors.grey.shade600),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //         // Icon(Icons.keyboard_arrow_right),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (builder)=>DeleteAccountRequestScreen()));
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(left: 12, right: 50),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 14.0,
                                            top: 9.0,
                                            bottom: 9.0,
                                            right: 8.0),
                                        child: Row(
                                          // mainAxisAlignment:
                                          //     MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Icon(Icons.circle,
                                                    size: 8,
                                                    color: Colors.grey.shade500),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Text(
                                                  "Delete Account",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w600,
                                                      color:
                                                          Colors.grey.shade600),
                                                ),
                                              ],
                                            ),
                                            // Icon(Icons.keyboard_arrow_right),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  //touch id.............................
                                  // Container(
                                  //   margin:
                                  //       EdgeInsets.only(left: 12, right: 50),
                                  //   child: Padding(
                                  //     padding: EdgeInsets.only(
                                  //         left: 14.0,
                                  //         top: 0.0,
                                  //         bottom: 9.0,
                                  //         right: 8.0),
                                  //     child: Row(
                                  //       mainAxisAlignment:
                                  //           MainAxisAlignment.spaceBetween,
                                  //       children: [
                                  //         Row(
                                  //           children: [
                                  //             SizedBox(
                                  //               width: 10,
                                  //             ),
                                  //             Text(
                                  //               Platform.isAndroid
                                  //                   ? "Enable Touch Id"
                                  //                   : "Enable Face ID",
                                  //               style: TextStyle(
                                  //                   fontSize: 13,
                                  //                   fontWeight: FontWeight.w600,
                                  //                   color:
                                  //                       Colors.grey.shade600),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //         Switch(
                                  //           value: isSwitched,
                                  //           onChanged: (value) async {
                                  //             setState(() {
                                  //               isSwitched = value;
                                  //               print(isSwitched);
                                  //             });
                                  //             SelectTouchId.isTouched =
                                  //                 isSwitched;
                                  //             await storageService!.setBoolData(
                                  //                 StorageKeys.touchID
                                  //                     .toString(),
                                  //                 SelectTouchId.isTouched);
                                  //             // await Provider.of<AuthProvider>(
                                  //             //         context,
                                  //             //         listen: false)
                                  //             //     .setEnableTouch(value);
                                  //           },
                                  //           activeTrackColor: Color.fromRGBO(
                                  //               129, 109, 224, 1),
                                  //           activeColor:
                                  //               Color.fromRGBO(91, 121, 229, 1),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              )
                            : Container(),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(),
                            shrinkWrap: true,
                            itemCount: drawerItem.length,
                            itemBuilder: (ctx, i) {
                              return DrawerItem(
                                callback: callback,
                                data: drawerItem[i],
                                tag: drawerItem[i]['id'],
                                action: actived,
                                active: tagId1 == drawerItem[i]['id']
                                    ? true
                                    : false,
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      if (isLoadingProgress)
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              color: Theme.of(context).backgroundColor,
            ),
          ),
        ),
    ]);
  }
}
