import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:like_button/like_button.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/invite_member.dart';
import 'package:mystory_flutter/providers/linkStories_familytree&storybook_provider.dart';
import 'package:mystory_flutter/providers/post_provider.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/services/storage_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:mystory_flutter/widgets/cache_image.dart';
import 'package:mystory_flutter/widgets/gallery-pkg/galleryimage.dart';
import 'package:mystory_flutter/screens/post_comments_screen.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

import '../global.dart';

class LinkedStoryBookWidget extends StatefulWidget {
  final data;
  int? index;

  LinkedStoryBookWidget({
    this.data,
  });

  @override
  _LinkedStoryBookWidgetState createState() => _LinkedStoryBookWidgetState();
}

class _LinkedStoryBookWidgetState extends State<LinkedStoryBookWidget> {
  var navigationService = locator<NavigationService>();
  var formatted;
  bool like = false;
  bool isShow = false;
  // var snapLength;
  // bool _enabled = true;
  var user;
  // void _onTap() async {
  //   // Disable GestureDetector's 'onTap' property.
  //   setState(() => _enabled = false);

  //   // Enable it after 1s.
  //   Timer(Duration(seconds: 1), () => setState(() => _enabled = true));

  //   await Provider.of<PostProvider>(context, listen: false).likePostByUser(
  //     postId: widget.data["id"],
  //     addedById: user.id,
  //     entityUserID: widget.data["addedById"],
  //     addedByName: widget.data["addedByName"],
  //     addedByProfilePic: widget.data["addedByProfilePic"],
  //   );
  // }
  // bool isLinkEnable = false;
  // int count = 5;
  // Timer? linkTimer;
  // void timerActive() {
  //   count = 5;
  //   linkTimer = Timer.periodic(Duration(seconds: 1), (timer) {
  //     print('object');

  //     setState(() {
  //       count--;
  //     });
  //     if (count == 0) {
  //       isLinkEnable = true;
  //       linkTimer!.cancel();
  //     }
  //   });
  // }

  @override
  void initState() {
    user = Provider.of<AuthProviderr>(context, listen: false).user;

    super.initState();
  }

