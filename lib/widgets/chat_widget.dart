import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/chatProvider.dart';
import 'package:mystory_flutter/providers/invite_member.dart';
import 'package:mystory_flutter/screens/chat_message_screen.dart';
import 'package:mystory_flutter/services/navigation_service.dart';

import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

// ignore: must_be_immutable
class ChatWidget extends StatefulWidget {
  Map<String, dynamic> chatMessage;
  var searchTitle;
  final ref;
  ChatWidget({Key? key, required this.chatMessage, this.ref, this.searchTitle})
      : super(key: key);
  // ChatWidget({required this.chatMessage, this.ref, this.searchTitle});

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  var member = {};
  var loggedUser = {};
  var memberProfile = {};
  var navigationService = locator<NavigationService>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String searchId = "";


  getMember(Map<String, dynamic> chatMessage, BuildContext context) {
    //getMember detail from chatMessage gorup

    Map<String, dynamic> members = chatMessage['members'];
    members.forEach((key, value) {
      if (key != context.read<AuthProviderr>().user.id) {
        member = value;
        print(members);
      } else {
        loggedUser = value;
      }
      searchId = member["id"]??"";
    });
  }

  @override
  void initState() {

    if (widget.ref != "Active") {
      getMember(widget.chatMessage, context);
    }
    else{
      searchId = widget.searchTitle["id"]??"";
    }
    // getMember(widget.chatMessage, context);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ChatWidget oldWidget) {
    getMember(widget.chatMessage, context);
    super.didUpdateWidget(oldWidget);
  }

  Future getChatDetails() async {
    context.read<ChatProvider>().senderId =
        context.read<AuthProviderr>().user.id;
    context.read<ChatProvider>().receverId =
        widget.ref == "Active" ? widget.searchTitle["id"] : member['id'];
    await context.read<ChatProvider>().getChatRoomId();
  }

  @override
  Widget build(BuildContext context) {
    DateTime messageTime = (widget.ref == "Active"
            ? widget.searchTitle["time"]
            : widget.chatMessage['time'] as Timestamp)
        .toDate();
    return GestureDetector(
      onTap: () async {
        await getChatDetails();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatMessageScreen(
                widget.ref == "Active" ? widget.searchTitle : member),
          ),
        );
      },
      child: Container(
        child: Container(
          padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 10.h),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color.fromRGBO(245, 246, 248, 0.6),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(width: 1, color: Colors.transparent),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 48.h,
                            width: 50.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              image: DecorationImage(
                                image: NetworkImage(
                                  widget.ref == "Active"
                                      ? widget.searchTitle["profile"]
                                      : member['profile'],
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          StreamBuilder<DocumentSnapshot>(
                            stream:  _firestore
                                .collection("users")
                                .doc(searchId)       // changed by chetu
                                .snapshots(),
                            builder: (context, snapshot) {
                              if(snapshot.data!=null){
                              //  print('Snapshot Data Here: ${snapshot.data!["status"]}');
                                return Container(
                                  margin: EdgeInsets.only(
                                    left: 42.w,
                                    top: 40.h,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.r),
                                      border: Border.all(
                                        color: Colors.white,
                                      ),
                                      color: snapshot.data!["status"]=="Online"?Colors.green:Colors.grey,
                                    ),
                                    width: 12.w,
                                    height: 12.h,
                                  ),
                                );
                              }else{
                                return SizedBox();
                              }

                            }
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2.r),
                                color: member['relation'] == ""
                                    ? Colors.transparent
                                    : Colors.grey.shade300,
                              ),
                              padding: EdgeInsets.all(2),
                              child: Text(
                                widget.ref == "Active"
                                    ? widget.searchTitle["relation"]
                                    : member['relation'],
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromRGBO(88, 102, 115, 1),
                                    height: 1.5),
                              ),
                            ),
                            Text(
                              widget.ref == "Active"
                                  ? widget.searchTitle["name"]
                                  : member['name'],overflow: TextOverflow.fade,
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,overflow: TextOverflow.clip,
                                  color: Color.fromRGBO(47, 45, 101, 1),
                                  height: 1.7),
                            ),
                            Container(
                              constraints: BoxConstraints(
                                maxWidth: 230.w,
                              ),
                              child: Text(
                                widget.ref == "Active"
                                    ? ""
                                    : widget.chatMessage['lastMessage'],
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromRGBO(88, 102, 115, 1),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      timeago.format(DateTime.now()
                          .subtract(DateTime.now().difference(messageTime))),
                      style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w300,
                          color: Color.fromRGBO(88, 102, 115, 1),
                          height: 2),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    if (widget.ref == "Active")
                      widget.searchTitle["unreadCount"] != 0
                          ? Container(
                              padding: EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.orange),
                              child: Center(
                                child: Text(
                                    "${widget.searchTitle["unreadCount"]}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ),
                            )
                          : Container(),
                    if (widget.ref != "Active")
                      int.parse("${loggedUser['unreadCount']}") != 0
                          ? Container(
                              padding: EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.orange),
                              child: Center(
                                child: Text("${loggedUser['unreadCount']}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ),
                            )
                          : Container(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
