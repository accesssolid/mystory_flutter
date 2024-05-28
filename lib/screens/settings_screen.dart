import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/models/appuser.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/post_provider.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:provider/provider.dart';

import '../global.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class Student {
  var name = '';
  var selected;

  Student(this.name, this.selected);
}

class _SettingScreenState extends State<SettingScreen> {
  bool isNotification = false;
  bool isloading = false;
  var navigationService = locator<NavigationService>();

  var _students = [
    // Student('Linked Requests', true),
    // Student('An Accepted link', true),
    // Student('Pending Invitations', true),
    // Student('Storybook Likes', true),
    // Student('Chat', true),
    // Student('New Story', true),
    // Student('In App Notifications', true),
    // Student('ADMIN', true),
  ];
// students.add(Student('Linked Requests', true),);

  var notificaiton = {
    // "linkedRequests": true,
    // "acceptedLink": true,
    // "pendingInvitaions": true,
    // "storybookLikes": true,
    // "chat": true,
    // "newStory": true,
    // "inappNotifications": true,
    // "admin": true,
  };

  String notificationText(String text) {
    print(text);
    if (text == 'linkedRequests') {
      return 'Link Request';
    } else if (text == 'acceptedLink') {
      return 'Accept Link';
    } else if (text == 'pendingInvitaions') {
      return 'Pending Invitaions';
    } else if (text == 'storybookLikes') {
      return 'Story Book Likes';
    } else if (text == 'chat') {
      return 'Chat';
    } else if (text == 'newStory') {
      return 'New Story';
    } else if (text == 'inappNotifications') {
      return 'Inapp Notifications';
    }
    else {
      return 'Admin';
    }
  }

  var user;

  getNot() {
    AppUser user = Provider.of<AuthProviderr>(context, listen: false).user;
    print(user.notificationSettting);
    Map notf = user.notificationSettting;

    notificaiton.addAll(notf);
    notf.forEach((key, value) {
      if (key == "inappNotifications" && value == true) {
        isNotification = true;
      }
      _students.add(
        Student(key, value),
      );
      _students.sort((a, b) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
       _students.removeWhere((element) => element.name=="admin");

    });
  }

  @override
  void initState() {
    getNot();

    // Provider.of<AuthProviderr>(context, listen: false)
    //     .notificationPermision(notificationPermisiton: notificaiton);

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
    return WillPopScope(
      onWillPop: () async {
        // FocusScope.of(context).unfocus();
        navigationService.navigateTo(MaindeshboardRoute);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
         //     navigationService.navigateTo(MaindeshboardRoute);
            },
            icon: Icon(
              Icons.arrow_back,
              size: 22.h,
              color: Color.fromRGBO(
                137,
                139,
                142,
                1,
              ),
            ),
          ),
          title: Text(
            "Notifications",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(
            15.w,
            20.h,
            15.w,
            0.h,
          ),
          child: ListView.separated(
            itemCount: _students.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.fromLTRB(
                  10.w,
                  3.h,
                  10.w,
                  3.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade100.withOpacity(
                        0.8,
                      ),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(
                        1,
                        5,
                      ), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      10.h,
                    ),
                  ),
                  border: Border.all(
                    width: 1,
                    color: Color.fromRGBO(
                      242,
                      242,
                      242,
                      1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      notificationText(_students[index].name),
                      style: TextStyle(
                        color: Color.fromRGBO(
                          130,
                          130,
                          130,
                          1,
                        ),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Transform.scale(
                      scale: MediaQuery.of(context).size.height * 0.0008,
                      child: Container(
                        child: CupertinoSwitch(
                          activeColor: Theme.of(context).primaryColor,
                          value: _students[index].selected,
                          onChanged: (bool value) async {
                            showLoadingAnimation(context);
                            if (_students[index].name == 'inappNotifications') {
                              isNotification = value;
                              setState(() {
                                _students.forEach((element) {
                                  element.selected = value;
                                });
                              });
                              notificaiton.forEach((key, cval) {
                                notificaiton[key] = value;
                              });
                              await Provider.of<AuthProviderr>(context,
                                      listen: false)
                                  .notificationPermision(notificaiton, context);
                            } else {
                              if (_students[index].name ==
                                          'inappNotifications' &&
                                      _students[index].selected == true ||
                                  isNotification == true) {
                                setState(() {
                                  _students[index].selected = value;
                                });
                                notificaiton.forEach((key, cval) {
                                  if (key == _students[index].name) {
                                    notificaiton[key] = value;
                                  }
                                });
                                await Provider.of<AuthProviderr>(context,
                                        listen: false)
                                    .notificationPermision(
                                        notificaiton, context);
                              }

                              // print(notificaitonPermisiton);

                            }
                            navigationService.closeScreen();
                            print(notificaiton);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 15.h,
              );
            },
          ),
        ),
      ),
    );
  }
}
