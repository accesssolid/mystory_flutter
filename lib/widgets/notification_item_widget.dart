import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/chatProvider.dart';
import 'package:mystory_flutter/providers/invite_member.dart';
import 'package:mystory_flutter/providers/notification_provider.dart';
import 'package:mystory_flutter/screens/invite_member_screen.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/services/storage_service.dart';
import 'package:mystory_flutter/services/util_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationItemWidget extends StatefulWidget {
  final data;

  NotificationItemWidget({this.data});

  @override
  _NotificationItemWidgetState createState() => _NotificationItemWidgetState();
}

class _NotificationItemWidgetState extends State<NotificationItemWidget> {
  var formatted;
  bool isLoading = false;
  var navigationService = locator<NavigationService>();
  var utilService = locator<UtilService>();
  var user;

  //chetu
  //var getUserDetail;
  // List tempcategoriesList = [];

  @override
  void initState() {
    user = Provider.of<AuthProviderr>(context, listen: false).user;
    // getUserDetail =
    //     Provider.of<AuthProvider>(context, listen: false).getUserDetailData;
    super.initState();
  }

  // void acceptInvitaion(){
  //   navigationService.navigateTo('/invite_member_notification_screen');
  // }

  @override
  Widget build(BuildContext context) {
    formatted = timeago.format(DateTime.fromMillisecondsSinceEpoch(
        widget.data['data']["createdOnDate"]));
    ScreenUtil.init(
      context,
        //BoxConstraints(
        //    maxWidth: MediaQuery.of(context).size.width,
        //    maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(360, 690),
        //orientation: Orientation.portrait
    );
    return Consumer<InviteProvider>(builder: (context, search, child) {
      return Stack(children: [
        Container(
          color: Colors.grey.shade100,
          padding: EdgeInsets.only(
            top: 10.h,
            left: 10.w,
            right: 10.w,
            bottom: 10.h,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    child: Container(
                      width: 40.w,
                      height: 35.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          scale: 3,
                          image: NetworkImage(
                            widget.data['data']['sender']["profilePicture"],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text(
                          widget.data['data']['sender']["firstName"].toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(" "),
                        Text(
                          widget.data['data']['sender']["lastName"].toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ]),
                      Text(
                        "@${widget.data['data']['sender']["firstName"]}",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Container(
                        width: 220.w,
                        child: RichText(
                          text: TextSpan(
                            text: 'wants to add you as a ',
                            style: TextStyle(
                              height: 1.3,
                              fontSize: 12.sp,
                              color: Colors.black87,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    "${widget.data['data']["relation"]['relationName']}",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: ' in the family tree. ',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade400,
                                    spreadRadius: -3,
                                    blurRadius: 5,
                                    offset: Offset(1, 5))
                              ],
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              ),
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(91, 121, 229, 1),
                                  Color.fromRGBO(129, 109, 224, 1)
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0.0, 0.99],
                              ),
                            ),
                            height: 30.h,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                textStyle:
                                    TextStyle(fontWeight: FontWeight.w600),
                                fixedSize: Size(
                                    MediaQuery.of(context).size.width / 3.5,
                                    MediaQuery.of(context).size.height * 0.040),
                                //primary: Colors.transparent,
                              ),
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                var a =
                                    '${context.read<AuthProviderr>().user.id}';
                                var b =
                                    '${widget.data['data']['sender']['id']}';
                                print(
                                    'my user ${context.read<AuthProviderr>().user.id}');
                                print(
                                    'sender user ${widget.data['data']['sender']['id']}');
                                await context
                                    .read<InviteProvider>()
                                    .fetchSearchUserDetail(
                                        myId: a, viewuserId: b);
                                Map<String, dynamic> receiverData = context
                                    .read<InviteProvider>()
                                    .getSearchUserData;
                                var receiverEmail = receiverData["email"];

                                setState(() {
                                  isLoading = false;
                                }); //    Implemented by chetu 29 sep
                                if (context
                                            .read<InviteProvider>()
                                            .searchUserData['inviteStatus'] ==
                                        "approved" ||
                                    context
                                            .read<InviteProvider>()
                                            .searchUserData['inviteStatus'] ==
                                        "pending") {
                                  navigationService.navigateTo(
                                      FamilyMemberProfileScreenRoute);
                                } else {
                                  print("object");
                                  print(widget.data);
                                  // Provider.of<AuthProvider>(context,
                                  //         listen: false)
                                  //     .setDataForUserDetail(
                                  //         search.searchUserData);
                                  // navigationService
                                  //     .navigateTo('/invite-member-screen')
                                  //     .then((_) {
                                  //   context.read<ChatProvider>().createChatRoom(
                                  //       senderUser: widget.data,
                                  //       receiverUser: user);
                                  // });       // commented by chetu on 29 sep 2022
                                  // navigationService.navigateTo(
                                  //     '/invite-member-screen'); //implemented by chetu
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) =>
                                              InviteMemberScreen(
                                                  fromAcceptInvitation: true,
                                                  data: widget.data,receiverEmail: receiverEmail)));
                                }

                                // var senderDetails = {
                                //   "id": widget.data['data']['sender']['id'],
                                //   "firstName": widget.data['data']['sender']['firstName'],
                                //   "middleName": widget.data['data']['sender']['middleName']??"",
                                //   "lastName": widget.data['data']['sender']['lastName'],
                                //   "profilePicture": widget.data['data']['sender']['profilePicture']??"",
                                //   "dob": widget.data['data']['sender']['dob'],
                                //   "address": widget.data['data']['sender']['address'],
                                //   "senderEmail": widget.data['data']['sender']["email"],
                                //   "permission": widget.data['data']['permission'],
                                //   "categories": widget.data['data']['categories'],
                                //   "relation": widget.data['data']['relation']
                                // };
                                //
                                // await Provider.of<InviteProvider>(context,
                                //         listen: false)
                                //     .inviteMembers(
                                //   context: context,
                                //   linkedStatus: "approved",
                                //   id: widget.data['data']["id"],sender: senderDetails,
                                //   notificationId: widget.data["id"],
                                // )
                                //     .then((_) {
                                //   context.read<ChatProvider>().createChatRoom(
                                //       senderUser: widget.data,
                                //       receiverUser: user);
                                // });
                                //
                                // setState(() {
                                //   isLoading = false;
                                // });
                                //
                                // await Provider.of<NotificationProvider>(context,
                                //         listen: false)
                                //     .removeInviteNotifications(
                                //         widget.data["id"]);
                                // utilService.showToast(
                                //     // "Please first enable touch id from settings",
                                //     "You are now added on their family tree.",
                                //     context);      commented by chetu on 28 sep 2022
                              },
                              child: Text(
                                'View',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Container(
                            height: 30.h,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                textStyle:
                                    TextStyle(fontWeight: FontWeight.w600),
                                fixedSize: Size(
                                  MediaQuery.of(context).size.width / 3.5,
                                  MediaQuery.of(context).size.height * 0.040,
                                ),
                                backgroundColor: Colors.white,
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(
                                    50,
                                  ),
                                  side: BorderSide(
                                    color: Theme.of(context).indicatorColor,
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                await Provider.of<InviteProvider>(context,
                                        listen: false)
                                    .inviteMembers(
                                        context: context,
                                        linkedStatus: "reject",
                                        notificationId: widget.data["id"],
                                        id: widget.data['data']["id"]);
                                setState(() {
                                  isLoading = false;
                                });
                                // await Provider.of<NotificationProvider>(context,
                                //         listen: false)
                                //     .removeNotification(widget.data["id"]);
                                await Provider.of<NotificationProvider>(context,
                                        listen: false)
                                    .removeInviteNotifications(
                                        widget.data["id"]);
                                await Provider.of<InviteProvider>(context,
                                        listen: false)
                                    .fetchAllFamilyTree(
                                        id: user.id, count: 10, page: 1);
                              },
                              child: Text(
                                'Decline',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.w,
                      ),
                    ],
                  ),
                ],
              ),
              // Spacer(),
              Expanded(
                child: Text(
                  formatted,
                  style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        if (isLoading)
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ),
          )
      ]);
    });
  }
}
