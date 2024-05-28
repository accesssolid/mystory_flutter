import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/widgets/audio_player_widget.dart';
import 'package:mystory_flutter/widgets/video_player_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:timeago/timeago.dart' as timeago;

// ignore: must_be_immutable
class MyMessageChatTile extends StatefulWidget {
  String memberProfilePic;
  Map<String, dynamic> messageData;
  final bool isCurrentUser;

  MyMessageChatTile(
      {required this.isCurrentUser,
      required this.memberProfilePic,
      required this.messageData});

  @override
  State<MyMessageChatTile> createState() => _MyMessageChatTileState();
}

class _MyMessageChatTileState extends State<MyMessageChatTile> {
  final double minValue = 8.0;

  var user;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    user = Provider.of<AuthProviderr>(context, listen: false).user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey key = GlobalKey();
    DateTime messageTime = (widget.messageData['time'] as Timestamp).toDate();
    return RelativeBuilder(builder: (context, height, width, sy, sx) {
      return widget.isCurrentUser
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  constraints: BoxConstraints(
                      maxWidth:
                          widget.messageData['type'] == 'audio' ? 370 : 220),
                  padding: EdgeInsets.symmetric(
                    vertical: sy(3),
                  ),
                  child: Bubble(
                    style: BubbleStyle(
                      radius: Radius.circular(10),
                      padding: BubbleEdges.all(
                        sy(7),
                      ),
                    ),
                    color: Colors.blue,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (widget.messageData['type'] == 'image')
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => _showSecondPage(
                                        context, widget.messageData['url'])),
                              );
                            },
                            child: Container(
                              width: 150,
                              child: Image.network(
                                widget.messageData['url'],
                              ),
                            ),
                          ),

                        if (widget.messageData['type'] == 'image' &&
                            widget.messageData['message'] != '')
                          SizedBox(height: sy(5)),
                        if (widget.messageData['type'] == 'video')
                          Container(
                              width: 250,
                              child: VideoPlayerWidget(
                                key: key,
                                videoUrl: widget.messageData['url'],
                              )),
                        if (widget.messageData['type'] == 'audio')
                          Container(
                              width: 250,
                              child: AudioPlayerWidget(
                                key: key,
                                audioUrl: widget.messageData['url'],
                              )),

                        if (widget.messageData['message'] != '')
                          SelectableText(
                            widget.messageData['message'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        SizedBox(
                          height: sy(10),
                        ),
                        Text(
                          timeago.format(DateTime.now().subtract(
                              DateTime.now().difference(messageTime))),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: sy(8),
                          ),
                        ),
                        //gallery-image//
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Row(
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        Container(
                          height: sy(20),
                          width: sy(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5),
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(12)),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(context
                                  .read<AuthProviderr>()
                                  .user
                                  .profilePicture),
                            ),
                          ),
                        ),
                        StreamBuilder<DocumentSnapshot>(
                          stream: _firestore
                              .collection("users")
                              .doc(user.id)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              return Container(
                                margin: EdgeInsets.only(
                                  left: 15.w,
                                  top: 38.h,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.r),
                                    border: Border.all(
                                      color: Colors.white,
                                    ),
                                    color: snapshot.data!["status"] == "Online"
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                  width: 10.w,
                                  height: 10.h,
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),

                        // Positioned(
                        //   bottom: 0,
                        //   right: 0,
                        //   child: CircleAvatar(
                        //     backgroundColor: Colors.white,
                        //     radius: 5,
                        //     child: CircleAvatar(
                        //       radius: 5,
                        //       backgroundColor: Colors.green.shade300,
                        //     ),
                        //   ),
                        // )
                      ],
                    )
                  ],
                ),
              ],
            )
          //here is second row of user.......................................
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: sy(20),
                          width: sy(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                widget.memberProfilePic,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: StreamBuilder<DocumentSnapshot>(
                            stream: _firestore
                                .collection("users")
                                .doc(widget.messageData["senderId"])
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                return CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 4,
                                  child: CircleAvatar(
                                      radius: 4,
                                      backgroundColor:
                                      snapshot.data!["status"] == "Online"
                                          ? Colors.green
                                          : Colors.grey),
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
                SizedBox(width: 10),
                Container(
                  constraints: BoxConstraints(
                      maxWidth:
                          widget.messageData['type'] == 'audio' ? 370 : 220),
                  padding: EdgeInsets.symmetric(
                    vertical: sy(3),
                  ),
                  child: Bubble(
                    style: BubbleStyle(
                      radius: Radius.circular(10),
                      padding: BubbleEdges.all(
                        sy(7),
                      ),
                    ),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (widget.messageData['type'] == 'image')
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => _showSecondPage(
                                        context, widget.messageData['url'])),
                              );
                            },
                            child: Container(
                              width: 150,
                              child: Image.network(
                                widget.messageData['url'],
                              ),
                            ),
                          ),
                        if (widget.messageData['type'] == 'image' &&
                            widget.messageData['message'] != '')
                          SizedBox(height: sy(5)),
                        if (widget.messageData['type'] == 'video')
                          Container(
                              width: 250,
                              child: VideoPlayerWidget(
                                key: key,
                                videoUrl: widget.messageData['url'],
                              )),
                        if (widget.messageData['type'] == 'audio')
                          Container(
                              width: 250,
                              child: AudioPlayerWidget(
                                key: key,
                                audioUrl: widget.messageData['url'],
                              )),
                        if (widget.messageData['message'] != '')
                          SelectableText(
                            widget.messageData['message'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        SizedBox(
                          height: sy(10),
                        ),
                        Text(
                          timeago.format(DateTime.now().subtract(
                              DateTime.now().difference(messageTime))),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: sy(8),
                          ),
                        ),
                        //gallery-image//
                      ],
                    ),
                  ),
                ),
              ],
            );
    });
  }

  _showSecondPage(BuildContext context, String imageUrl) {
    return WillPopScope(
        // ignore: missing_return
        onWillPop: () async {
          FocusScope.of(context).unfocus();
          Navigator.of(context).pop();
          return true;
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: InkWell(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.arrow_back)),
            ),
            body: Container(
              color: Colors.white,
              height: double.infinity,
              width: double.infinity,
              child: PhotoView(
                imageProvider: NetworkImage(imageUrl),
                basePosition: Alignment(0.5, 0.0),
              ),
            )));
  }
}
