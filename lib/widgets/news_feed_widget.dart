import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:like_button/like_button.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/invite_member.dart';
import 'package:mystory_flutter/providers/media_gallery_provider.dart';
import 'package:mystory_flutter/providers/post_provider.dart';
import 'package:mystory_flutter/screens/create_story_screen.dart';
import 'package:mystory_flutter/screens/family_member_profile_screen.dart';
import 'package:mystory_flutter/services/dynamic_link_service.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/services/storage_service.dart';
import 'package:mystory_flutter/services/util_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:mystory_flutter/widgets/cache_image.dart';
import 'package:mystory_flutter/widgets/gallery-pkg/galleryimage.dart';
import 'package:mystory_flutter/screens/post_comments_screen.dart';
import 'package:mystory_flutter/widgets/read_more_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

import '../global.dart';
import 'delete_popup_widget.dart';

class NewsFeedWidget extends StatefulWidget {
  final data;
  final Function(bool)? callback;
  int? index;
  String? subCatID;
  String? route;
  String? userId;

  NewsFeedWidget(
      {this.data, this.callback, this.subCatID, this.index, this.route});

  @override
  _NewsFeedWidgetState createState() => _NewsFeedWidgetState();
}

class _NewsFeedWidgetState extends State<NewsFeedWidget> {
  var navigationService = locator<NavigationService>();
  var dynamicLink = locator<DynamicLinksService>();
  var formatted;
  bool like = false;
  bool isShow = false;
  ScreenshotController screenshotController = ScreenshotController();
  String postAddedByName = "";
  String socialShareText =
      "I am sharing a story from my Storybook. Check out MyStory - you can capture your life's story and share with family and friends today, and future generations, forever! It's free - download the app today! www.mystoryforlife.com";
  UtilService? utilService = locator<UtilService>();

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
  List<String> descriptionList = [];
  List<String> pickTagName = [];
  List<String> removeFirstChFromPickTagName = [];
  List<QueryDocumentSnapshot<Object?>> allUsers = [];

  @override
  void initState() {
    user = Provider.of<AuthProviderr>(context, listen: false).user;
    allUsers =
        Provider.of<AuthProviderr>(context, listen: false).allUserDataList;
    widget.data["description"]
        .split(' ')
        .forEach((ch) => descriptionList.add(ch));
    pickTagName.addAll(descriptionList.where((item) => item.contains('@')));

    for (int i = 0; i < pickTagName.length; i++) {
      removeFirstChFromPickTagName.add(pickTagName[i].substring(1));
    }
    for (var j = 0; j < removeFirstChFromPickTagName.length; j++) {
      for (int x = 0; x < widget.data["taggedUser"].length; x++) {}
    }

    // for(var data in allUsers){
    //   if(data["id"]==widget.data["addedById"]){
    //     postAddedByName = data["fullName"];
    //     break;
    //   }
    // }
    // timerActive();
    super.initState();
  }

  // deleteNewsFeed() async {
  //   setState(() {
  //     widget.callback!(true);
  //   });
  //   await Provider.of<PostProvider>(context, listen: false).deleteStoryPost(
  //       route: widget.route,
  //       index: widget.index,
  //       context: context,
  //       data: widget.data,
  //       subID: widget.subCatID);

  //   setState(() {
  //     widget.callback!(false);
  //   });
  // }
  deleteNewsFeed() async {
    showLoadingAnimation(context);
    await Provider.of<PostProvider>(context, listen: false)
        .deleteStoryPost(
            route: widget.route,
            index: widget.index,
            context: context,
            data: widget.data,
            subID: widget.subCatID)
        .then((_) {
      Navigator.pop(context);
      navigationService.navigateTo(MaindeshboardRoute);
    });
  }

