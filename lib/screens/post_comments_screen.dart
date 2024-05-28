import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hashtagable_v3/widgets/hashtag_text.dart';
import 'package:like_button/like_button.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/post_provider.dart';
import 'package:mystory_flutter/screens/family_member_profile_screen.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/services/storage_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:mystory_flutter/widgets/cache_image.dart';
import 'package:mystory_flutter/widgets/column_scroll_view.dart';
import 'package:mystory_flutter/widgets/gallery-pkg/galleryimage.dart';
import 'package:mystory_flutter/widgets/post_comments_widget.dart';
import 'package:provider/provider.dart';

class PostCommentsScreen extends StatefulWidget {
  final data;
  var date;

  PostCommentsScreen({this.data, this.date});

  @override
  _PostCommentsScreenState createState() => _PostCommentsScreenState();
}

class _PostCommentsScreenState extends State<PostCommentsScreen> {
  FocusNode? _focusNode;
  TextEditingController _commentController = TextEditingController();
  var navigationService = locator<NavigationService>();
  final _key = GlobalKey();

  // var snapLength;
  var user;
  bool like = false;

  @override
  void initState() {
    user = Provider.of<AuthProviderr>(context, listen: false).user;
    Provider.of<PostProvider>(context, listen: false)
        .setTempData(widget.data["media"]);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant PostCommentsScreen oldWidget) {
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
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
        // var storageService, data;
        // storageService = locator<StorageService>();
        // data = await storageService.getData("route");
        // navigationService.navigateTo(data);
        //
        // await storageService.setData(
        //     "route", context.read<AuthProviderr>().tempRoute);
        navigationService.closeScreen();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            bottomOpacity: 0,
            elevation: 0,
            title: Text(
              "Comments",
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            leading: InkWell(
                onTap: () async {
                  // var storageService = locator<StorageService>();
                  // var data = await storageService.getData("route");
                  // if (data == "/sister-screen") {
                  //   Navigator.of(context).push(
                  //     MaterialPageRoute(
                  //       builder: (ctx) => SisterScreen(
                  //         route: "Family Screen",
                  //         // familyMember:
                  //         //     family.fetcFamilyTree[i]
                  //       ),
                  //     ),
                  //   );
                  // } else {
                  //   navigationService.navigateTo(data);
                  // }
                  //      context.read<PostProvider>().clearTempNewsFeedMedia();
                  //-----------------------
                  // var storageService, data;
                  // storageService = locator<StorageService>();
                  // data = await storageService.getData("route");
                  // navigationService.navigateTo(data);
                  //
                  // await storageService.setData(
                  //     "route", context.read<AuthProviderr>().tempRoute);
                  navigationService.closeScreen();
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.grey,
                )),
          ),
          body: Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: ColumnScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // navigationService.navigateTo(SisterScreenRoute);
                              },
                              child: Row(
                                children: [
                                  Container(
                                    child: widget.data["addedByProfilePic"] ==
                                            ""
                                        ? CircleAvatar(
                                            radius: height * 0.035,
                                            backgroundImage: AssetImage(
                                                "assets/images/place_holder.png"),
                                          )
                                        : CircleAvatar(
                                            radius: height * 0.035,
                                            backgroundColor: Colors.transparent,
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
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.data['addedByName'],
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Container(
                                        width: 150.w,
                                        child: Row(
                                          children: [
                                            Text(
                                              widget.date,
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
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                              widget.data['storyTitle'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13.sp),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      HashTagText(
                        text: widget.data["description"],
                        textAlign: TextAlign.start,
                        decoratedStyle: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                        basicStyle:
                            TextStyle(fontSize: 14.sp, color: Colors.black),
                        onTap: (text) {
                          print(text);
                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      widget.data["media"].isEmpty
                          ? Container()
                          : GalleryImage(
                              imageUrls: widget.data["media"], key: UniqueKey(),
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
                                            child: Text(
                                                '${snapshot.error.toString()}'));
                                      if (snapshot.hasData) {
                                        var likeLength =
                                            snapshot.data!.docs.length;
                                        return LikeButton(
                                          onTap: (bool isLiked) async {
                                            await Provider.of<PostProvider>(
                                                    context,
                                                    listen: false)
                                                .likePostByUser(
                                                    context: context,
                                                    postId: widget.data["id"],
                                                    addedById: user.id,
                                                    entityUserID: widget
                                                        .data["addedById"],
                                                    addedByName:
                                                        "${user.firstName} ${user.lastName}",
                                                    //  user.firstName +
                                                    //     user.lastName,
                                                    addedByProfilePic:
                                                        user.profilePicture);
                                          },
                                          size: 20,
                                          circleColor: CircleColor(
                                              start: Color(0xff00ddff),
                                              end: Color(0xff0099cc)),
                                          bubblesColor: BubblesColor(
                                            dotPrimaryColor: Color(0xff33b5e5),
                                            dotSecondaryColor:
                                                Color(0xff0099cc),
                                          ),
                                          likeBuilder: (bool isLiked) {
                                            return Icon(
                                              Icons.favorite,
                                              color: likeLength == 0
                                                  ? Colors.grey
                                                  : Colors.red,
                                              size: 20,
                                            );
                                          },
                                          likeCount:
                                              likeLength == 0 ? 0 : likeLength,
                                        );
                                      } else {
                                        return Center(
                                            child: SpinKitThreeInOut(
                                          color:
                                              Theme.of(context).backgroundColor,
                                          size: 10.0,
                                          duration: const Duration(
                                              milliseconds: 1200),
                                        ));
                                      }
                                    }),
                                SizedBox(
                                  width: 15.w,
                                ),
                                InkWell(
                                  onTap: () {},
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
                                            child: Text(
                                                '${snapshot.error.toString()}'));
                                      if (snapshot.hasData) {
                                        var commentLength =
                                            snapshot.data!.docs.length;
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
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
                                          color:
                                              Theme.of(context).backgroundColor,
                                          size: 10.0,
                                          duration: const Duration(
                                              milliseconds: 1200),
                                        ));
                                      }
                                    }),
                                SizedBox(
                                  width: 15.w,
                                ),
                                Visibility(
                                  visible: user.id == widget.data["addedById"],
                                  //* implemented visibility condition by chetu
                                  child: GestureDetector(
                                    onTap: () async {
                                      // await Share.share("text");
                                    },
                                    child: Image.asset(
                                      "assets/images/Share.png",
                                      scale: 3,
                                    ),
                                  ),
                                ),
                                Text(" 0",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
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
                              return Stack(children: [
                                ListView.separated(
                                    padding: EdgeInsets.only(top: 15),
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.docs.length == 0
                                        ? 0
                                        : snapshot.data!.docs.length,
                                    itemBuilder: (ctx, i) {
                                      return PostCommentsWidget(
                                          data: snapshot.data!.docs[i]);
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return SizedBox(
                                        height: 15.h,
                                      );
                                    }),
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting)
                                  Positioned(
                                      child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: SpinKitThreeInOut(
                                            color: Theme.of(context)
                                                .backgroundColor,
                                            size: 20.0,
                                            duration: const Duration(
                                                milliseconds: 1200),
                                          )))
                              ]);
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
                      //       if (snapshot.hasError)
                      //         return Center(
                      //             child: Text('${snapshot.error.toString()}'));
                      //       return Stack(children: [
                      //         ListView.separated(
                      //             padding: EdgeInsets.only(top: 15),
                      //             physics: NeverScrollableScrollPhysics(),
                      //             shrinkWrap: true,
                      //             itemCount: snapshot.data!.docs.length == 0
                      //                 ? 0
                      //                 : snapshot.data!.docs.length,
                      //             itemBuilder: (ctx, i) {
                      //               return PostCommentsWidget(
                      //                   data: snapshot.data!.docs[i]);
                      //             },
                      //             separatorBuilder:
                      //                 (BuildContext context, int index) {
                      //               return SizedBox(
                      //                 height: 15.h,
                      //               );
                      //             }),
                      //         if (snapshot.connectionState ==
                      //             ConnectionState.waiting)
                      //           Positioned(
                      //               child: Align(
                      //                   alignment: Alignment.bottomCenter,
                      //                   child: SpinKitThreeInOut(
                      //                     color:
                      //                         Theme.of(context).backgroundColor,
                      //                     size: 20.0,
                      //                     duration:
                      //                         const Duration(milliseconds: 1200),
                      //                   )))
                      //       ]);
                      //     }),
                    ],
                  ),
                  Container(
                    // width: sx(400),
                    // height: 33.h,
                    margin: EdgeInsets.only(top: 30.h, bottom: 10.h),
                    // padding: EdgeInsets.symmetric(horizontal: minValue),
                    // decoration: BoxDecoration(
                    //   color: Color.fromRGBO(233, 233, 233, 1),
                    //   borderRadius: BorderRadius.all(
                    //     Radius.circular(
                    //       50.h,
                    //     ),
                    //   ),
                    // ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              constraints: BoxConstraints(maxHeight: 100),
                              child: TextField(
                                focusNode: _focusNode,
                                // keyboardType: TextInputType.text,
                                controller: _commentController,
                                // onChanged: _onMessageChanged,
                                maxLines: null,
                                // expands: true,
                                // keyboardType: TextInputType.multiline,
                                decoration: InputDecoration(
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                    vertical: 11.h,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 2.0,
                                    ),
                                  ),
                                  hintText: "Comment",
                                  hintStyle:
                                      TextStyle(color: Colors.grey.shade500),
                                  fillColor: Colors.grey.shade300,
                                ),
                                autofocus: false,
                                onTap: () {},
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (_commentController.text != "") {
                              String temp = _commentController.text;
                              _commentController.text = "";
                              FocusScope.of(context).requestFocus(FocusNode());
                              await Provider.of<PostProvider>(context,
                                      listen: false)
                                  .commentPost(
                                context: context,
                                addedById: user.id,
                                entityUserID: widget.data["addedById"],
                                addedByName:
                                    "${user.firstName} ${user.lastName}",
                                // user.firstName + user.lastName,
                                addedByProfilePic: user.profilePicture,
                                description: temp,
                                postId: widget.data["id"],
                                media: [],
                                taggedUser: [],
                                // tecmpComLength: snapLength,
                              );
                            }
                          },
                          child: Container(
                            height: 45.h,
                            width: 45.w,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(
                                  "assets/images/Group 933.png",
                                ),
                              ),
                            ),
                            child: Center(
                              child: Image.asset(
                                "assets/images/Send.png",
                                scale: 3.5,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
