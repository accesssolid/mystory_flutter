import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/invite_member.dart';
import 'package:mystory_flutter/providers/notification_provider.dart';
import 'package:mystory_flutter/screens/settings_screen.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:mystory_flutter/widgets/no_data_yet.dart';
import 'package:mystory_flutter/widgets/notification_first_widget.dart';
import 'package:mystory_flutter/widgets/notification_item_widget.dart';
import 'package:provider/provider.dart';
import 'package:supercharged/supercharged.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool? open = false;
  bool? topOpen = false;
  bool isLoadingProgress = false;
  int totalcount = 0;
  var user;
  var navigationService = locator<NavigationService>();
  var data = [];

  @override
  void didUpdateWidget(covariant NotificationScreen oldWidget) {
    data = Provider.of<NotificationProvider>(context, listen: false)
        .userNotification;

    // if (user != null)
    //   Provider.of<NotificationProvider>(context, listen: false)
    //       .setNewNotification(false, user.id);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    data = Provider.of<NotificationProvider>(context, listen: false)
        .userNotification;

    // user = Provider.of<AuthProviderr>(context, listen: false).userData;
    // if (user != null)
    //   Provider.of<NotificationProvider>(context, listen: false)
    //       .setNewNotification(false, user.id);
    super.didChangeDependencies();
  }

  String id = 'asasasas';

  @override
  void initState() {
    setState(() {
      open = !open!;
    });
    user = Provider.of<AuthProviderr>(context, listen: false).user;

    // user = Provider.of<AuthProviderr>(context, listen: false).userData;
    // if (user != null)
    //   Provider.of<NotificationProvider>(context, listen: false)
    //       .setNewNotification(false, user.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<NotificationProvider>(builder: (context, noti, child) {
        noti.notifications
            .sort((a, b) => b["createdOnDate"].compareTo(a["createdOnDate"]));
        return Container(
          padding: EdgeInsets.only(
            top: 15.h,
            // bottom: 15.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10.w,
                        right: 10.w,
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            open = !open!;
                          });
                        },
                        // FirebaseFirestore.instance.collection('notifications').doc().delete();
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Requests - $totalcount",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            open!
                                ? Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Theme.of(context).primaryColor,
                                    size: 25.h,
                                  )
                                : Icon(
                                    Icons.keyboard_arrow_right,
                                    size: 25.h,
                                  ),
                          ],
                        ),
                      ),
                    ),
                    open!
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('notifications')
                                    .orderBy("createdOnDate", descending: true)
                                    .snapshots(),
                                //builder function will call when new data comes in the stream
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshots) {
                                  print('arso id here');
                                  print(context.read<AuthProviderr>().user.id);
                                  print(user.id);
                                  totalcount = 0;
                                  bool containsRequest = false;
                                  if (snapshots.hasData) {
                                    // snapshots.data!.docs.sort((a, b) => b["createdOnDate"].compareTo(a["createdOnDate"]));
                                    return ListView.builder(
                                      physics: BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int i) {
                                        // print(snapshots.data!.docs[0]['data']);
                                        //  snapshots.data!.docs.sort((a, b) =>
                                        //      b["createdOnDate"].toString()
                                        //          .compareTo(a["createdOnDate"].toString()));
                                        var data = snapshots.data!.docs[i]
                                            .data() as Map;

                                        if (snapshots.data!.docs[i]['data']
                                                    ['linkedStatus'] ==
                                                'pending' &&
                                            snapshots.data!.docs[i]['data']
                                                    ['reciever']['id'] ==
                                                context
                                                    .read<AuthProviderr>()
                                                    .user
                                                    .id) {
                                          totalcount = totalcount + 1;
                                          print(
                                              'arso total count = $totalcount');
                                          containsRequest = false;
                                          // print(data);
                                          return Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 5.h),
                                            child: GestureDetector(
                                              onTap: () async {
                                                // var a =
                                                //     '${context.read<AuthProviderr>().user.id}';
                                                // var b =
                                                //     '${snapshots.data!.docs[i]['data']['sender']['id']}';
                                                // print(
                                                //     'my user ${context.read<AuthProviderr>().user.id}');
                                                // print(
                                                //     'sender user ${snapshots.data!.docs[i]['data']['sender']['id']}');
                                                // await context
                                                //     .read<InviteProvider>()
                                                //     .fetchSearchUserDetail(
                                                //         myId: a, viewuserId: b);
                                                // navigationService.navigateTo(
                                                //     '/search-Storybook-screen');  //   commented by chetu on 29 september 2022
                                              },
                                              child: NotificationItemWidget(
                                                data: data,
                                              ),
                                            ),
                                          );
                                        } else {
                                          containsRequest = false;
                                          return (i ==
                                                      snapshots.data!.docs
                                                              .length -
                                                          1 &&
                                                  totalcount == 0)
                                              ? Container(
                                                  height: 200,
                                                  alignment: Alignment.center,
                                                  child: NoDataYet(
                                                      title: "No requests yet",
                                                      image:
                                                          "Notification-Icon-(InActive).png"),
                                                )
                                              : Container();
                                        }
                                        return Text('arso');
                                      },
                                      // separatorBuilder:
                                      //     (BuildContext context, int index) {
                                      //    return containsRequest?SizedBox(
                                      //     height: 0.1.h,
                                      //   ):SizedBox(height: 0,);
                                      // },                      // commented by chetu on 28 sep 2022
                                      itemCount: snapshots.data!.docs.length,
                                    );
                                  } else {
                                    return SizedBox();
                                  }
                                }),
                          )
                        // : totalcount == 0
                        //     ? Container(
                        //         height: 200,
                        //         alignment: Alignment.center,
                        //         child: NoDataYet(
                        //             title: "No requests yet",
                        //             image: "Notification-Icon-(InActive).png"),
                        //       )
                        : Container(
                            color: Colors.cyan,
                          )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 15.h),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        topOpen = !topOpen!;
                      });
                    },
                    // FirebaseFirestore.instance.collection('notifications').doc().delete();
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          noti.notifications.isEmpty
                              ? "Notifications - 0"
                              : "Notifications - ${noti.notifications.length}",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        topOpen!
                            ? Icon(
                                Icons.keyboard_arrow_down,
                                color: Theme.of(context).primaryColor,
                                size: 25.h,
                              )
                            : Icon(
                                Icons.keyboard_arrow_right,
                                size: 25.h,
                              ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Column(
                  children: [
                    if (topOpen!)
                      noti.notifications.isEmpty
                          ? NoDataYet(
                              title: "No notifications yet",
                              image: "Notification-Icon-(InActive).png")
                          : ListView.separated(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return
                                    // noti.notifications[index]["type"] == "invite"
                                    // ? Container()
                                    // :
                                    NotificationFirstWidget(
                                  data: noti.notifications[index],
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  height: 10.h,
                                );
                              },
                              itemCount: noti.notifications.length,
                            ),
                  ],
                ),
                // Expanded(
                //   flex: 5,
                //   child: Container(
                //     // height: MediaQuery.of(context).size.height / 3.5,
                //     child: Column(
                //       children: [
                //         Padding(
                //           padding: EdgeInsets.only(
                //             left: 10.w,
                //             right: 10.w,
                //           ),
                //           child: InkWell(
                //             onTap: () {
                //               setState(() {
                //                 topOpen = !topOpen!;
                //               });
                //             },
                //             // FirebaseFirestore.instance.collection('notifications').doc().delete();
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               children: [
                //                 Text(
                //                   noti.notifications.isEmpty
                //                       ? "Notifications - 0"
                //                       : "Notifications - ${noti.notifications.length}",
                //                   style: TextStyle(
                //                     fontSize: 16.sp,
                //                     color: Colors.black,
                //                     fontWeight: FontWeight.w700,
                //                   ),
                //                 ),
                //                 topOpen!
                //                     ? Icon(
                //                         Icons.keyboard_arrow_down,
                //                         color: Theme.of(context).primaryColor,
                //                         size: 25.h,
                //                       )
                //                     : Icon(
                //                         Icons.keyboard_arrow_right,
                //                         size: 25.h,
                //                       ),
                //               ],
                //             ),
                //           ),
                //         ),
                //         SizedBox(
                //           height: 15.h,
                //         ),
                //         if (topOpen!)
                //           noti.notifications.isEmpty
                //               ? NoDataYet(
                //                   title: "No notifications yet",
                //                   image: "Notification-Icon-(InActive).png")
                //               : Container(
                //
                //                   // height: MediaQuery.of(context).size.height * 0.4,
                //                   child: Expanded(
                //                     child: ListView.separated(
                //                       physics: BouncingScrollPhysics(),
                //                       shrinkWrap: true,
                //                       itemBuilder:
                //                           (BuildContext context, int index) {
                //                         return
                //                             // noti.notifications[index]["type"] == "invite"
                //                             // ? Container()
                //                             // :
                //                             NotificationFirstWidget(
                //                           data: noti.notifications[index],
                //                         );
                //                       },
                //                       separatorBuilder:
                //                           (BuildContext context, int index) {
                //                         return SizedBox(
                //                           height: 10.h,
                //                         );
                //                       },
                //                       itemCount: noti.notifications.length,
                //                     ),
                //                   ),
                //                 ),
                //         SizedBox(
                //           height: 15.h,
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