  void tagUserClick() async {
    // showLoadingAnimation(context);
    // await Provider.of<InviteProvider>(context, listen: false)
    //     .fetchSearchUserDetail(
    //         myId: user.id, viewuserId: widget.data["addedById"])
    //     .then((value) async {
    //   Navigator.pop(context);
    //   Provider.of<InviteProvider>(context, listen: false)
    //       .setFamilyData(context.read<InviteProvider>().searchUserData);
    //   var storageService = locator<StorageService>();
    //   await storageService.setData("route", "/maindeshboard-screen");
    //   navigationService.navigateTo(FamilyMemberProfileScreenRoute);
    // });
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
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7)),
          side: BorderSide(width: 0.2, color: Colors.grey)),

      //* Changed UI  by chetu on 28 aug //

      child: Container(
        padding: EdgeInsets.all(15),
        color: Colors.white,
        child: Column(
          children: [
            Screenshot(
                controller: screenshotController,
                child: Column(
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
                                    context.read<AuthProviderr>().tempRoute =
                                        "/maindeshboard-screen";
                                    var storageService =
                                        locator<StorageService>();
                                    await storageService.setData(
                                        "route", "/maindeshboard-screen");
                                    navigationService
                                        .navigateTo(MyProfileScreenRoute);
                                  } else {
                                    showLoadingAnimation(context);
                                    await Provider.of<InviteProvider>(context,
                                            listen: false)
                                        .fetchSearchUserDetail(
                                            myId: user.id,
                                            viewuserId:
                                                widget.data["addedById"])
                                        .then((value) async {
                                      Navigator.pop(context);
                                      Provider.of<InviteProvider>(context,
                                              listen: false)
                                          .setFamilyData(context
                                              .read<InviteProvider>()
                                              .searchUserData);
                                      var storageService =
                                          locator<StorageService>();
                                      await storageService.setData(
                                          "route", "/maindeshboard-screen");
                                      navigationService.navigateTo(
                                          FamilyMemberProfileScreenRoute);
                                    });
                                  }
                                },
                                child: Container(
                                  child: widget.data["addedByProfilePic"] == ""
                                      ? CircleAvatar(
                                          radius: height * 0.03,
                                          backgroundImage: AssetImage(
                                              "assets/images/place_holder.png"),
                                        )
                                      : user.id == widget.data["addedById"]
                                          ? CircleAvatar(
                                              radius: height * 0.03,
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: CacheImage(
                                                placeHolder: "place_holder.png",
                                                imageUrl: user.profilePicture,
                                                height: 100,
                                                width: 100,
                                                radius: 100,
                                              ),
                                            )
                                          : CircleAvatar(
                                              radius: height * 0.03,
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: CacheImage(
                                                placeHolder: "place_holder.png",
                                                imageUrl: widget
                                                    .data["addedByProfilePic"],
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
                                          //  : postAddedByName,
                                          : widget.data['addedByName'],
                                      // commented bt chetu
                                      style: TextStyle(
                                        fontSize: 14.sp,
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
                          widget.data["addedById"] == user.id
                              ? FocusedMenuHolder(
                                  menuWidth:
                                      MediaQuery.of(context).size.width * 0.50,
                                  blurSize: 0,
                                  menuItemExtent: 45,
                                  menuBoxDecoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0))),
                                  duration: Duration(milliseconds: 100),
                                  animateMenuItems: true,
                                  blurBackgroundColor: Colors.black54,
                                  bottomOffsetHeight: 100,
                                  openWithTap: true,
                                  menuItems: <FocusedMenuItem>[
                                    FocusedMenuItem(
                                        title: Text("Edit"),
                                        trailingIcon: Icon(Icons.edit),
                                        onPressed: () {
                                          context
                                              .read<MediaGalleryProvider>()
                                              .postTitle = "Edit Story";
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return CreateStoryScreen(
                                                route: widget.route,
                                                subId: widget.subCatID,
                                                // postTitle: "Edit Story",
                                                postEdit: widget.data);
                                          }));
                                        }),
                                    FocusedMenuItem(
                                        title: Text(
                                          "Delete",
                                          style: TextStyle(
                                              color: Colors.redAccent),
                                        ),
                                        trailingIcon: Icon(
                                          Icons.delete,
                                          color: Colors.redAccent,
                                        ),
                                        onPressed: () async {
                                          showDialog(
                                              context: context,
                                              builder: (_) {
                                                return DeletePopupWidget(
                                                    deleteNewsFeed);
                                              });
                                        }),
                                  ],
                                  onPressed: () {},
                                  child: Icon(
                                    Icons.more_vert,
                                    color: Colors.grey,
                                    size: 20.h,
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        'Story Date: ${widget.data['year'] ?? ""}-${widget.data['month'] ?? ""}-${widget.data['day'] ?? ""}',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 10.sp),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        widget.data['storyTitle'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13.sp),
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    // ReadMoreTextWidget(
                    //   widget.data["description"],
                    //   textAlign: TextAlign.start,
                    //   trimLines: 4,
                    //   trimLength: 200,
                    //   style: TextStyle(fontSize: 12.0),
                    //   moreStyle:  TextStyle(
                    //       color: Color(0xff2069d3),
                    //       fontWeight: FontWeight.w500),
                    //   lessStyle:   TextStyle(
                    //       color: Color(0xff2069d3),
                    //       fontWeight: FontWeight.w500),
                    //
                    // ),
                    !isShow && widget.data["description"].length > 90
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MarkdownBody(
                                data: _replaceMentions(
                                        widget.data["description"].substring(
                                            0,
                                            widget.data["description"].length <
                                                    165
                                                ? widget
                                                    .data["description"].length
                                                : 165),
                                        context)
                                    .replaceAll('\n', '\\\n'),
                                builders: {
                                  "coloredBox":
                                      ColoredBoxMarkdownElementBuilder(
                                          context,
                                          context
                                              .read<PostProvider>()
                                              .fetchMSCatByIdAllTN,
                                          'APPSTIRR',
                                          tagUserClick),
                                },
                                inlineSyntaxes: [
                                  ColoredBoxInlineSyntax(),
                                ],
                                styleSheet: MarkdownStyleSheet.fromTheme(
                                  Theme.of(context).copyWith(
                                    textTheme:
                                        Theme.of(context).textTheme.apply(
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
                                        color: Color(0xff2069d3),
                                        fontWeight: FontWeight.w500),
                                  ))
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MarkdownBody(
                                data: _replaceMentions(
                                        widget.data["description"], context)
                                    .replaceAll('\n', '\\\n'),
                                builders: {
                                  "coloredBox":
                                      ColoredBoxMarkdownElementBuilder(
                                          context,
                                          context
                                              .read<PostProvider>()
                                              .fetchMSCatByIdAllTN,
                                          'APPSTIRR',
                                          tagUserClick),
                                },
                                inlineSyntaxes: [
                                  ColoredBoxInlineSyntax(),
                                ],
                                styleSheet: MarkdownStyleSheet.fromTheme(
                                  Theme.of(context).copyWith(
                                    textTheme:
                                        Theme.of(context).textTheme.apply(
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
                                            color: Color(0xff2069d3),
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
                        : Padding(
                            padding:
                                const EdgeInsets.only(bottom: 10.0, top: 2),
                            child: GalleryImage(
                                key: UniqueKey(),
                                imageUrls: widget.data["media"]
                                // images
                                ),
                          ),
                  ],
                )),
            SizedBox(
              height: 3,
            ),
            Row(
              //   mainAxisAlignment: MainAxisAlignment.,
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("post")
                          .doc(widget.data["id"])
                          .collection('like')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError)
                          // return Center(child: Text(''));  // todo change by chetu
                          return Icon(
                            Icons.favorite,
                            color: Colors.grey,
                            size: 20,
                          );
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
                                          "${user.firstName} ${user.lastName}",
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
                ),

                // SizedBox(
                //   width: 15.w,
                // ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          // var storageService = locator<StorageService>();
                          // await storageService.setData(
                          //     "route", "/maindeshboard-screen");

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
                              return Center(child: Text(''));
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
                    ],
                  ),
                ),

