import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hashtagable_v3/widgets/hashtag_text.dart';
import 'package:like_button/like_button.dart';
import 'package:mystory_flutter/providers/auth_provider.dart';
import 'package:mystory_flutter/providers/invite_member.dart';
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

class NewsFeedWidgetDynamic extends StatefulWidget {
  final postID;
  final postCreatorID;

  // final date;

  NewsFeedWidgetDynamic({required this.postID, required this.postCreatorID});

  @override
  _PostCommentsScreenState createState() => _PostCommentsScreenState();
}

class _PostCommentsScreenState extends State<NewsFeedWidgetDynamic> {
  FocusNode? _focusNode;
  TextEditingController _commentController = TextEditingController();
  var navigationService = locator<NavigationService>();

  var user;
  bool like = false;
  Map<String, dynamic> data = {};
  var date;
  bool isLoading = true;
  bool isFamilyMember = false;

  @override
  void initState() {
    user = Provider.of<AuthProviderr>(context, listen: false).user;
    // Provider.of<PostProvider>(context, listen: false)
    //     .setTempData(data["media"]);
    getPostData();
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   setState(() {});
  //   super.didChangeDependencies();
  // }
  //
  // @override
  // void didUpdateWidget(covariant NewsFeedWidgetDynamic oldWidget) {
  //   setState(() {});
  //   super.didUpdateWidget(oldWidget);
  // }

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
          navigationService.closeScreen();
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              bottomOpacity: 0,
              elevation: 0,
              title: Text(
                "Post",
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: true,
              leading: InkWell(
                  onTap: () async {
                    navigationService.closeScreen();
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.grey,
                  )),
            ),
            body:

            isLoading
                ? Center(child: CircularProgressIndicator())
                : isFamilyMember
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: data.isEmpty
                            ? Center(child: Text("This post has been deleted"))
                            : ColumnScrollView(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () {},
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      child:
                                                          data["addedByProfilePic"] ==
                                                                  ""
                                                              ? CircleAvatar(
                                                                  radius:
                                                                      height *
                                                                          0.035,
                                                                  backgroundImage:
                                                                      AssetImage(
                                                                          "assets/images/place_holder.png"),
                                                                )
                                                              : CircleAvatar(
                                                                  radius:
                                                                      height *
                                                                          0.035,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  child:
                                                                      CacheImage(
                                                                    placeHolder:
                                                                        "place_holder.png",
                                                                    imageUrl: data[
                                                                        "addedByProfilePic"],
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
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          data['addedByName'],
                                                          style: TextStyle(
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 150.w,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "widgedate",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .grey,
                                                                    height:
                                                                        1.5),
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              child: Text(
                                                data['storyTitle'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13.sp),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        HashTagText(
                                          text: data["description"],
                                          textAlign: TextAlign.start,
                                          decoratedStyle: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                          basicStyle: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.black),
                                          onTap: (text) {
                                            print(text);
                                          },
                                        ),
                                        SizedBox(
                                          height: 15.h,
                                        ),
                                        data["media"].isEmpty
                                            ? Container()
                                            : GalleryImage(
                                                imageUrls: data["media"],
                                                key: UniqueKey(),
                                                // images
                                              ),
                                        SizedBox(
                                          height: 25,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  StreamBuilder<QuerySnapshot>(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection("post")
                                                          .doc(data["id"])
                                                          .collection('like')
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasError)
                                                          return Center(
                                                              child: Text(
                                                                  '${snapshot.error.toString()}'));
                                                        if (snapshot.hasData) {
                                                          var likeLength =
                                                              snapshot.data!
                                                                  .docs.length;
                                                          return LikeButton(
                                                            onTap: (bool
                                                                isLiked) async {
                                                              await Provider.of<
                                                                          PostProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .likePostByUser(
                                                                      context:
                                                                          context,
                                                                      postId:
                                                                          data[
                                                                              "id"],
                                                                      addedById: user
                                                                          .id,
                                                                      entityUserID:
                                                                          data[
                                                                              "addedById"],
                                                                      addedByName:
                                                                          "${user.firstName} ${user.lastName}",
                                                                      //  user.firstName +
                                                                      //     user.lastName,
                                                                      addedByProfilePic:
                                                                          user.profilePicture);
                                                            },
                                                            size: 20,
                                                            circleColor: CircleColor(
                                                                start: Color(
                                                                    0xff00ddff),
                                                                end: Color(
                                                                    0xff0099cc)),
                                                            bubblesColor:
                                                                BubblesColor(
                                                              dotPrimaryColor:
                                                                  Color(
                                                                      0xff33b5e5),
                                                              dotSecondaryColor:
                                                                  Color(
                                                                      0xff0099cc),
                                                            ),
                                                            likeBuilder:
                                                                (bool isLiked) {
                                                              return Icon(
                                                                Icons.favorite,
                                                                color:
                                                                    likeLength ==
                                                                            0
                                                                        ? Colors
                                                                            .grey
                                                                        : Colors
                                                                            .red,
                                                                size: 20,
                                                              );
                                                            },
                                                            likeCount:
                                                                likeLength == 0
                                                                    ? 0
                                                                    : likeLength,
                                                          );
                                                        } else {
                                                          return Center(
                                                              child:
                                                                  SpinKitThreeInOut(
                                                            color: Theme.of(
                                                                    context)
                                                                .backgroundColor,
                                                            size: 10.0,
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        1200),
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
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection("post")
                                                          .doc(data["id"]
                                                              .toString())
                                                          .collection('comment')
                                                          .orderBy(
                                                              'createdOnDate')
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasError)
                                                          return Center(
                                                              child: Text(
                                                                  '${snapshot.error.toString()}'));
                                                        if (snapshot.hasData) {
                                                          var commentLength =
                                                              snapshot.data!
                                                                  .docs.length;
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8.0),
                                                            child: Text(
                                                                commentLength ==
                                                                        0
                                                                    ? "0"
                                                                    : commentLength
                                                                        .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                )),
                                                          );
                                                        } else {
                                                          return Center(
                                                              child:
                                                                  SpinKitThreeInOut(
                                                            color: Theme.of(
                                                                    context)
                                                                .backgroundColor,
                                                            size: 10.0,
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        1200),
                                                          ));
                                                        }
                                                      }),
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
                                                .doc(data["id"].toString())
                                                .collection('comment')
                                                .orderBy('createdOnDate')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError)
                                                return Center(
                                                    child: Text(
                                                        '${snapshot.error.toString()}'));
                                              if (snapshot.hasData) {
                                                return Stack(children: [
                                                  ListView.separated(
                                                      padding: EdgeInsets.only(
                                                          top: 15),
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount: snapshot
                                                                  .data!
                                                                  .docs
                                                                  .length ==
                                                              0
                                                          ? 0
                                                          : snapshot.data!.docs
                                                              .length,
                                                      itemBuilder: (ctx, i) {
                                                        return PostCommentsWidget(
                                                            data: snapshot
                                                                .data!.docs[i]);
                                                      },
                                                      separatorBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return SizedBox(
                                                          height: 15.h,
                                                        );
                                                      }),
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting)
                                                    Positioned(
                                                        child: Align(
                                                            alignment: Alignment
                                                                .bottomCenter,
                                                            child:
                                                                SpinKitThreeInOut(
                                                              color: Theme.of(
                                                                      context)
                                                                  .backgroundColor,
                                                              size: 20.0,
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          1200),
                                                            )))
                                                ]);
                                              } else {
                                                return Center(
                                                    child: SpinKitThreeInOut(
                                                  color: Theme.of(context)
                                                      .backgroundColor,
                                                  size: 10.0,
                                                  duration: const Duration(
                                                      milliseconds: 1200),
                                                ));
                                              }
                                            }),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 30.h, bottom: 10.h),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: SingleChildScrollView(
                                              child: Container(
                                                constraints: BoxConstraints(
                                                    maxHeight: 100),
                                                child: TextField(
                                                  focusNode: _focusNode,
                                                  // keyboardType: TextInputType.text,
                                                  controller:
                                                      _commentController,
                                                  // onChanged: _onMessageChanged,
                                                  maxLines: null,
                                                  // expands: true,
                                                  // keyboardType: TextInputType.multiline,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 14.w,
                                                      vertical: 11.h,
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade300,
                                                      ),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade300,
                                                        width: 2.0,
                                                      ),
                                                    ),
                                                    hintText: "Comment",
                                                    hintStyle: TextStyle(
                                                        color: Colors
                                                            .grey.shade500),
                                                    fillColor:
                                                        Colors.grey.shade300,
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
                                              if (_commentController.text !=
                                                  "") {
                                                String temp =
                                                    _commentController.text;
                                                _commentController.text = "";
                                                FocusScope.of(context)
                                                    .requestFocus(FocusNode());
                                                await Provider.of<PostProvider>(
                                                        context,
                                                        listen: false)
                                                    .commentPost(
                                                  context: context,
                                                  addedById: user.id,
                                                  entityUserID:
                                                      data["addedById"],
                                                  addedByName:
                                                      "${user.firstName} ${user.lastName}",
                                                  // user.firstName + user.lastName,
                                                  addedByProfilePic:
                                                      user.profilePicture,
                                                  description: temp,
                                                  postId: data["id"],
                                                  media: [],
                                                  taggedUser: [],
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
                      )
                    : Center(
                        child: Padding(
                        padding: const EdgeInsets.only(bottom: 88.0),
                        child: Text(
                          "Sorry,You are not a family member.",
                          style: TextStyle(fontSize: 15),
                        ),
                      ))));
  }

  void getPostData() async {
    var familyData = context.read<InviteProvider>().fetcFamilyTree;
    for (var data in familyData) {
      if (data["id"] == widget.postCreatorID) {
        isFamilyMember = true;
        break;
      }
    }
    if (isFamilyMember) {
      data = await Provider.of<PostProvider>(context, listen: false)
          .getPostByPostId(id: widget.postID, context: context);
    }
    setState(() {
      isLoading = false;
    });
  }
}
