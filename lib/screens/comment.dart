import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:mystory_flutter/widgets/gallery-pkg/galleryimage.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:share_plus/share_plus.dart';

class CommentsScreen extends StatefulWidget {
  CommentsScreen({Key? key}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  var navigationService = locator<NavigationService>();

  final double minValue = 8.0;
  final double iconSize = 28.0;
  FocusNode? _focusNode;
  TextEditingController _txtController = TextEditingController();

  bool isCurrentUserTyping = false;
  // ignore: unused_field
  ScrollController? _scrollController;

  String message = '';

  var isLoading = false;
  bool like = false;
  List<Map<String, dynamic>> gallerylist = [
    {
      "imgurl": [
        "https://akm-img-a-in.tosshub.com/indiatoday/647_050817013517.jpg?.fMJVxo6nTfpjX01fKZGCjHvyY99hlGC&size=770:433",
        "https://www.eatthis.com/wp-content/uploads/sites/4/2020/10/happy-meal.jpg?fit=1200%2C879&ssl=1",
        "https://i.insider.com/5a62455a00d0ef1e008b4a40?width=700",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSUgGqFIYInrNamNyYMpFpRxiQx5HTKV4lTww&usqp=CAU",
        "https://www.eatthis.com/wp-content/uploads/sites/4/2020/10/happy-meal.jpg?fit=1200%2C879&ssl=1",
        "https://i.insider.com/5a62455a00d0ef1e008b4a40?width=700",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSUgGqFIYInrNamNyYMpFpRxiQx5HTKV4lTww&usqp=CAU",
        "https://www.eatthis.com/wp-content/uploads/sites/4/2020/10/happy-meal.jpg?fit=1200%2C879&ssl=1",
        "https://i.insider.com/5a62455a00d0ef1e008b4a40?width=700",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSUgGqFIYInrNamNyYMpFpRxiQx5HTKV4lTww&usqp=CAU",
      ],
    }
  ];

  List<Map<String, dynamic>> commentlist = [
    {
      "id": "1",
      "name": "maryjane",
      "description": "let's do it again next weak",
      "subdesc": "mandypo",
      "subname": "#maryjane ",
      "subdescription": "#summertime #beachlife",
      "comment": [
        {
          "title":
              "its been avery wonderful time on the west beach today. Best day ever! ",
          "subtitle": "mandyport"
        },
        {
          "title":
              "its been avery wonderful time on the west beach today. Best day ever! ",
          "subtitle": "mandyport"
        },
        {
          "title":
              "its been avery wonderful time on the west beach today. Best day ever! ",
          "subtitle": "mandyport"
        },
      ]
    },
    {
      "id": "2",
      "name": "maryjane",
      "description": "let's do it again next weak",
      "subame": "mandypo",
      "subdesc": "mandypo",
      "subname": "#maryjane ",
      "subdescription": "#summertime #beachlife",
      "comment": [
        {
          "title":
              "its been avery wonderful time on the west beach today. Best day ever! ",
          "subtitle": "mandyport"
        },
        {
          "title":
              "its been avery wonderful time on the west beach today. Best day ever! ",
          "subtitle": "mandyport"
        },
        {
          "title":
              "its been avery wonderful time on the west beach today. Best day ever! ",
          "subtitle": "mandyport"
        },
      ]
    },
    {
      "id": "3",
      "name": "maryjane",
      "description": "let's do it again next weak",
      "subame": "mandypo",
      "subdesc": "mandypo",
      "subname": "#maryjane ",
      "subdescription": "#summertime #beachlife ",
      "comment": [
        {
          "title":
              "its been avery wonderful time on the west beach today. Best day ever! ",
          "subtitle": "mandyport"
        },
        {
          "title":
              "its been avery wonderful time on the west beach today. Best day ever! ",
          "subtitle": "mandyport"
        },
        {
          "title":
              "its been avery wonderful time on the west beach today. Best day ever! ",
          "subtitle": "mandyport"
        },
      ]
    }
  ];
  String text = '';
  String subject = '';
  List<String> imagePaths = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: InkWell(
              onTap: () {
                navigationService.navigateTo(MaindeshboardRoute);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            title: Text(
              "Comments",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            actions: [
              Icon(
                Icons.more_horiz,
                color: Colors.grey.shade500,
              ),
              SizedBox(
                width: 20.w,
              )
            ],
            bottom: PreferredSize(
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 25.h,
                              backgroundImage:
                                  AssetImage("assets/images/dummy.jpg"),
                            ),
                            SizedBox(
                              width: 13.h,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 3),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.red.shade100),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 6.0.h,
                                        right: 6.h,
                                        top: 2.h,
                                        bottom: 2.h),
                                    child: Text(
                                      "Brother",
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(239, 111, 110, 1),
                                          fontSize: 9.sp),
                                    ),
                                  ),
                                ),
                                Text(
                                  "Mande Portman",
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "30 mins ago",
                                  style: TextStyle(
                                      fontSize: 9.sp,
                                      color: Colors.grey.shade500),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                preferredSize: Size.fromHeight(0))),
        preferredSize: Size.fromHeight(115),
      ),
      floatingActionButton: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              margin: EdgeInsets.only(left: 17.0.h),
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: _buildBottomSection()))),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                RichText(
                  text: TextSpan(
                      text: "Mandypo its been a very wonderful ",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                      children: [
                        TextSpan(
                            text: "@maryjane ",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp)),
                        TextSpan(
                            text:
                                "\nits been a very wonderful time on the west beach today. Best, thanks!",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                                height: 1.5)),
                        TextSpan(
                            text: " #summertime #beachlife\n",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 13.sp))
                      ]),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                spreadRadius: -13,
                                blurRadius: 5,
                                offset: Offset(0, 20))
                          ]),
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: gallerylist.length,
                          itemBuilder: (ctx, i) {
                            return GalleryImage(
                              key: UniqueKey(),
                                imageUrls: gallerylist[i]['imgurl']);
                          }),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      like = !like;
                                    });
                                  },
                                  child: Image.asset(
                                    "assets/images/Like.png",
                                    scale: 3,
                                    color: like ? Colors.red : Colors.grey,
                                  )),
                              Text(
                                "  1.5k",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                              Text("  256",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )),
                              SizedBox(
                                width: 15.w,
                              ),
                              GestureDetector(
                                onTap: () => _onShareWithEmptyOrigin(context),
                                child: Image.asset(
                                  "assets/images/Share.png",
                                  scale: 3,
                                ),
                              ),
                              Text(" 256",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: commentlist.length,
                    itemBuilder: (ctx, index) {
                      return Column(
                        children: [
                          ListView.separated(
                              shrinkWrap: true,
                              itemCount: 1,
                              itemBuilder: (ctx, i) {
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 275.h,
                                          child: RichText(
                                            text: TextSpan(
                                                text:
                                                    "${commentlist[i]['comment'][index]['subtitle']}",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                children: [
                                                  TextSpan(
                                                      text:
                                                          "  ${commentlist[i]['comment'][index]['title']}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 14.sp,
                                                          height: 1.3)),
                                                  TextSpan(
                                                    text:
                                                        "${commentlist[index]['subname']}",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 13.sp),
                                                  ),
                                                  TextSpan(
                                                      text:
                                                          "${commentlist[index]['subdescription']}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.sp,
                                                          height: 1.3))
                                                ]),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                              text:
                                                  "${commentlist[index]['name']}  ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  height: 1.3),
                                              children: [
                                                TextSpan(
                                                    text:
                                                        "${commentlist[index]['description']} ",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                                TextSpan(
                                                    text:
                                                        "${commentlist[index]['subdesc']}",
                                                    style: TextStyle(
                                                        color: Colors.red))
                                              ]),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                              text:
                                                  "${commentlist[index]['name']}  ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  height: 1.3),
                                              children: [
                                                TextSpan(
                                                    text:
                                                        "${commentlist[index]['description']} ",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                                TextSpan(
                                                    text:
                                                        "${commentlist[index]['subdesc']}",
                                                    style: TextStyle(
                                                        color: Colors.red))
                                              ]),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  height: 15.h,
                                );
                              }),
                        ],
                      );
                    }),
                SizedBox(
                  height: 80,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onDeleteImage(int position) {
    setState(() {
      imagePaths.removeAt(position);
    });
  }

  _onShare(BuildContext context) async {
    // A builder is used to retrieve the context immediately
    // surrounding the ElevatedButton.
    //
    // The context's `findRenderObject` returns the first
    // RenderObject in its descendent tree when it's not
    // a RenderObjectWidget. The ElevatedButton's RenderObject
    // has its position and size after it's built.
    final RenderBox box = context.findRenderObject() as RenderBox;

    if (imagePaths.isNotEmpty) {
      await Share.shareFiles(imagePaths,
          text: text,
          subject: subject,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    } else {
      await Share.share(text,
          subject: subject,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }

  _onShareWithEmptyOrigin(BuildContext context) async {
    await Share.share("text");
  }

  Widget _buildBottomSection() {
    return RelativeBuilder(builder: (context, height, width, sy, sx) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: sx(400),
            height: sy(33),
            margin: EdgeInsets.all(minValue),
            padding: EdgeInsets.symmetric(horizontal: minValue),
            decoration: BoxDecoration(
              color: Color.fromRGBO(233, 233, 233, 1),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  sy(50),
                ),
              ),
            ),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: minValue,
                ),
                Expanded(
                  child: TextField(
                    focusNode: _focusNode,
                    keyboardType: TextInputType.text,
                    controller: _txtController,
                    // onChanged: _onMessageChanged,

                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: sx(14),
                        vertical: sy(11),
                      ),
                      border: InputBorder.none,
                      hintText: "write a comment....",
                    ),
                    autofocus: false,
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 45.h,
            width: 52.w,
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
          )
          // CircleAvatar(
          //   radius: sy(16),
          //   backgroundImage: AssetImage(
          //     "assets/images/Group 33611.png",
          //   ),
          // ),
        ],
      );
    });
  }
}