//                   Visibility(
//                     visible: user.id == widget.data["addedById"],
//                     //* implemented visibility condition by chetu
//                     child: Expanded(
//                       child: GestureDetector(
//                         onTap: () async {
//                           log(jsonEncode(widget.data));
//
//                           ///      final createdLink =await dynamicLink.createDynamicLink(parameter: "Hello World Dynamic Link");
//
//                    ////////  ////
//                    //        final createdLink =
//                    //        await dynamicLink.createDynamicLink(
//                    //            parameter: widget.data["id"],
//                    //            imageUrl: widget.data["media"].isEmpty
//                    //                ? ""
//                    //                : widget.data["media"][0]["url"],
//                    //            title: widget.data["storyTitle"],
//                    //            userId: widget.data["addedById"]);
//                    //        print('Hi there Created Link: $createdLink');
//                    //        print([widget.data["media"][0]["url"]]);
// //////////
//                         //     await Share.share(createdLink);
//                           //  await Share.shareFiles([widget.data["media"][0]["url"]]);
//                           //         text: 'Contact : Arsalan');
//                           await screenshotController
//                               .capture(
//                               delay: const Duration(milliseconds: 20),
//                               pixelRatio: 3)
//                               .then((image) async {
//                             if (image != null) {
//                               final directory =
//                               await getApplicationDocumentsDirectory();
//                               final imagePath = await File(
//                                   '${directory.path}/myStory_+${DateTime.now().millisecondsSinceEpoch}.png')
//                                   .create();
//                               await imagePath.writeAsBytes(image);
//
//                               //new code
//                               //    final ByteData bytes = await rootBundle
//                               //        .load('assets/images/${widget.data["media"][1]["url"]}.jpeg');
//                               //    final Uint8List list = bytes.buffer.asUint8List();
//                               // //   final imageDirectory = (await getExternalStorageDirectory())?.path;
//                               //    final imageDirectory = await getApplicationDocumentsDirectory();
//                               //    final imgFile =  File('$imageDirectory/screenshot.jpeg');
//                               //    imgFile.writeAsBytesSync(list);
//                               //
//
//                               /// Share Plugin
//                               // await Share.shareFiles([imagePath.path],subject: "opps",
//                               //     text: createdLink);
//
//                               final createdLink =
//                                      await dynamicLink.createDynamicLink(
//                                          parameter: widget.data["id"],
//                                          imageUrl: imagePath.path.isEmpty
//                                              ? ""
//                                              : widget.data["media"][0]["url"],
//                                          title: widget.data["storyTitle"],
//                                          userId: widget.data["addedById"]);
//                                      print('Hi there Created Link: $createdLink');
//                                     // print([widget.data["media"][0]["url"]]);
//
//                               // await Share.share(createdLink);
//                               await Share.shareFiles([imagePath.path]);
//                           //    await Share.share("Hi yipeee! $createdLink");
//                               // print("result");
//                               // print(result.status);
//                               // print(result);
//                             }
//                           });
//                         }, //* changed Icon by chetu //
//                         child: Icon(
//                           Icons.reply_rounded,
//                           color: Colors.black54,
//                           textDirection: TextDirection.rtl,
//                         ),
//
//                         //* commented image  by chetu
//
//                         // Image.asset(
//                         //   "assets/images/Share.png",
//                         //   scale: 3,
//                         // ),
//                       ),
//                     ),
//                   ),
                Visibility(
                  visible: user.id == widget.data["addedById"],
                  //* implemented visibility condition by chetu
                  child: Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (builder) {
                              bool isCopied = false;
                              return Dialog(
                                  child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 13.0, vertical: 25),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "The MyStory sharing function will be enhanced in a future release, but for now, please tap on the Copy Text button below and then tap on Continue Sharing and paste the text into the social media site where the story is being shared. This will help MyStory grow its user base and expedite new features.",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 0.7)),
                                        child: Column(
                                          children: [
                                            Text(socialShareText),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  isCopied = true;
                                                  await Clipboard.setData(
                                                      ClipboardData(
                                                          text:
                                                              socialShareText));
                                                  utilService!
                                                      .cancelAllToast(context);
                                                  utilService!.showToast(
                                                      "Text copied.", context!);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 0,
                                                  backgroundColor: Colors.white,
                                                  shape:
                                                      new RoundedRectangleBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(15.0),
                                                    side: BorderSide(
                                                      //    width: 1.w,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                ),
                                                child: Text(
                                                  "Copy Text",
                                                  style: TextStyle(
                                                    fontSize: 11.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 10,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              utilService!
                                                  .cancelAllToast(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              textStyle: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.03,
                                                  fontWeight: FontWeight.w600),
                                              fixedSize: Size(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    1,
                                                MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.060,
                                              ),
                                              backgroundColor: Colors.white,
                                              shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                side: BorderSide(
                                                  width: 1.w,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(flex: 1, child: SizedBox()),
                                        Expanded(
                                          flex: 10,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                            //  if (isCopied) {
                                                Navigator.pop(context);
                                                // log(jsonEncode(widget.data));

                                                ///      final createdLink =await dynamicLink.createDynamicLink(parameter: "Hello World Dynamic Link");

                                                ////////  ////
                                                //        final createdLink =
                                                //        await dynamicLink.createDynamicLink(
                                                //            parameter: widget.data["id"],
                                                //            imageUrl: widget.data["media"].isEmpty
                                                //                ? ""
                                                //                : widget.data["media"][0]["url"],
                                                //            title: widget.data["storyTitle"],
                                                //            userId: widget.data["addedById"]);
                                                //        print('Hi there Created Link: $createdLink');
                                                //        print([widget.data["media"][0]["url"]]);
//////////
                                                //     await Share.share(createdLink);
                                                //  await Share.shareFiles([widget.data["media"][0]["url"]]);
                                                //         text: 'Contact : Arsalan');
                                                await screenshotController
                                                    .capture(
                                                        delay: const Duration(
                                                            milliseconds: 20),
                                                        pixelRatio: 3)
                                                    .then((image) async {
                                                  if (image != null) {
                                                    final directory =
                                                        await getApplicationDocumentsDirectory();
                                                    final imagePath = await File(
                                                            '${directory.path}/myStory_+${DateTime.now().millisecondsSinceEpoch}.png')
                                                        .create();
                                                    await imagePath
                                                        .writeAsBytes(image);

                                                    //new code
                                                    //    final ByteData bytes = await rootBundle
                                                    //        .load('assets/images/${widget.data["media"][1]["url"]}.jpeg');
                                                    //    final Uint8List list = bytes.buffer.asUint8List();
                                                    // //   final imageDirectory = (await getExternalStorageDirectory())?.path;
                                                    //    final imageDirectory = await getApplicationDocumentsDirectory();
                                                    //    final imgFile =  File('$imageDirectory/screenshot.jpeg');
                                                    //    imgFile.writeAsBytesSync(list);
                                                    //

                                                    /// Share Plugin
                                                    // await Share.shareFiles([imagePath.path],subject: "opps",
                                                    //     text: createdLink);

                                                    // final createdLink = await dynamicLink
                                                    //     .createDynamicLink(
                                                    //         parameter: widget
                                                    //             .data["id"],
                                                    //         imageUrl: imagePath
                                                    //                 .path
                                                    //                 .isEmpty
                                                    //             ? ""
                                                    //             : widget.data[
                                                    //                     "media"]
                                                    //                 [0]["url"],
                                                    //         title: widget.data[
                                                    //             "storyTitle"],
                                                    //         userId: widget.data[
                                                    //             "addedById"]);     // open for generate dynamic link



                                                    // print(
                                                    //     'Hi there Created Link: $createdLink');

                                                    // print([widget.data["media"][0]["url"]]);

                                                    // await Share.share(createdLink);
                                                    await Share.shareFiles(
                                                        [imagePath.path]);
                                                    //    await Share.share("Hi yipeee! $createdLink");
                                                    // print("result");
                                                    // print(result.status);
                                                    // print(result);
                                                  }
                                                });
                                            //  }
                                              // else {
                                              //   utilService!.showToast(
                                              //       "Please copy text to continue.",
                                              //       context!);
                                              // }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              textStyle: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.03,
                                                  fontWeight: FontWeight.w600),
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                              fixedSize: Size(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    1,
                                                MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.060,
                                              ),
                                              shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                side: BorderSide(
                                                  width: 1.w,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              "Continue Sharing",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ));
                            });
                      }, //* changed Icon by chetu //
                      child: Icon(
                        Icons.reply_rounded,
                        color: Colors.black54,
                        textDirection: TextDirection.rtl,
                      ),

                      //* commented image  by chetu

                      // Image.asset(
                      //   "assets/images/Share.png",
                      //   scale: 3,
                      // ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _replaceMentions(String text, BuildContext context) {
    context
        .read<PostProvider>()
        .fetchMSCatByIdAllTN
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