  void tagUserClick() async {
    showLoadingAnimation(context);
    await Provider.of<InviteProvider>(context, listen: false)
        .fetchSearchUserDetail(
            myId: user.id, viewuserId: widget.data["addedById"])
        .then((value) async {
      Navigator.pop(context);
      Provider.of<InviteProvider>(context, listen: false)
          .setFamilyData(context.read<InviteProvider>().searchUserData);
      var storageService = locator<StorageService>();
      await storageService.setData("route", "/maindeshboard-screen");
      navigationService.navigateTo(FamilyMemberProfileScreenRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    Provider.of<PostProvider>(context, listen: false)
        .setTempData(widget.data["media"]);
    formatted = timeago.format(
        DateTime.fromMillisecondsSinceEpoch(widget.data["createdOnDate"]));
    ScreenUtil.init(
      context,
      //BoxConstraints(
      //    maxWidth: MediaQuery.of(context).size.width,
      //    maxHeight: MediaQuery.of(context).size.height),
      designSize: Size(360, 690),
      //orientation: Orientation.portrait
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (user.id == widget.data["addedById"]) {
                        navigationService.navigateTo(MyProfileScreenRoute);
                      } else {
                        showLoadingAnimation(context);
                        await Provider.of<InviteProvider>(context,
                                listen: false)
                            .fetchSearchUserDetail(
                                myId: user.id,
                                viewuserId: widget.data["addedById"])
                            .then((value) async {
                          Navigator.pop(context);
                          Provider.of<InviteProvider>(context, listen: false)
                              .setFamilyData(context
                                  .read<InviteProvider>()
                                  .searchUserData);
                          var storageService = locator<StorageService>();
                          await storageService.setData(
                              "route", "/maindeshboard-screen");
                          navigationService
                              .navigateTo(FamilyMemberProfileScreenRoute);
                        });
                      }
                    },
                    child: Container(
                      child: widget.data["addedByProfilePic"] == ""
                          ? CircleAvatar(
                              radius: height * 0.035,
                              backgroundImage:
                                  AssetImage("assets/images/place_holder.png"),
                            )
                          : user.id == widget.data["addedById"]
                              ? CircleAvatar(
                                  radius: height * 0.035,
                                  backgroundColor: Colors.transparent,
                                  child: CacheImage(
                                    placeHolder: "place_holder.png",
                                    imageUrl: user.profilePicture,
                                    height: 100,
                                    width: 100,
                                    radius: 100,
                                  ),
                                )
                              : CircleAvatar(
                                  radius: height * 0.035,
                                  backgroundColor: Colors.transparent,
                                  child: CacheImage(
                                    placeHolder: "place_holder.png",
                                    imageUrl: widget.data["addedByProfilePic"],
                                    height: 100,
                                    width: 100,
                                    radius: 100,
                                  ),
                                ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 200.w,
                        child: Text(
                          user.id == widget.data["addedById"]
                              ? "${user.firstName} ${user.lastName}"
                              : widget.data['addedByName'],
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      Container(
                        width: 150.w,
                        child: Row(
                          children: [
                            Text(
                              formatted,
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                  height: 1.5),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Row(
          children: [
            Text(
              widget.data['storyTitle'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
            ),
          ],
        ),
        SizedBox(
          height: 3,
        ),
        !isShow && widget.data["description"].length > 90
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MarkdownBody(
                    data: _replaceMentions(
                            widget.data["description"].substring(0, 60),
                            context)
                        .replaceAll('\n', '\\\n'),
                    builders: {
                      "coloredBox": ColoredBoxMarkdownElementBuilder(
                          context,
                          context.read<PostProvider>().fetchMSCatByIdAllTN,
                          'APPSTIRR',
                          tagUserClick),
                    },
                    inlineSyntaxes: [
                      ColoredBoxInlineSyntax(),
                    ],
                    styleSheet: MarkdownStyleSheet.fromTheme(
                      Theme.of(context).copyWith(
                        textTheme: Theme.of(context).textTheme.apply(
                              bodyColor: Colors.black,

                              // fontSizeDelta: 5.sp,
                              // fontSizeFactor: 14.sp,
                            ),
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          isShow = !isShow;
                        });
                      },
                      child: Text(
                        '..Show more',
                        style: TextStyle(
                            color: Theme.of(context).backgroundColor,
                            fontWeight: FontWeight.w500),
                      ))
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MarkdownBody(
                    data: _replaceMentions(widget.data["description"], context)
                        .replaceAll('\n', '\\\n'),
                    builders: {
                      "coloredBox": ColoredBoxMarkdownElementBuilder(
                          context,
                          context.read<PostProvider>().fetchMSCatByIdAllTN,
                          'APPSTIRR',
                          tagUserClick),
                    },
                    inlineSyntaxes: [
                      ColoredBoxInlineSyntax(),
                    ],
                    styleSheet: MarkdownStyleSheet.fromTheme(
                      Theme.of(context).copyWith(
                        textTheme: Theme.of(context).textTheme.apply(
                              bodyColor: Colors.black,

                              // fontSizeDelta: 5.sp,
                              // fontSizeFactor: 14.sp,
                            ),
                      ),
                    ),
                  ),
                  widget.data["description"].length > 90
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              isShow = !isShow;
                            });
                          },
                          child: Text(
                            '..Show less',
                            style: TextStyle(
                                color: Theme.of(context).backgroundColor,
                                fontWeight: FontWeight.w500),
                          ))
                      : Container()
                ],
              ),

        // HashTagText(
        //   text: widget.data["description"],
        //   textAlign: TextAlign.start,
        //   decoratedStyle: TextStyle(
        //       fontSize: 14.sp,
        //       color: Colors.black,
        //       fontWeight: FontWeight.bold),
        //   basicStyle: TextStyle(fontSize: 14.sp, color: Colors.black),
        //   onTap: (text) {
        //     print(text);
        //   },
        // ),
        SizedBox(
          height: 15.h,
        ),
        widget.data["media"].isEmpty
            ? Container()
            : GalleryImage(key: UniqueKey(), imageUrls: widget.data["media"]
                // images
                ),
        SizedBox(
          height: 25,
        ),
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("post")
                          .doc(widget.data["id"])
                          .collection('like')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError)
                          return Center(
                              child: Text('${snapshot.error.toString()}'));
                        if (snapshot.hasData) {
                          var likeLength = snapshot.data!.docs.length;
                          return LikeButton(
                            onTap: (bool isLiked) async {
                              await Provider.of<PostProvider>(context,
                                      listen: false)
                                  .likePostByUser(
                                    context: context,
                                      postId: widget.data["id"],
                                      addedById: user.id,
                                      entityUserID: widget.data["addedById"],
                                      addedByName:
                                          user.firstName + user.lastName,
                                      addedByProfilePic: user.profilePicture);
                              return !isLiked;
                            },
                            size: 20,
                            circleColor: CircleColor(
                                start: Color(0xff00ddff),
                                end: Color(0xff0099cc)),
                            bubblesColor: BubblesColor(
                              dotPrimaryColor: Color(0xff33b5e5),
                              dotSecondaryColor: Color(0xff0099cc),
                            ),
                            likeBuilder: (bool isLiked) {
                              return Icon(
                                Icons.favorite,
                                color:
                                    likeLength == 0 ? Colors.grey : Colors.red,
                                size: 20,
                              );
                            },
                            likeCount: likeLength == 0 ? 0 : likeLength,
                          );
                        } else {
                          return Center(
                              child: SpinKitThreeInOut(
                            color: Theme.of(context).backgroundColor,
                            size: 10.0,
                            duration: const Duration(milliseconds: 1200),
                          ));
                        }
                      }),

                  SizedBox(
                    width: 15.w,
                  ),
                  InkWell(
                    onTap: () async {
                      var storageService = locator<StorageService>();
                      await storageService.setData(
                          "route",
                          context.read<LinkFamilyStoryProvider>().linkRoute ==
                                  "ProfileScreen"
                              ? "/myprofile-screen"
                              : "/family-member-profile-screen");

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PostCommentsScreen(
                                  data: widget.data,
                                  date: formatted,
                                )),
                      );
                      // navigationService.navigateTo(PostCommentsScreenRoute);
                    },
                    child: Image.asset(
                      "assets/images/Comment.png",
                      scale: 3,
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("post")
                          .doc(widget.data["id"].toString())
                          .collection('comment')
                          .orderBy('createdOnDate')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError)
                          return Center(
                              child: Text('${snapshot.error.toString()}'));
                        if (snapshot.hasData) {
                          var commentLength = snapshot.data!.docs.length;
                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                                commentLength == 0
                                    ? "0"
                                    : commentLength.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                          );
                        } else {
                          return Center(
                              child: SpinKitThreeInOut(
                            color: Theme.of(context).backgroundColor,
                            size: 10.0,
                            duration: const Duration(milliseconds: 1200),
                          ));
                        }
                      }),

                  // StreamBuilder<QuerySnapshot>(
                  //     stream: FirebaseFirestore.instance
                  //         .collection("post")
                  //         .doc(widget.data["id"].toString())
                  //         .collection('comment')
                  //         .orderBy('createdOnDate')
                  //         .snapshots(),
                  //     builder: (context, snapshot) {
                  //       var commentLength = snapshot.data!.docs.length;

                  //         return Padding(
                  //           padding: const EdgeInsets.only(left: 8.0),
                  //           child: Text(
                  //               commentLength == 0
                  //                   ? "0"
                  //                   : commentLength.toString(),
                  //               style: TextStyle(
                  //                 fontWeight: FontWeight.bold,
                  //               )),
                  //         );

                  //     }),

                  SizedBox(
                    width: 15.w,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Share.share("text");
                    },
                    child: Image.asset(
                      "assets/images/Share.png",
                      scale: 3,
                    ),
                  ),
                  // Text(" 0",
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //     )),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  // Widget _buildBottomSection() {
  //   return RelativeBuilder(builder: (context, height, width, sy, sx) {
  //     return Row(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       children: <Widget>[
  //         Container(
  //           // width: sx(400),
  //           height: sy(33),
  //           margin: EdgeInsets.all(minValue),
  //           padding: EdgeInsets.symmetric(horizontal: minValue),
  //           decoration: BoxDecoration(
  //             color: Color.fromRGBO(233, 233, 233, 1),
  //             borderRadius: BorderRadius.all(
  //               Radius.circular(
  //                 sy(50),
  //               ),
  //             ),
  //           ),
  //           child: Row(
  //             children: <Widget>[
  //               SizedBox(
  //                 width: minValue,
  //               ),
  //               Expanded(
  //                 child: TextField(
  //                   focusNode: _focusNode,
  //                   keyboardType: TextInputType.text,
  //                   controller: _txtController,
  //                   // onChanged: _onMessageChanged,

  //                   decoration: InputDecoration(
  //                     contentPadding: EdgeInsets.symmetric(
  //                       horizontal: sx(14),
  //                       vertical: sy(11),
  //                     ),
  //                     border: InputBorder.none,
  //                     hintText: "write a comment....",
  //                   ),
  //                   autofocus: false,
  //                   onTap: () {},
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Container(
  //           height: 45.h,
  //           width: 52.w,
  //           decoration: BoxDecoration(
  //             image: DecorationImage(
  //               fit: BoxFit.fill,
  //               image: AssetImage(
  //                 "assets/images/Group 933.png",
  //               ),
  //             ),
  //           ),
  //           child: Center(
  //             child: Image.asset(
  //               "assets/images/Send.png",
  //               scale: 3.5,
  //               color: Colors.white,
  //             ),
  //           ),
  //         )
  //         // CircleAvatar(
  //         //   radius: sy(16),
  //         //   backgroundImage: AssetImage(
  //         //     "assets/images/Group 33611.png",
  //         //   ),
  //         // ),
  //       ],
  //     );
  //   });
  // }
  String _replaceMentions(String text, BuildContext context) {
    context
        .read<LinkFamilyStoryProvider>()
        .fetchTagUserColorLinkStory
        .map((u) => u)
        .toSet()
        .forEach((userName) {
      text = text.replaceAll('@$userName', '[@$userName]');
    });
    return text;
  }
}

