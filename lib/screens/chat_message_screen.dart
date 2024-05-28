import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/chatProvider.dart';
import 'package:mystory_flutter/providers/invite_member.dart';
import 'package:mystory_flutter/providers/media_gallery_provider.dart';
import 'package:mystory_flutter/services/sound_services.dart';
import 'package:mystory_flutter/services/storage_service.dart';
import 'package:mystory_flutter/services/util_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:provider/provider.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:mystory_flutter/widgets/chat_message_tile.dart';
import '../global.dart';
import '../services/navigation_service.dart';
import '../utils/service_locator.dart';
import 'package:flutter/foundation.dart' as foundation;

class ChatMessageScreen extends StatefulWidget {
  var familyMember;

  ChatMessageScreen(this.familyMember);

  @override
  _ChatMessageScreenState createState() => _ChatMessageScreenState();
}

class _ChatMessageScreenState extends State<ChatMessageScreen>
    with WidgetsBindingObserver {
  var navigationService = locator<NavigationService>();
  var utilService = locator<UtilService>();
  var soundService = SoundService();
  final double minValue = 8.0;
  final double iconSize = 28.0;
  FocusNode? _focusNode;

  TextEditingController _txtController = TextEditingController();
  bool emojiShowing = false;
  bool isCurrentUserTyping = false;
  ScrollController? _scrollController;
  String imgURL = '';
  String inAppImgURL = '';
  bool isNetworkImage = false;
  String videoURL = '';
  String message = '';

  var isLoading = false;
  var user;

  void _scrollToLast() {
    _scrollController!.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    setStatus("Online");
    _scrollController = ScrollController(initialScrollOffset: 0);
    soundService.init();
    _focusNode = FocusNode();
    _focusNode!.addListener(() {
      print('Something happened');
    });
    user = Provider.of<AuthProviderr>(context, listen: false).user;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }

  @override
  void dispose() {
    _scrollController!.dispose();
    soundService.dispose();
    super.dispose();
  }

  void onTextFieldTapped() {}

  void _onMessageChanged(String value) {
    setState(() {
      message = value;
      if (value.trim().isEmpty) {
        isCurrentUserTyping = false;
        return;
      } else {
        isCurrentUserTyping = true;
      }
    });
  }

  // ignore: unused_element
  void _like() {}

  // void _sendMessage() {
  //   setState(() {
  //     myMessages.insert(
  //         0, (Message(messageBody: message, senderId: currentUser.userId)));
  //     message = '';
  //     _txtController.text = '';
  //   });
  //   _scrollToLast();
  // }

  // void _scrollToLast() {
  //   _scrollController!.animateTo(
  //     0.0,
  //     curve: Curves.easeOut,
  //     duration: const Duration(milliseconds: 300),
  //   );
  // }
  _onEmojiSelected(Emoji emoji) {
    _txtController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _txtController.text.length));
  }

  _onBackspacePressed() {
    _txtController
      ..text = _txtController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _txtController.text.length));
  }

  @override
  Widget build(BuildContext context) {
    bool isRecording = soundService.isRecording;
    return RelativeBuilder(builder: (context, height, width, sy, sx) {
      return Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              // margin: EdgeInsets.fromLTRB(5, 30, 5, 0),
              padding: EdgeInsets.fromLTRB(2, 50, 5, 10),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      IconButton(
                          color: Colors.black,
                          icon: Icon(
                            Icons.arrow_back,
                            size: sy(18),
                          ),
                          onPressed: () async {
                            await context
                                .read<ChatProvider>()
                                .resetUnreadCount(context);
                            navigationService.closeScreen();
                          }),
                      SizedBox(
                        width: sx(5),
                      ),
                      GestureDetector(
                        onTap: () async {
                          // showLoadingAnimation(context);
                          // await Provider.of<InviteProvider>(context,
                          //         listen: false)
                          //     .fetchSearchUserDetail(
                          //         myId: user.id,
                          //         viewuserId: widget.familyMember['id'])
                          //     .then((value) {
                          //   Navigator.pop(context);
                          //   Provider.of<InviteProvider>(context, listen: false)
                          //       .setFamilyData(context
                          //           .read<InviteProvider>()
                          //           .searchUserData);
                          //   navigationService
                          //       .navigateTo(FamilyMemberProfileScreenRoute);
                          // });
                        },
                        child: Container(
                          height: sy(30),
                          width: sy(30),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image:
                                  NetworkImage(widget.familyMember['profile']),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: sx(20),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(sx(5), 1, sx(5), 1),
                            color: widget.familyMember['relation'] == ""
                                ? Colors.transparent
                                : Theme.of(context).indicatorColor,
                            child: Text(
                              widget.familyMember['relation'],
                              style: TextStyle(
                                fontSize: sy(7),
                                color: Colors.grey.shade700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          Text(
                            widget.familyMember['name'],
                            style: TextStyle(
                              fontSize: sy(10),
                              color: Colors.black,
                              letterSpacing: 0.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: sy(1),
                          ),
                          Text(
                            '@' + widget.familyMember['name'],
                            style: TextStyle(
                              fontSize: sy(7),
                              color: Colors.grey,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // IconButton(
                  //     icon: Icon(
                  //       Icons.more_vert,
                  //       color: Colors.black,
                  //       size: sy(15),
                  //     ),
                  //     onPressed: () => null)
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .doc(context.read<ChatProvider>().chatRoomId)
                      .collection('conversation')
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          reverse: true,
                          controller: _scrollController,
                          padding: EdgeInsets.symmetric(
                              vertical: minValue * 2, horizontal: minValue),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> chatMap =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;
                            print(chatMap['senderId']);
                            // final Message message = myMessages[index];
                            return MyMessageChatTile(
                              memberProfilePic: widget.familyMember['profile'],
                              messageData: chatMap,
                              isCurrentUser: chatMap['senderId'] ==
                                      context.read<AuthProviderr>().user.id
                                  ? true
                                  : false,
                            );
                          });
                    } else {
                      return Container();
                    }
                  }),
            ),
            // if (imgURL != '')
            imgURL != ''
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              child: Image.file(
                                File(imgURL),
                                height: 100,
                              ),
                            ),
                            Positioned(
                              top: -10,
                              right: -10,
                              child: IconButton(
                                onPressed: () {
                                  imgURL = '';

                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : inAppImgURL != ''
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  child: Image.network(
                                    inAppImgURL,
                                    height: 100,
                                  ),
                                ),
                                Positioned(
                                  top: -10,
                                  right: -10,
                                  child: IconButton(
                                    onPressed: () {
                                      inAppImgURL = '';

                                      setState(() {});
                                    },
                                    icon: Icon(
                                      Icons.cancel,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container(),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              height: 50,
              // _txtController.text.length == 0
              //     ? 50
              //     : _txtController.text.length.toDouble(),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    sy(10),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {
                        emojiShowing = !emojiShowing;
                      });
                    },
                    icon: const Icon(
                      Icons.emoji_emotions_outlined,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      focusNode: _focusNode,
                      // keyboardType: TextInputType.text,
                      controller: _txtController,
                      onChanged: _onMessageChanged,
                      decoration: InputDecoration(
                        // prefixIcon: Padding(
                        //   padding: EdgeInsets.only(
                        //     right: sx(20),
                        //   ),
                        // ),
                        border: InputBorder.none,
                        hintText: "Write a message...",
                      ),
                      autofocus: false,
                      onTap: () {
                        setState(() {
                          emojiShowing = false;
                        });
                      },
                    ),
                  ),

                  IconButton(
                    icon: Image.asset(
                      'assets/images/Frame.png',
                      scale: 2.5,
                    ),
                    onPressed: () {
                      showBottomSheet(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: sy(5),
                      bottom: sy(5),
                    ),
                    child: VerticalDivider(),
                  ),
                  // isCurrentUserTyping
                  //     ? Container()
                  //     :
                  _txtController.text == ''
                      ? isRecording
                          ? IconButton(
                              onPressed: () async {
                                await soundService.toggoleRecording(context);
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.record_voice_over_rounded,
                                color: Colors.red,
                              ))
                          : IconButton(
                              onPressed: () async {
                                await soundService.toggoleRecording(context);
                                setState(() {});
                              },
                              icon: Image.asset(
                                'assets/images/audio.png',
                                scale: 4,
                              ))
                      : IconButton(
                          icon: Image.asset(
                            'assets/images/Group 33611.png',
                            scale: 4,
                          ),
                          onPressed: () async {
                            if (imgURL == '' &&
                                inAppImgURL == '' &&
                                _txtController.text != '') {
                              context
                                  .read<ChatProvider>()
                                  .sendMessage(_txtController.text);

                              var count =
                                  context.read<ChatProvider>().getUnreadCount;
                              await context
                                  .read<ChatProvider>()
                                  .updateUnreadCount(count, message);
                              _scrollToLast();
                              _txtController.clear();
                            } else if (imgURL != '') {
                              showLoadingAnimation(context);
                              String imageURL =
                                  await utilService.sendImageForChat(imgURL);
                              await context
                                  .read<ChatProvider>()
                                  .sendMediaMessage(imageURL,
                                      message: _txtController.text)
                                  .then((_) {
                                _txtController.text = '';
                                imgURL = '';
                                setState(() {});
                                Navigator.pop(context);
                              });
                            } else if (inAppImgURL != '') {
                              print('working inappimageurl');
                              showLoadingAnimation(context);
                              // String imageURL =
                              // await utilService.sendImageForChat(inAppImgURL);
                              await context
                                  .read<ChatProvider>()
                                  .sendMediaMessage(inAppImgURL,
                                      message: _txtController.text)
                                  .then((_) {
                                _txtController.text = '';
                                inAppImgURL = '';
                                setState(() {});
                                Navigator.pop(context);
                              });
                            }
                          },
                        ),
                ],
              ),
            ),
            SizedBox(
              height: Platform.isIOS ? 20 : 0,
            ),
            Offstage(
                offstage: !emojiShowing,
                child: SizedBox(
                  height: 250,
                  child: EmojiPicker(
                    onEmojiSelected: (Category? category, Emoji emoji) {
                      _onEmojiSelected(emoji);
                    },
                    onBackspacePressed: _onBackspacePressed,
                    config: Config(
                        emojiViewConfig: EmojiViewConfig(
                            // Issue: https://github.com/flutter/flutter/issues/28894
                            emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                            recentsLimit: 28,
                            backgroundColor: const Color(0xFFF2F2F2),
                            columns: 7,
                            verticalSpacing: 0,
                            horizontalSpacing: 0,
                            buttonMode: ButtonMode.MATERIAL,

                            replaceEmojiOnLimitExceed: true)
                        // columns: 7,
                        // Issue: https://github.com/flutter/flutter/issues/28894
                        //verticalSpacing: 0,
                        //horizontalSpacing: 0,
                        //initCategory: Category.RECENT,
                        //bgColor: const Color(0xFFF2F2F2),
                        //indicatorColor: Colors.blue,
                        //iconColor: Colors.grey,
                        //iconColorSelected: Colors.blue,
                        //progressIndicatorColor: Colors.blue,
                        //backspaceColor: Colors.blue,
                        //skinToneDialogBgColor: Colors.white,
                        //skinToneIndicatorColor: Colors.grey,
                        //enableSkinTones: true,
                        //showRecentsTab: true,
                        // recentsLimit: 28,
                        //noRecentsText: 'No Recents',
                        //noRecentsStyle: const TextStyle(
                        //    fontSize: 20, color: Colors.black26),
                        //tabIndicatorAnimDuration: kTabScrollDuration,
                        //categoryIcons: const CategoryIcons(),
                        //buttonMode: ButtonMode.MATERIAL)),
                        ),
                  ),
                ))
          ],
        ),
      );
    });
  }

  void showBottomSheet(context) {
    final chatPro = Provider.of<ChatProvider>(context, listen: false);
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: Colors.white,
            child: Wrap(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('Upload Media',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      )),
                ),
                Divider(),
                ListTile(
                  trailing: Icon(Icons.keyboard_arrow_right),
                  leading: Container(
                    height: 38.h,
                    width: 35.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        border: Border.all(color: Colors.black12, width: 0.1),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .indicatorColor
                                .withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        image: DecorationImage(
                            image: AssetImage("assets/images/app gallery.png"),
                            fit: BoxFit.fill)),
                  ),
                  title: Text('Photo Library',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        color: Colors.black,
                      )),
                  onTap: () async {
                    Navigator.pop(context);
                    imgURL = await utilService.browseImageForChat();
                    _txtController.text = ' ';
                    setState(() {});
                  },
                ),
                ListTile(
                  trailing: Icon(Icons.keyboard_arrow_right),
                  leading: Container(
                    height: 38.h,
                    width: 35.h,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(0),
                        border: Border.all(color: Colors.black12, width: 0.1),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .indicatorColor
                                .withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        image: DecorationImage(
                            image: AssetImage("assets/images/camera.png"),
                            scale: 3
                            // fit: BoxFit.fill
                            )),
                  ),
                  title: Text('Camera',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        color: Colors.black,
                      )),
                  onTap: () async {
                    Navigator.pop(context);
                    imgURL = await utilService.captureImageForChat();
                    _txtController.text = ' ';
                    setState(() {});
                  },
                ),
                ListTile(
                  trailing: Icon(Icons.keyboard_arrow_right),
                  leading: Container(
                    height: 38.h,
                    width: 35.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        border: Border.all(color: Colors.black12, width: 0.1),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .indicatorColor
                                .withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        image: DecorationImage(
                          image: AssetImage("assets/images/gallery.png"),
                          fit: BoxFit.fill,
                        )),
                  ),
                  title: Text('Video Library',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        color: Colors.black,
                      )),
                  onTap: () async {
                    Navigator.pop(context);
                    showLoadingAnimation(context);
                    await utilService.browseVideoForChat(context).then((url) {
                      if (url == "") {
                        Navigator.pop(context);
                      } else {
                        Provider.of<ChatProvider>(context, listen: false)
                            .sendMediaMessage(url, type: 'video');
                        Navigator.pop(context);
                      }
                    });
                    // Navigator.pop(context);
                  },
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: new ListTile(
                    leading: Container(
                      height: 38.h,
                      width: 35.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          border: Border.all(color: Colors.black12, width: 0.1),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .indicatorColor
                                  .withOpacity(0.2),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          image: DecorationImage(
                              image:
                                  AssetImage("assets/images/app gallery.png"),
                              fit: BoxFit.fill)),
                    ),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    title: Text('App Gallery',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          color: Colors.black,
                        )),
                    onTap: () async {
                      Provider.of<MediaGalleryProvider>(context, listen: false)
                          .ImageUrlForChat = '';
                      Provider.of<MediaGalleryProvider>(context, listen: false)
                          .mediaGalleryRoute = "chat screen";
                      // var storageService = locator<StorageService>();
                      // await storageService.setData(
                      //     "route", "/create-story-screen");
                      await navigationService
                          .navigateTo(MediaGalleryScreenRoute);
                      inAppImgURL = Provider.of<MediaGalleryProvider>(context,
                              listen: false)
                          .ImageUrlForChat;
                      print('arsalan a here');
                      print(inAppImgURL);
                      print('arsalan a here');
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

// Widget _buildBottomSection() {
//   return RelativeBuilder(builder: (context, height, width, sy, sx) {
//     return Row(
//       children: <Widget>[
//         Expanded(
//           child:
//         ),
//       ],
//     );
//   });
// }
}