class ColoredBoxInlineSyntax extends md.InlineSyntax {
  ColoredBoxInlineSyntax({
    String pattern = r'\[(.*?)\]',
  }) : super(pattern);

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final withoutBracket1 = match.group(0)!.replaceAll('[', "");
    final withoutBracket2 = withoutBracket1.replaceAll(']', "");
    md.Element mentionedElement =
        md.Element.text("coloredBox", withoutBracket2);
    parser.addNode(mentionedElement);
    return true;
  }
}

class ColoredBoxMarkdownElementBuilder extends MarkdownElementBuilder {
  final BuildContext context;
  final List<String> mentionedUsers;
  final String myName;
  final Function ontap;
  ColoredBoxMarkdownElementBuilder(
      this.context, this.mentionedUsers, this.myName, this.ontap);

  @override
  Widget visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    return GestureDetector(
      onTap: () {
        ontap();
      },
      child: Container(
        margin: EdgeInsets.only(left: 0, right: 0, top: 2, bottom: 2),
        child: Padding(
          padding: element.textContent.contains(myName)
              ? EdgeInsets.all(4.0)
              : EdgeInsets.all(0),
          child: Text(
            element.textContent,
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  bool checkIfFormattingNeeded(String text) {
    var checkIfFormattingNeeded = false;
    if (mentionedUsers != null && mentionedUsers.isNotEmpty) {
      if (mentionedUsers.contains(text) || mentionedUsers.contains(myName)) {
        checkIfFormattingNeeded = true;
      } else {
        checkIfFormattingNeeded = false;
      }
    }
    return checkIfFormattingNeeded;
  }
}
